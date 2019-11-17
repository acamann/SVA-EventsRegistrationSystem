Imports Microsoft.VisualBasic
Imports EventDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class MenuItemBll

    Private _adapter As MenuItemTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As MenuItemTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New MenuItemTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetMenuItemsByEventId(ByVal eventId As Integer) As EventDAL.MenuItemDataTable
        Return Adapter.GetMenuItems(eventId)
    End Function

End Class
