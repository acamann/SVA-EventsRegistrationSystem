Imports Microsoft.VisualBasic
Imports RegistrationDALTableAdapters

Public Class PaymentBll

#Region " Payment "

    Private _adapter As PaymentTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As PaymentTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New PaymentTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    Public Function GetPaymentByRegistration(ByVal registrationId As Integer) As RegistrationDAL.PaymentDataTable
        Return Adapter.GetPayments(Nothing, registrationId, Nothing, Nothing)
    End Function

    Public Function GetPaymentByToken(ByVal tcTrusteeToken As String) As RegistrationDAL.PaymentDataTable
        Return Adapter.GetPayments(Nothing, Nothing, Nothing, tcTrusteeToken)
    End Function

    Public Function GetPaymentById(ByVal paymentId As Integer) As RegistrationDAL.PaymentDataTable
        Return Adapter.GetPayments(paymentId, Nothing, Nothing, Nothing)
    End Function

    Public Function InitializePayment( _
            ByVal registrationId As Integer, _
            ByVal tcTrusteeToken As String, _
            ByVal pricingId As Integer, _
            ByVal quantity As Byte, _
            ByVal amountDue As Double, _
            ByVal isCreditCard As Boolean) As Boolean

        If String.IsNullOrEmpty(tcTrusteeToken) Then tcTrusteeToken = Nothing
        Return Adapter.Insert(registrationId, tcTrusteeToken, Nothing, Nothing, pricingId, quantity, amountDue, 0, isCreditCard, Nothing, Nothing, False) > 0

    End Function

    Public Function ProcessPayment( _
            ByVal paymentId As Integer, _
            ByVal amountPaid As Double, _
            ByVal tcTrusteeTransId As String, _
            ByVal tcTrusteeReturnData As String, _
            ByVal isAccepted As Boolean) As Boolean

        Dim paymentTable As RegistrationDAL.PaymentDataTable
        paymentTable = GetPaymentById(paymentId)
        If paymentTable.Rows.Count > 0 Then

            paymentTable(0).AmountPaid = amountPaid
            paymentTable(0).TCTrusteeTransId = tcTrusteeTransId
            paymentTable(0).DatePaid = Now
            paymentTable(0).TCTrusteeReturnData = tcTrusteeReturnData
            paymentTable(0).IsAccepted = isAccepted
            Return Adapter.Update(paymentTable(0)) = 1

        Else
            Return False
        End If

    End Function


#End Region


End Class
