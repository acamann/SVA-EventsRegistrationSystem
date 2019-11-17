
Partial Class Profile
    Inherits System.Web.UI.Page

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        If Not User.Identity.IsAuthenticated Then
            'if the user isn't logged in, redirect to login page
            Server.Transfer("~/Login/Default.aspx?destination=" & Request.Url.PathAndQuery)
        End If

    End Sub

End Class
