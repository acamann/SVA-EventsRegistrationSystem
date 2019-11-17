Imports Microsoft.VisualBasic
Imports RegistrationDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class RegistrationBll


#Region " RegistrationBll "

#Region "   Adapter "

    Private _adapter As RegistrationTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As RegistrationTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New RegistrationTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

#End Region

#Region "   Select "

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetRegistrationByEventId(ByVal eventId As Integer) As RegistrationDAL.RegistrationDataTable
        Dim userId As Guid = UserMethods.GetUserId()
        If Not userId = Nothing Then
            Return Adapter.GetRegistrationByEventAndUser(eventId, userId)
        End If
        Return Nothing
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetRegistrationById(ByVal registrationId As Integer) As RegistrationDAL.RegistrationDataTable
        Return Adapter.GetRegistrations(Nothing, Nothing, registrationId)
    End Function

#End Region

#Region "   Complete Registration "

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Update, True)> _
    Public Function CompleteRegistration( _
            ByVal registrationId As Integer, _
            ByVal referral As String, _
            ByVal isFirstTime As Boolean, _
            ByVal wouldPurchaseVideo As Boolean, _
            ByVal menuItemId As Nullable(Of Short), _
            ByVal specialAccommodations As String, _
            ByVal dietaryRestrictions As String, _
            ByVal hasHousingNeeds As Boolean) _
                As Boolean

        Dim success As Boolean = False
        success = Adapter.Update(registrationId, referral, isFirstTime, wouldPurchaseVideo, menuItemId, specialAccommodations, dietaryRestrictions, hasHousingNeeds) > 0
        If success Then
            'Email the Receipt
            EmailHelper.EmailReceipt(registrationId)
        End If
        Return success
    End Function

#End Region

#Region "   Cancel Registration "

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Update, False)> _
    Public Function CancelRegistration(ByVal registrationId As Integer) As Boolean

        'Get the event Id
        Dim eventId As Integer
        Dim registrationTable As RegistrationDAL.RegistrationDataTable
        registrationTable = GetRegistrationById(registrationId)
        If registrationTable.Rows.Count > 0 Then
            eventId = registrationTable(0).EventId
        Else
            Return False
        End If

        'Check to see if this cancellation will cause a full event to open up
        Dim sendEventWaitingList As Boolean = False
        Dim eventBll As New EventBll
        Dim eventTable As EventDAL.EventDataTable = eventBll.GetEventById(eventId)
        If eventTable.Rows.Count > 0 Then
            'If the event is currently full (Attendnace = Max Attendance)
            If eventTable(0).Attendance = eventTable(0).MaxAttendance Then
                'Remember that we need to e-mail the waiting list
                sendEventWaitingList = True
            End If
        Else
            Return False
        End If

        'Now Check to see if this cancellation will cause a breakout to open up
        Dim breakoutWaitingListToSend As New ArrayList
        Dim breakoutBll As New BreakoutBll
        Dim breakoutTable As EventDAL.BreakoutDataTable = breakoutBll.GetBreakoutsByEventId(eventId)
        For Each breakout As EventDAL.BreakoutRow In breakoutTable
            'If any of the breakouts are currently full
            If breakout.Attendance = breakout.MaxAttendance Then
                'Cycle through this guy's breakouts to see if he was registered for it
                Dim myBreakouts As RegistrationDAL.BreakoutReceiptDataTable = breakoutBll.GetBreakoutRegistration(breakout.SessionId, registrationId)
                For Each myBreakout As RegistrationDAL.BreakoutReceiptRow In myBreakouts
                    If myBreakout.BreakoutId = breakout.BreakoutId Then
                        'If they match, that means that this cancellation will open up a spot in the breakout, 
                        '   so add it to the arraylist
                        breakoutWaitingListToSend.Add(breakout.BreakoutId)
                    End If
                Next
            End If
        Next


        'Cancel the registration
        Dim success As Boolean = False
        success = Adapter.Cancel(registrationId) > 0


        If success Then

            Dim waitingListBll As New WaitingListBll

            'If we're supposed to send the Event Waiting List, do it
            If sendEventWaitingList Then
                Dim waitingList As EventDAL.EventWaitingListDataTable
                waitingList = waitingListBll.GetWaitingList(eventId, Nothing)
                If waitingList.Rows.Count > 0 Then
                    'Email the waiting list
                    EmailHelper.EmailEventWaitOver(eventId)
                End If
            End If

            'If we're supposed to send any BreakOut Watiing Lists, do it
            Dim breakoutWait As RegistrationDAL.BreakoutWaitingListDataTable
            For Each breakoutId As Integer In breakoutWaitingListToSend
                'Email the breakout Waiting List
                breakoutWait = waitingListBll.GetBreakoutWaitingListById(breakoutId)
                If breakoutWait.Rows.Count > 0 Then
                    'Email the breakout waiting list
                    EmailHelper.EmailBreakoutWaitOver(breakoutId, eventId)
                End If
            Next

        End If

        Return success

    End Function

