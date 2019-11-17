
Partial Class Registration_WaitingList
    Inherits System.Web.UI.Page

#Region " RegistrationId Property "

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

        UserMethods.AuthenticateUser()
        EventId = Tools.CheckQueryStringInt("EventId", "Event")

        EventPageHeader1.EventId = EventId
        hlBackToEvent.NavigateUrl = "~/Details/Default.aspx?EventId=" & EventId
        hlEventDetails.NavigateUrl = "~/Details/Default.aspx?EventId=" & EventId

        'TODO: is this what we want?
        'Add to waiting List
        Dim waitingList As New WaitingListBll
        waitingList.InsertWait(EventId, UserMethods.GetUserId())

    End Sub

#End Region

End Class
