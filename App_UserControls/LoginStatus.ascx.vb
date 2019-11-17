
Partial Class App_UserControls_LoginStatus
    Inherits System.Web.UI.UserControl


    Protected Sub LoginView1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles LoginView1.Load
        If Not Membership.GetUser() Is Nothing Then

            Dim lblName As Label = DirectCast(LoginView1.FindControl("lblName"), Label)
            If Not lblName Is Nothing And Not Membership.GetUser.Email Is Nothing Then
                lblName.Text = Membership.GetUser.Email
            End If

        End If
    End Sub

End Class
