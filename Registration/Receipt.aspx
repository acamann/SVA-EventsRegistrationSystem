<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Receipt.aspx.vb" Inherits="Registration_Receipt" title="Untitled Page" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register src="../App_UserControls/EventPageHeader.ascx" tagname="EventPageHeader" tagprefix="sva" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">


    <asp:ListView ID="lvRegistrationSteps" runat="server"
            DataSourceID="odsRegistrationSteps" SelectedIndex="0" DataKeyNames="Index">
        <LayoutTemplate>
            <div class="statusheader">
                Registration Steps
                <img runat="server" id="imgHelpSteps" src="../App_Themes/Events/Images/questionmark.gif" alt="help" />
                <telerik:RadToolTip ID="RadToolTip1" runat="server" 
                        Skin="WebBlue" TargetControlID="imgHelpSteps"
                        Position="MiddleRight" RelativeTo="Element"
                        AutoCloseDelay="5000" Width="250">
                    This is a list of steps required for registration.
                    You are currently viewing the receipt/invoice for your completed registration.
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


    <asp:ListView ID="lvContact" runat="server" 
            DataSourceID="odsContact">
        <LayoutTemplate>
            <div ID="itemPlaceholderContainer" runat="server"
                    class="bodytext"
                    style="margin-top:25px;">
                <span ID="itemPlaceholder" runat="server" />
            </div>
        </LayoutTemplate>
        <EmptyDataTemplate>
        </EmptyDataTemplate>
        <ItemTemplate>
            <div style="padding-bottom:10px;font-size:.8em;">
                If you have any questions about your registration, please contact the event coordinator:
            </div>
            <div>
                <div style="color:#024478; font-weight:bold;">
                    <%#Eval("FirstName") %> <%#Eval("LastName")%>
                </div>
                <div>
                    <%#Eval("Phone")%> 
                </div>
                <div>
                    <asp:HyperLink ID="hlEmail" runat="server"
                            NavigateUrl='<%#Eval("Email", "mailto:{0}")%>'>
                        <%#Eval("Email")%>
                    </asp:HyperLink>
                </div>
            </div>
        </ItemTemplate>
    </asp:ListView>
    
    <asp:ObjectDataSource ID="odsContact" runat="server"
            SelectMethod="GetContactByEventId" TypeName="ContactBll">
        <SelectParameters>
            <asp:Parameter Name="eventId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
            
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
        <asp:FormView ID="fvReceipt" runat="server" 
                DataSourceID="odsReceipt" DataKeyNames="RegistrationId" 
                Width="100%">
            <ItemTemplate>
                <asp:HiddenField ID="hdnEventId" runat="server" Value='<%#Eval("EventId")%>' />
                <asp:HiddenField ID="hdnUserId" runat="server" Value='<%#Eval("UserId")%>' />
                
                <sva:EventPageHeader ID="EventPageHeader1" runat="server" EventId='<%#Eval("EventId") %>' SubTitle="Registration Receipt" />
           
                <div style="padding:5px;">
           
                <div class="bodytext" style="padding-bottom:15px;">
                    You are registered for this event.
                </div>

                <asp:Panel ID="pnlInvoice" runat="server" CssClass="bodytext" Visible="false">
                    This is your invoice.  Payment is due by the date of the event.
                    
                    <div style="padding:20px;">
                        <asp:ListView ID="lvContact" runat="server">
                            <LayoutTemplate>
                                <div ID="itemPlaceholderContainer" runat="server">
                                    <span ID="itemPlaceholder" runat="server" />
                                </div>
                            </LayoutTemplate>
                            <EmptyDataTemplate>
                            </EmptyDataTemplate>
                            <ItemTemplate>
                                Attn: <%#Eval("FirstName") %> <%#Eval("LastName")%>
                            </ItemTemplate>
                        </asp:ListView>
                        1221 John Q. Hammons Dr<br />
                        Madison, WI 53717
                    </div>
                </asp:Panel>  
                
                <div class="clearfix bodytext" 
                        style="height:1%;border-top:solid 1px #7B97AD;
                        border-bottom:solid 1px #7B97AD;">
                
                    <div class="row">
                        <div class="left">Registration #:</div>
                        <div class="right">
                            <%#Eval("RegistrationId")%>
                        </div>
                    </div>

                    <div class="row">
                        <div class="left">Attendee Name:</div>
                        <div class="right">
                            <%#Eval("FirstName")%> <%#Eval("LastName")%>
                        </div>
                    </div>
                                        
                    <div class="row">
                        <div class="left">Date Registered:</div>
                        <div class="right">
                            <%#Eval("DateRegistered")%>
                        </div>
                    </div>
                    
                    
                    <div class="row">
                        <div class="left">Event Title:</div>
                        <div class="right">
                            <asp:HyperLink ID="hlEvent" runat="server" 
                                    style="color:Blue;"
                                    NavigateUrl='<%#Eval("EventId", "~/Details/Default.aspx?EventId={0}") %>'>
                                <%#Eval("EventTitle")%>
                            </asp:HyperLink>
                        </div>
                    </div>
                                   
                    <div class="row">
                        <div class="left">Facility:</div>
                        <div class="right">
                            <asp:HyperLink ID="hlFacility" runat="server" 
                                    style="color:Blue;"
                                    NavigateUrl='<%#Eval("FacilityId", "~/Details/Facility.aspx?FacilityId={0}") %>'>
                                <%#Eval("FacilityName")%>
                            </asp:HyperLink>
                        </div>
                    </div> 
                                   
                    <asp:ListView ID="lvDates" runat="server" DataSourceID="odsDates">
                        <LayoutTemplate>
                            <div class="row">
                                <div class="left">Date and Time:</div>
                                <div class="right" id="itemPlaceholderContainer" runat="server">
                                    <span ID="itemPlaceholder" runat="server" />
                                </div>
                            </div>
                        </LayoutTemplate>
                        <EmptyDataTemplate>
                        </EmptyDataTemplate>
                        <ItemTemplate>
                            <div>
                                <span style="font-weight:bold; color:#09387E;">
                                    <%#Eval("StartDate", "{0:ddd, MMM d, yyyy }")%>
                                </span> -
                                <%#Eval("StartDate", "{0:t}")%> to <%#Eval("EndDate", "{0:t}")%>
                            </div>
                        </ItemTemplate>
                    </asp:ListView>
                    
                    <asp:ObjectDataSource ID="odsDates" runat="server"
                            SelectMethod="GetEventDaysByEventId" TypeName="EventDayBll">
                        <SelectParameters>
                            <asp:Parameter Name="eventId" Type="Int32" />
                        </SelectParameters>
                    </asp:ObjectDataSource>

                    
                    <asp:ListView ID="lvGuests" runat="server" DataSourceID="odsGuests">
                        <LayoutTemplate>
                            <div class="row">
                                <div class="left">Guests:</div>
                                <div class="right" id="itemPlaceholderContainer" runat="server">
                                    <ol style="font-size:1em;padding:0px;margin-bottom:0px;">
                                        <span ID="itemPlaceholder" runat="server" />
                                    </ol>
                                </div>
                            </div>
                        </LayoutTemplate>
                        <EmptyDataTemplate>
                        </EmptyDataTemplate>
                        <ItemTemplate>
                            <li style="font-size:1em;list-style-type:decimal;">
                                <%#Eval("FirstName") %> <%#Eval("LastName")%><%#Eval("Email", ", <a href='mailto:{0}'>{0}</a>")%>
                            </li>
                        </ItemTemplate>
                    </asp:ListView>
                    
                    <asp:ObjectDataSource ID="odsGuests" runat="server"
                            SelectMethod="GetGuestsByRegistrationId" TypeName="GuestBll">
                        <SelectParameters>
                            <asp:QueryStringParameter Name="registrationId" QueryStringField="RegistrationId" Type="Int32" />
                        </SelectParameters>
                    </asp:ObjectDataSource>   
                               
                    
                    <asp:ListView ID="lvEventSession" runat="server"
                            OnItemDataBound="lvEventSession_ItemDataBound"
                            DataSourceID="odsEventSession"
                            DataKeyNames="SessionId">
                        <LayoutTemplate>
                            <div class="row">
                                <div class="left">Breakouts:</div>
                                <div class="right" id="itemPlaceholderContainer" runat="server">
                                    <span ID="itemPlaceholder" runat="server" />
                                </div>
                            </div>
                        </LayoutTemplate>
                        <ItemTemplate>
                            <asp:HiddenField ID="hdnSessionId" runat="server" Value='<%# Eval("SessionId") %>' />
                            
                            <div>
                            
                                <div class="bold">
                                    <%#Eval("StartDate", "{0:d}")%> - 
                                    <%# Eval("StartDate", "{0:t}") %> to <%#Eval("EndDate", "{0:t}")%>
                                </div>
                            
                                <asp:ListView ID="lvBreakout" runat="server" 
                                        DataKeyNames="BreakOutId"
                                        DataSourceID="odsBreakout">
                                    <LayoutTemplate>
                                        <div ID="itemPlaceholderContainer" runat="server" class="agendaregister">
                                            <span ID="itemPlaceholder" runat="server" />
                                        </div>
                                    </LayoutTemplate>
                                    <ItemTemplate>
                                        <div style="margin-left:10px;padding:3px;">
                                            
                                            <%-- Breakout - Title and Details --%>
                                            - <%#Eval("Title")%>
                                            <asp:Label ID="lblAttendance" runat="server" 
                                                Text='<%#Eval("Attendance", " - ({0} Registered)")%>'
                                                Visible='<%# Eval("Attendance") > 1 %>'>
                                            </asp:Label>
                                            
                                        </div>
                                    </ItemTemplate>
                                    <EmptyDataTemplate>
                                    </EmptyDataTemplate>
                                </asp:ListView>  
                                                                 
                            </div>
                            
                            <asp:ObjectDataSource ID="odsBreakOut" runat="server" 
                                    SelectMethod="GetBreakoutRegistration" TypeName="BreakoutBll">
                                <SelectParameters>
                                    <asp:Parameter Name="SessionId" Type="Int32" />
                                    <asp:Parameter Name="RegistrationId" Type="Int32" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                            
                        </ItemTemplate> 
                        <ItemSeparatorTemplate>
                            <hr class="separator" />
                        </ItemSeparatorTemplate>
                    </asp:ListView>
                    
                    <asp:ObjectDataSource ID="odsEventSession" runat="server" 
                            SelectMethod="GetSessionsByEventId" TypeName="SessionBll">
                        <SelectParameters>
                            <asp:Parameter Name="eventId" Type="Int32" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    
                    <div class="row" visible='<%# Not Eval("MenuItem") is DBNull.value %>' runat="server">
                        <div class="left">Menu Item:</div>
                        <div class="right">
                            <%#Eval("MenuItem")%>
                        </div>
                    </div>
                    
                    <div class="row" visible='<%# Not Eval("DietaryRestrictions") is DBNull.value %>' runat="server">
                        <div class="left">Dietary Restrictions:</div>
                        <div class="right">
                            <%#Eval("DietaryRestrictions")%>
                        </div>
                    </div>
                    
                    <div class="row" visible='<%# Not Eval("SpecialAccommodations") is DBNull.value %>' runat="server">
                        <div class="left">Special Accommodations:</div>
                        <div class="right">
                            <%#Eval("SpecialAccommodations")%>
                        </div>
                    </div>
                    
                    <%-- PAYMENT --%>
                    <asp:ListView ID="lvPayment" runat="server"
                            DataSourceID="odsPayment"
                            OnItemDataBound="odsPayment_ItemDataBound"
                            DataKeyNames="PaymentId">
                        <LayoutTemplate>
                            <div class="row">
                                <div class="left">Payment:</div>
                                <div class="right" id="itemPlaceholderContainer" runat="server">
                                    <span ID="itemPlaceholder" runat="server" />
                                </div>
                            </div>
                            <asp:DataPager ID="DataPager1" runat="server" PagedControlID="lvPayment" PageSize="1" Visible="false">
                            </asp:DataPager>
                        </LayoutTemplate>
                        <ItemTemplate>
                            
                            <%-- Check different Payment cases --%>                            
                            <telerik:RadMultiPage ID="rmpPayment" runat="server"
                                    SelectedIndex='<%# Iif(Eval("IsAccepted") = True, 0, Iif(Eval("IsCreditCard") = True, 1, 2)) %>'>
                                <telerik:RadPageView ID="pageCredit" runat="server">
                                   
                                   <%-- Paid by Credit Card --%>
                                    Paid <strong><%#Eval("AmountPaid", "{0:c}")%></strong> 
                                    on <strong><%#Eval("DatePaid", "{0:d} {0:t}")%></strong>
                                         
                                </telerik:RadPageView>
                                <telerik:RadPageView ID="pageDeclined" runat="server">
                                    
                                    <%-- Credit Card was declined / other problem --%>
                                    You selected to pay by Credit card on <strong><%#Eval("DateCreated", "{0:d} {0:t}")%></strong>, 
                                        but we encountered a problem processing your payment.
                                    Please contact the event coordinator to resolve this issue.
                                    
                                </telerik:RadPageView>
                                <telerik:RadPageView ID="pageMail" runat="server">
                                    
                                    <%-- Chose to Mail in Payment --%>
                                    You have chosen to mail in your payment of 
                                    <strong><%#Eval("AmountDue", "{0:c}")%></strong>.
                                    Payment is due by the date of the event.
                                    
                                </telerik:RadPageView>
                            </telerik:RadMultiPage>
                            
                        </ItemTemplate> 
                        <ItemSeparatorTemplate>
                            <hr class="separator" />
                        </ItemSeparatorTemplate>
                    </asp:ListView>
                
                    <asp:ObjectDataSource ID="odsPayment" runat="server" 
                            SelectMethod="GetPaymentByRegistration" TypeName="PaymentBll">
                        <SelectParameters>
                            <asp:controlParameter Name="registrationId" Type="Int32" 
                                ControlID="fvReceipt" PropertyName="DataKey.Value" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </div>
                

                <div style="width:100%; margin:15px;">
                    <a href="javascript:window.print()">
                        <img src="../App_Themes/Events/Images/print.gif" 
                            alt="Print Receipt"
                            style="border:none;" />
                    </a>
                </div>
            </div>
                
        </ItemTemplate>
    </asp:FormView>
    
    <asp:ObjectDataSource ID="odsReceipt" runat="server"
            SelectMethod="GetRegistrationById" TypeName="RegistrationBll">
        <SelectParameters>
            <asp:QueryStringParameter Name="registrationId" Type="Int32" QueryStringField="RegistrationId" />
        </SelectParameters>
    </asp:ObjectDataSource>
    
</asp:Content>

