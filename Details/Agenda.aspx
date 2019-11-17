<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Agenda.aspx.vb" Inherits="Details_Agenda" title="Untitled Page" %>

<%@ Register Assembly="RadTabStrip.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>
<%@ Register src="../App_UserControls/EventPageHeader.ascx" tagname="EventPageHeader" tagprefix="sva" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
    <asp:HyperLink ID="hlEventsDetails" runat="server"
            CssClass="leftlink"
            NavigateUrl="">
        <img id="Img1" src="~/App_Themes/Events/Images/return.gif" alt="Back" runat="server" />
        Back to Event
    </asp:HyperLink>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    
    <script type="text/javascript">
        function toggle(panelid) {
            var panel = document.getElementById(panelid);
            var current = panel.style.display;
            if (current=='none') {
                panel.style.display = 'block';
            } else {
                panel.style.display = 'none';
            }
        }
    </script>
    
    <sva:EventPageHeader ID="EventPageHeader1" runat="server" SubTitle="Event Agenda" />
        
    <asp:ListView ID="lvEventDay" runat="server"
            DataKeyNames="DayId" DataSourceID="odsEventDays">
        <LayoutTemplate>
            <ul ID="itemPlaceholderContainer" runat="server" class="agenda">
                <span ID="itemPlaceholder" runat="server" />
            </ul>
        </LayoutTemplate>
        <ItemTemplate>
            <%-- Event Day --%>
            <asp:HiddenField ID="hdnDayId" runat="server" Value='<%#Eval("DayId")%>' />
            <li>
                <div class="clearfix eventday" style="height:1%;">
                    <img src="~/App_Themes/Events/Images/title-bullet.gif" 
                        alt="Event Day" runat="server" />
                    <div style="padding:5px;">
                        <%--<div style="font-weight:bold;">
                            <%#Eval("DayNumber", "Day {0}")%>&nbsp;
                        </div>--%>
                        <div style="line-height:35px;">
                            <span style="color:#014377;font-weight:bold;">
                                <%# Eval("StartDate", "{0:D}") %> 
                            </span>
                            (<%# Eval("StartDate", "{0:t}") %> to <%#Eval("EndDate", "{0:t}")%>)                       
                        </div>
                    </div>
                </div>  
            </li>              
            
                <asp:ListView ID="lvSession" runat="server"
                        DataKeyNames="SessionId" DataSourceID="odsSession"
                        OnItemDataBound="lvSession_ItemDataBound">
                    <LayoutTemplate>
                        <ul ID="itemPlaceholderContainer" runat="server" >
                            <span ID="itemPlaceholder" runat="server" />
                        </ul>
                    </LayoutTemplate>
                    <EmptyDataTemplate>
                       <%-- <div style="padding:10px;">
                            This event is not divided into sessions.
                        </div>--%>
                    </EmptyDataTemplate>
                    <ItemTemplate>
                    
                        <%-- Session --%>
                        <asp:HiddenField ID="hdnSessionId" runat="server" Value='<%#Eval("SessionId")%>' />
                        <li class="session">
                            <div class="clearfix" style="height:1%;">
                                <div style="float:left;width:125px;">
                                    <%# Eval("StartDate", "{0:h:mm}") %> - <%#Eval("EndDate", "{0:h:mm}")%> 
                                </div>
                                <div style="color:#0B497A;font-weight:bold;">
                                    <asp:Label ID="lblTitle" runat="server" 
                                        Text='<%# Iif(Eval("Title") is DBNull.Value, Eval("SessionNumber", "Session {0}"), Eval("Title")) %>'>
                                    </asp:Label>
                                </div>
                            </div>
                        
                            <%-- Breakout --%>
                            <asp:ListView ID="lvBreakout" runat="server"
                                    DataKeyNames="BreakoutId" DataSourceID="odsBreakout">
                                <LayoutTemplate>
                                    <ul ID="itemPlaceholderContainer" runat="server">
                                        <span ID="itemPlaceholder" runat="server" />
                                    </ul>
                                </LayoutTemplate>
                                <ItemTemplate>
                                    <li class="breakout">
                                        <asp:LinkButton ID="lbBreakout" runat="server"
                                                OnLoad="lbBreakout_Load"
                                                CommandArgument='<%#Eval("BreakoutId")%>'>
                                            <%#Eval("Title")%>
                                        </asp:LinkButton>
                                        <asp:Panel ID="pnlBreakoutDetails" runat="server" 
                                            CssClass="breakoutdetails" style="display:none;">
                                           
                                            <asp:Panel style="padding:0 8px 8px 0;float:left;" runat="server"
                                                    Visible='<%# Not Eval("PhotoUrl") is DBNull.Value %>'>
                                                <div class="dropshadow">
                                                    <asp:Image ID="imgPhoto" runat="server" 
                                                        ImageUrl='<%#Eval("PhotoUrl", "~/images/Events/Breakouts/{0}")%>'
                                                        style="width:50px;border:solid 1px;padding:4px;" />
                                                </div>
                                            </asp:Panel>
                                            
                                            <%#Eval("Description")%>
                                            
                                            <%#Eval("Location", "<div style='margin-top:5px;'><span style='font-weight:bold;'>Location: </span>{0}</div>")%>
                                            
                                            <div style="margin-top:5px;"><span style="font-weight:bold;">Remaining Seats: </span>
                                                <%#Eval("MaxAttendance") - Eval("Attendance")%>
                                            </div>
                                            
                                        </asp:Panel>
                                        <div style="clear:both;"></div>
                                    </li>                                                
                                    
                                </ItemTemplate>
                            </asp:ListView>
                            
                            <asp:ObjectDataSource ID="odsBreakout" runat="server" 
                                    SelectMethod="GetBreakoutsBySessionId" TypeName="BreakoutBll">
                                <SelectParameters>
                                    <asp:Parameter Name="SessionId" Type="Int32" />
                                </SelectParameters>
                            </asp:ObjectDataSource> 
                             
                        </li>
                    </ItemTemplate>
                </asp:ListView>
            
            <asp:ObjectDataSource ID="odsSession" runat="server" 
                    SelectMethod="GetSessionsByEventDayId" TypeName="SessionBll">
                <SelectParameters>
                    <asp:Parameter Name="DayId" Type="Int32" />
                </SelectParameters>
            </asp:ObjectDataSource>            
            
        </ItemTemplate>
    </asp:ListView>
        
    <asp:ObjectDataSource ID="odsEventDays" runat="server"
            SelectMethod="GetEventDaysByEventId" TypeName="EventDayBll">
        <SelectParameters>
            <asp:QueryStringParameter Name="EventId" QueryStringField="EventId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    
</asp:Content>

