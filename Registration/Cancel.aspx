<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Cancel.aspx.vb" Inherits="Registration_Cancel" title="Untitled Page" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register src="../App_UserControls/EventPageHeader.ascx" tagname="EventPageHeader" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
    <asp:HyperLink ID="hlBackToEvent" runat="server" CssClass="leftlink">
        <img id="Img1" src="~/App_Themes/Events/Images/return.gif" alt="Back" runat="server" />
        Back to Event
    </asp:HyperLink>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    
    <uc1:EventPageHeader ID="EventPageHeader1" runat="server" SubTitle="Cancel Registration" />
    
    <telerik:RadMultiPage ID="rmpCancel" runat="server" SelectedIndex="0">
        <telerik:RadPageView ID="pageChoose" runat="server">
        
            <div class="bodytext" style="padding:10px;">
                You have chosen to cancel your registration for this event.  Are you sure?
            </div>
            <div class="bodytext" style="padding:10px;">
                <asp:LinkButton style="width:100px;"
                    ID="lbCancel" runat="server" CssClass="formyellowbutton">Yes</asp:LinkButton>
            </div>        
        
        </telerik:RadPageView>
        <telerik:RadPageView ID="pageSuccess" runat="server">
            
            <div class="bodytext" style="padding:10px;">
                You have successfully cancelled your registration.
            </div>
            
            <ul>
                <li>
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Default.aspx">
                        Upcoming Events
                    </asp:HyperLink>
                </li>
                <li>
                    <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/MyEvents/Default.aspx">
                        My Events
                    </asp:HyperLink>
                </li>
                <li>
                    <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl="~/Contact/Default.aspx">
                        Contact Us
                    </asp:HyperLink>
                </li>
            </ul>
        
        </telerik:RadPageView>
        <telerik:RadPageView ID="pageFailure" runat="server">
            
            <div class="bodytext" style="padding:10px;">
                There was a problem cancelling your registration.  
                The event coordinator has been notified.  Sorry for the inconvenience!
            </div>
            
            <ul>
                <li>
                    <asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl="~/Default.aspx">
                        Upcoming Events
                    </asp:HyperLink>
                </li>
                <li>
                    <asp:HyperLink ID="HyperLink5" runat="server" NavigateUrl="~/MyEvents/Default.aspx">
                        My Events
                    </asp:HyperLink>
                </li>
                <li>
                    <asp:HyperLink ID="HyperLink6" runat="server" NavigateUrl="~/Contact/Default.aspx">
                        Contact Us
                    </asp:HyperLink>
                </li>
            </ul>
        
        </telerik:RadPageView>
    </telerik:RadMultiPage>
    

    
</asp:Content>

