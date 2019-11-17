<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="Registration_Default" title="Untitled Page" %>

<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>

<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="RadTabStrip.Net2" Namespace="Telerik.WebControls" TagPrefix="radTS" %>
<%@ Register src="../App_UserControls/EditProfile.ascx" tagname="EditProfile" tagprefix="uc2" %>
<%@ Register src="../App_UserControls/EventPageHeader.ascx" tagname="EventPageHeader" tagprefix="sva" %>

<%@ Register assembly="Telerik.Web.UI" namespace="Telerik.Web.UI" tagprefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
                
    
                
    <asp:ListView ID="lvRegistrationSteps" runat="server"
            DataSourceID="odsRegistrationSteps" SelectedIndex="0" DataKeyNames="Index">
        <LayoutTemplate>
            <div class="statusheader">
                Registration Steps
                <img runat="server" id="imgHelpSteps" src="../App_Themes/Events/Images/questionmark.gif" alt="help" />
                <telerik:RadToolTip ID="RadToolTip1" runat="server" 
                        Skin="WebBlue" TargetControlID="imgHelpSteps"
                        Position="MiddleRight" RelativeTo="Element"
                        AutoCloseDelay="5000" Width="250">
                    This is a list of steps required for registration.  
                    Navigate these steps using the "Next" and "Previous" buttons on the bottom right of the page.
                </telerik:RadToolTip>
            </div>
            <ol ID="itemPlaceholderContainer" runat="server" class="statuslist">
                <span ID="itemPlaceholder" runat="server" />
            </ol>
        </LayoutTemplate>
        <EmptyDataTemplate>
        </EmptyDataTemplate>
        <SelectedItemTemplate>
            <li class="selectedstatus">
                <%#Eval("Title")%>
            </li>
        </SelectedItemTemplate>
        <ItemSeparatorTemplate>
        </ItemSeparatorTemplate>
        <ItemTemplate>
            <li class="status">
                <%#Eval("Title")%>
            </li>
        </ItemTemplate>
    </asp:ListView>
    
    <asp:ObjectDataSource ID="odsRegistrationSteps" runat="server"
            TypeName="RegistrationBll" SelectMethod="GetRegistrationStepsByEvent">
        <SelectParameters>
            <asp:QueryStringParameter Name="eventId" QueryStringField="EventId" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    
    <sva:EventPageHeader ID="EventPageHeader1" runat="server" />
    <div style="padding:5px;"></div>
    
    <asp:ObjectDataSource ID="odsRegistration" runat="server"
            TypeName="RegistrationBll"
            SelectMethod="GetRegistrationByEventId"
            UpdateMethod="CompleteRegistration" >
        <SelectParameters>
            <asp:Parameter Name="eventId" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="RegistrationId" Type="Int32" />
            <asp:Parameter Name="referral" Type="String" />
            <asp:Parameter Name="isFirstTime" Type="Boolean" />
            <asp:Parameter Name="wouldPurchaseVideo" Type="Boolean" />
            <asp:Parameter Name="menuItemId" Type="Int16" />
            <asp:Parameter Name="specialAccommodations" Type="String" />
            <asp:Parameter Name="dietaryRestrictions" Type="String" />
            <asp:Parameter Name="hasHousingNeeds" Type="Boolean" />
        </UpdateParameters>
    </asp:ObjectDataSource>

    
    <asp:FormView ID="fvRegistration" runat="server" Width="100%" 
            DefaultMode="Edit" DataKeyNames="RegistrationId">
        <EditItemTemplate>
            <asp:HiddenField ID="hdnRegistered" runat="server" Value='<%#Eval("DateRegistered")%>' />
        
            <asp:Wizard ID="Wizard1" runat="server"
                    Width="100%" 
                    DisplaySideBar="false"
                    StepNextButtonType="Link" StepPreviousButtonType="Link" 
                    FinishCompleteButtonType="Link" FinishPreviousButtonType="Link"
                    StartNextButtonType="Link"
                    OnNextButtonClick="Wizard1_NextButtonClick"
                    OnPreviousButtonClick="Wizard1_PreviousButtonClick"
                    OnFinishButtonClick="Wizard1_FinishButtonClick">
                <WizardSteps>
                    <asp:WizardStep ID="wizContact" runat="server" Title="Contact Information">
                        <h2>Registration - Contact Information</h2>
                        <uc2:EditProfile ID="EditProfile1" runat="server" OnInit="EditProfile1_Init" />
                    </asp:WizardStep>
                    <asp:WizardStep ID="wizEvent" runat="server" Title="Event Information">
                        <h2>Registration - Event Information</h2>
                        
                        <div style="padding:5px;"  class="bodytext">
                            How did you hear about this event?
                            <asp:DropDownList ID="ddlReferral" runat="server">
                                <asp:ListItem Text="Choose..." Value=""></asp:ListItem>
                                <asp:ListItem Text="Invitation" Value="Invitation"></asp:ListItem>
                                <asp:ListItem Text="Newspaper" Value="Newspaper"></asp:ListItem>
                                <asp:ListItem Text="Word of Mouth/Referral" Value="Referral"></asp:ListItem>
                                <asp:ListItem Text="SVA Website" Value="Website"></asp:ListItem>
                                <asp:ListItem Text="Other" Value="Other"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvReferral" runat="server" 
                                ControlToValidate="ddlReferral" ErrorMessage="***" />

                            <div style="margin-left:20px;padding:4px;">
                                Please explain: 
                                <asp:TextBox ID="txtReferralDetails" runat="server"></asp:TextBox>
                            </div>
                            
                            <div style="padding:8px"></div>
                            
                            <asp:CheckBox ID="cbFirstTime" runat="server" /> 
                            This is my first time attending this event.
                            
                            <div style="padding:8px"></div>
                            
                            <asp:CheckBox ID="cbWouldPurchaseVideo" runat="server" /> 
                            If video is produced, I would like to purchase a copy for $30.
                            
                            <div style="padding:8px"></div>
                            
                            Please indicate any special accommodations that you require:<br />
                            <asp:TextBox ID="txtAccommodations" runat="server" 
                                Columns="50" Rows="3" MaxLength="500"
                                TextMode="MultiLine">
                            </asp:TextBox>
                        </div>
                    </asp:WizardStep>
                    <asp:WizardStep ID="wizGuest" runat="server" OnActivate="wizGuest_Activate" Title="Guest Registration">
                                    
                        <h2>Registration - Guest Information (optional)</h2>
                        <div style="padding:5px;" class="bodytext">
                            Please provide the following information for any guests in addition to your registration.
                            <div style="padding:3px;"></div>
                            <radA:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
                                <asp:ListView ID="lvGuest" runat="server" DataKeyNames="GuestId" 
                                        DataSourceID="OdsGuest" InsertItemPosition="LastItem"
                                        OnItemInserting="lvGuest_ItemInserting">
                                    <LayoutTemplate>
                                        <div ID="itemPlaceholderContainer" runat="server" style="">
                                            <span ID="itemPlaceholder" runat="server" />
                                        </div>
                                    </LayoutTemplate>
                                    <EditItemTemplate>
                                        <div style="font-size:1em;border-bottom:solid 1px #7D97B0;">
                                            <div class="row">
                                                <div class="left">* First Name:</div>
                                                <div class="right">
                                                    <asp:TextBox ID="txtFirstName" runat="server" 
                                                        Text='<%# Bind("FirstName") %>' />
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                                        ControlToValidate="txtFirstName" ErrorMessage="*" ValidationGroup="EditGuest" />
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="left">* Last Name:</div>
                                                <div class="right">
                                                    <asp:TextBox ID="txtLastName" runat="server" 
                                                        Text='<%# Bind("LastName") %>' />
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                                                        ControlToValidate="txtLastName" ErrorMessage="*" ValidationGroup="EditGuest" />
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="left">Email:</div>
                                                <div class="right">
                                                    <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>' />
                                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                                                        ControlToValidate="txtEmail" ErrorMessage="*" ValidationGroup="EditGuest" />--%>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="left">Company:</div>
                                                <div class="right">
                                                    <asp:TextBox ID="txtCompany" runat="server" Text='<%# Bind("Company") %>' />
                                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                                                        ControlToValidate="txtCompany" ErrorMessage="*" ValidationGroup="EditGuest" />--%>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="left">Title:</div>
                                                <div class="right">
                                                    <asp:TextBox ID="txtTitle" runat="server" Text='<%# Bind("Title") %>' />
                                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" 
                                                        ControlToValidate="txtTitle" ErrorMessage="*" ValidationGroup="EditGuest" />--%>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="left"></div>
                                                <div class="right">
                                                    <asp:LinkButton ID="CancelButton" runat="server" CommandName="Cancel" 
                                                        Text="Cancel" ValidationGroup="EditGuest" CausesValidation="false" />                                                
                                                    <asp:LinkButton ID="UpdateButton" runat="server" CommandName="Update" 
                                                        Text="Update" ValidationGroup="EditGuest" CausesValidation="true" />
                                                </div>
                                            </div>
                                        </div>
                                    </EditItemTemplate>
                                    <EmptyDataTemplate>
                                    </EmptyDataTemplate>
                                    <InsertItemTemplate>
                                        <div class="row">
                                            <div class="left">* First Name:</div>
                                            <div class="right">
                                                <asp:TextBox ID="txtFirstName" runat="server" 
                                                    Text='<%# Bind("FirstName") %>' />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                                    ControlToValidate="txtFirstName" ErrorMessage="*" ValidationGroup="InsertGuest" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="left">* Last Name:</div>
                                            <div class="right">
                                                <asp:TextBox ID="txtLastName" runat="server" 
                                                    Text='<%# Bind("LastName") %>' />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                                                    ControlToValidate="txtLastName" ErrorMessage="*" ValidationGroup="InsertGuest" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="left">Email:</div>
                                            <div class="right">
                                                <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>' />
                                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                                                    ControlToValidate="txtEmail" ErrorMessage="*" ValidationGroup="InsertGuest" />--%>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="left">Company:</div>
                                            <div class="right">
                                                <asp:TextBox ID="txtCompany" runat="server" Text='<%# Bind("Company") %>' />
                                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                                                    ControlToValidate="txtCompany" ErrorMessage="*" ValidationGroup="InsertGuest" />--%>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="left">Title:</div>
                                            <div class="right">
                                                <asp:TextBox ID="txtTitle" runat="server" Text='<%# Bind("Title") %>' />
                                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" 
                                                    ControlToValidate="txtTitle" ErrorMessage="*" ValidationGroup="InsertGuest" />--%>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="left"></div>
                                            <div class="right">
                                            <asp:LinkButton ID="InsertButton" runat="server" CommandName="Insert" 
                                                Text="Add Guest" ValidationGroup="InsertGuest" CausesValidation="true" />
                                            </div>
                                        </div>
                                    </InsertItemTemplate>
                                    <ItemTemplate>
                                        <div style="font-size:1em;border-bottom:solid 1px #7D97B0;">
                                            
                                            <img src="../App_Themes/Events/Images/guest.png" alt="Guest" style="float:left;" />
                                            
                                            <div style="padding:5px;">
                                                <div>
                                                    <span style="color:#024478; font-weight:bold;">
                                                    <%# Eval("FirstName") %> <%# Eval("LastName") %></span> <%#Eval("Email", "({0})")%>
                                                </div>
                                                <div>
                                                <%#Eval("Title", "{0}, ")%><%# Eval("Company") %>
                                                </div>
                                                <asp:LinkButton ID="EditButton" runat="server" CommandName="Edit" Text="Edit" />
                                                <asp:LinkButton ID="DeleteButton" runat="server" CommandName="Delete" 
                                                    Text="Remove" />
                                            </div>
                                            
                                        </div>
                                    </ItemTemplate>
                                    <ItemSeparatorTemplate>
                                        <div style="padding:3px;"></div>
                                    </ItemSeparatorTemplate>
                                </asp:ListView>
                                
                                <asp:ObjectDataSource ID="OdsGuest" runat="server"
                                        SelectMethod="GetGuestsByRegistrationId"
                                        InsertMethod="InsertGuest"
                                        DeleteMethod="DeleteGuest"
                                        UpdateMethod="UpdateGuest"
                                        TypeName="GuestBll">
                                    <SelectParameters>
                                        <asp:Parameter Name="RegistrationId" Type="Int32" />
                                    </SelectParameters>
                                    <DeleteParameters>
                                        <asp:Parameter Name="GuestId" Type="Int32" />
                                    </DeleteParameters>
                                    <InsertParameters>
                                        <asp:Parameter Name="RegistrationId" Type="Int32" />
                                        <asp:Parameter Name="FirstName" Type="String" />
                                        <asp:Parameter Name="LastName" Type="String" />
                                        <asp:Parameter Name="Email" Type="String" />
                                        <asp:Parameter Name="Company" Type="String" />
                                        <asp:Parameter Name="Title" Type="String" />
                                    </InsertParameters>
                                    <UpdateParameters>
                                        <asp:Parameter Name="FirstName" Type="String" />
                                        <asp:Parameter Name="LastName" Type="String" />
                                        <asp:Parameter Name="Email" Type="String" />
                                        <asp:Parameter Name="Company" Type="String" />
                                        <asp:Parameter Name="Title" Type="String" />
                                        <asp:Parameter Name="GuestId" Type="Int32" />
                                    </UpdateParameters>
                                </asp:ObjectDataSource>

                            
                            </radA:RadAjaxPanel>
                        </div>
                    </asp:WizardStep>
                    <asp:WizardStep ID="wizInvite" runat="server" OnActivate="wizInvite_Activate" Title="Send Invitations">
                         
                        <h2>Registration - Send Invitations (optional)</h2>
                        <div style="padding:5px;" class="bodytext">
                            Please provide the name and email address of anyone you think would be interested in attending this event.
                            <div style="padding:3px;"></div>
                            <radA:RadAjaxPanel ID="RadAjaxPanel2" runat="server">
                                
                                <asp:ListView ID="lvInvite" runat="server" DataKeyNames="InviteId" 
                                        DataSourceID="OdsInvite" InsertItemPosition="LastItem"
                                        OnItemInserting="lvInvite_ItemInserting">
                                    <LayoutTemplate>
                                        <div ID="itemPlaceholderContainer" runat="server" style="">
                                            <span ID="itemPlaceholder" runat="server" />
                                        </div>
                                    </LayoutTemplate>
                                    <EmptyDataTemplate>
                                    </EmptyDataTemplate>
                                    <InsertItemTemplate>
                                        <div style="padding:5px;">
                                            <div class="row">
                                                <div class="left">First Name:</div>
                                                <div class="right">
                                                    <asp:TextBox ID="txtFirstName" runat="server" 
                                                        Text='<%# Bind("FirstName") %>' />
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                                        ControlToValidate="txtFirstName" ErrorMessage="*" ValidationGroup="InsertInvite" />
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="left">Last Name:</div>
                                                <div class="right">
                                                    <asp:TextBox ID="txtLastName" runat="server" 
                                                        Text='<%# Bind("LastName") %>' />
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                                        ControlToValidate="txtLastName" ErrorMessage="*" ValidationGroup="InsertInvite" />
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="left">Email:</div>
                                                <div class="right">
                                                    <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>' />
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                                                        ControlToValidate="txtEmail" ErrorMessage="*" ValidationGroup="InsertInvite" />
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="left"></div>
                                                <div class="right">
                                                <asp:LinkButton ID="InsertButton" runat="server" CommandName="Insert" 
                                                    Text="Send Invite" CausesValidation="true" ValidationGroup="InsertInvite" />
                                                </div>
                                            </div>
                                        </div>
                                    </InsertItemTemplate>
                                    <ItemTemplate>
                                        <div style="font-size:1em;border-bottom:solid 1px #7D97B0;padding:5px;">
                                        
                                            Invitation sent to <span class="bold">
                                            <%# Eval("FirstName") %> <%# Eval("LastName") %></span> at <span class="bold"><%# Eval("Email") %></span>
                                            
                                        </div>
                                    </ItemTemplate>
                                    <ItemSeparatorTemplate>
                                    </ItemSeparatorTemplate>
                                </asp:ListView>
                                
                                <asp:ObjectDataSource ID="OdsInvite" runat="server"
                                        SelectMethod="GetInvitesByRegistrationId"
                                        InsertMethod="SendInvite"
                                        TypeName="InviteBll">
                                    <SelectParameters>
                                        <asp:Parameter Name="RegistrationId" Type="Int32" />
                                    </SelectParameters>
                                    <InsertParameters>
                                        <asp:Parameter Name="RegistrationId" Type="Int32" />
                                        <asp:Parameter Name="FirstName" Type="String" />
                                        <asp:Parameter Name="LastName" Type="String" />
                                        <asp:Parameter Name="Email" Type="String" />
                                    </InsertParameters>
                                </asp:ObjectDataSource>
                                
                            </radA:RadAjaxPanel>
                        </div>
                    </asp:WizardStep>
                    <asp:WizardStep ID="wizMenu" runat="server" Title="Menu Selection">
                        <h2>Registration - Menu Selection</h2>
                        <div style="padding:5px;" class="bodytext">
                            
                            <asp:SqlDataSource ID="SqlMenuItems" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:cnSVAEvents %>" 
                                    SelectCommand="SELECT * FROM [MenuItem] WHERE ([EventId] = @EventId)" >
                                <SelectParameters>
                                    <asp:QueryStringParameter Name="EventId" 
                                        QueryStringField="EventId" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            
                            Please select one item from the menu:
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                                ControlToValidate="rblMenuItems" ErrorMessage="*" /> 
                            <asp:RadioButtonList ID="rblMenuItems" style="margin-left:20px;" 
                                runat="server" DataSourceID="SqlMenuItems"
                                DataTextField="MenuItem" DataValueField="MenuItemId">
                            </asp:RadioButtonList>
                            
                            <div style="padding:8px"></div>
                            
                            Please indicate any dietary restrictions:<br />
                            <asp:TextBox ID="txtDietaryRestrictions" runat="server" 
                                Columns="50" Rows="3" MaxLength="500"
                                TextMode="MultiLine">
                            </asp:TextBox>
                            
                        </div>
                    </asp:WizardStep>
                    <asp:WizardStep ID="wizHousing" runat="server" Title="Housing & Transportation">
                        <h2>Registration - Housing and Transportation</h2>
                        <div style="padding:5px;" class="bodytext">
                            If you will require housing and/or transportation, we will do our best to help you find accommodations that will best suit your needs.
                            <div style="padding:3px;"></div>
                            
                            <asp:CheckBox ID="cbHousing" runat="server" /> 
                            Please contact me to discuss housing and/or transportation needs
                            
                        </div>
                    </asp:WizardStep>
                    <asp:WizardStep ID="wizBreakouts" runat="server" OnActivate="wizBreakouts_Activate" Title="Breakouts">
                    
                        <h2>Registration - Schedule Breakouts</h2>
                        <div style="padding:5px;" class="bodytext">
                        
                            <div style="margin-bottom:15px;">
                                Please schedule one breakout per session for each attendee<%-- (including guests)--%>.
                            </div>
                        
                            <script type="text/javascript">
                                function toggle(panelid) {
                                    var panel = document.getElementById(panelid);
                                    var current = panel.style.display;
                                    if (current=='none') {
                                        panel.style.display = 'block';
                                    } else {
                                        panel.style.display = 'none';
                                    }
                                }
                            </script>                            

                                                    
                            <asp:FormView ID="fvEventSession" runat="server"
                                    OnDataBound="fvEventSession_DataBound"
                                    DataSourceID="odsEventSession"
                                    DataKeyNames="SessionId" Width="100%">
                                <ItemTemplate>
                                    <asp:HiddenField ID="hdnSessionId" runat="server" Value='<%# Eval("SessionId") %>' />
                                    
                                    <radA:RadAjaxPanel ID="RadAjaxPanel3" runat="server">
                            
                                        <div class="sessionhead clearfix">
                                            <div class="sessionnumber">
                                                <asp:Label ID="lblSessionNumber" runat="server" Text=""></asp:Label>
                                            </div>
                                            <div class="dateandtime">
                                                <div class="bold">
                                                    <%# Eval("StartDate", "{0:t}") %> - <%#Eval("EndDate", "{0:t}")%>
                                                </div>
                                                <div>
                                                    <%# Eval("StartDate", "{0:D}") %>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlSessionStatus" runat="server" class="status">
                                                <img src="../App_Themes/Events/Images/greencheck.gif" alt="Valid" style="margin-top:-20px;" /></asp:Panel>
                                        </div>
                                    
                                    
                                        <asp:ListView ID="lvBreakout" runat="server" 
                                                DataKeyNames="BreakOutId"
                                                OnDataBound="lvBreakout_DataBound"
                                                OnItemCommand="lvBreakout_ItemCommand"
                                                DataSourceID="odsBreakout">
                                            <LayoutTemplate>
                                                <ul ID="itemPlaceholderContainer" runat="server" class="agendaregister">
                                                    <span ID="itemPlaceholder" runat="server" />
                                                </ul>
                                            </LayoutTemplate>
                                            <ItemTemplate>
                                                <li class="clearfix breakout">
                                                    
                                                    <asp:HiddenField ID="hdnSessionMax" runat="server" Value='<%#Eval("CurrentSessionMax") %>' />
                                                    <asp:HiddenField ID="hdnSessionAttendance" runat="server" Value='<%#Eval("CurrentSessionAttendance") %>' />
                                                    
                                                    <%-- Breakout - Registration --%>
                                                    <asp:Panel ID="pnlRegistration" runat="server"
                                                            CssClass='<%# Iif(Eval("CurrentBreakoutAttendance") > 0, "registrationactive", "registration") %>'>
                                                    
                                                        <asp:ImageButton ID="lbUnregister" runat="server"
                                                                CommandName="Unregister" 
                                                                CommandArgument='<%#Eval("BreakoutId")%>'
                                                                AlternateText="Unregister"
                                                                ImageUrl="~/App_Themes/Events/Images/minus.png"
                                                                visible='<%# (Eval("CurrentBreakoutAttendance") > 0) %>'>
                                                        </asp:ImageButton>
                                                        
                                                        <img src="../App_Themes/Events/Images/disable.png" runat="server"
                                                            alt="Unregistration is not allowed" visible='<%# Not (Eval("CurrentBreakoutAttendance") > 0) %>' />
                                                            
                                                        <asp:TextBox ID="txtRegistered" runat="server" 
                                                            Enabled="false" Width="20px"
                                                            style="padding:3px;text-align:center;color:Black;"
                                                            Text='<%#Eval("CurrentBreakoutAttendance") %>'>
                                                        </asp:TextBox>
                                                        
                                                        <asp:ImageButton ID="lbRegister" runat="server"
                                                                CommandName="Register" 
                                                                CommandArgument='<%#Eval("BreakoutId")%>'
                                                                AlternateText="Register"
                                                                ImageUrl="~/App_Themes/Events/Images/plus.png"
                                                                visible='<%# ((Eval("CurrentSessionMax") > Eval("CurrentSessionAttendance")) And ((Eval("Attendance") +  Eval("CurrentBreakoutAttendance")) < Eval("MaxAttendance"))) %>'>
                                                        </asp:ImageButton>
                                                        
                                                        <img src="../App_Themes/Events/Images/disable.png" runat="server"
                                                            alt="Registration is not allowed" visible='<%# Not ((Eval("CurrentSessionMax") > Eval("CurrentSessionAttendance")) And ((Eval("Attendance") +  Eval("CurrentBreakoutAttendance")) < Eval("MaxAttendance"))) %>' /></asp:Panel>
                                                                                                        
                                                    <%-- Breakout - Title and Details --%>
                                                    <div style="float:left;padding:4px;width:auto;">
                                                    
                                                        <%--<asp:LinkButton ID="lbDetails" runat="server" OnLoad="lbDetails_Load">--%>
                                                        <div class="bold">
                                                            <%#Eval("Title")%>
                                                        </div>
                                                        <%--</asp:LinkButton>--%>
                                                        
                                                        <asp:Panel ID="pnlDetails" runat="server" 
                                                                style="display:block;" CssClass="breakoutdetails">
                                                            
                                                            <asp:Image ID="imgBreakout" runat="server"
                                                                ImageUrl='<%#Eval("PhotoUrl", "~/images/Events/Breakouts/{0}")%>' style="width:50px;padding-right:10px;float:left;"
                                                                Visible='<%# Not Eval("PhotoUrl") is DBNull.Value %>' />
                                                                
                                                            <%#Eval("Description")%>
                                                            <div style="clear:both;"></div>
                                                        </asp:Panel>
                                                        
                                                    </div>
                                                    
                                                  
                                                    
                                                </li>
                                                
                                                    <%--<td style="text-align:center;border-top:solid 1px #cccccc;padding:10px;">
                                                        <asp:Image ID="imgBreakout" runat="server"
                                                            ImageUrl='<%#Eval("PhotoUrl")%>' style="width:50px;"
                                                            Visible='<%# Not Eval("PhotoUrl") is DBNull.Value %>' />    
                                                    </td>--%>
                                                        <%--<div>--%>
                                                            
                                                            <%--<%#Eval("Location", " - <span style='color:#777777;'>{0}</span>")%>
                                                        </div>  
                                                        <div style="padding:5px 0 5px 0;font-size:0.9em;">
                                                            <%#Eval("Description")%>
                                                        </div>--%>
                                                        
                                                        <%--<span style="font-weight:bold;">Seats Remaining:</span>
                                                            
                                                        <asp:Label ID="Label1" runat="server"
                                                            Visible='<%#Eval("MaxAttendance") > (Eval("Attendance") +  Eval("CurrentBreakoutAttendance")) %>' 
                                                            Text='<%#Eval("MaxAttendance") - (Eval("Attendance") +  Eval("CurrentBreakoutAttendance")) %>'>
                                                        </asp:Label>
                                                        <asp:Label ID="Label2" runat="server"
                                                            Visible='<%#Eval("MaxAttendance") <= (Eval("Attendance") +  Eval("CurrentBreakoutAttendance")) %>' 
                                                            Text="Full" style="color:Red; font-weight:bold;">
                                                        </asp:Label>--%>

                                                        <%--
                                                        <asp:LinkButton ID="lbWaitingList" runat="server" 
                                                                CommandName="WaitingList" 
                                                                CommandArgument='<%#Eval("BreakoutId")%>'
                                                                Visible='<%# ((Eval("CurrentBreakoutAttendance") = 0) And (Eval("WaitingList") = 0) And ((Eval("Attendance") +  Eval("CurrentBreakoutAttendance")) >= Eval("MaxAttendance")))  %>'>
                                                            Join Waiting List
                                                        </asp:LinkButton>
                                                        
                                                        <asp:Label ID="Label3" runat="server" 
                                                            Visible='<%#Eval("WaitingList") > 0 %>'
                                                            style="color:"
                                                            Text="On Waiting List...">
                                                        </asp:Label>--%>

                                            </ItemTemplate>
                                            <EmptyDataTemplate>
                                            </EmptyDataTemplate>
                                        </asp:ListView>
                                       
                                        
                                    </radA:RadAjaxPanel>                                    

                                    <asp:ObjectDataSource ID="odsBreakOut" runat="server" 
                                            SelectMethod="GetBreakoutRegistration" TypeName="BreakoutBll">
                                        <SelectParameters>
                                            <asp:Parameter Name="SessionId" Type="Int32" />
                                            <asp:Parameter Name="RegistrationId" Type="Int32" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
 
                                    
                                </ItemTemplate>
                            </asp:FormView>
                            
                            <asp:ObjectDataSource ID="odsEventSession" runat="server" 
                                    SelectMethod="GetSessionsByEventId" TypeName="SessionBll">
                                <SelectParameters>
                                    <asp:QueryStringParameter Name="eventId" QueryStringField="EventId" Type="Int32" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        
                        </div>
                    </asp:WizardStep>
                    <asp:WizardStep ID="wizSummary" runat="server" 
                            Title="Registration Summary" >
                            <%--OnActivate="wizSummary_Activate">--%>
                            
                        <h2>Registration - Summary</h2>
                        <div style="padding:5px;" class="bodytext">
                            Please confirm your registration selections.
                            
                        </div>
                    </asp:WizardStep>
                </WizardSteps>
                <NavigationStyle Font-Size="0.8em" />
                <NavigationButtonStyle CssClass="formyellowbutton" />
            </asp:Wizard>    
        </EditItemTemplate>
    </asp:FormView>
    
    

    <asp:ObjectDataSource ID="odsBreakoutRegister" runat="server"
            TypeName="BreakoutBll"
            InsertMethod="BreakoutRegister" DeleteMethod="BreakoutUnRegister">
        <InsertParameters>
            <asp:Parameter Name="BreakoutId" Type="Int32" />
            <asp:Parameter Name="RegistrationId" Type="Int32" />
        </InsertParameters>
        <DeleteParameters>
            <asp:Parameter Name="BreakoutId" Type="Int32" />
            <asp:Parameter Name="RegistrationId" Type="Int32" />
        </DeleteParameters>            
    </asp:ObjectDataSource>
    
    <asp:ObjectDataSource ID="odsBreakoutWait" runat="server"
            TypeName="BreakoutBll"
            InsertMethod="BreakoutJoinWaitingList">
        <InsertParameters>
            <asp:Parameter Name="BreakoutId" Type="Int32" />
            <asp:Parameter Name="RegistrationId" Type="Int32" />
        </InsertParameters>
    </asp:ObjectDataSource>
    
</asp:Content>

