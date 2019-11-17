Imports Microsoft.VisualBasic

Public Class ExceptionHandler

    Public Shared Sub Thrown(ByVal ex As Exception)

        'Dim title As String = Tools.Shorten(GetSafe(ex.Message), 100)
        Dim details As String = ExceptionDetails(ex)

        EmailError("SVA Events Registration Exception", details)
        'LogError(details)

    End Sub

#Region " Email Error "

    Private Shared Sub EmailError(ByVal subject As String, ByVal body As String)

        'Email the error?
        Dim emailErrors As Boolean = True  'Send the error by default
        If Not IsNothing(ConfigurationManager.AppSettings("emailErrors")) Then
            emailErrors = ConfigurationManager.AppSettings("emailErrors")
        End If

        'To what email address?
        Dim emailAddress As String = "webmaster@sva.com"  'Use webmaster@sva.com as default
        If Not IsNothing(ConfigurationManager.AppSettings("adminEmail")) Then
            emailAddress = ConfigurationManager.AppSettings("adminEmail")
        End If

        If emailErrors Then

            Dim smtp As New Net.Mail.SmtpClient
            smtp.Send("info@sva.com", emailAddress, subject, body)

        End If

    End Sub

#End Region

#Region " Log Error "

    Private Shared Sub LogError(ByVal details As String)

        ' ''Log the error?
        ''Dim logErrors As Boolean = True  'Send the error by default
        ''If Not IsNothing(ConfigurationManager.AppSettings("logErrors")) Then
        ''    logErrors = ConfigurationManager.AppSettings("logErrors")
        ''End If

        ''If logErrors Then

        ''    System.Diagnostics.EventLog.WriteEntry("SVA Events", details)

        ''End If

    End Sub

#End Region

#Region " Helper Functions "

    Private Shared Function GetSafe(ByVal value As Object) As String
        Dim safeValue As String = String.Empty
        If Not value Is DBNull.Value Then
            If Not IsNothing(value) Then
                safeValue = value.ToString
            End If
        End If
        Return safeValue
    End Function

    Private Shared Function ExceptionDetails(ByVal ex As Exception) As String
        Dim details As New StringBuilder
        details.Append("DATE OCCURRED: " & Now & vbCrLf & vbCrLf)
        If Not IsNothing(ex.Message) Then
            details.Append("ERROR MESSAGE: " & ex.Message.ToString & vbCrLf & vbCrLf)
        End If
        If Not IsNothing(ex.Source) Then
            details.Append("SOURCE: " & ex.Source.ToString & vbCrLf & vbCrLf)
        End If
        If Not IsNothing(HttpContext.Current.Request.QueryString) Then
            details.Append("QUERYSTRING: " & HttpContext.Current.Request.QueryString.ToString & vbCrLf & vbCrLf)
        End If
        If Not IsNothing(HttpContext.Current.Request.UrlReferrer) Then
            details.Append("REFERRER: " & HttpContext.Current.Request.UrlReferrer.ToString & vbCrLf & vbCrLf)
        End If
        If Not IsNothing(ex.StackTrace) Then
            details.Append("TARGET SITE: " & ex.StackTrace & vbCrLf & vbCrLf)
        End If
        If Not IsNothing(HttpContext.Current.Request.FilePath) Then
            details.Append("PAGE: " & HttpContext.Current.Request.FilePath.ToString & vbCrLf & vbCrLf)
        End If

        'Try to attach any logged-in user information (if there is any)
        Dim userProfileBll As New UserProfileBll
        Dim user As UserProfileDAL.UserProfileRow = userProfileBll.GetUser()
        If Not user Is Nothing Then
            details.Append("USER: " & user.FirstName & " " & user.LastName & "(" & user.Email & ")")
        End If

        Return details.ToString
    End Function

#End Region

End Class
