Imports Microsoft.VisualBasic
Imports RegistrationDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class InviteBll

    Private _adapter As InviteTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As InviteTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New InviteTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetInvitesByRegistrationId(ByVal registrationId As Integer) As RegistrationDAL.InviteDataTable
        Return Adapter.GetInvites(registrationId)
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Insert, True)> _
    Public Function SendInvite(ByVal registrationId As Integer, ByVal firstName As String, ByVal lastName As String, ByVal email As String) As Boolean
        Dim success As Boolean

        Dim rowsAffected As Integer = Adapter.Insert(registrationId, firstName, lastName, email)
        success = rowsAffected = 1

        EmailHelper.EmailInvitation(email, firstName & " " & lastName, registrationId)

        Return success
    End Function

End Class
