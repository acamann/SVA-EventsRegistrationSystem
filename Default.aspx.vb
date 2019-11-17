
Partial Class _Default
    Inherits System.Web.UI.Page

    'Main (Upcoming) Events Page:
    '  Shows a list of Upcoming events
    '   - Name, short description, date, location, type, facility
    '   - Searchable and filterable
    '
    ' QueryString:
    '   - Search (optional), a string value that is searches the title and description of the events
    '   - EventTypeId (optional), an integer value that filters the event list by type
    '   - EntityId (optional), an integer value that filters the event list by which entity is sponsoring the event
    '   - FacilityId (optional), an integer value that filters the event list by facility
    

#Region " Page Init / Default Button and Focus "

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        'Set the default button and put the focus on the Search text box
        Page.Form.DefaultButton = btnSearch.UniqueID
        Page.Form.DefaultFocus = txtSearch.ClientID

    End Sub

#End Region

#Region " Search "

    Protected Sub btnSearch_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Init

        'Give the search button the correct JavaScript
        btnSearch.OnClientClick = FilterScript()

    End Sub

    Protected Sub txtSearch_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtSearch.PreRender

        'Place the search that is passed in the querystring into the search box
        txtSearch.Text = Request.QueryString("Search")

    End Sub

#End Region

#Region " Add Filter JavaScript Function to DropDownList "

    Private Sub AddFilter(ByVal dropDown As DropDownList)
        'Add the correct javascript to the dropdown
        dropDown.Attributes.Add("onchange", FilterScript)
    End Sub

    Private Function FilterScript() As String
        'Creates a javascript that calls the function "filter"
        '  and passes the clientIDs of all controls involved in a search/filter
        ' - We do this so that any search or filter appears in the querystring so that users can easily bookmark or e-mail a link to this page
        Return "javascript:filter('" & txtSearch.ClientID & "', '" & ddlEventType.ClientID & "', null, '" & ddlEntity.ClientID & "'); return false;"
    End Function

    Protected Sub ddlEventType_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEventType.Init
        AddFilter(ddlEventType)
    End Sub

    Protected Sub ddlEntity_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEntity.Init
        AddFilter(ddlEntity)
    End Sub

#End Region

#Region " Select QueryString Value in DropDownList "

    Private Sub SelectQueryStringValueInDropDown(ByVal key As String, ByVal dropDown As DropDownList)
        ' Looks for a specific key in the querystring
        '  - if it exists, select the value of that querystring key in the appropriate dropdown
        If Not IsPostBack Then
            If Not Request.QueryString(key) Is Nothing Then
                Dim value As Integer
                If Integer.TryParse(Request.QueryString(key), value) Then
                    SelectValueInDropDown(dropDown, value)
                End If
            End If
        End If
    End Sub

    Private Sub SelectValueInDropDown(ByVal dropDown As DropDownList, ByVal value As String)
        ' Finds the value in the dropdown and selects it (if it exists)

        dropDown.ClearSelection()

        For Each item As ListItem In dropDown.Items
            If item.Value.Equals(value) Then
                item.Selected = True
                Exit Sub
            End If
        Next

    End Sub

    Protected Sub ddlEntity_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEntity.DataBound
        SelectQueryStringValueInDropDown("EntityId", ddlEntity)
    End Sub

    Protected Sub ddlEventType_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEventType.DataBound
        SelectQueryStringValueInDropDown("EventTypeId", ddlEventType)
    End Sub

#End Region

#Region " Sort by Date "

    Protected Sub lvEvents_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvEvents.Init
        'By default, sort the listview by date (first events are sooner)
        lvEvents.Sort("Date", SortDirection.Ascending)
    End Sub

#End Region

#Region " Get Openings "

    Protected Function GetOpenings(ByVal maxAttendance As Integer, ByVal attendance As Integer, ByVal registerFrom As Object, ByVal registerTo As Object) As String

        'The event is full
        If maxAttendance <= attendance Then Return "<span class='openings full'>Full</span>"

        'We're too early
        If Not registerTo Is DBNull.Value Then
            Dim registerToDate As DateTime = DirectCast(registerTo, DateTime)
            If registerToDate < Now Then Return "<span class='openings full'>Closed</span>"
        End If

        'We're too late
        If Not registerFrom Is DBNull.Value Then
            Dim registerFromDate As DateTime = DirectCast(registerFrom, DateTime)
            If registerFromDate > Now Then Return "<span class='openings full'>Closed</span>"
        End If

        'Better hurry, there are less than 5 spots left!
        If maxAttendance - attendance <= 5 Then
            Return "<span class='hurry'>Openings: <span class='openings'>" & maxAttendance - attendance & "</span></span>"
        End If

        'After checking all these cases, just return the remaining number
        Return "<span class='normal'>Openings: <span class='openings'>" & maxAttendance - attendance & "</span></span>"

    End Function

#End Region

End Class
