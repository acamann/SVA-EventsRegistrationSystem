
Partial Class App_UserControls_RegistrationInfo
    Inherits System.Web.UI.UserControl

    Public WriteOnly Property EventId() As Nullable(Of Integer)
        Set(ByVal value As Nullable(Of Integer))
            If value.HasValue Then
                LoadRegistrationInfo(value.Value)
            End If
        End Set
    End Property

#Region " Grab the Registration Info for this event and current user (if any) "

    Private Sub LoadRegistrationInfo(ByVal eventId As Integer)

        'Get the registration info for this user (if logged in) and the current EventId
        Dim registrationBll As New RegistrationBll
        Dim registrationInfoTable As RegistrationDAL.RegistrationInfoDataTable
        registrationInfoTable = registrationBll.GetRegistrationInfo(eventId)
        If registrationInfoTable.Rows.Count > 0 Then
            'If we successfully grabbed the row, determine what to display
            DetermineDisplay(registrationInfoTable(0))
        Else
            'If the registration info could not be found - display generic register button

        End If

    End Sub

#End Region

#Region " Determine what to display based on registration info "

    Private Sub DetermineDisplay(ByVal registrationInfo As RegistrationDAL.RegistrationInfoRow)
        'Set the multipage view to display based on the registration info:

        If registrationInfo.IsDatePublishedNull Then
            'the event has not been published
            viewNotPublished.Selected = True

        Else
            'the event has been published

            If Not registrationInfo.IsDateCancelledNull Then
                'the event has been cancelled!
                viewCancelled.Selected = True
                lblDateCancelled.Text = FormatDateTime(registrationInfo.DateCancelled, DateFormat.ShortDate)

            Else
                'the event has not been cancelled, so check all the normal cases...

                If Not registrationInfo.IsDateRegCancelledNull Then
                    'the current user registered and already cancelled for this event
                    '   show when they cancelled

                    viewRegCancelled.Selected = True
                    lblRegCancelledDate.Text = FormatDateTime(registrationInfo.DateRegCancelled, DateFormat.ShortDate)


                ElseIf registrationInfo.IsRegistered Then
                    'the current user is registered for this event, ready and raring to go
                    '   show when they were registered and link to receipt

                    viewIsRegistered.Selected = True
                    lblDateRegistered.Text = FormatDateTime(registrationInfo.DateRegistered, DateFormat.ShortDate)
                    hlViewReceipt.NavigateUrl = "~/Registration/Receipt.aspx?RegistrationId=" & registrationInfo.RegistrationId
                    hlCancelRegistration.NavigateUrl = "~/Registration/Cancel.aspx?RegistrationId=" & registrationInfo.RegistrationId


                ElseIf registrationInfo.IsWaiting Then
                    'the current user is on the waiting list for this event, twiddling his thumbs
                    '   show when they joined waiting list

                    viewIsWaiting.Selected = True
                    lblDateWaiting.Text = FormatDateTime(registrationInfo.DateWaiting, DateFormat.ShortDate)


                Else
                    'the user is either not registered/waiting or not logged in

                    If registrationInfo.RegisterFrom > Now Then
                        'event registration hasn't started yet, I can't wait!
                        '   Show when registration begins

                        viewNotYet.Selected = True
                        lblBegins.Text = FormatDateTime(registrationInfo.RegisterFrom, DateFormat.ShortDate)


                    ElseIf registrationInfo.RegisterTo < Now Then
                        'event registration is over, wah-wah...
                        '   Show when registration ended

                        viewEnded.Selected = True
                        lblEnded.Text = FormatDateTime(registrationInfo.RegisterTo, DateFormat.ShortDate)


                    Else
                        'we are currently within the registration dates, booyah!

                        If registrationInfo.Attendance < registrationInfo.MaxAttendance Then
                            'there are still spots remaining for the event, get it while it's hot
                            '   Show the # of remaining seats and a nice big "Register" button

                            viewOpen.Selected = True
                            lblRemaining.Text = registrationInfo.MaxAttendance - registrationInfo.Attendance
                            hlRegister.NavigateUrl = "~/Registration/Default.aspx?EventId=" & registrationInfo.EventId

                        Else
                            'the event is Full!
                            '   Show that it is full - oh well, better luck next time.

                            viewFull.Selected = True
                            hlJoinWaitingList.NavigateUrl = "~/Registration/WaitingList.aspx?EventId=" & registrationInfo.EventId

                        End If

                    End If

                End If

            End If

        End If

    End Sub

#End Region


End Class

