<%@ Page Language="VB" MasterPageFile="~/Events.master" 
    AutoEventWireup="false" CodeFile="Default.aspx.vb" 
    Inherits="_Default" title="Untitled Page" %>

<%@ Register Assembly="RadTabStrip.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>

<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>

<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>

<%@ Register assembly="RadGrid.Net2" namespace="Telerik.WebControls" tagprefix="radG" %>

<asp:Content ID="contentLeft" ContentPlaceHolderID="cphLeftCol" Runat="Server">
    
    <script type="text/javascript">
    
        function filter(searchid, eventtypeid, areaid, entityid) {
            
            var txtSearch = document.getElementById(searchid);
            var ddlEventType = document.getElementById(eventtypeid);
            var ddlEntity = document.getElementById(entityid);
            
            var postback = 'Default.aspx?'
            if (txtSearch.value) postback+='Search='+txtSearch.value+'&';
            if (ddlEventType.value) postback+='EventTypeId='+ddlEventType.value+'&';
            if (ddlEntity.value) postback+='EntityId='+ddlEntity.value+'&';
            
            window.location=postback;
        }
        
    </script>

    <div class="bodytext" style="margin-right:7px;margin-top:15px;">
        
        <div style="padding-bottom:3px;">Search:</div>
        
        <asp:TextBox ID="txtSearch" runat="server" Width="125px" onfocus="javascript:this.select();" ></asp:TextBox>
        <asp:ImageButton ID="btnSearch" runat="server"
            ImageUrl="~/App_Themes/Events/Images/orange-arrow.gif" 
            AlternateText="Search" />
        
        <hr style="margin-top:15px;margin-bottom:15px;" />
        
        <div style="padding-bottom:3px;">Event Type:</div>
        <asp:DropDownList ID="ddlEventType" runat="server" style="font-size:0.9em"
                AppendDataBoundItems="True" DataSourceID="SqlEventType" Width="100%" 
                DataTextField="EventType" DataValueField="EventTypeId">
            <asp:ListItem Text="All" Value="" Selected="True"></asp:ListItem>
        </asp:DropDownList>
                    
        <asp:SqlDataSource ID="SqlEventType" runat="server" 
            ConnectionString="<%$ ConnectionStrings:cnSVAEvents %>" 
            SelectCommandType="StoredProcedure"
            SelectCommand="EventType_Select">
        </asp:SqlDataSource>
        
        <div style="padding-bottom:3px;padding-top:8px;">Entity:</div>
        <asp:DropDownList ID="ddlEntity" runat="server" style="font-size:0.9em;"
                AppendDataBoundItems="True" DataSourceID="odsEntity" Width="100%" 
                DataTextField="Title" DataValueField="EntityId">
            <asp:ListItem Text="All" Value="" Selected="True"></asp:ListItem>
        </asp:DropDownList>

        <asp:ObjectDataSource ID="odsEntity" runat="server"
            SelectMethod="GetEntities" TypeName="EntityBll">
        </asp:ObjectDataSource>

    
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    <h1>Upcoming Events</h1>
    
    <asp:ListView ID="lvEvents" runat="server" DataSourceID="odsUpcomingEvents" 
            DataKeyNames="EventId">
        <LayoutTemplate>
            
            <div class="bodytext clearfix datapager">
            
                <asp:DataPager ID="DataPager2" runat="server">
                    <Fields>
                        <asp:TemplatePagerField>
                            <PagerTemplate>
                                <span style="display:block;float:right;">
                                    Results <strong><%#Container.StartRowIndex + 1%></strong>
                                    - <strong><%#IIf(Container.TotalRowCount > Container.MaximumRows, _
                                                IIf(Container.StartRowIndex + Container.MaximumRows > Container.TotalRowCount, _
                                                    Container.TotalRowCount, _
                                                    Container.StartRowIndex + Container.MaximumRows), _
                                                Container.TotalRowCount)%></strong>
                                    of
                                    <strong><%# Container.TotalRowCount%></strong>
                                </span>
                            </PagerTemplate>
                        </asp:TemplatePagerField>
                    </Fields>
                </asp:DataPager>
            </div>
            
            <div class="eventlist bodytext" id="itemPlaceHolderContainer" runat="server">
                <span id="itemPlaceholder" runat="server"></span>
            </div>
            
            <div class="bodytext datapager">
                <asp:DataPager ID="DataPager1" runat="server" PageSize="10">
                    <Fields>
                        <asp:NumericPagerField ButtonCount="10" NextPageText="..." PreviousPageText="..." />
                    </Fields>
                </asp:DataPager>
            </div>
            
        </LayoutTemplate>
        <EmptyDataTemplate>
            There are no upcoming events that match your search.
        </EmptyDataTemplate>
        <ItemSeparatorTemplate>
            <div class="separator"></div>
        </ItemSeparatorTemplate>
        <ItemTemplate>

            <asp:HyperLink ID="HyperLink1" runat="server"
                    CssClass="event"
                    NavigateUrl='<%# Eval("EventId", "~/Details/Default.aspx?EventId={0}") %>'>
                
                <span class="title"><%#Eval("Title")%></span>
                
                <span class="description">
                    <%#Tools.Shorten(Tools.UnformatHTML(Eval("Description")), 250)%>
                </span>
                    
                <span class="infobar clearfix">
                    <span class="left">
                        <span class="date"><%#Eval("Date", "{0:ddd, MMM d, yyyy}")%></span>
                        <span class="type"><%#Eval("Type")%></span>
                    </span>
                    <span class="middle">
                        <span class="facility"><%#Eval("FacilityName")%></span>
                        <span class="location"><%#Eval("Location")%></span>
                    </span>
                    <span class="right">
                        <%#GetOpenings(Eval("MaxAttendance"), Eval("Attendance"), Eval("RegisterFrom"), Eval("RegisterTo"))%>                        
                    </span>
                </span>
                
            </asp:HyperLink>
            
        </ItemTemplate>
    </asp:ListView>
                
    <asp:ObjectDataSource ID="odsUpcomingEvents" runat="server" 
            SelectMethod="GetUpcomingEvents" 
            TypeName="EventBll">
        <SelectParameters>
            <asp:QueryStringParameter QueryStringField="FacilityId" Name="facilityId" Type="Int32" />
            <asp:QueryStringParameter QueryStringField="AreaId" Name="areaId" Type="Byte" />
            <asp:QueryStringParameter QueryStringField="EntityId" Name="entityId" Type="Byte" />
            <asp:QueryStringParameter QueryStringField="Search" Name="search" Type="String" />
            <asp:QueryStringParameter QueryStringField="EventTypeId" Name="eventTypeId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    
</asp:Content>

