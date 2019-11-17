Imports Microsoft.VisualBasic
Imports EventDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class FacilityBll

    Private _adapter As FacilityTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As FacilityTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New FacilityTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetFacilityByEventId(ByVal eventId As Integer) As EventDAL.FacilityDataTable
        Return Adapter.GetFacilities(Nothing, eventId)
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetFacilityById(ByVal facilityId As Integer) As EventDAL.FacilityDataTable
        Return Adapter.GetFacilities(facilityId, Nothing)
    End Function

End Class
