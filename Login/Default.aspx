<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" 
    Inherits="login_default" title="Untitled Page" %>
    
<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
    
    <asp:HyperLink ID="hlNewAccount" runat="server"
            NavigateUrl="~/Login/NewUser.aspx" CssClass="leftlink">
        Create a New Account
    </asp:HyperLink>
    
    <asp:HyperLink ID="HyperLink1" runat="server"
            NavigateUrl="~/Login/Password.aspx" CssClass="leftlink">
        Forgot Password?
    </asp:HyperLink>
            
    <asp:Panel ID="pnlMustLogin" class="bodytext" runat="server" style="margin-top:15px;">
        You must be logged in to view this page.</asp:Panel>
    
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    
    <asp:Login ID="Login1" runat="server"
            UserNameLabelText="E-Mail:" style="margin-bottom:15px;" 
            DestinationPageUrl="~/Default.aspx">
        <TitleTextStyle BackColor="#7B97AD" ForeColor="White" Font-Bold="true" Height="25px" />
    </asp:Login>
    
    <div class="bodytext" style="margin-bottom:15px;">
        Forgot your
        <asp:HyperLink ID="HyperLink2" runat="server"
            NavigateUrl="~/Login/Password.aspx" style="color:Blue;" >password</asp:HyperLink>?
    </div>
    
    <div class="bodytext">
        If you have never logged in before, you will need to 
        <asp:HyperLink ID="hlNewAccount2" runat="server"
            NavigateUrl="~/Login/NewUser.aspx" style="color:Blue;" >create a new account</asp:HyperLink>.
    </div>
    
</asp:Content>

