
Partial Class ErrorPages_NotFound
    Inherits System.Web.UI.Page

    'The Insufficient Access page accepts two values in the query string:
    '   - Type = the type of object that could not be found (Event, Registration,...)
    '   - Path = the path that was requested 
    '           (this information will be emailed/logged to the adminEmail if emailErrors=True in web.config)

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        Dim type As String = "Page"
        If Not Request.QueryString("Type") Is Nothing Then type = Request.QueryString("Type")
        lblType1.Text = type
        lblType2.Text = type

        Dim path As String = "unknown"
        If Not Request.QueryString("Path") Is Nothing Then path = Request.QueryString("Path")

        ExceptionHandler.Thrown(New Exception(type & " not found.  Path=" & path))

    End Sub


End Class
