<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="Details_Default" title="Untitled Page" %>

<%@ Register Assembly="RadPanelbar.Net2" Namespace="Telerik.WebControls" TagPrefix="radP" %>
<%@ Register assembly="RadMenu.Net2" namespace="Telerik.WebControls" tagprefix="radM" %>

<%@ Register src="../App_UserControls/EventPageHeader.ascx" tagname="EventPageHeader" tagprefix="sva" %>
<%@ Register src="../App_UserControls/RegistrationInfo.ascx" tagname="RegistrationInfo" tagprefix="sva" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">

    <!-- Navigation -->
    <asp:ListView ID="lvNavigation" runat="server" 
            DataSourceID="cphCenterCol$odsEventDetails">
        <LayoutTemplate>
            <div ID="itemPlaceholderContainer" runat="server" style="margin-bottom:20px;">
                <span ID="itemPlaceholder" runat="server" />
            </div>
        </LayoutTemplate>
        <EmptyDataTemplate>
        </EmptyDataTemplate>
        <ItemTemplate>
            <asp:HyperLink ID="hlViewAgenda" runat="server"
                    CssClass="leftlink"
                    NavigateUrl='<%#Eval("EventId", "~/Details/Agenda.aspx?EventId={0}") %>'>
                View Agenda
            </asp:HyperLink>

            <asp:HyperLink ID="hlFacility" runat="server"
                    OnPreRender="AddEventIdToLink"
                    CssClass="leftlink"
                    NavigateUrl='<%#Eval("FacilityId", "~/Details/Facility.aspx?FacilityId={0}") %>'>
                Facility Details
            </asp:HyperLink>

            <asp:HyperLink ID="hlAreaAttractions" runat="server"
                    onprerender="AddEventIdToLink"
                    CssClass="leftlink"
                    Visible='<%# not Eval("AreaId") is DBNUll.Value %>'
                    NavigateUrl='<%#Eval("AreaId", "~/Details/Attractions.aspx?AreaId={0}") %>'>
                Area Attractions
            </asp:HyperLink>

            <asp:HyperLink ID="HyperLink1" runat="server"
                    CssClass="leftlink"
                    onprerender="AddEventIdToLink"
                    NavigateUrl='<%#Eval("ContactId", "~/Contact/Default.aspx?ContactId={0}") %>'>
                Contact Us
            </asp:HyperLink>
    
            <asp:HyperLink ID="hlUpcoming" runat="server"
                    CssClass="leftlink"
                    NavigateUrl="~/Default.aspx">
                Upcoming Events
            </asp:HyperLink>
               
        </ItemTemplate>
    </asp:ListView>

    <!-- End Navigation -->
        
    <sva:RegistrationInfo ID="RegistrationInfo1" runat="server" />
   
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">

    
    <asp:FormView ID="fvEvent" runat="server" DataKeyNames="EventId" 
            DataSourceID="odsEventDetails" Width="100%">
        <ItemTemplate>
        
            <asp:HiddenField ID="hdnDatePublished" runat="server" Value='<%#Eval("DatePublished") %>' />
            
            <sva:EventPageHeader ID="EventPageHeader1" runat="server" EventId='<%#Eval("EventId")%>' />
            
            <div class="clearfix bodytext row" 
                    style="height:1%;border-bottom:solid 1px #7B97AD;padding-top:6px;padding-bottom:6px;width:100%;">  
                <div class="left">Date and Time:</div>
                
                <div class="right clearfix" style="height:1%;width:400px;">
                
                    <asp:ListView ID="lvAgenda" runat="server" DataSourceID="odsAgendaDetails">
                        <LayoutTemplate>
                            <div ID="itemPlaceholderContainer" runat="server" style="float:left;">
                                <span ID="itemPlaceholder" runat="server" />
                            </div>
                        </LayoutTemplate>
                        <EmptyDataTemplate>
                        </EmptyDataTemplate>
                        <ItemTemplate>
                        
                                <div>
                                    <span style="font-weight:bold;color:#09387E;">
                                        <%#Eval("StartDate", "{0:ddd, MMM d, yyyy}")%> 
                                    </span> 
                                
                                    (<%#Eval("StartDate", "{0:t}")%> - 
                                    <%#Eval("EndDate", "{0:t}")%>)
                                </div> 
                                 
                        </ItemTemplate>
                        <ItemSeparatorTemplate>
                        </ItemSeparatorTemplate>
                    </asp:ListView>
                    
                    <div style="float:right;">
                        <asp:HyperLink ID="hlViewAgenda" runat="server"
                                style="color:blue;"
                                NavigateUrl='<%#Eval("EventId", "~/Details/Agenda.aspx?EventId={0}") %>'>
                            View Agenda
                        </asp:HyperLink>
                    </div>
                                    
                </div>
             </div>   
             
            <div class="clearfix bodytext row" 
                    style="height:1%;border-bottom:solid 1px #7B97AD;padding-top:6px;padding-bottom:6px;width:100%;">
                <div class="left">Facility:</div>  
                <asp:ListView ID="lvLocationDetails" runat="server" 
                        DataSourceID="odsFacilityDetails">
                    <LayoutTemplate>
                        <div ID="itemPlaceholderContainer" class="right" runat="server" style="width:400px;">
                            <span ID="itemPlaceholder" runat="server" />
                        </div>
                    </LayoutTemplate>
                    <EmptyDataTemplate>
                    </EmptyDataTemplate>
                    <ItemTemplate>
                        
                        <div class="clearfix" style="height:1%;">
                                                    
                            <%-- Address --%>
                            <div style="float:left;">
                                <div style="font-weight:bold; color:#09387E;">
                                    <%# Eval("Title") %>
                                </div>
                                <asp:Panel ID="pnlAddress" runat="server" Visible='<%# Not Eval("Address") is DBNull.Value %>'>
                                    <%# Eval("Address") %><br />
                                    <%# Eval("City") %>, <%# Eval("State") %> <%# Eval("Zip") %>
                                </asp:Panel>
                                <asp:Panel ID="pnlPhone" runat="server" Visible='<%# Not Eval("Phone") is DBNull.Value %>'>
                                    <%# Eval("Phone") %>                            
                                </asp:Panel>
                            </div>
                                                        
                            <div style="float:right;text-align:right;">
                                <div>
                                    <asp:HyperLink ID="hlFacility" runat="server"
                                            style="color:blue;"
                                            OnPreRender="AddEventIdToLink"
                                            NavigateUrl='<%#Eval("FacilityId", "~/Details/Facility.aspx?FacilityId={0}") %>'>
                                        Facility Details
                                    </asp:HyperLink>
                                </div>
                                <div>
                                    <asp:HyperLink ID="hlAreaAttractions" runat="server"
                                            style="color:blue;"
                                            onprerender="AddEventIdToLink"
                                            Visible='<%# not Eval("AreaId") is DBNUll.Value %>'
                                            NavigateUrl='<%#Eval("AreaId", "~/Details/Attractions.aspx?AreaId={0}") %>'>
                                        Area Attractions
                                    </asp:HyperLink>
                                </div>
                            </div>
                            
                        </div>
                    </ItemTemplate>
                </asp:ListView>
            </div> 
              
            <div class="clearfix bodytext row" 
                    style="height:1%;border-bottom:solid 1px #7B97AD;padding-top:6px;padding-bottom:6px;width:100%;">  
                <div class="left">Contact:</div>
                
                <div class="right clearfix" style="height:1%;width:400px;">
                                            
                    <asp:ListView ID="lvContactDetails" runat="server" 
                            DataSourceID="odsContactDetails">
                        <LayoutTemplate>
                            <div ID="itemPlaceholderContainer" runat="server" style="">
                                <span ID="itemPlaceholder" runat="server" />
                            </div>
                        </LayoutTemplate>
                        <EmptyDataTemplate>
                        </EmptyDataTemplate>
                        <ItemTemplate>
                                               
                            <%-- Contact --%>
                            <div style="float:left;">
                                <div style="font-weight:bold;color:#09387E;"><%#Eval("FirstName")%> <%#Eval("LastName")%></div>
                                <%#Eval("Title", "{0}<br />")%>
                                <%#Eval("Phone")%>
                                <br />
                                <%#Eval("Email", "<a href='mailto:{0}'>{0}</a>")%>
                            </div>

                        </ItemTemplate>
                    </asp:ListView>
                    
                    <div style="float:right;">
                        <asp:HyperLink ID="HyperLink1" runat="server"
                                style="color:blue;"
                                onprerender="AddEventIdToLink"
                                NavigateUrl='<%# Eval("ContactId", "~/Contact/Default.aspx?ContactId={0}") %>'>
                            Contact Us
                        </asp:HyperLink>
                    </div>  
                       
                </div>              
            </div>
            
            <asp:ListView ID="lvPricing" runat="server" 
                    DataKeyNames="PricingId"
                    DataSourceID="odsPricing">
                <LayoutTemplate>
                    <div class="clearfix bodytext row" 
                            style="height:1%;border-bottom:solid 1px #7B97AD;padding-top:6px;padding-bottom:6px;">  
                        <div class="left">Price:</div>
                        
                        <div class="right clearfix" style="height:1%;">

                            <div ID="itemPlaceholderContainer" runat="server" style="float:left;">
                                <span ID="itemPlaceholder" runat="server" />
                            </div>    
                        </div>
                    </div>
                </LayoutTemplate>
                <ItemTemplate>
                    <div>
                        <span style="font-weight:bold;color:#09387E;">
                            <%#Eval("Price", "{0:c}")%> 
                        </span> 
                        - <%#Eval("Title")%>
                        <%#IIf(Eval("StartDate") Is DBNull.Value, IIf(Eval("ExpireDate") Is DBNull.Value, "", Eval("ExpireDate", "(Until {0:d})")), IIf(Eval("ExpireDate") Is DBNull.Value, Eval("StartDate", "(After {0:d})"), "(" & Eval("StartDate", "{0:d}") & " to " & Eval("ExpireDate") & ")"))%>
                    </div>
                </ItemTemplate>
            </asp:ListView>
                
            <div class="bodytext" style="padding:10px;">
                <%# Eval("Description") %>
            </div>
            
            <sva:RegistrationInfo ID="RegistrationInfo2" runat="server" EventId='<%#Eval("EventId")%>' />
            
        </ItemTemplate>
    </asp:FormView>
    
    <asp:ObjectDataSource ID="odsEventDetails" runat="server" 
            SelectMethod="GetEventById" 
            TypeName="EventBll">
        <SelectParameters>
            <asp:QueryStringParameter Name="eventId" QueryStringField="EventId" 
                Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsAgendaDetails" runat="server"
            SelectMethod="GetEventDaysByEventId" TypeName="EventDayBll">
        <SelectParameters>
            <asp:QueryStringParameter Name="eventId" QueryStringField="EventId" 
                Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    
    <asp:ObjectDataSource ID="odsContactDetails" runat="server" 
            SelectMethod="GetContactByEventId" TypeName="ContactBll">
        <SelectParameters>
            <asp:QueryStringParameter Name="eventId" QueryStringField="EventId" 
                Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
        
    <asp:ObjectDataSource ID="odsFacilityDetails" runat="server"
            SelectMethod="GetFacilityByEventId" TypeName="FacilityBll">
        <SelectParameters>
            <asp:QueryStringParameter Name="eventId" QueryStringField="EventId" 
                Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    
    <asp:ObjectDataSource ID="odsPricing" runat="server"
            SelectMethod="SelectAllPricing" TypeName="PricingBll">
        <SelectParameters>
            <asp:QueryStringParameter Name="eventId" QueryStringField="EventId" 
                Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    
</asp:Content>



