
Partial Class Registration_Default
    Inherits System.Web.UI.Page

#Region " Setup "

#Region "   Properties "

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

#Region "   Page Init "

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        'Verify EventId
        EventId = Tools.CheckQueryStringInt("EventId", "Event")

        'If Registration is Closed, redirect to the event details page
        Dim registrationBll As New RegistrationBll
        If Not registrationBll.CanRegister(EventId) Then
            Response.Redirect("~/Details/Default.aspx?EventId=" & EventId)
        End If

        If Not IsPostBack Then
            BeginRegistration()
        End If

    End Sub

#End Region

#Region "   Begin Registration "

    Private Sub BeginRegistration()

        UserMethods.AuthenticateUser()

        EventPageHeader1.EventId = EventId

        'Get Registration (add if it doesn't exist)
        odsRegistration.SelectParameters("EventId").DefaultValue = EventId
        fvRegistration.DataSource = odsRegistration
        fvRegistration.DataBind()

    End Sub

#End Region

#End Region

#Region " Registration Form DataBound "

    Protected Sub fvRegistration_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles fvRegistration.DataBound

        Dim hdnRegistered As HiddenField = fvRegistration.FindControl("hdnRegistered")
        Dim dateRegistered As Date
        If Date.TryParse(hdnRegistered.Value, dateRegistered) Then
            'if the registration has already been completed, forward to a receipt page
            Response.Redirect("~/Registration/Receipt.aspx?RegistrationId=" & fvRegistration.DataKey.Value)
        End If

    End Sub

#End Region

#Region " Wizard Navigation "

    Private Function GetWizard() As Wizard
        Return DirectCast(fvRegistration.FindControl("Wizard1"), Wizard)
    End Function

    Protected Sub Wizard1_NextButtonClick(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.WizardNavigationEventArgs)
        Navigate(lvRegistrationSteps.SelectedIndex, e, True)
    End Sub

    Protected Sub Wizard1_PreviousButtonClick(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.WizardNavigationEventArgs)
        Navigate(lvRegistrationSteps.SelectedIndex, e, False)
    End Sub

    Private Sub Navigate(ByVal currentIndex As Integer, ByVal e As System.Web.UI.WebControls.WizardNavigationEventArgs, ByVal isNext As Boolean)

        UserMethods.AuthenticateUser()

        If e.CurrentStepIndex = 6 Then
            'If we're registering for breakouts, advance the data pager (or previous)
            'If we are only changing pages, exit the sub (or if first/last data page, navigate the wizard)
            If NavigateSession(isNext) Then
                e.Cancel = True
                Exit Sub
            End If
        End If

        'Move the navigation on the left in the right direction
        If isNext Then
            lvRegistrationSteps.SelectedIndex += 1
        Else
            lvRegistrationSteps.SelectedIndex -= 1
        End If

        'Based on the value of the left navigation, set the wizard step
        Dim index As Integer = lvRegistrationSteps.SelectedDataKey.Value

        If index <= 6 Then
            'If we haven't finished yet, keep moving
            GetWizard.ActiveStepIndex = index
        Else
            'send to the receipt/payment if we've passed the hardest part
            CompleteRegistration()
        End If

    End Sub


#End Region

#Region " Registration Steps "

#Region " Step 0 : Edit Profile - Mode Changed (Next button disabled) "

    Protected Sub ProfileModeChanged(ByVal currentMode As FormViewMode)
        If Not currentMode = FormViewMode.ReadOnly Then
            GetWizard.StartNextButtonText = ""
        Else
            GetWizard.StartNextButtonText = "Next"
        End If
    End Sub

    Protected Sub EditProfile1_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim editProfile As App_UserControls_EditProfile
        editProfile = DirectCast(sender, App_UserControls_EditProfile)
        AddHandler editProfile.ModeChanged, AddressOf ProfileModeChanged
    End Sub

#End Region

#Region " Step 1 : Event Info "



#End Region

