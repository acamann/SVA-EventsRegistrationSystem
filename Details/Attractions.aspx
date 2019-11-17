<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Attractions.aspx.vb" Inherits="Details_Attractions" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
    
    <asp:HyperLink ID="hlFacilityDetails" runat="server"
            CssClass="leftlink" Visible="false">
        <img src="~/App_Themes/Events/Images/return.gif" alt="Back" runat="server" />
        Back to Facility
    </asp:HyperLink>

    <asp:HyperLink ID="hlEventDetails" runat="server" 
            CssClass="leftlink" Visible="false">
        <img src="~/App_Themes/Events/Images/return.gif" alt="Back" runat="server" />
        Back to Event
    </asp:HyperLink>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">
    
    <asp:FormView ID="fvArea" runat="server" DataKeyNames="AreaId" 
            DataSourceID="odsArea">
        <ItemTemplate>
            <h1>Area Attractions for <%# Eval("Title") %></h1>
        </ItemTemplate>
    </asp:FormView>
    
    <asp:ObjectDataSource ID="odsArea" runat="server" 
            SelectMethod="GetAreaById"
            TypeName="AreaBll">
        <SelectParameters>
            <asp:QueryStringParameter Name="areaId" QueryStringField="AreaId" Type="Byte" />
        </SelectParameters>
    </asp:ObjectDataSource>
    
    
    
    <asp:ListView ID="lvAttraction" runat="server" DataSourceID="odsAttraction" 
            DataKeyNames="AreaAttractionId">
        <LayoutTemplate>
            
            <div ID="itemPlaceholderContainer" runat="server">
                <span ID="itemPlaceholder" runat="server" />
            </div>
            
        </LayoutTemplate>
        <EmptyDataTemplate>
            <span>No data was returned.</span>
        </EmptyDataTemplate>
        <ItemSeparatorTemplate>
            <div style="border-top:solid 1px #7B97AD;height:0px;margin-top:6px;margin-bottom:6px;"></div>
        </ItemSeparatorTemplate>
        <ItemTemplate>
            
            <div style="height:1%;" class="bodytext clearfix">
            
                <asp:Panel runat="server" ID="pnlPhoto" 
                        style="float:left;padding:6px;padding-right:12px;"
                        Visible='<%# Not Eval("PhotoUrl") Is DBNull.Value %>' >
                    <div class="dropshadow">
                        <asp:Image ID="imgPhoto" runat="server"
                            AlternateText='<%#Eval("Title") %>'
                            ImageUrl='<%#Eval("PhotoUrl", "~/images/Facilities/AreaAttractions/{0}") %>'
                            style="width:150px;border:solid 1px;padding:4px;" />
                    </div>
                </asp:Panel>
                
                <div style="clear:none;padding:6px;">
                
                    <div style="color:#024478; font-size:1.4em; font-weight:bold;">
                        <%#Eval("Title")%>
                    </div>
                    <div style="font-size:1em;padding-bottom:6px;padding-top:3px;">
                        <%# Eval("Description") %>
                    </div>
                    <div style="font-size:0.9em;color:#696E72;" runat="server" visible='<%# Not Eval("NavigateUrl") is DBNull.Value %>'>
                        <%--For more information, visit --%>
                        <asp:HyperLink ID="hlLink" runat="server" 
                                ToolTip='<%#Eval("NavigateUrl")%>'
                                NavigateUrl='<%#Eval("NavigateUrl")%>' Target="_blank">
                            <%#Eval("Title", "{0} Website")%>
                        </asp:HyperLink>
                        <img src="~/App_Themes/Events/Images/external_link.gif" 
                                alt="Opens in new window" runat="server" 
                                Visible='<%#Not Eval("NavigateUrl") is DBnull.Value%>' />
                    </div>

                </div>
            </div>
            
        </ItemTemplate>
        <AlternatingItemTemplate>
            
            <div style="height:1%;" class="bodytext clearfix" >
                
                <asp:Panel runat="server" ID="pnlPhoto" 
                        Visible='<%# Not Eval("PhotoUrl") Is DBNull.Value %>' 
                        style="float:right;padding:6px;padding-left:12px;">
                    <div class="dropshadow">
                        <asp:Image ID="imgPhoto" runat="server"
                            AlternateText='<%#Eval("Title") %>'
                            ImageUrl='<%#Eval("PhotoUrl", "~/images/Facilities/AreaAttractions/{0}") %>'
                            style="width:150px;border:solid 1px;padding:4px;" />
                    </div>
                </asp:Panel>
                                
                <div style="clear:none;padding:6px;text-align:right;">
                    <div style="color:#024478; font-size:1.4em; font-weight:bold;">
                        <%#Eval("Title")%>
                    </div>
                    <div style="font-size:1em;padding-bottom:6px;padding-top:3px;">
                        <%# Eval("Description") %>
                    </div>
                    <div style="font-size:0.9em;color:#696E72;">
                        <%--For more information, visit --%>
                        <asp:HyperLink ID="hlLink" runat="server"
                                NavigateUrl='<%#Eval("NavigateUrl")%>' Target="_blank">
                            <%#Eval("Title", "{0} Website")%>
                        </asp:HyperLink>
                        <img id="Img1" src="~/App_Themes/Events/Images/external_link.gif" 
                                alt="Opens in new window" runat="server" 
                                Visible='<%#Not Eval("NavigateUrl") is DBnull.Value%>' />
                    </div>
                </div>
                

                
            </div>
            
        </AlternatingItemTemplate>
    </asp:ListView>

    <asp:ObjectDataSource ID="odsAttraction" runat="server" 
            SelectMethod="GetAreaAttractions"
            TypeName="AreaBll">
        <SelectParameters>
            <asp:QueryStringParameter Name="areaId" QueryStringField="AreaId" Type="Byte" />
        </SelectParameters>
    </asp:ObjectDataSource>

    
</asp:Content>

