Imports Microsoft.VisualBasic

Public Class Tools

    'Removes all tags from an HTML string (returning only the text contained)
    Public Shared Function UnformatHTML(ByVal html As String) As String
        Return Regex.Replace(html, "<(.|\n)*?>", "")
    End Function

    'Returns a shortened string (shortened to the nearest word greater than the desired length)
    Public Shared Function Shorten(ByVal str As String, ByVal length As Integer) As String
        If str.Length > length Then
            Return str.Substring(0, str.IndexOf(" ", length)) & "..."
        End If
        Return str
    End Function

    'Returns an integer value of the querystring content
    '   If the data is invalid or missing, the user is redirected to the NotFound page
    Public Shared Function CheckQueryStringInt(ByVal key As String, ByVal type As String) As Integer
        Dim value As Integer
        If Not Integer.TryParse(HttpContext.Current.Request.QueryString(key), value) Then
            ObjectNotFound(type)
        End If
        Return value
    End Function

    'Returns an integer value of the querystring content
    '   If the data is invalid or missing, return NOTHING
    Public Shared Function GetSafeQueryStringInt(ByVal key As String) As Nullable(Of Integer)
        Dim value As Integer
        If Not Integer.TryParse(HttpContext.Current.Request.QueryString(key), value) Then
            Return Nothing
        End If
        Return value
    End Function

    Public Shared Sub ObjectNotFound(ByVal type As String)

        'redirect to Friendly Error page describing that the object could not be found
        HttpContext.Current.Server.Transfer("~/ErrorPages/NotFound.aspx?Type=" & type & "&Path=" & HttpContext.Current.Request.Url.PathAndQuery)

    End Sub

    Public Shared Sub ErrorMessage(ByVal message As String, ByVal logError As Boolean)

        'If we want to log the error, use the Exception handler
        If logError Then
            ExceptionHandler.Thrown(New Exception(message))
        End If

        'redirect to Friendly Error page describing the error
        HttpContext.Current.Server.Transfer("~/ErrorPages/Default.aspx?Message=" & message)

    End Sub

End Class
