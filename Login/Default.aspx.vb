
Partial Class login_Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim pnlLogin As Panel = DirectCast(Me.Master.FindControl("pnlLogin"), Panel)
        pnlLogin.Visible = False

        'If the user was automatically sent to this page

        If Not String.IsNullOrEmpty(Request.QueryString("destination")) Then

            'grab the referring page and pass it along to the New User link
            Login1.DestinationPageUrl = Request.QueryString("destination").ToString
            hlNewAccount.NavigateUrl = "~/Login/NewUser.aspx?destination=" & Request.QueryString("destination").ToString
            hlNewAccount2.NavigateUrl = "~/Login/NewUser.aspx?destination=" & Request.QueryString("destination").ToString

            'show the "you must be logged in" notice
            pnlMustLogin.Visible = True

        Else

            'hide the "you must be logged in" notice
            pnlMustLogin.Visible = False

        End If

    End Sub

    Protected Sub Login1_Authenticate(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.AuthenticateEventArgs) Handles Login1.Authenticate
        Dim userName As String = Membership.GetUserNameByEmail(Login1.UserName)
        If Not userName Is Nothing Then
            e.Authenticated = Membership.ValidateUser(userName, Login1.Password)
        Else
            e.Authenticated = False
        End If
        If e.Authenticated Then
            Login1.UserName = userName
        End If
    End Sub

    'Protected Sub Login1_LoggedIn(ByVal sender As Object, ByVal e As System.EventArgs) Handles Login1.LoggedIn
    ' Dim user As MembershipUser = Membership.GetUser(Login1.UserName)
    '    Session("CurrentUser") = user
    'End Sub


End Class
