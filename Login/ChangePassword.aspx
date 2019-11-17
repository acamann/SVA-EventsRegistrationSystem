<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="ChangePassword.aspx.vb" Inherits="Login_ChangePassword" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    <asp:ChangePassword ID="ChangePassword1" runat="server" 
            CancelButtonText="" CancelButtonType="Link"
            ContinueDestinationPageUrl="~/Login/Profile.aspx">
        <TitleTextStyle BackColor="#7B97AD" Font-Bold="true" ForeColor="White" 
            Height="25px" />
    </asp:ChangePassword>
</asp:Content>

