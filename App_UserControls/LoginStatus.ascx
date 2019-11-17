<%@ Control Language="VB" AutoEventWireup="false" CodeFile="LoginStatus.ascx.vb" Inherits="App_UserControls_LoginStatus" %>

<asp:LoginView ID="LoginView1" runat="server">
    <AnonymousTemplate>
        <asp:HyperLink ID="hlLogin" runat="server" 
                NavigateUrl="~/Login/Default.aspx" class="leftlink">
            Login/New Account
        </asp:HyperLink>
    </AnonymousTemplate>
    <LoggedInTemplate>
        <div class="wordbreak" style="font-size:.8em;">
            Logged in as<br /> 
            <asp:Label ID="lblName" runat="server" 
                style="font-weight:bold;color:#024478; font-size:0.9em;">
            </asp:Label>
        </div>
        <asp:LoginStatus ID="LoginStatus1" runat="server" CssClass="leftlink" />
        <asp:HyperLink ID="hlEditProfile" runat="server" 
                NavigateUrl="~/Login/Profile.aspx" class="leftlink">
            My Profile
        </asp:HyperLink>
    </LoggedInTemplate>
</asp:LoginView>

<%--<asp:LoginView ID="LoginView2" runat="server">
    <LoggedInTemplate>
    
        <asp:HyperLink ID="hlEditProfile" runat="server" 
                NavigateUrl="~/Login/Profile.aspx" class="leftlink">
            My Profile
        </asp:HyperLink>
    </LoggedInTemplate>
</asp:LoginView>--%>