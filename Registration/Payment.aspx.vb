
Partial Class Registration_Payment
    Inherits System.Web.UI.Page

#Region " Properties "

    Private _registrationId As Integer
    Public Property RegistrationId() As Integer
        Get
            Return _registrationId
        End Get
        Set(ByVal value As Integer)
            _registrationId = value
        End Set
    End Property

#End Region

#Region " Page Init "

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        If Not Request.QueryString("status") Is Nothing Then
            'If the user was redirected to this page from a recent payment attempt
            '   then "status" is one of the values passed in the querystring
            '   so, collect the payment information...

            ReceivePaymentDetails(Request.QueryString)

        Else

            'Redirect to login page if not logged in
            UserMethods.AuthenticateUser()

            'Verify registration ID
            RegistrationId = Tools.CheckQueryStringInt("RegistrationId", "Registration")

            'Set up Continue button
            'hlViewReceipt.NavigateUrl = "~/Registration/Receipt.aspx?RegistrationId=" & RegistrationId

        End If


    End Sub

#End Region

#Region " Payment Form DataBound "

    Protected Sub fvPayment_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles fvPayment.DataBound
        If fvPayment.DataItemCount > 0 Then

            'If the user has already paid, take them to the receipt
            Dim hdnDatePaid As HiddenField = fvPayment.FindControl("hdnDatePaid")
            If Not String.IsNullOrEmpty(hdnDatePaid.Value) Then
                ShowReceipt()
            End If

            'Get EventId
            Dim eventId As Integer
            Dim hdnEventId As HiddenField = fvPayment.FindControl("hdnEventId")
            eventId = Integer.Parse(hdnEventId.Value)

            'Set up Pricing Options
            Dim odsPricing As ObjectDataSource = fvPayment.FindControl("odsPricing")
            odsPricing.SelectParameters("EventId").DefaultValue = eventId

            'Dim pricingBll As New PricingBll
            'Dim pricingTable As RegistrationDAL.PricingDataTable = pricingBll.SelectPricingByEventId(eventId)
            'If pricingTable.Rows.Count > 0 Then
            '    'If there are pricing options, present them
            '    Dim lvPricing As ListView = fvPayment.FindControl("lvPricing")
            '    lvPricing.DataSource = pricingTable
            '    lvPricing.DataBind()
            'Else
            '    'If there aren't, forward them to the receipt...
            '    ShowReceipt()
            'End If
            
            'Set up Left navigation
            odsRegistrationSteps.SelectParameters("EventId").DefaultValue = eventId

            'Get UserId to verify that it matches the current user
            Dim userId As String
            Dim hdnUserId As HiddenField = fvPayment.FindControl("hdnUserId")
            userId = hdnUserId.Value

            UserMethods.VerifyCurrentUser(userId)
        End If
    End Sub

#End Region

#Region " Set up Registration Steps "

    Protected Sub lvRegistrationSteps_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvRegistrationSteps.DataBound
        If lvRegistrationSteps.Items.Count > 1 Then
            lvRegistrationSteps.SelectedIndex = (lvRegistrationSteps.Items.Count - 2)
        End If
    End Sub

#End Region

