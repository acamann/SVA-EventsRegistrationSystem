
Partial Class Password
    Inherits System.Web.UI.Page

    Protected Sub PasswordRecovery1_SendingMail(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.MailMessageEventArgs) Handles PasswordRecovery1.SendingMail

        Dim user As MembershipUser = Membership.GetUser(PasswordRecovery1.UserName)

        e.Message.Subject = "SVA Events - Password Recovery"
        e.Message.Body = "Here is the password information you requested:<br /><br />" & _
            "<b>Login:</b> " & user.Email & "<br />" & _
            "<b>Password:</b> " & user.GetPassword() & "<br /><br />" & _
            "Please return to the <a href='" & ConfigurationManager.AppSettings("appPath") & "Login/Default.aspx" & "'>SVA Events Registration System</a> to login using this information.<br /><br />" & _
            "<span style='font-size:0.85em;'>If you feel you've received this e-mail in error, please contact our <a href='mailto:webmaster@sva.com'>Webmaster</a>.</span><br /><br />"

        e.Message.IsBodyHtml = True

        'PasswordRecovery1.SuccessText = e.Message.Body
        'e.Cancel = True

    End Sub

    Protected Sub PasswordRecovery1_VerifyingAnswer(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.LoginCancelEventArgs) Handles PasswordRecovery1.VerifyingAnswer

        'PasswordRecovery1.UserName = Membership.GetUser(PasswordRecovery1.UserName).Email

    End Sub

    Protected Sub PasswordRecovery1_VerifyingUser(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.LoginCancelEventArgs) Handles PasswordRecovery1.VerifyingUser

        Dim userName As String = Membership.GetUserNameByEmail(PasswordRecovery1.UserName)

        If String.IsNullOrEmpty(userName) Then

            'The user could not be found
            Tools.ObjectNotFound("E-Mail Address")
            
        End If
        
        PasswordRecovery1.UserName = userName

    End Sub

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        If Not String.IsNullOrEmpty(Request.QueryString("Email")) Then
            PasswordRecovery1.UserName = Request.QueryString("Email")
        End If
    End Sub
End Class
