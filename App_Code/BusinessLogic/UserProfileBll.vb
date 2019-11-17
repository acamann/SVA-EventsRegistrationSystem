Imports Microsoft.VisualBasic
Imports UserProfileDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class UserProfileBll

#Region " Data Access Methods "

    Private _profileAdapter As UserProfileTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As UserProfileTableAdapter
        Get
            If _profileAdapter Is Nothing Then
                _profileAdapter = New UserProfileTableAdapter()
            End If

            Return _profileAdapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetUser() As UserProfileDAL.UserProfileRow
        Dim user As UserProfileDAL.UserProfileRow = Nothing
        Dim userId As Guid = UserMethods.GetUserId
        If Not userId = Nothing Then
            Dim userTable As UserProfileDAL.UserProfileDataTable = Adapter.GetUsers(userId, Nothing, Nothing)
            If userTable.Rows.Count > 0 Then
                user = userTable(0)
            End If
        End If
        Return user
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetUserById(ByVal userId As Guid) As UserProfileDAL.UserProfileRow
        Dim user As UserProfileDAL.UserProfileRow = Nothing
        Dim userTable As UserProfileDAL.UserProfileDataTable = Adapter.GetUsers(userId, Nothing, Nothing)
        If userTable.Rows.Count > 0 Then
            user = userTable(0)
        End If
        Return user
    End Function


    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Update, True)> _
    Public Function UpdateUserProfile( _
            ByVal firstName As String, _
            ByVal lastName As String, _
            ByVal email As String, _
            ByVal company As String, _
            ByVal title As String, _
            ByVal address As String, _
            ByVal address2 As String, _
            ByVal city As String, _
            ByVal state As String, _
            ByVal zip As String, _
            ByVal country As String, _
            ByVal phone As String, _
            ByVal specialAccommodations As String) As Boolean

        'If not logged in
        Dim userId As Guid = UserMethods.GetUserId()
        If userId = Nothing Then Return False

        'Does someone (else) already exist with this Email
        If Not String.IsNullOrEmpty(Membership.GetUserNameByEmail(email)) Then
            If Not Membership.GetUserNameByEmail(email).Equals(Membership.GetUser.UserName) Then

                'Error message
                Tools.ErrorMessage("An account already exists for the e-mail address you've specified.  If the e-mail address belongs to you, this means you've already set up an account for that address.  If not, please go back and choose a different e-mail.", False)

                Return False
            End If
        End If

        Dim rowsAffected = Adapter.Update(firstName, lastName, company, title, _
                            address, address2, city, state, zip, country, _
                            phone, specialAccommodations, userId)

        If rowsAffected = 0 Then Return False

        Dim user As MembershipUser = Membership.GetUser
        user.Email = email
        Membership.UpdateUser(user)

        Return True

    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Insert, True)> _
    Public Function InsertUserProfile( _
            ByVal firstName As String, _
            ByVal lastName As String, _
            ByVal company As String, _
            ByVal title As String, _
            ByVal address As String, _
            ByVal address2 As String, _
            ByVal city As String, _
            ByVal state As String, _
            ByVal zip As String, _
            ByVal country As String, _
            ByVal phone As String, _
            ByVal specialAccommodations As String) As Boolean

        Dim userId As Guid = UserMethods.GetUserId()
        If userId = Nothing Then Return False

        Return Adapter.Insert(firstName, lastName, company, title, _
                            address, address2, city, state, zip, country, _
                            phone, specialAccommodations, userId) = 1

    End Function

#End Region

End Class
