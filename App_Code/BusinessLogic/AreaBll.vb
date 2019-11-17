Imports Microsoft.VisualBasic
Imports EventDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class AreaBll

#Region " Area "

    Private _adapter As AreaTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As AreaTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New AreaTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetAreas() As EventDAL.AreaDataTable
        Return Adapter.GetAreas(Nothing)
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetAreaById(ByVal areaId As Byte) As EventDAL.AreaDataTable
        Return Adapter.GetAreas(areaId)
    End Function

#End Region

#Region " Area Attraction "

    Private _attractionAdapter As AreaAttractionTableAdapter = Nothing
    Protected ReadOnly Property AttractionAdapter() As AreaAttractionTableAdapter
        Get
            If _attractionAdapter Is Nothing Then
                _attractionAdapter = New AreaAttractionTableAdapter()
            End If

            Return _attractionAdapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetAreaAttractions(ByVal areaId As Byte) As EventDAL.AreaAttractionDataTable
        Return AttractionAdapter.GetAreaAttractions(areaId)
    End Function

#End Region

End Class
