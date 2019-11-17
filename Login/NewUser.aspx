<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="NewUser.aspx.vb" Inherits="NewUser" title="Untitled Page" %>

<%@ Register Assembly="RadTabStrip.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
    
    <asp:HyperLink ID="hlLogin2" runat="server"
            NavigateUrl="~/Login/Default.aspx" cssclass="leftlink">
        Login
    </asp:HyperLink> 
    
    <asp:HyperLink ID="hlPassword" runat="server"
            NavigateUrl="~/Login/Password.aspx" cssclass="leftlink">
        Forgot Password?
    </asp:HyperLink> 
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    
    <rad:RadMultiPage ID="rmpNewUser" runat="server" SelectedIndex="0">
        <rad:PageView ID="pageCreate" runat="server">
            <asp:CreateUserWizard ID="CreateUserWizard1" runat="server"  
                    DuplicateUserNameErrorMessage="This E-mail is already being used." 
                    RequireEmail="false" UserNameLabelText="Email:">
                <TitleTextStyle BackColor="#7B97AD" Font-Bold="true" ForeColor="White" 
                    Height="25px" />
                <WizardSteps>
                    
                    <asp:CreateUserWizardStep runat="server" Title="Create a New Account">
                    </asp:CreateUserWizardStep>
                    
                    <asp:CompleteWizardStep ID="CompleteWizardStep1" runat="server">
                    </asp:CompleteWizardStep>
                    
                </WizardSteps>
            </asp:CreateUserWizard>

            <div class="bodytext" >
                Already registered with SVA? 
                <asp:HyperLink ID="hlLogin" runat="server"
                        NavigateUrl="~/Login/Default.aspx" style="color:Blue;">
                    Login</asp:HyperLink> 
                now.
            </div>     
        </rad:PageView>
        <rad:PageView ID="pageExistsOk" runat="server">
            
            <div class="bodytext" >
                It appears that you've already registered with this information.  
                You are now logged in. 
            </div>
            <asp:HyperLink ID="hlContinue" runat="server" 
                CssClass="formyellowbutton">Continue</asp:HyperLink>
            
        </rad:PageView>
        <rad:PageView ID="pageExistsNotOk" runat="server">
            
            <div class="bodytext" >
                An account already exists for the e-mail address you entered.
            </div>
            
            <ul>
                <li><asp:HyperLink ID="hlForgotPassword" runat="server"
                        NavigateUrl="~/Login/Password.aspx" style="color:Blue;">
                    Forgot your password</asp:HyperLink>?  We can send you a new one.</li>
                <li>
                    Try a <asp:HyperLink ID="hlBack" runat="server"
                        NavigateUrl="~/Login/NewUser.aspx">different e-mail address</asp:HyperLink>.
                </li>
            </ul> 
            
        </rad:PageView>
    </rad:RadMultiPage>
    
       
   
</asp:Content>