#End Region

#Region "   Can Register "

    Public Function CanRegister(ByVal eventId As Integer) As Boolean

        Dim regInfo As RegistrationDAL.RegistrationInfoDataTable
        regInfo = GetRegistrationInfo(eventId)
        If regInfo.Rows.Count > 0 Then

            If Not regInfo(0).IsRegisterFromNull Then
                'If there is a From date and it is after now
                If regInfo(0).RegisterFrom > Now Then Return False
            End If

            If Not regInfo(0).IsRegisterToNull Then
                'If there is a To date and it before now
                If regInfo(0).RegisterTo < Now Then Return False
            End If

        Else
            'If we couldn't find the registration info, then we can't register
            Return False
        End If

        'If we miss these cases, return true (we can register)
        Return True

    End Function

#End Region

#End Region


#Region " Registration Info "

    Private _regInfoAdapter As RegistrationInfoTableAdapter = Nothing
    Protected ReadOnly Property RegInfoAdapter() As RegistrationInfoTableAdapter
        Get
            If _regInfoAdapter Is Nothing Then
                _regInfoAdapter = New RegistrationInfoTableAdapter()
            End If

            Return _regInfoAdapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetRegistrationInfo( _
            ByVal eventId As Integer) _
                As RegistrationDAL.RegistrationInfoDataTable

        Return RegInfoAdapter.GetRegistrationInfo(eventId, UserMethods.GetUserId())
    End Function

#End Region


#Region " Get Registration Steps "

    Public Function GetRegistrationStepsByEvent(ByVal eventId As Integer) As Generic.List(Of RegistrationStep)
        Dim steps As New Generic.List(Of RegistrationStep)

        Dim eventBll As New EventBll
        Dim events As EventDAL.EventDataTable = eventBll.GetEventById(eventId)

        If events.Rows.Count < 1 Then Return Nothing

        Dim ev As EventDAL.EventRow = events(0)


        steps.Add(New RegistrationStep("Contact", 0))

        'Event Information (optional)
        If ev.HasBasicQuestions Then
            steps.Add(New RegistrationStep("Referral", 1))
        End If

        'Guest Registration (optional)
        If ev.HasGuests Then
            steps.Add(New RegistrationStep("Guests", 2))
        End If

        'Send Invitations (optional)
        If ev.HasInvites Then
            steps.Add(New RegistrationStep("Invitations", 3))
        End If

        'Menu Selection (optional)
        If ev.HasMenu Then
            steps.Add(New RegistrationStep("Menu", 4))
        End If

        'Housing Information (optional)
        If ev.HasHousingContact Then
            steps.Add(New RegistrationStep("Housing", 5))
        End If

        'BreakOuts (optional)
        If ev.HasBreakOuts Then
            steps.Add(New RegistrationStep("Breakouts", 6))
        End If

        'Remove Summary for now and just submit registration
        'steps.Add(New RegistrationStep("Summary", 7))

        'Has Cost (optional)
        If ev.HasCost Then

            'This extra step was removed because it is double checked in the event manager

            'In addition to relying on the "Has Cost" field,
            '   let's check to make sure that there are actually pricing levels associated
            Dim pricingBll As New PricingBll
            Dim pricingTable As RegistrationDAL.PricingDataTable
            pricingTable = pricingBll.SelectCurrentPricing(eventId)

            If pricingTable.Rows.Count > 0 Then
                'If there are pricign levels associated,
                'We'll still ignore the Payment screen if there is only one level and it is FREE
                If Not (pricingTable.Rows.Count = 1 And pricingTable(0).Price = 0) Then
                    steps.Add(New RegistrationStep("Payment", 8))
                End If

            End If
        End If

        steps.Add(New RegistrationStep("Receipt", 9))

        Return steps
    End Function

#End Region


End Class


#Region " Registration Step Class "

Public Class RegistrationStep

    Private _title As String
    Public Property Title() As String
        Get
            Return _title
        End Get
        Set(ByVal value As String)
            _title = value
        End Set
    End Property


    Private _index As Integer
    Public Property Index() As Integer
        Get
            Return _index
        End Get
        Set(ByVal value As Integer)
            _index = value
        End Set
    End Property


    Public Sub New(ByVal title As String, ByVal index As Integer)
        _title = title
        _index = index
    End Sub

End Class

#End Region

