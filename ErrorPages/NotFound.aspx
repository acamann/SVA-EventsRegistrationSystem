<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="NotFound.aspx.vb" Inherits="ErrorPages_NotFound" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    <h1>
        <asp:Label ID="lblType1" runat="server" Text="Page"></asp:Label>
        Not Found
    </h1>
    We're sorry.&nbsp; The requested <asp:Label ID="lblType2" runat="server" Text="page" />&nbsp;could not be found.&nbsp;
     Please try one of the following links or use your 
    browser's back button to return to the previous page. 
    
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

