Imports Microsoft.VisualBasic
Imports RegistrationDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class GuestBll

    Private _adapter As GuestTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As GuestTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New GuestTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetGuestsByRegistrationId(ByVal registrationId As Integer) As RegistrationDAL.GuestDataTable
        Return Adapter.GetGuests(registrationId)
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Delete, True)> _
    Public Function DeleteGuest(ByVal guestId As Integer) As Boolean
        Return Adapter.Delete(guestId) = 1
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Insert, True)> _
    Public Function InsertGuest( _
            ByVal registrationId As Integer, _
            ByVal firstName As String, _
            ByVal lastName As String, _
            ByVal email As String, _
            ByVal company As String, _
            ByVal title As String) _
                As Boolean

        Return Adapter.Insert(registrationId, firstName, lastName, email, company, title) = 1
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Update, True)> _
    Public Function UpdateGuest( _
            ByVal guestId As Integer, _
            ByVal firstName As String, _
            ByVal lastName As String, _
            ByVal email As String, _
            ByVal company As String, _
            ByVal title As String) _
                As Boolean

        Return Adapter.Update(guestId, firstName, lastName, email, company, title) = 1
    End Function

End Class
