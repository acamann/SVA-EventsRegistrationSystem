<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="ErrorPages_Default" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    
    <h1>
        Oops!
    </h1>
    
    <div style="margin-bottom:15px;">
        <asp:Label ID="lblMessage" runat="server" Text="Sorry, we've encountered an unexpected problem."></asp:Label>    
    </div>
    
    <div>
     Please <asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl="~/Contact/Default.aspx">contact us</asp:HyperLink> if you feel you've reached this page in error.
    </div>
    
</asp:Content>

