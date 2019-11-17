Imports Microsoft.VisualBasic

Public Class UserMethods

#Region " Shared Authentication Methods "

    'Returns a Guid object that contains the UserId of the current user
    '   (Returns Nothing if no user is currently logged in)
    Public Shared Function GetUserId() As Guid

        Dim user As MembershipUser = Membership.GetUser()
        If user Is Nothing Then Return Nothing
        Dim userId As Guid = user.ProviderUserKey
        Return userId

    End Function

    'Returns true if the user is an administrator, False otherwise
    Public Shared Function IsAdmin() As Boolean
        Return HttpContext.Current.User.IsInRole("Admin")
    End Function

    'If the user isn't logged in, they are redirected to the login page
    Public Shared Sub AuthenticateUser()
        If Not HttpContext.Current.User.Identity.IsAuthenticated Then
            HttpContext.Current.Server.Transfer("~/Login/Default.aspx?destination=" & HttpContext.Current.Request.Url.PathAndQuery)
        End If
    End Sub

    'If the current user doesn't match the passed UserId, they are redirected to the insufficient access page
    Public Shared Sub VerifyCurrentUser(ByVal userId As String)
        AuthenticateUser()
        Dim currentUser As Guid = GetUserId()
        If Not String.Equals(currentUser.ToString, userId) Then

            'If admin, let them access it:
            If UserMethods.IsAdmin Then
                Return
            Else
                'Otherwise, insufficient access page
                HttpContext.Current.Server.Transfer("~/ErrorPages/Insufficient.aspx?Path=" & HttpContext.Current.Request.Url.PathAndQuery & "&UserId=" & currentUser.ToString)
            End If

        End If
    End Sub

    Public Shared Sub InsufficientAccess()
        'The authenticated user doesn't have access to this page, so send em packing to the insufficient access page
        HttpContext.Current.Server.Transfer("~/ErrorPages/Insufficient.aspx?Path=" & HttpContext.Current.Request.Url.PathAndQuery & "&UserId=" & GetUserId.ToString)

    End Sub

#End Region

End Class
