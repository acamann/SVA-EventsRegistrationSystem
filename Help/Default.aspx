<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="FAQ_Default" title="Untitled Page" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register Assembly="RadTabStrip.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">

    <div style="margin-top:20px; font-weight:bold;margin-bottom:5px;background-color:#7B97AD; color:White;padding:4px; font-size:0.9em;width:167px;">
        Help Topics
    </div>
    <a href="Default.aspx" class="leftlink">Help Home</a>
    <a href="Default.aspx?View=CreateAccount" class="leftlink">Creating an Account</a>
    <a href="Default.aspx?View=EventList" class="leftlink">Viewing the Event Lists</a>
    <a href="Default.aspx?View=EventDescription" class="leftlink">Viewing an Event Description</a>
    <a href="Default.aspx?View=EventRegistration" class="leftlink">Event Registration</a>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    
    
    <telerik:RadMultiPage ID="rmpHelp" runat="server" RenderSelectedPageOnly="true">
        <telerik:RadPageView ID="pageContents" runat="server" Selected="true">
            <h1><img src="../App_Themes/Events/Images/question.gif" style="vertical-align:middle;" alt="Help" /> Help</h1>
    
            <p>Welcome to the SVA Event Registration Site; the purpose of this site is to register for upcoming events conducted by SVA.</p>
            <p>Select a specific help topic from the left or download the entire training document below.</p>
            
            <%--<ul>
                <li><a href="Default.aspx?View=CreateAccount">Creating an Account</a></li>
                <li><a href="Default.aspx?View=EventList">Viewing the Event Lists</a></li>
                <li><a href="Default.aspx?View=EventDescription">Viewing an Event Description</a></li>
                <li><a href="Default.aspx?View=EventRegistration">Event Registration</a></li>
            </ul> --%>
                          
            <p style="margin-left:25px;">
                <img src="../App_Themes/Events/Images/page_white_acrobat.png" alt="Download Documentation (.PDF)" /> 
                <a href="Event Reg System.pdf">
                    Event Registration System - User Documentation</a><br />
                <small> (Right Click, Save As to download)</small>
            </p>
            
            
        </telerik:RadPageView>
        <telerik:RadPageView ID="pageCreateAccount" runat="server">
            <h1><img src="../App_Themes/Events/Images/question.gif" style="vertical-align:middle;" alt="Help" /> Creating an Account</h1>
            <div class="helpdetails">
                <p>To log on to the web site for the first time:</p>
                <ol>
                    <li>Select the Login/New Account Link<a href="Images/createaccount01.jpg"><img src="Images/createaccount01.jpg" alt="Select Login/New Account" /></a></li>
                    <li>Select the Create a new account link<a href="Images/createaccount02.jpg"><img src="Images/createaccount02.jpg" alt="Create New Account" /></a></li>
                    <li>In the screen below, enter your E-mail Address, Password and confirm your password.<a href="Images/createaccount03.jpg"><img
                        src="Images/createaccount03.jpg" alt="Enter information" /></a></li>
                    <li>Select Create user</li>
                    <li>Once your account has been created, select the Continue button.<a href="Images/createaccount04.jpg"><img src="Images/createaccount04.jpg" alt="Continue" /></a></li>
                    <li>At the user profile screen, enter in your information in the appropriate fields. This is a one-time process. After the information is entered, select the Save link at the bottom of the screen.<a href="Images/createaccount05.jpg"><img src="Images/createaccount05.jpg" alt="Save" /></a></li>
                </ol>
            </div>
        </telerik:RadPageView>
        <telerik:RadPageView ID="RadPageView1" runat="server">
            <h1><img src="../App_Themes/Events/Images/question.gif" style="vertical-align:middle;" alt="Help" /> Viewing the Event Lists</h1>
            <div class="helpdetails">
                <p>The purpose of this section is to view the event lists that are part of the system.</p>
                <p>To view events:</p>
                <ol>
                    <li>Select Upcoming Events in the top menu</li>
                    <li>If necessary, filter by the Search function, the Event type or the Entity.<img
                        src="Images/eventlist01.jpg" alt="Event List Filter" /></li>
                    <li>Select the My Events link in the header section of the screen to see events that you are already
                    registered for or ones you have previously attended.<img src="Images/eventlist02.jpg" alt="My Events Link" /></li>
                    <li>Select either My Upcoming events or My Previous Events to see those specific events.<img
                        src="Images/eventlist03.jpg" alt="My Upcoming/My Previous Events" /></li>
                </ol>        
            </div>
        </telerik:RadPageView>
        <telerik:RadPageView ID="RadPageView2" runat="server">
            <h1><img src="../App_Themes/Events/Images/question.gif" style="vertical-align:middle;" alt="Help" /> Viewing an Event Description</h1>
            <div class="helpdetails">
                <p>There are two ways you will be taken to the event description page:</p>
                <ul>
                    <li>By clicking an invitation link in an e-mail that has been sent to you</li>
                    <li>By clicking an event in the Upcoming Events list</li>
                </ul>
                <p>This page has
                the following items available: a list of event details (date and time), the name of the facility, contact details and
                a short description.<img src="Images/eventdescription01.jpg" alt="Event Description" /></p>        
            </div>
        </telerik:RadPageView>
        <telerik:RadPageView ID="RadPageView3" runat="server">
            <h1><img src="../App_Themes/Events/Images/question.gif" style="vertical-align:middle;" alt="Help" /> Event Registration</h1>
            <div class="helpdetails">
                <p>The purpose of this section is to provide information on how to register for an event.
                To register for an event:</p>
                <ol>
                    <li>Select the Registration button (registration is only available for if the event is open for registration).<a href="Images/registration01.jpg"><img src="Images/registration01.jpg" alt="Registration Button" /></a></li>
                    <li>The registration steps as shown on the left are designed to collect information for your attendance.  The number and type of steps displayed will vary based on the nature of the event. Please
                verify your contact information and select next.<a href="Images/registration02.jpg"><img src="Images/registration02.jpg" alt="Registration Steps" /></a></li>
                    <li>Complete the Guest Information section if you are bringing anyone to the event and select Add guest.
                After you have added all your guests, select Next. If no guests are attending, select Next.<a href="Images/registration03.jpg"><img src="Images/registration03.jpg" alt="Guest Information" /></a></li>
                    <li>Complete the Send Invitations (optional) screen to send an invite to anyone else who might be
                interested in attending the event. Select Send Invite then select Next. If no invitations are necessary,
                then just select Next.<a href="Images/registration04.jpg"><img src="Images/registration04.jpg" alt="Invitations" /></a></li>
                    <li>Complete the Payment screen if event has a cost associated with it and select Next.<a href="Images/registration05.jpg"><img
                        src="Images/registration05.jpg" alt="Payment" /></a>
                Note: If paying by credit card, please note the CVV or CVC field is the last three numbers on the back of the
                credit card.<a href="Images/registration06.jpg"><img src="Images/registration06.jpg" alt="Credit Card Processing" /></a></li>
                    <li>After payment for the event occurs, you will be redirected back to the Registration details where you
                can print your receipt. A copy of the receipt is also e-mailed to you.<a href="Images/registration07.jpg"><img src="Images/registration07.jpg" alt="Registration Receipt" /></a></li>
                    <li>If you have any questions about your registration, select the contact information on the lower left side
                of the screen.<img src="Images/registration08.jpg" alt="Contact Information" /></li>
                </ol>         
            </div>
        </telerik:RadPageView>
    </telerik:RadMultiPage>
                     
</asp:Content>

