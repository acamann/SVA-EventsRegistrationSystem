<%@ Control Language="VB" AutoEventWireup="false" CodeFile="EventsMenu.ascx.vb" Inherits="App_UserControls_EventsMenu" %>
<%@ Register assembly="RadMenu.Net2" namespace="Telerik.WebControls" tagprefix="radM" %>

<radM:RadMenu ID="RadMenu1" runat="server" Skin="Default2006" Width="540px" CausesValidation="false">
    <Items>
        <radM:RadMenuItem runat="server" Text="Upcoming Events" NavigateUrl="~/Default.aspx">
        </radM:RadMenuItem>
        <radM:RadMenuItem runat="server" Text="My Events" NavigateUrl="~/MyEvents/Default.aspx">
        </radM:RadMenuItem>
        <radM:RadMenuItem runat="server" Text="Contact Us" NavigateUrl="~/Contact/Default.aspx">
        </radM:RadMenuItem>
        <radM:RadMenuItem runat="server" Text="Help" NavigateUrl="~/Help/Default.aspx">
        </radM:RadMenuItem>
    </Items>
</radM:RadMenu>
