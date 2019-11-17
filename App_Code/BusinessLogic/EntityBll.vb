Imports Microsoft.VisualBasic
Imports EventDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class EntityBll

    Private _adapter As EntityTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As EntityTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New EntityTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetEntityById(ByVal entityId As Integer) As EventDAL.EntityDataTable
        Return Adapter.GetEntities(entityId)
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetEntities() As EventDAL.EntityDataTable
        Return Adapter.GetEntities(Nothing)
    End Function

End Class