#Region " Pricing Levels List DataBound "

    Protected Sub lvPricing_DataBound(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim lvPricing As ListView = sender
        If lvPricing.Items.Count > 0 Then
            'No Pricing levels exist for this time period??
            'Response.Redirect("~/Registration/Receipt.aspx?RegistrationId=" & Request.QueryString("RegistrationID"))
            If lvPricing.Items.Count = 1 Then
                'If there is only one pricing level, remove the "Please select" and select the only possible one
                Dim pnlSelect As Panel = fvPayment.FindControl("pnlSelect")
                pnlSelect.Visible = False
                lvPricing.SelectedIndex = 0
                UpdateInvoice(sender)
            End If

        End If
    End Sub

#End Region

#Region " Update Invoice / Calculate Total Amount / Get Values "

    Protected Sub lvPricing_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        UpdateInvoice(sender)
    End Sub

    Protected Sub lvPricing_SelectedIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ListViewSelectEventArgs)
        'We need this method because it is fired automatically by listview
        Dim listview As ListView = sender
        listview.SelectedIndex = e.NewSelectedIndex
    End Sub

    Private Sub UpdateInvoice(ByVal lvPricing As ListView)
        Dim selectedItem As ListViewDataItem = lvPricing.Items(lvPricing.SelectedIndex)
        Dim hdnPrice As HiddenField = selectedItem.FindControl("hdnPrice")
        CalculateTotalAmount(hdnPrice.Value)
    End Sub

    Private Sub CalculateTotalAmount(ByVal unitPrice As Double)
        Dim txtUnitPrice As TextBox = fvPayment.FindControl("txtUnitPrice")
        Dim txtAmountDue As TextBox = fvPayment.FindControl("txtAmountDue")

        txtUnitPrice.Text = FormatCurrency(unitPrice)
        Dim quantity As Integer = GetQuantity()
        txtAmountDue.Text = FormatCurrency(unitPrice * quantity)
    End Sub

    Private Function GetQuantity() As Byte
        Dim txtQuantity As TextBox = fvPayment.FindControl("txtQuantity")
        Return txtQuantity.Text
    End Function

    Private Function GetTotalAmount() As Double
        Dim txtAmountDue As TextBox = fvPayment.FindControl("txtAmountDue")
        Return txtAmountDue.Text
    End Function

    Private Function GetPricingId() As Integer
        Dim lvPricing As ListView = fvPayment.FindControl("lvPricing")
        Return lvPricing.SelectedDataKey("PricingId")
    End Function

#End Region

#Region " Process Payment "

    Protected Sub lbProcessPayment_Click(ByVal sender As Object, ByVal e As EventArgs)
        ProcessPayment()
    End Sub

    Private Sub ProcessPayment()
        Dim rblPayment As RadioButtonList = fvPayment.FindControl("rblPayment")

        Dim pricingId As Integer = GetPricingId()
        Dim quantity As Byte = GetQuantity()
        Dim amountDue As Double = GetTotalAmount()
        Dim paymentBll As New PaymentBll

        Select Case rblPayment.SelectedValue

            Case "Credit"
                'If we're making a credit payment


                '  1 - Grab the session TOKEN that will be used to make the payment
                Dim tcTrusteeToken As String = PaymentMethods.GetToken(RegistrationId)
                If tcTrusteeToken Is Nothing Then
                    'If the token grab was unsuccessful, throw an exception
                    ExceptionHandler.Thrown(New Exception("Problem grabbing token from TrustCommerce. RegId=" & RegistrationId & ", quantity=" & quantity & ", amountDue=" & amountDue))
                End If


                '  2 - Insert an empty Payment record for this registration using the TOKEN retreived
                If Not paymentBll.InitializePayment(RegistrationId, tcTrusteeToken, pricingId, quantity, amountDue, True) Then
                    'If there's a problem inserting the initial payment record, save the error
                    ExceptionHandler.Thrown(New Exception("Problem initializing payment. RegId=" & RegistrationId & ", token=" & tcTrusteeToken & ", amountDue=" & amountDue))
                End If


                '  3 - Forward to the TC Trustee payment screen
                PaymentMethods.PostPayment(tcTrusteeToken, amountDue)


            Case "Mail"

                'If the user chooses to mail in the payment at a later date:

                'Initialize empty payment into table, to be handled manually at a later date
                If Not paymentBll.InitializePayment(RegistrationId, Nothing, pricingId, quantity, amountDue, False) Then

                    'Save error 
                    ExceptionHandler.Thrown(New Exception("Problem initializing Mail-In Payment. RegId=" & RegistrationId & ", quantity=" & quantity & ", amountDue=" & amountDue))

                End If

                'Show receipt whether the MailIn record initialization was successful or not.
                ShowReceipt()

        End Select

    End Sub

