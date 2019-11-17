
Partial Class NewUser
    Inherits System.Web.UI.Page

    Protected Sub CreateUserWizard1_CreatedUser(ByVal sender As Object, ByVal e As System.EventArgs) Handles CreateUserWizard1.CreatedUser
        'Dim userName As String = CreateUserWizard1.UserName.ToString()

        'Dim user As MembershipUser = Membership.GetUser(userName)
        'Dim userId As Guid = user.ProviderUserKey

        'sqlExtendedProfile.InsertParameters.Add("UserId", userId.ToString)
        'sqlExtendedProfile.Insert()
    End Sub


    Protected Sub CreateUserWizard1_CreatingUser(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.LoginCancelEventArgs) Handles CreateUserWizard1.CreatingUser
        Dim email As String = CreateUserWizard1.UserName.ToString()

        If String.IsNullOrEmpty(Membership.GetUserNameByEmail(email)) Then
            'If the E-mail is not currently taken
            CreateUserWizard1.Email = email
            CreateUserWizard1.UserName = email & "." & Guid.NewGuid.ToString
            'CreateUserWizard1.UserName = Guid.NewGuid.ToString

        Else
            'The user already exists, so don't create it
            e.Cancel = True

            Dim userName As String = Membership.GetUserNameByEmail(email)
            If Not userName Is Nothing Then
                If Not Membership.ValidateUser(userName, CreateUserWizard1.Password.ToString) Then
                    'If the e-mail is taken but the password was not correct, display message and link                    
                    pageExistsNotOk.Selected = True
                    hlForgotPassword.NavigateUrl = "~/Login/Password.aspx?Email=" & email

                Else
                    'Login info is correct, so log the user in and display message
                    FormsAuthentication.SetAuthCookie(userName, False)
                    pageExistsOk.Selected = True
                    If Not String.IsNullOrEmpty(Request.QueryString("destination")) Then
                        hlContinue.NavigateUrl = Request.QueryString("destination").ToString
                    Else
                        hlContinue.NavigateUrl = "~/Login/Profile.aspx"
                    End If
                End If
            End If
        End If


    End Sub


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim pnlLogin As Panel = DirectCast(Me.Master.FindControl("pnlLogin"), Panel)
        pnlLogin.Visible = False

        'If the user was automatically sent to this page (or the login page)
        If Not String.IsNullOrEmpty(Request.QueryString("destination")) Then

            'grab the referring page and pass it along to the New User link
            CreateUserWizard1.ContinueDestinationPageUrl = Request.QueryString("destination").ToString
            hlLogin.NavigateUrl = "~/Login/Default.aspx?destination=" & Request.QueryString("destination").ToString
            hlLogin2.NavigateUrl = "~/Login/Default.aspx?destination=" & Request.QueryString("destination").ToString

        Else

            CreateUserWizard1.ContinueDestinationPageUrl = "~/Login/Profile.aspx"
            
        End If
    End Sub

End Class
