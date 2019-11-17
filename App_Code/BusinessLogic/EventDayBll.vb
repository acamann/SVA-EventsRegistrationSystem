Imports Microsoft.VisualBasic
Imports EventDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class EventDayBll

    Private _adapter As EventDayTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As EventDayTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New EventDayTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetEventDaysByEventId(ByVal eventId As Integer) As EventDAL.EventDayDataTable
        Return Adapter.GetEventDays(eventId, Nothing)
    End Function

End Class
