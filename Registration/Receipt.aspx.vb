
Partial Class Registration_Receipt
    Inherits System.Web.UI.Page

#Region " RegistrationId Property "

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

        UserMethods.AuthenticateUser()
        RegistrationId = Tools.CheckQueryStringInt("RegistrationId", "Registration")

    End Sub

#End Region

#Region " Receipt DataBound "

    Protected Sub fvReceipt_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles fvReceipt.DataBound
        If fvReceipt.DataItemCount > 0 Then

            Dim hdnEventId As HiddenField = fvReceipt.FindControl("hdnEventId")
            Dim eventId As Integer = hdnEventId.Value

            'Set EventID parameter of Dates data source
            Dim odsDates As ObjectDataSource = fvReceipt.FindControl("odsDates")
            odsDates.SelectParameters("EventId").DefaultValue = eventId

            'Set EventId parameter of Contact data source
            odsContact.SelectParameters("EventId").DefaultValue = eventId

            'Set odsContact as the datasource for the "Attn:" information in the Mail-In Invoice notification
            Dim lvContact As ListView = DirectCast(fvReceipt.FindControl("lvContact"), ListView)
            lvContact.DataSource = odsContact
            lvContact.DataBind()

            'Set EventId parameter of Left Navigation Steps data source
            odsRegistrationSteps.SelectParameters("EventId").DefaultValue = eventId


            Dim odsEventSession As ObjectDataSource = fvReceipt.FindControl("odsEventSession")
            odsEventSession.SelectParameters("EventId").DefaultValue = eventId

            'Check that the user has access to this receipt
            Dim hdnUserId As HiddenField = fvReceipt.FindControl("hdnUserId")
            Dim userId As String = hdnUserId.Value
            UserMethods.VerifyCurrentUser(userId)

        Else
            Tools.ObjectNotFound("Receipt")

        End If
    End Sub

#End Region

#Region " Set Up Registration Steps "

    Protected Sub lvRegistrationSteps_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvRegistrationSteps.DataBound
        If lvRegistrationSteps.Items.Count > 0 Then
            lvRegistrationSteps.SelectedIndex = lvRegistrationSteps.Items.Count - 1
        End If
    End Sub

#End Region

#Region " Agenda ItemDataBound "

    Protected Sub lvEventSession_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ListViewItemEventArgs)
        Dim item As ListViewDataItem = e.Item
        Dim odsBreakout As ObjectDataSource = item.FindControl("odsBreakOut")
        Dim hdnSessionId As HiddenField = item.FindControl("hdnSessionId")
        odsBreakout.SelectParameters("RegistrationId").DefaultValue = RegistrationId
        odsBreakout.SelectParameters("SessionId").DefaultValue = hdnSessionId.Value
    End Sub

#End Region

    Protected Sub odsPayment_ItemDataBound(ByVal sender As Object, ByVal e As ListViewItemEventArgs)

        'Display the Invoice description and mail-to address if they have chosen to mail payment
        If e.Item.ItemType = ListViewItemType.DataItem Then
            Dim currentItem As ListViewDataItem = DirectCast(e.Item, ListViewDataItem)
            Dim dataRow As System.Data.DataRowView = DirectCast(currentItem.DataItem, System.Data.DataRowView)
            Dim payment As RegistrationDAL.PaymentRow = DirectCast(dataRow.Row, RegistrationDAL.PaymentRow)
            If Not payment.IsCreditCard Then
                'If they aren't paying with a credit card, change the title from Receipt to Invoice
                Dim pnlInvoice As Panel = fvReceipt.FindControl("pnlInvoice")
                pnlInvoice.Visible = True
            End If
        End If

    End Sub

End Class