#Region " Step 2 : Guests "

    Protected Sub wizGuest_Activate(ByVal sender As Object, ByVal e As System.EventArgs)
        'Display Invite information
        Dim odsGuest As ObjectDataSource
        odsGuest = DirectCast(DirectCast(sender, WizardStep).FindControl("OdsGuest"), ObjectDataSource)
        odsGuest.SelectParameters("RegistrationId").DefaultValue = fvRegistration.DataKey.Value
    End Sub

    Protected Sub lvGuest_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ListViewInsertEventArgs)
        e.Values("RegistrationId") = fvRegistration.DataKey.Value
    End Sub

#End Region

#Region " Step 3 : Invites "

    Protected Sub wizInvite_Activate(ByVal sender As Object, ByVal e As System.EventArgs)
        'Display Invite information
        Dim odsInvite As ObjectDataSource
        odsInvite = DirectCast(DirectCast(sender, WizardStep).FindControl("OdsInvite"), ObjectDataSource)
        odsInvite.SelectParameters("RegistrationId").DefaultValue = fvRegistration.DataKey.Value
    End Sub

    Protected Sub lvInvite_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ListViewInsertEventArgs)
        e.Values("RegistrationId") = fvRegistration.DataKey.Value
    End Sub

#End Region

#Region " Step 6 : Breakouts "

    Protected Sub lbDetails_Load(ByVal sender As Object, ByVal e As EventArgs)

        Dim lbDetails As LinkButton = sender
        Dim pnlDetails As Panel = lbDetails.Parent.FindControl("pnlDetails")
        lbDetails.OnClientClick = "javascript:toggle('" & pnlDetails.ClientID & "');return false;"

    End Sub

    Protected Sub wizBreakouts_Activate(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim fvEventSession As FormView = DirectCast(DirectCast(sender, WizardStep).FindControl("fvEventSession"), FormView)
        fvEventSession.DataBind()
    End Sub

    Protected Sub fvEventSession_DataBound(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim fvEventTitle As FormView = DirectCast(sender, FormView)
        If fvEventTitle.DataItemCount > 0 Then
            Dim odsBreakout As ObjectDataSource = fvEventTitle.FindControl("odsBreakout")
            Dim hdnSessionId As HiddenField = fvEventTitle.FindControl("hdnSessionId")
            odsBreakout.SelectParameters("RegistrationId").DefaultValue = fvRegistration.DataKey.Value
            odsBreakout.SelectParameters("SessionId").DefaultValue = hdnSessionId.Value
            Dim lblSessionNumber As Label = fvEventTitle.FindControl("lblSessionNumber")
            lblSessionNumber.Text = fvEventTitle.PageIndex + 1
        End If
    End Sub

    Protected Sub lvBreakout_DataBound(ByVal sender As Object, ByVal e As System.EventArgs)
        ' Determine the amount still needed to register for this session
        Dim lvBreakout As ListView = sender
        If lvBreakout.Items.Count > 0 Then
            Dim hdnSessionMax As HiddenField = lvBreakout.Items(0).FindControl("hdnSessionMax")
            Dim hdnSessionAttendance As HiddenField = lvBreakout.Items(0).FindControl("hdnSessionAttendance")

            Dim sessionAttendance As Integer = hdnSessionAttendance.Value
            Dim sessionMax As Integer = hdnSessionMax.Value

            If sessionAttendance = sessionMax Then
                'Good to go! - show check image and enable "Next" button
                ''Do nothing and leave it as the default
                ''Dim lbNext As LinkButton = GetWizard.FindControl("StepNavigationTemplateContainerID").FindControl("lbNext")
                ''lbNext.Enabled = True

            Else
                '' 'Disable the next button
                ''Dim lbNext As LinkButton = GetWizard.FindControl("StepNavigationTemplateContainerID").FindControl("lbNext")
                ''lbNext.Enabled = False


                Dim pnlSessionStatus As Panel = GetWizard.FindControl("fvEventSession").FindControl("pnlSessionStatus")
                If sessionAttendance < sessionMax Then
                    'Still need to register for more - display the number
                    pnlSessionStatus.Controls.Clear()
                    pnlSessionStatus.Controls.Add(New LiteralControl("Please add <span style='color:red;font-size:2em;'>" & (sessionMax - sessionAttendance) & "</span>"))
                Else
                    'Need to UNregister
                    pnlSessionStatus.Controls.Clear()
                    pnlSessionStatus.Controls.Add(New LiteralControl("Please remove <span style='color:red;font-size:2em;'>" & (sessionAttendance - sessionMax) & "</span>"))
                End If
            End If


        Else
            'There aren't any breakouts in this session?
        End If


        ''Dim lvBreakout As ListView = sender

        '' ''If already registered for a breakout in this session, select it?
        ''Dim registrationId As Integer = fvRegistration.DataKey.Value
        ''Dim breakoutDal As New BreakoutDALTableAdapters.BreakoutRegistrationTableAdapter
        ''Dim breakouts As BreakoutDAL.BreakoutRegistrationDataTable = breakoutDal.GetBreakoutRegistration(registrationId)
        ''For Each breakout As BreakoutDAL.BreakoutRegistrationRow In breakouts
        ''    For Each item As ListViewItem In lvBreakout.Items
        ''        If breakout.BreakoutId.Equals(
        ''    Next
        ''    lvBreakout.Items(i)
        ''Next
    End Sub

    Private Function NavigateSession(ByVal isNext As Boolean) As Boolean
        Dim fvEventSession As FormView = DirectCast(GetWizard.FindControl("fvEventSession"), FormView)

        If isNext Then
            If fvEventSession.PageIndex >= fvEventSession.PageCount - 1 Then Return False
            fvEventSession.PageIndex += 1
        Else
            If fvEventSession.PageIndex = 0 Then Return False
            fvEventSession.PageIndex -= 1
        End If

        Return True
    End Function

    Protected Sub lvBreakout_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ListViewCommandEventArgs)
        Select Case e.CommandName
            Case "Register"
                BreakoutRegister(e.CommandArgument)

            Case "Unregister"
                BreakoutUnregister(e.CommandArgument)

            Case "WaitingList"
                BreakoutWaitingList(e.CommandArgument)

        End Select
    End Sub

    Private Sub BreakoutRegister(ByVal breakoutId As Integer)
        odsBreakoutRegister.InsertParameters("RegistrationId").DefaultValue = fvRegistration.DataKey.Value
        odsBreakoutRegister.InsertParameters("BreakoutId").DefaultValue = breakoutId
        odsBreakoutRegister.Insert()
    End Sub


    Protected Sub odsBreakoutRegister_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ObjectDataSourceStatusEventArgs) Handles odsBreakoutRegister.Inserted
        'after insert, refresh the current session of breakouts
        GetWizard.FindControl("fvEventSession").DataBind()
    End Sub

    Private Sub BreakoutUnregister(ByVal breakoutId As Integer)
        odsBreakoutRegister.DeleteParameters("RegistrationId").DefaultValue = fvRegistration.DataKey.Value
        odsBreakoutRegister.DeleteParameters("BreakoutId").DefaultValue = breakoutId
        odsBreakoutRegister.Delete()
    End Sub


    Protected Sub odsBreakoutRegister_Deleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ObjectDataSourceStatusEventArgs) Handles odsBreakoutRegister.Deleted
        'after unregister, refresh the current session of breakouts
        GetWizard.FindControl("fvEventSession").DataBind()
    End Sub


    Private Sub BreakoutWaitingList(ByVal breakoutId As Integer)
        odsBreakoutWait.InsertParameters("RegistrationId").DefaultValue = fvRegistration.DataKey.Value
        odsBreakoutWait.InsertParameters("BreakoutId").DefaultValue = breakoutId
        odsBreakoutWait.Insert()
    End Sub

    Protected Sub odsBreakoutWait_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ObjectDataSourceStatusEventArgs) Handles odsBreakoutWait.Inserted
        'after insert, refresh the current session of breakouts
        GetWizard.FindControl("fvEventSession").DataBind()
    End Sub

