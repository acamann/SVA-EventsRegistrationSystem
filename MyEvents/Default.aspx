<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="MyEvents_Default" title="My Events" %>

<%@ Register Assembly="RadTabStrip.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>

<%@ Register assembly="RadGrid.Net2" namespace="Telerik.WebControls" tagprefix="radG" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
    
    <asp:HyperLink ID="hlUpcoming" runat="server" 
            CssClass="leftlink"
            NavigateUrl="Default.aspx?Mode=Upcoming">
        My Upcoming Events
    </asp:HyperLink>
    <asp:HyperLink ID="hlPrevious" runat="server"
            CssClass="leftlink"
            NavigateUrl="Default.aspx?Mode=Previous">
        My Previous Events
    </asp:HyperLink>
    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    
    <h1><asp:Label ID="lblTitle" runat="server" Text="My Events"></asp:Label></h1>
    
    <asp:ListView ID="lvEvents" runat="server" 
            DataKeyNames="EventId">
        <LayoutTemplate>
            
            <div class="bodytext clearfix datapager" >
                <%--<div style="float:left">
                    Sort by:
                    <asp:LinkButton runat="server" ID="lbTitleSort" CommandName="Sort"
                     CommandArgument="Title">Title</asp:LinkButton>,
                    <asp:LinkButton runat="server" ID="lbDateSort" CommandName="Sort"
                     CommandArgument="Date">Date</asp:LinkButton>

                </div>--%>
            
                <asp:DataPager ID="DataPager2" runat="server">
                    <Fields>
                        <asp:TemplatePagerField>
                            <PagerTemplate>
                                <span style="display:block;float:right;">
                                    Results 
                                    <strong>
                                        <%#Container.StartRowIndex + 1%>
                                    </strong>
                                    -
                                    <strong>
                                        <%#IIf(Container.TotalRowCount > Container.MaximumRows, _
                                                IIf(Container.StartRowIndex + Container.MaximumRows > Container.TotalRowCount, _
                                                    Container.TotalRowCount, _
                                                    Container.StartRowIndex + Container.MaximumRows), _
                                                Container.TotalRowCount)%>
                                    </strong>
                                    of
                                    <strong>
                                        <%# Container.TotalRowCount%>
                                    </strong>
                                </span>
                            </PagerTemplate>
                        </asp:TemplatePagerField>
                    </Fields>
                </asp:DataPager>
            </div>
            
            <div class="bodytext eventlist" id="itemPlaceholderContainer" runat="server">
                <span id="itemPlaceholder" runat="server"></span>
            </div>
            
            <div class="bodytext datapager">
                <asp:DataPager ID="DataPager1" runat="server" PageSize="5">
                    <Fields>
                        <asp:NumericPagerField ButtonCount="10" NextPageText="..." PreviousPageText="..." />
                    </Fields>
                </asp:DataPager>
            </div>
            
        </LayoutTemplate>
        <EmptyDataTemplate>
            <asp:Label ID="lblEmpty" runat="server" Text="You are not registered for any future events."></asp:Label>            
        </EmptyDataTemplate>
        <ItemSeparatorTemplate>
            <div class="separator"></div>
        </ItemSeparatorTemplate>
        <ItemTemplate>
            <asp:HyperLink ID="HyperLink1" runat="server"
                    CssClass="event"
                    NavigateUrl='<%# Eval("EventId", "~/Details/Default.aspx?EventId={0}") %>'>
                
                <span class="title"><%#Eval("Title")%></span>
                    
                <span class="infobar clearfix">
                    <span class="left">
                        <span class="date"><%#Eval("Date", "{0:ddd, MMM d, yyyy}")%></span>
                        <span class="type"><%#Eval("Type")%></span>
                    </span>
                    <span class="middle">
                        <span class="facility"><%#Eval("FacilityName")%></span>
                        <span class="location"><%#Eval("Location")%></span>
                    </span>
                </span>
                
            </asp:HyperLink>

        </ItemTemplate>
    </asp:ListView>
                
    <asp:ObjectDataSource ID="odsUpcomingEvents" runat="server" 
            SelectMethod="GetMyUpcomingEvents" 
            TypeName="EventBll">
        <SelectParameters>
        </SelectParameters>
    </asp:ObjectDataSource>
    
    <asp:ObjectDataSource ID="odsPreviousEvents" runat="server" 
            SelectMethod="GetMyPreviousEvents" 
            TypeName="EventBll">
        <SelectParameters>
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>

