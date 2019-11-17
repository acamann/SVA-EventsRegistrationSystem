
Partial Class Details_Default
    Inherits System.Web.UI.Page

    'Event Details Page:
    '  Shows the details for an event
    '   - Title, image, date, facility, contact, description, registration info/button
    '
    ' QueryString:
    '   - EventId (required), an integer value associated with the Event


#Region " EventId "

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

#Region " Details Setup / Querystring "

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        'Pull the eventId from the querystring (if there's invalid data, redirect)
        EventId = Tools.CheckQueryStringInt("EventId", "Event")

        'Set up Registration Info control
        RegistrationInfo1.EventId = EventId

    End Sub

    Protected Sub fvEvent_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles fvEvent.DataBound

        If fvEvent.DataItemCount = 0 Then
            'Redirect to "Event Not Found" page
            Tools.ObjectNotFound("Event")
        End If

        Dim hdnDatePublished As HiddenField = fvEvent.FindControl("hdnDatePublished")
        If hdnDatePublished.Value = Nothing Then
            'If the event isn't published yet, make the user log-in and make sure it is the admin
            UserMethods.AuthenticateUser()
            If Not UserMethods.IsAdmin() Then
                'If it's not the Admin, redirect to insufficient access
                UserMethods.InsufficientAccess()
            End If

        End If

    End Sub

#End Region

#Region " Set up Hyperlinks - Add EventId "

    Protected Sub AddEventIdToLink(ByVal sender As Object, ByVal e As EventArgs)
        Dim link As HyperLink = sender
        link.NavigateUrl = link.NavigateUrl & "&EventId=" & EventId
    End Sub

#End Region

End Class
