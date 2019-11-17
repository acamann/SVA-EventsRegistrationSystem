<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" 
    CodeFile="WaitingList.aspx.vb" Inherits="Registration_WaitingList" 
    title="Waiting List" %>

<%@ Register src="../App_UserControls/EventPageHeader.ascx" tagname="EventPageHeader" tagprefix="sva" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
    <asp:HyperLink ID="hlBackToEvent" runat="server" CssClass="leftlink" 
            NavigateUrl="" > 
        <img id="Img1" src="~/App_Themes/Events/Images/return.gif" alt="Back" runat="server" />
        Back to Event
    </asp:HyperLink>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">

    <sva:EventPageHeader ID="EventPageHeader1" runat="server" SubTitle="Waiting List" />

    <div class="bodytext" style="margin-bottom:20px;">
        You have been successfully added to the waiting list for this event.  
        You will be notified as soon as a spot becomes open.
    </div>
    
    <div style="text-align:center;font-size:0.8em;">
        
        <asp:HyperLink ID="hlEventDetails" runat="server" CssClass="formyellowbutton" 
                NavigateUrl=""
                style="width:125px;" > 
            Event Details
        </asp:HyperLink>
    </div>
</asp:Content>

