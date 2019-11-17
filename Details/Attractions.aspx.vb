
Partial Class Details_Attractions
    Inherits System.Web.UI.Page

    'Area Attractions Page:
    '  Shows the area attractions associated with a location
    '   - Name, description, Image, website link
    '
    ' QueryString:
    '   - AreaId (required), an integer value associated with the Area
    '   - FacilityId (optional), an integer value used for backlink to the Facility that the user just came from, if any
    '   - EventId (optional), an integer value used for backlink to the Event that the user just came from, if any


#Region " Properties "

    Private _areaId As Integer
    Public Property AreaId() As Integer
        Get
            Return _areaId
        End Get
        Set(ByVal value As Integer)
            _areaId = value
        End Set
    End Property

    Private _eventId As Nullable(Of Integer)
    Public Property EventId() As Nullable(Of Integer)
        Get
            Return _eventId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            _eventId = value
        End Set
    End Property

    Private _facilityId As Nullable(Of Integer)
    Public Property FacilityId() As Nullable(Of Integer)
        Get
            Return _facilityId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            _facilityId = value
        End Set
    End Property

#End Region

#Region " Page Init "

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        'Pull properties from querystring (if they exist)
        '  The only required one is AreaId, the rest are optional
        AreaId = Tools.CheckQueryStringInt("AreaId", "Location")
        FacilityId = Tools.GetSafeQueryStringInt("FacilityId")
        EventId = Tools.GetSafeQueryStringInt("EventId")

    End Sub

#End Region

#Region " Set up hyperlinks "

    Protected Sub hlEventDetails_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles hlEventDetails.Load

        'Set up "back to event details" button
        If Not EventId Is Nothing Then
            hlEventDetails.NavigateUrl = "~/Details/Default.aspx?EventId=" & EventId
            hlEventDetails.Visible = True
        End If

    End Sub

    Protected Sub hlFacilityDetails_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles hlFacilityDetails.Load

        'Set up "back to facility details" button
        If Not FacilityId Is Nothing Then

            hlFacilityDetails.NavigateUrl = "~/Details/Facility.aspx?FacilityId=" & FacilityId

            If Not EventId Is Nothing Then
                hlFacilityDetails.NavigateUrl = hlFacilityDetails.NavigateUrl & "&EventId=" & EventId
            End If

            hlFacilityDetails.Visible = True

        End If

    End Sub

#End Region

End Class
