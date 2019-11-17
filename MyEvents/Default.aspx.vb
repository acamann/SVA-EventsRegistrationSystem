
Partial Class MyEvents_Default
    Inherits System.Web.UI.Page

    'My Events Page:
    '  Shows a list of The currently logged in user's events
    '   - Must be logged in to view
    '   - Either upcoming or previous, depending on the querystring
    '   - Name, date, location, type, facility
    '
    ' QueryString:
    '   - Mode (optional), either "Upcoming" or "Previous" - shows Upcoming by default

#Region " Page Init "

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        'Redirect to the login if the user isn't authenticated
        UserMethods.AuthenticateUser()

        'Load the grid based on the querystring
        If Not IsPostBack Then
            If Request.QueryString("Mode") Is Nothing Then
                LoadGrid("Upcoming")
            Else
                LoadGrid(Request.QueryString("Mode"))
            End If
        End If

    End Sub

#End Region

#Region " Load Grid "

    'Loads the grid with the correct data based on the querystring "Mode" value
    Private Sub LoadGrid(ByVal mode As String)
        Select Case mode
            Case "Upcoming"
                lvEvents.DataSourceID = "odsUpcomingEvents"
                lblTitle.Text = "My Upcoming Events"

            Case "Previous"
                lvEvents.DataSourceID = "odsPreviousEvents"
                lblTitle.Text = "My Previous Events"

        End Select
    End Sub

    'Set the "empty data text" based on which data source is being used
    Protected Sub lvEvents_ItemCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ListViewItemEventArgs) Handles lvEvents.ItemCreated
        If e.Item.ItemType = ListViewItemType.EmptyItem Then
            Dim lblEmpty As Label = e.Item.FindControl("lblEmpty")
            Select Case Request.QueryString("Mode")
                Case "Previous"
                    lblEmpty.Text = "You have not attended any events in the past year."

                Case Else
                    lblEmpty.Text = "You are not currently registered for any future events."

            End Select
        End If
    End Sub

#End Region

End Class
