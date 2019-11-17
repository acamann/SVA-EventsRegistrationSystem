Imports Microsoft.VisualBasic
Imports EventDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class SessionBll

    Private _adapter As SessionTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As SessionTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New SessionTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetSessionsByEventDayId(ByVal dayId As Integer) As EventDAL.SessionDataTable
        Return Adapter.GetSessions(dayId)
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetSessionsByEventId(ByVal eventId As Integer) As EventDAL.SessionDataTable
        Return Adapter.GetSessionsByEventId(eventId)
    End Function

End Class
