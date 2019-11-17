<%@ Control Language="VB" AutoEventWireup="false" CodeFile="RegistrationInfo.ascx.vb" Inherits="App_UserControls_RegistrationInfo" %>
<%@ Register Assembly="RadTabStrip.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>

<%@ Register assembly="Telerik.Web.UI" namespace="Telerik.Web.UI" tagprefix="telerik" %>

<!-- Register button / Attendance -->
        
<rad:RadMultiPage ID="rmpRegistrationInfo" runat="server"
        RenderSelectedPageOnly="true">
    <rad:PageView ID="viewIsRegistered" runat="server">
    
        <div class="bodytext" style="text-align:center; font-weight:bold;margin-bottom:6px;color:#4E4E4E;">
            You Registered <br /> on 
            <asp:Label ID="lblDateRegistered" runat="server"></asp:Label>
        </div>
        <div style="text-align:center;font-size:0.8em;">                    
            <asp:HyperLink ID="hlViewReceipt" runat="server" 
                    CssClass="formyellowbutton" 
                    style="width:125px;"> 
                View Receipt
            </asp:HyperLink>                    
        </div>
        <div style="text-align:center;font-size:0.6em;padding:5px;">                    
            <asp:HyperLink ID="hlCancelRegistration" runat="server" >
                Cancel Registration...
            </asp:HyperLink>                    
        </div>
        
    </rad:PageView>
    <rad:PageView ID="viewIsWaiting" runat="server">
    
        <div class="bodytext" style="text-align:center; font-weight:bold;margin-bottom:6px;color:#4E4E4E;">
            Joined Waiting List <br /> on 
            <asp:Label ID="lblDateWaiting" runat="server"></asp:Label>
        </div>
    
    </rad:PageView>
    <rad:PageView ID="viewFull" runat="server">
    
        <div class="bodytext" style="text-align:center; font-weight:bold;margin-bottom:6px;color:#4E4E4E;">
            This Event is Full
        </div>
        
        <div style="text-align:center;font-size:0.8em;">
            <asp:HyperLink ID="hlJoinWaitingList" runat="server" 
                    CssClass="formyellowbutton" 
                    style="width:125px;"> 
                Join Waiting List
            </asp:HyperLink>
        </div>
                        
    </rad:PageView>
    <rad:PageView ID="viewOpen" runat="server">
            
        <div class="bodytext" style="text-align:center;margin-bottom:6px;">
            <asp:Label ID="lblRemaining" runat="server" 
                Style="color:#08327A;font-size:1.5em;font-weight:bold;">
            </asp:Label>
            remaining
        </div>
        
        <div style="text-align:center;font-size:0.8em;">
            <asp:HyperLink ID="hlRegister" runat="server" 
                    CssClass="formyellowbutton" 
                    style="width:125px;"> 
                Register
            </asp:HyperLink>
        </div>
                    
    </rad:PageView>
    <rad:PageView ID="viewEnded" runat="server">
        
        <div class="bodytext" style="text-align:center; font-weight:bold;color:#4E4E4E;">
            Registration Ended <br /> on 
            <asp:Label ID="lblEnded" runat="server"></asp:Label>
        </div>
        
    </rad:PageView>
    <rad:PageView ID="viewNotYet" runat="server">
        
        <div class="bodytext" style="text-align:center; font-weight:bold;color:#4E4E4E;">
            Registration Begins <br /> on 
            <asp:Label ID="lblBegins" runat="server"></asp:Label>
        </div>
        
    </rad:PageView>
    <rad:PageView ID="viewNotPublished" runat="server">
        
        <div class="bodytext" style="text-align:center; font-weight:bold;color:#4E4E4E;">
            Not published
        </div>
        <div class="bodytext" style="text-align:center; font-size:0.6em;">
            (This page is only available as a preview to Administrators)
        </div>
        
    </rad:PageView>
    <rad:PageView ID="viewCancelled" runat="server">
        
        <div class="bodytext" style="text-align:center; font-weight:bold;color:#4E4E4E;">
            <span style="font-size:1.5em;color:#A53B3B;">Cancelled</span>
            <img id="imgHelpCancel" runat="server" 
                alt="What does this mean?" 
                src="../App_Themes/Events/Images/questionmark.gif" />
            <br /> on 
            <asp:Label ID="lblDateCancelled" runat="server"></asp:Label>
            
            <telerik:RadToolTip ID="RadToolTip1" runat="server" 
                    Skin="WebBlue" AutoCloseDelay="7000" Width="250"
                    RelativeTo="Element" Position="MiddleRight" 
                    TargetControlID="imgHelpCancel">
                Because this event has been cancelled, registration is closed.
                If you have registered for this event, you should have received a notification e-mail or phone call.
                If you have made a payment for this event, you will be fully refunded.
            </telerik:RadToolTip>
        </div>
        
    </rad:PageView>
    <rad:PageView ID="viewRegCancelled" runat="server">
        
        <div class="bodytext" style="text-align:center; font-weight:bold;color:#4E4E4E;">
            <span style="font-size:1.3em;color:#A53B3B;">You Cancelled</span>
            <br /> on 
            <asp:Label ID="lblRegCancelledDate" runat="server"></asp:Label>            
        </div>
        
    </rad:PageView>
</rad:RadMultiPage>