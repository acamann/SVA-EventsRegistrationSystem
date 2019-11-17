<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Insufficient.aspx.vb" Inherits="ErrorPages_Insufficient" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    <h1>
        Insufficient Access
    </h1>
    We're sorry.&nbsp; You have insufficient access to view this page.&nbsp;
     Please <asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl="~/Contact/Default.aspx">contact us</asp:HyperLink> if you feel you've reached this page in error.
    
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
    
</asp:Content>