#End Region

#Region " Step 7 : Registration Summary "

    ''Protected Sub wizSummary_Activate(ByVal sender As Object, ByVal e As System.EventArgs)
    ''    'Set the destination for registration completion to either the Payment page (if payment is required)
    ''    ' or the Receipt page (if it isn't) 

    ''    Dim eventBll As New EventBll
    ''    Dim events As EventDAL.EventDataTable = eventBll.GetEventById(EventId)
    ''    If events.Rows.Count > 0 Then
    ''        If events(0).HasCost Then
    ''            GetWizard.FinishDestinationPageUrl = "~/Registration/Payment.aspx?RegistrationId=" & fvRegistration.DataKey.Value
    ''        Else
    ''            GetWizard.FinishDestinationPageUrl = "~/Registration/Receipt.aspx?RegistrationId=" & fvRegistration.DataKey.Value
    ''        End If

    ''    Else
    ''        'Something wrong with the event
    ''    End If

    ''End Sub

#End Region

#Region " Finish (Complete Registration) "

    Protected Sub Wizard1_FinishButtonClick(ByVal sender As Object, ByVal e As System.EventArgs)
        CompleteRegistration()
    End Sub

    Protected Sub CompleteRegistration()
        'go through the wizard, grab all the entered data, verify, complete the registration, send to Payment/Receipt

        'Referral
        Dim referral As String = Nothing
        Dim ddlReferral As DropDownList = GetWizard.FindControl("ddlReferral")
        If ddlReferral.SelectedIndex >= 0 Then
            referral = ddlReferral.SelectedValue
        End If
        Dim txtReferralDetails As TextBox = GetWizard.FindControl("txtReferralDetails")
        If txtReferralDetails.Text.Length > 0 Then
            referral = referral & ": " & txtReferralDetails.Text
        End If

        'IsFirstTime
        Dim cbFirstTime As CheckBox = GetWizard.FindControl("cbFirstTime")
        Dim isFirstTime As Boolean = cbFirstTime.Checked

        'WouldPurchaseVideo
        Dim cbWouldPurchaseVideo As CheckBox = GetWizard.FindControl("cbWouldPurchaseVideo")
        Dim wouldPurchaseVideo As Boolean = cbWouldPurchaseVideo.Checked

        'MenuItemId
        Dim menuItemId As Nullable(Of Integer)
        Dim rblMenuItems As RadioButtonList = GetWizard.FindControl("rblMenuItems")
        If rblMenuItems.SelectedIndex > 0 Then
            menuItemId = rblMenuItems.SelectedValue
        End If

        'SpecialAccommodations
        Dim specialAccommodations As String = Nothing
        Dim txtAccommodations As TextBox = GetWizard.FindControl("txtAccommodations")
        If txtAccommodations.Text.Length > 0 Then specialAccommodations = txtAccommodations.Text

        'DietaryRestrictions
        Dim dietaryRestrictions As String = Nothing
        Dim txtDietaryRestrictions As TextBox = GetWizard.FindControl("txtDietaryRestrictions")
        If txtDietaryRestrictions.Text.Length > 0 Then dietaryRestrictions = txtDietaryRestrictions.Text

        'HasHousingNeeds
        Dim cbHousing As CheckBox = GetWizard.FindControl("cbHousing")
        Dim hasHousingNeeds As Boolean = cbHousing.Checked

        Dim registrationBll As New RegistrationBll
        Dim success As Boolean = registrationBll.CompleteRegistration( _
                    fvRegistration.DataKey.Value, referral, isFirstTime, wouldPurchaseVideo, _
                    menuItemId, specialAccommodations, dietaryRestrictions, hasHousingNeeds)


        'Set the destination for registration completion to either the Payment page (if payment is required)
        ' or the Receipt page (if it isn't) 
        Dim eventBll As New EventBll
        Dim events As EventDAL.EventDataTable = eventBll.GetEventById(EventId)
        If events.Rows.Count > 0 Then
            If events(0).HasCost Then
                Response.Redirect("~/Registration/Payment.aspx?RegistrationId=" & fvRegistration.DataKey.Value)
            Else
                Response.Redirect("~/Registration/Receipt.aspx?RegistrationId=" & fvRegistration.DataKey.Value)
            End If

        Else
            'Something wrong with the event
        End If

    End Sub

#End Region

#End Region


End Class
