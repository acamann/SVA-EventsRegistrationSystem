
Partial Class Details_Agenda
    Inherits System.Web.UI.Page

    'Agenda Page:
    '  Shows the agenda details for an event
    '   - Set up as an ordered list using three nested ListViews:
    '        Day > Session > Breakout
    '
    ' QueryString:
    '   - EventId (required), an integer value associated with the Event that has the desired agenda

#Region " EventId Property "

    Private _eventId As Integer
    Public Property EventId() As Integer
        Get
            Return _eventId
        End Get
        Set(ByVal value As Integer)
            _eventId = value
        End Set
    End Property

#End Region

#Region " Page Init "

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        'Pull the EventId from the querystring
        EventId = Tools.CheckQueryStringInt("EventId", "Event Agenda")

        'Set up the "Back to Event" link
        hlEventsDetails.NavigateUrl = "~/Details/Default.aspx?EventId=" & EventId

        'Set up the event header
        EventPageHeader1.EventId = EventId

    End Sub

#End Region

#Region " Set Up Nested Agenda ListViews "

    Protected Sub lvEventDay_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ListViewItemEventArgs) Handles lvEventDay.ItemDataBound

        'Set up the session data source for each event Day
        Dim odsSession As ObjectDataSource = e.Item.FindControl("odsSession")
        Dim hdnDayId As HiddenField = e.Item.FindControl("hdnDayId")
        odsSession.SelectParameters("DayId").DefaultValue = hdnDayId.Value

    End Sub

    Protected Sub lvSession_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ListViewItemEventArgs)

        'Set up the breakout datasource for each session
        Dim odsBreakout As ObjectDataSource = e.Item.FindControl("odsBreakout")
        Dim hdnSessionId As HiddenField = e.Item.FindControl("hdnSessionId")
        odsBreakout.SelectParameters("SessionId").DefaultValue = hdnSessionId.Value

    End Sub

    Protected Sub lbBreakout_Load(ByVal sender As Object, ByVal e As EventArgs)

        'Set up the linkbutton that toggles the Breakout Details via javascript
        Dim lbBreakout As LinkButton = sender
        Dim pnlBreakoutDetails As Panel = lbBreakout.Parent.FindControl("pnlBreakoutDetails")
        lbBreakout.OnClientClick = "javascript:toggle('" & pnlBreakoutDetails.ClientID & "');return false;"

    End Sub

#End Region

End Class
