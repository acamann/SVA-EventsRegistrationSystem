<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Profile.aspx.vb" Inherits="Profile" title="Untitled Page" %>

<%@ Register src="../App_UserControls/EditProfile.ascx" tagname="EditProfile" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
    <asp:HyperLink ID="HyperLink1" runat="server" 
            CssClass="leftlink"
            NavigateUrl="~/Login/ChangePassword.aspx">
        Change Password
    </asp:HyperLink>
    <asp:HyperLink ID="hlUpcoming" runat="server" 
            CssClass="leftlink"
            NavigateUrl="~/MyEvents/Default.aspx?Mode=Upcoming">
        My Upcoming Events
    </asp:HyperLink>
    <asp:HyperLink ID="hlPrevious" runat="server"
            CssClass="leftlink"
            NavigateUrl="~/MyEvents/Default.aspx?Mode=Previous">
        My Previous Events
    </asp:HyperLink>
        
    <%--<div class="bodytext" style="margin-top:10px;">
        Would you like to receive e-mail updates about upcoming events?
    </div>--%>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    <h1>
        User Profile
    </h1>
    
    <div class="bodytext" style="margin-bottom:15px;">
        <asp:HyperLink ID="HyperLink2" runat="server"
                NavigateUrl="~/Login/ChangePassword.aspx">
            Change Password
        </asp:HyperLink>
    </div>
    
    <uc1:EditProfile ID="EditProfile1" runat="server" />
</asp:Content>

