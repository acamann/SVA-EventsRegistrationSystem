<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Payment.aspx.vb" Inherits="Registration_Payment" title="Untitled Page" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register Assembly="RadTabStrip.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>

<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>

<%@ Register src="../App_UserControls/EventPageHeader.ascx" tagname="EventPageHeader" tagprefix="sva" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">

    <asp:ListView ID="lvRegistrationSteps" runat="server"
            DataSourceID="odsRegistrationSteps" SelectedIndex="0" DataKeyNames="Index">
        <LayoutTemplate>
            <div class="statusheader">
                Registration Steps
                <img runat="server" id="imgHelpSteps" src="../App_Themes/Events/Images/questionmark.gif" />
                <telerik:RadToolTip ID="RadToolTip1" runat="server" 
                        Skin="WebBlue" TargetControlID="imgHelpSteps"
                        Position="MiddleRight" RelativeTo="Element"
                        AutoCloseDelay="5000" Width="250">
                    This is a list of steps required for registration.  
                    You are currently viewing the payment options.
                </telerik:RadToolTip>
            </div>
            <ol ID="itemPlaceholderContainer" runat="server" class="statuslist">
                <span ID="itemPlaceholder" runat="server" />
            </ol>
        </LayoutTemplate>
        <EmptyDataTemplate>
        </EmptyDataTemplate>
        <SelectedItemTemplate>
            <li class="selectedstatus">
                <%#Eval("Title")%>
            </li>
        </SelectedItemTemplate>
        <ItemSeparatorTemplate>
        </ItemSeparatorTemplate>
        <ItemTemplate>
            <li class="status">
                <%#Eval("Title")%>
            </li>
        </ItemTemplate>
    </asp:ListView>
    
    <asp:ObjectDataSource ID="odsRegistrationSteps" runat="server"
            TypeName="RegistrationBll" SelectMethod="GetRegistrationStepsByEvent">
        <SelectParameters>
            <asp:Parameter Name="eventId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    
    <rad:RadMultiPage ID="rmpPayment" runat="server" SelectedIndex="0">
        <rad:PageView ID="viewPayment" runat="server">
            <asp:FormView ID="fvPayment" runat="server" 
                    Width="100%" DataSourceID="odsRegistrationPayment">
                <ItemTemplate>
                    
                    <sva:EventPageHeader ID="EventPageHeader1" runat="server" 
                        EventId='<%#Eval("EventId")%>' SubTitle="Registration - Payment" />
                                        
                    <asp:HiddenField ID="hdnEventId" runat="server" Value='<%# Eval("EventId") %>' />
                    <asp:HiddenField ID="hdnUserId" runat="server" Value='<%# Eval("UserId") %>' />
                    <asp:HiddenField ID="hdnDatePaid" runat='server' Value='<%# Eval("DatePaid") %>' />
                    
                    <div class="bodytext" style="padding:5px;">
                        <rad:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
                            
                            <asp:Panel ID="pnlSelect" runat="server">
                                <asp:Label ID="lblSelect" runat="server">Please select your pricing level:</asp:Label>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                    ErrorMessage="***" ControlToValidate="txtAmountDue">
                                </asp:RequiredFieldValidator>
                                
                                <asp:ListView ID="lvPricing" runat="server" 
                                        DataKeyNames="PricingId"
                                        DataSourceID="odsPricing"
                                        OnDataBound="lvPricing_DataBound"
                                        onselectedIndexChanged="lvPricing_SelectedIndexChanged">
                                    <LayoutTemplate>
                                        <ul ID="itemPlaceholderContainer" runat="server" style="font-size:1em;" >
                                            <span ID="itemPlaceholder" runat="server" />
                                        </ul>    
                                    </LayoutTemplate>
                                    <SelectedItemTemplate>
                                        <li style="font-size:1em;">
                                            <asp:HiddenField ID="hdnPrice" runat="server" Value='<%#Eval("Price")%>' />
                                            <span class="bold" style="background-color:#FEEB82;">
                                                <%#Eval("Price", "{0:c}")%></span>
                                             - <%#Eval("Title")%>
                                        </li>
                                    </SelectedItemTemplate>
                                    <ItemTemplate>
                                        <li style="font-size:1em;">
                                            <asp:HiddenField ID="hdnPrice" runat="server" Value='<%#Eval("Price")%>' />
                                            <asp:LinkButton ID="lbSelectPrice" runat="server" 
                                                    CommandName="Select" CausesValidation="false">
                                                <%#Eval("Price", "{0:c}")%>
                                            </asp:LinkButton>
                                            - <%#Eval("Title")%>
                                        </li>
                                    </ItemTemplate>
                                </asp:ListView>
                            </asp:Panel>
                            
                            <asp:ObjectDataSource ID="odsPricing" runat="server"
                                    SelectMethod="SelectCurrentPricing" TypeName="PricingBll">
                                <SelectParameters>
                                    <asp:Parameter Name="EventId" Type="Int32" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                            
                            <div class="center" style="margin-bottom:25px;">
                                <div class="clearfix invoicehead">
                                    <div>
                                        Unit Price
                                    </div>
                                    <div>
                                        Quantity
                                    </div>
                                    <div>
                                        Amount Due
                                    </div>
                                </div>
                                <div class="clearfix invoicevalues">
                                    <asp:TextBox ID="txtUnitPrice" runat="server" 
                                        Text="" ReadOnly="true">
                                    </asp:TextBox>
                                    <asp:TextBox ID="txtQuantity" runat="server" 
                                        Text='<%#Eval("Guests") + 1 %>' ReadOnly="true">
                                    </asp:TextBox>
                                    <asp:TextBox ID="txtAmountDue" runat="server" 
                                        Text="" ReadOnly="true" CssClass="total">
                                    </asp:TextBox>
                                </div>
                            </div>
                        </rad:RadAjaxPanel>
                                  
                                    
                        Please select your payment method:   
                                                         
                        <img runat="server" id="imgHelpSteps" src="../App_Themes/Events/Images/questionmark.gif" />
                        <telerik:RadToolTip ID="RadToolTip1" runat="server" 
                                Skin="WebBlue" TargetControlID="imgHelpSteps"
                                Position="MiddleRight" RelativeTo="Element"
                                AutoCloseDelay="10000" Width="300">
                            If you decide to pay by Credit Card, you will be redirected 
                                to an external site for secure credit card processing.  
                            If you decide to mail in your payment, you will be taken to your invoice, 
                                which will contain further instructions.
                        </telerik:RadToolTip>
                        
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                            runat="server" ErrorMessage="***" ControlToValidate="rblPayment"></asp:RequiredFieldValidator>
                        <div style="padding:5px;margin-left:15px;">
                            <asp:RadioButtonList ID="rblPayment" runat="server">
                                <asp:ListItem Text="Pay by Credit Card" Value="Credit"></asp:ListItem>
                                <asp:ListItem Text="Mail in Payment" Value="Mail"></asp:ListItem>
                            </asp:RadioButtonList>    
                        </div>
                        
                        <div style="float:right;">
                            <div style="clear:both;">
                                <%--<asp:LinkButton ID="lbPrevious" runat="server" CausesValidation="false"
                                        CssClass="formyellowbutton" 
                                        OnClientClick="javascript:history.go(-1);return false;">
                                    Previous
                                </asp:LinkButton>
                                
                                &nbsp;&nbsp;--%>
                                
                                <asp:LinkButton ID="lbProcessPayment" runat="server" 
                                        CssClass="formyellowbutton" OnClick="lbProcessPayment_Click">
                                    Next
                                </asp:LinkButton>
                            </div>
                        </div>
                                        
                    </div>
                </ItemTemplate>
           
            </asp:FormView>    
        </rad:PageView>
        <rad:PageView ID="viewError" runat="server">
        
            <h2>Payment Error</h2>
            
            <div class="bodytext">
                There was an error submitting your payment information.
            </div>
            
        </rad:PageView>
        <%--<rad:PageView ID="viewPaid" runat="server">
        
            <h2>Payment</h2>
        
            <div class="bodytext">
                You have already paid for this event.  Please click continue to view your receipt.
            </div>
            
            <div style="float:right;">
                <asp:HyperLink ID="hlViewReceipt" runat="server" 
                        CssClass="formyellowbutton">
                    Continue
                </asp:HyperLink>
            </div>
            
        </rad:PageView>--%>
    </rad:RadMultiPage>
    
    

    <%--<asp:SqlDataSource ID="SqlRegistrationPayment" runat="server" 
            ConnectionString="<%$ ConnectionStrings:cnSVAEvents %>" 
            SelectCommand="SELECT * FROM [vwCompleteRegistration] WHERE ([RegistrationId] = @RegistrationId)">
        <SelectParameters>
            <asp:QueryStringParameter Name="RegistrationId" QueryStringField="RegistrationId" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>--%>
    <asp:ObjectDataSource ID="odsRegistrationPayment" runat="server" 
            SelectMethod="GetRegistrationById" TypeName="RegistrationBll">
        <SelectParameters>
            <asp:QueryStringParameter Name="RegistrationId" QueryStringField="RegistrationId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    

</asp:Content>

