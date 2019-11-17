Imports Microsoft.VisualBasic
Imports EventDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class ContactBll

    Private _adapter As ContactTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As ContactTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New ContactTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetContactByEventId(ByVal eventId As Integer) As EventDAL.ContactDataTable
        Return Adapter.GetContacts(Nothing, eventId)
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetContactByContactId(ByVal contactId As Integer) As EventDAL.ContactDataTable
        Return Adapter.GetContacts(contactId, Nothing)
    End Function

    'Returns e-mail address
    Public Function GetContactToEmail(ByVal contactId As Nullable(Of Integer)) As String

        Dim contactToEmail As String = String.Empty

        'Set the default contact e-mail to the app admin in case nothing else is found
        If Not ConfigurationManager.AppSettings("adminEmail") Is Nothing Then
            contactToEmail = ConfigurationManager.AppSettings("adminEmail")
        End If

        'Find the contact
        Dim contacts As EventDAL.ContactDataTable = Adapter.GetContacts(contactId, Nothing)
        If contacts.Rows.Count = 1 Then
            'Only one contact was returned so return that
            contactToEmail = contacts(0).Email
        Else
            'Either more than one was returned or none at all, so go through all contacts, looking for the "Main Contact"
            contacts = Adapter.GetContacts(Nothing, Nothing)
            For Each contact As EventDAL.ContactRow In contacts
                If contact.IsMainContact Then
                    contactToEmail = contact.Email
                End If
            Next
        End If

        Return contactToEmail

    End Function
End Class
