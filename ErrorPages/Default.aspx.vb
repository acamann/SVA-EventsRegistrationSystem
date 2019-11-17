
Partial Class ErrorPages_Default
    Inherits System.Web.UI.Page

    'The Default Error page accepts one value in the query string:
    '   - Message = the error message to display to the user
    
    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        If Not Request.QueryString("Message") Is Nothing Then
            lblMessage.Text = Request.QueryString("Message")
        End If

    End Sub

End Class
