
Partial Class Redirector
    Inherits System.Web.UI.Page

    'This page is automatically redirected to by any 404 error within the events app
    'This will be used for URL rewriting (www.sva.com/events/10001)

    'Raw Url = (Redirector.aspx?404;[Path...])

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        'Grab the url that sent us here 
        Dim rawUrl As String = Request.RawUrl
        'Grab everything after the last "/" (this will hopefully be an integer that we can use as the EventId
        Dim possibleEventId As String = rawUrl.Substring(rawUrl.LastIndexOf("/") + 1)

        Dim eventId As Integer
        If Integer.TryParse(possibleEventId, eventId) Then
            'If the last little piece of the 404 path is an integer, try to find the event details
            Server.Transfer("~/Details/Default.aspx?EventId=" & eventId)
        Else
            'If the last little piece of the 404 path is invalid as an Event Id, 
            ' just take to a page not found error
            Tools.ObjectNotFound("Page")
        End If

    End Sub


End Class
