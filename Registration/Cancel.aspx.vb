
Partial Class Registration_Cancel
    Inherits System.Web.UI.Page

    Private _registrationId As Integer
    Public Property RegistrationId() As Integer
        Get
            Return _registrationId
        End Get
        Set(ByVal value As Integer)
            _registrationId = value
        End Set
    End Property

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        'Verify RegistrationId
        RegistrationId = Tools.CheckQueryStringInt("RegistrationId", "Registration")

        'Set up the "Back to Event" link
        Dim registrationBll As New RegistrationBll
        Dim regTable As RegistrationDAL.RegistrationDataTable = registrationBll.GetRegistrationById(RegistrationId)
        If regTable.Rows.Count > 0 Then
            hlBackToEvent.NavigateUrl = "~/Details/Default.aspx?EventId=" & regTable(0).EventId
            EventPageHeader1.EventId = regTable(0).EventId
        End If

    End Sub


    Protected Sub lbCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbCancel.Click

        'Cancel the registration
        Dim registrationBll As New RegistrationBll
        If registrationBll.CancelRegistration(RegistrationId) Then
            'Success
            pageSuccess.Selected = True
        Else
            'Failure
            ExceptionHandler.Thrown(New Exception("The user tried to cancel their registration (" & RegistrationId & "), but encountered a problem."))
            pageFailure.Selected = True
        End If

    End Sub

End Class
