
Partial Class Details_Facility
    Inherits System.Web.UI.Page

    'Facility Page:
    '  Shows the details for an event facility
    '   - Address, phone, website, map, description, image
    '
    ' QueryString:
    '   - FacilityId (required), an integer value associated with the Facility
    '   - EventId (optional), an integer value used for backlink to the Event that the user just came from, if any

#Region " Properties "

    Private _facilityId As Integer
    Public Property FacilityId() As Integer
        Get
            Return _facilityId
        End Get
        Set(ByVal value As Integer)
            _facilityId = value
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

#End Region

#Region " Set Up Hyperlinks "

    Protected Sub hlEventDetails_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        If Not EventId Is Nothing Then
            'Set up "back to event details" button
            Dim hlEventDetails As HyperLink = DirectCast(sender, HyperLink)
            hlEventDetails.NavigateUrl = "~/Details/Default.aspx?EventId=" & EventId
            hlEventDetails.Visible = True
        End If

    End Sub

    Protected Sub hlAreaAttractions_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        'Set up "area attractions" button
        Dim hlAreaAttractions As HyperLink = DirectCast(sender, HyperLink)

        If Not EventId Is Nothing Then
            'add Event Id
            hlAreaAttractions.NavigateUrl &= "&EventId=" & EventId
        End If

        'add FacilityId
        hlAreaAttractions.NavigateUrl &= "&FacilityId=" & FacilityId

    End Sub


#End Region

#Region " Set Up Driving Directions "

    Protected Sub fvLocationLeftDetails_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles fvLocationLeftDetails.DataBound

        If fvLocationLeftDetails.DataItemCount = 0 Then
            Tools.ObjectNotFound("Facility")
        End If

        'Once the form is bound, set the driving directions link
        Dim lbDrivingDirections As LinkButton = DirectCast(fvLocationLeftDetails.FindControl("lbDrivingDirections"), LinkButton)
        SetUpDrivingDirections(lbDrivingDirections)

    End Sub

    Private Sub SetUpDrivingDirections(ByVal lbDrivingDirections As LinkButton)
        'Add javascript function to driving directions link
        '  Opens a google map with directions to the facility
        '  If the user is logged in, the directions are shown from their address on file

        Dim source As String = String.Empty
        Dim destination As String = lbDrivingDirections.CommandArgument

        Dim userMethods As New UserProfileBll
        Dim userProfile As UserProfileDAL.UserProfileRow = userMethods.GetUser()

        'Get User's Address for Driving Directions
        If Not userProfile Is Nothing Then
            If Not userProfile.IsAddressNull Then
                source = userProfile.Address & ", " & userProfile.City & ", " & userProfile.State
            End If
        End If

        lbDrivingDirections.OnClientClick = String.Format("javascript: window.open('http://maps.google.com/maps?saddr={0}&daddr={1}'); return false;", source, destination)

    End Sub


#End Region

#Region " Page Init "

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        'Pull properties from querystring
        '  FacilityId is requred, EventId is optional (for backlink)
        FacilityId = Tools.CheckQueryStringInt("FacilityId", "Facility")
        EventId = Tools.GetSafeQueryStringInt("EventId")

        fvLocationLeftDetails.DataSource = odsFacilityDetails
        fvLocationLeftDetails.DataBind()

    End Sub

#End Region

End Class
