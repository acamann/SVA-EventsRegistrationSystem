
Partial Class ErrorPages_Insufficient
    Inherits System.Web.UI.Page


    'The Insufficient Access page accepts two values in the query string:
    '   - UserId = the user id of the user trying to access this thing (if logged in)
    '   - Path = the path that was requested 
    '           (this information will be emailed/logged to the adminEmail if emailErrors=True in web.config)

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        Dim userId As String = "unknown"
        If Not Request.QueryString("UserId") Is Nothing Then userId = Request.QueryString("UserId")
        
        Dim path As String = "unknown"
        If Not Request.QueryString("Path") Is Nothing Then path = Request.QueryString("Path")

        ExceptionHandler.Thrown(New Exception("Insufficient Access for user " & userId & ". Path=" & path))

    End Sub

End Class
