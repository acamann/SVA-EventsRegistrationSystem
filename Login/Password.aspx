<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" 
    CodeFile="Password.aspx.vb" Inherits="Password" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">

    <asp:HyperLink ID="hlNewAccount" runat="server"
            NavigateUrl="~/Login/NewUser.aspx" CssClass="leftlink">
        Create a New Account
    </asp:HyperLink>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">

    <asp:PasswordRecovery ID="PasswordRecovery1" runat="server"
            UserNameTitleText="Forgot Your Password?" 
            UserNameInstructionText="If you've created an account in the past, enter your e-mail address and we'll send you your password." 
            UserNameLabelText="E-Mail:" Width="400px">
        <MailDefinition From="no-reply@sva.com" Subject="Password Reset" ></MailDefinition>
        <InstructionTextStyle Height="50px" Font-Size="Small" />
        <TitleTextStyle BackColor="#7B97AD" ForeColor="White" Font-Bold="true" Height="25px" />
        <%--<UserNameTemplate>
            <div style="background-color:#7B97AD;color:White;font-weight:bold;padding:3px;text-align:center;">
                Reset Password
            </div>
            <div style="font-size:small;padding:10px;">
                If you've created an account in the past, enter your e-mail address and we'll send you a new password.
            </div>
            <div style="margin-left:40px;">
                Email: 
                <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
            </div>
            <div class="bodytext" style="padding:3px;">
                <asp:literal runat="server" id="FailureText"></asp:literal>
            </div>
            <div style="text-align:right; padding:3px;">
                <asp:Button ID="btnSubmit" CommandName="Submit" runat="server" Text="Submit" />
            </div>
        </UserNameTemplate>--%>
    </asp:PasswordRecovery>
    
</asp:Content>