#End Region

#Region " Receive Payment Details (After returning from TrustCommerce) "

    Private Sub ReceivePaymentDetails(ByVal returnParameters As NameValueCollection)

        Select Case returnParameters("status")
            Case "approved"
                'The transaction was approved:


                '  1 - Grab the token from the return parameters
                Dim tcTrusteeToken As String = returnParameters("token")
                If tcTrusteeToken Is Nothing Then
                    ExceptionHandler.Thrown(New Exception("The TC Trustee payment was 'approved' but the token was not returned so it could not be associated with this registration. (" & returnParameters.ToString & ")"))
                End If


                '  2 - Grab the amount paid and the trans Id
                Dim amountPaid As Double
                Double.TryParse(returnParameters("amount"), amountPaid)
                Dim tcTrusteeTransId As String = returnParameters("transid")


                '  3 - Find and update the payment record by token
                Dim paymentBll As New PaymentBll
                Dim paymentTable As RegistrationDAL.PaymentDataTable
                paymentTable = paymentBll.GetPaymentByToken(tcTrusteeToken)
                If paymentTable.Rows.Count > 0 Then

                    'We found it, so lets set the amountPaid and tcTrusteeTransId
                    Dim payment As RegistrationDAL.PaymentRow = paymentTable(0)
                    RegistrationId = payment.RegistrationId
                    'We'll also store the entire returnValue string and IsAccepted=True
                    paymentBll.ProcessPayment(payment.PaymentId, amountPaid, tcTrusteeTransId, returnParameters.ToString, True)

                Else
                    'If there was a problem processing, save exception
                    ExceptionHandler.Thrown(New Exception( _
                            "The TC Trustee payment was 'approved' and the token was returned," & _
                            "but we couldn't find the payment record based on the token.  " & _
                            "Token=" & tcTrusteeToken & ", TransId=" & tcTrusteeTransId & " (" & returnParameters.ToString & ")"))
                End If


                '  4 - Forward to Receipt
                ShowReceipt()

            Case "decline"
                ' The transaction was declined: 

                '  1 - Grab the token from the return parameters
                Dim tcTrusteeToken As String = returnParameters("token")
                If tcTrusteeToken Is Nothing Then
                    ExceptionHandler.Thrown(New Exception("The TC Trustee payment was 'declined' but the token was not returned so it could not be associated with this registration. (" & returnParameters.ToString & ")"))
                End If


                '  2 - Grab the trans Id
                Dim tcTrusteeTransId As String = returnParameters("transid")

                '  3 - Find and update the payment record by token
                Dim paymentBll As New PaymentBll
                Dim paymentTable As RegistrationDAL.PaymentDataTable
                paymentTable = paymentBll.GetPaymentByToken(tcTrusteeToken)
                If paymentTable.Rows.Count > 0 Then

                    'We found it, so lets set the amountPaid and tcTrusteeTransId
                    Dim payment As RegistrationDAL.PaymentRow = paymentTable(0)
                    RegistrationId = payment.RegistrationId
                    'We'll also store the entire returnValue string and IsAccepted=False
                    paymentBll.ProcessPayment(payment.PaymentId, 0, tcTrusteeTransId, returnParameters.ToString, False)

                Else
                    'If there was a problem processing, save exception
                    ExceptionHandler.Thrown(New Exception( _
                            "The TC Trustee payment was 'declined' and the token was returned," & _
                            "but we couldn't find the payment record based on the token.  " & _
                            "Token=" & tcTrusteeToken & ", TransId=" & tcTrusteeTransId & " (" & returnParameters.ToString & ")"))
                End If

                '  4 - Show the receipt (which will display to the user that this was declined
                ShowReceipt()

            Case "baddata"
                ' There was bad data:

                '  1 - Grab the token from the return parameters
                Dim tcTrusteeToken As String = returnParameters("token")
                If tcTrusteeToken Is Nothing Then
                    ExceptionHandler.Thrown(New Exception("The TC Trustee payment returned 'baddata' but the token was not returned so it could not be associated with this registration. (" & returnParameters.ToString & ")"))
                End If


                '  2 - Grab the trans Id
                Dim tcTrusteeTransId As String = returnParameters("transid")

                '  3 - Find and update the payment record by token
                Dim paymentBll As New PaymentBll
                Dim paymentTable As RegistrationDAL.PaymentDataTable
                paymentTable = paymentBll.GetPaymentByToken(tcTrusteeToken)
                If paymentTable.Rows.Count > 0 Then

                    'We found it, so lets set the amountPaid and tcTrusteeTransId
                    Dim payment As RegistrationDAL.PaymentRow = paymentTable(0)
                    RegistrationId = payment.RegistrationId
                    'We'll also store the entire returnValue string and IsAccepted=False
                    paymentBll.ProcessPayment(payment.PaymentId, 0, tcTrusteeTransId, returnParameters.ToString, False)

                Else
                    'If there was a problem processing, save exception
                    ExceptionHandler.Thrown(New Exception( _
                            "The TC Trustee payment was 'baddata' and the token was returned," & _
                            "but we couldn't find the payment record based on the token.  " & _
                            "Token=" & tcTrusteeToken & ", TransId=" & tcTrusteeTransId & " (" & returnParameters.ToString & ")"))
                End If


                'Save the "bad data"
                ExceptionHandler.Thrown(New Exception( _
                            "The TC Trustee payment returned 'baddata'. " & _
                            "(" & returnParameters.ToString & ")"))

                'Just show the receipt, where the non-payment will be displayed to the user?
                ShowReceipt()
                viewError.Selected = True

            Case "error"

                '  1 - Grab the token from the return parameters
                Dim tcTrusteeToken As String = returnParameters("token")
                If tcTrusteeToken Is Nothing Then
                    ExceptionHandler.Thrown(New Exception("The TC Trustee payment returned 'error' but the token was not returned so it could not be associated with this registration. (" & returnParameters.ToString & ")"))
                End If


                '  2 - Grab the trans Id
                Dim tcTrusteeTransId As String = returnParameters("transid")

                '  3 - Find and update the payment record by token
                Dim paymentBll As New PaymentBll
                Dim paymentTable As RegistrationDAL.PaymentDataTable
                paymentTable = paymentBll.GetPaymentByToken(tcTrusteeToken)
                If paymentTable.Rows.Count > 0 Then

                    'We found it, so lets set the amountPaid and tcTrusteeTransId
                    Dim payment As RegistrationDAL.PaymentRow = paymentTable(0)
                    RegistrationId = payment.RegistrationId
                    'We'll also store the entire returnValue string and IsAccepted=False
                    paymentBll.ProcessPayment(payment.PaymentId, 0, tcTrusteeTransId, returnParameters.ToString, False)

                Else
                    'If there was a problem processing, save exception
                    ExceptionHandler.Thrown(New Exception( _
                            "The TC Trustee payment returned 'error' and the token was returned," & _
                            "but we couldn't find the payment record based on the token.  " & _
                            "Token=" & tcTrusteeToken & ", TransId=" & tcTrusteeTransId & " (" & returnParameters.ToString & ")"))
                End If


                'Save the "bad data"
                ExceptionHandler.Thrown(New Exception( _
                            "The TC Trustee payment returned 'error'. " & _
                            "(" & returnParameters.ToString & ")"))

                'Just show the receipt, where the non-payment will be displayed to the user?
                ShowReceipt()
                viewError.Selected = True

        End Select

    End Sub

#End Region

#Region " Show Receipt "

    Protected Sub ShowReceipt()
        Response.Redirect("~/Registration/Receipt.aspx?RegistrationId=" & RegistrationId)
    End Sub

#End Region

End Class
