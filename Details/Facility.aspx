<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Facility.aspx.vb" Inherits="Details_Facility" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">

    <asp:FormView ID="fvLocationLeftDetails" runat="server" style="width:100%;">
        <ItemTemplate>
        
             <asp:HyperLink ID="hlWebsite" runat="server"
                    Target="_blank"
                    CssClass="leftlink" 
                    Visible='<%# Not Eval("NavigateUrl") is DBNull.Value %>'
                    NavigateUrl='<%#Eval("NavigateUrl")%>'>
                <img src="~/App_Themes/Events/Images/external_link.gif" alt="Opens in new window" runat="server" /> Website
            </asp:HyperLink>
            
            <asp:LinkButton ID="lbDrivingDirections" runat="server"
                    CssClass="leftlink"
                    Visible='<%# Not Eval("Address") is DBNull.Value %>'
                    CommandArgument='<%# Eval("Address") & " " & Eval("City") & ", " & Eval("State") %>'>
                <img src="~/App_Themes/Events/Images/external_link.gif" alt="Opens in new window" runat="server" /> Driving Directions
            </asp:LinkButton>
            
            <asp:HyperLink ID="hlAreaAttractions" runat="server"
                    Visible='<%# Not Eval("AreaId") is DBNull.Value %>'
                    NavigateUrl='<%# Eval("AreaId", "~/Details/Attractions.aspx?AreaId={0}") %>'
                    CssClass="leftlink"
                    OnLoad="hlAreaAttractions_Load">
                Area Attractions
            </asp:HyperLink>
            
            <%--  Removed for now for simplicity's sake
            
            <asp:HyperLink ID="hlMoreEvents" runat="server"
                    CssClass="leftlink"
                    NavigateUrl='<%#Eval("FacilityId", "~/Default.aspx?FacilityId={0}")%>'>
                More at this Facility
            </asp:HyperLink>--%>
            
            <asp:HyperLink ID="hlEventDetails" runat="server"
                    CssClass="leftlink" Visible="false"
                    OnLoad="hlEventDetails_Load">
                <img id="Img1" src="~/App_Themes/Events/Images/return.gif" alt="Back" runat="server" />
                Back to Event
            </asp:HyperLink>
            
        </ItemTemplate>
    </asp:FormView>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">

    <asp:FormView ID="fvLocationDetails" runat="server"
            DataSourceID="odsFacilityDetails" Width="100%">
        <ItemTemplate>
        
            <asp:Panel ID="pnlImage" runat="server" 
                    Visible='<%# Not Eval("PhotoUrl") is DBNull.Value %>'
                    style="padding:5px;float:right;">
                <div class="dropshadow">
                    <asp:Image ID="imgPhoto" runat="server"
                            ImageUrl='<%# Eval("PhotoUrl", "~/images/Facilities/{0}") %>'
                            AlternateText='<%# Eval("Title") %>'
                            style="padding:4px;border:solid 1px;width:200px;">                            
                    </asp:Image>            
                </div>
            </asp:Panel>
            
            <h1><%#Eval("Title")%></h1>
            
            <div style="padding:5px;margin-bottom:5px;" runat="server"
                    visible='<%# Not Eval("Address") is DBNull.Value %>'>
                <%# Eval("Address") %>
                <br />
                <%# Eval("City") %>, <%# Eval("State") %> <%# Eval("Zip") %>
                <div style="font-weight:bold; color:#09387E;">
                    <%# Eval("Phone") %>
                </div>
            </div>
            
            <asp:HyperLink ID="hlWebsite" runat="server"
                    Target="_blank" CssClass="bodytext"
                    style="color:Blue; padding:5px;margin-bottom:5px;"
                    Visible='<%# Not Eval("NavigateUrl") is DBNull.Value %>'
                    NavigateUrl='<%#Eval("NavigateUrl")%>'>
                Website 
                <img id="Img2" style="border:none;" 
                    src="~/App_Themes/Events/Images/external_link.gif" 
                    alt="Opens in new window" runat="server" />
            </asp:HyperLink>  
                      
            

            <div class="bodytext" runat="server"
                    visible='<%# Not Eval("Description") is DBNull.Value %>'>
                <%#Eval("Description")%>
            </div>
            
            <asp:Panel ID="pnlMap" runat="server" class="formbackground" style="width:425px;margin-bottom:10px;margin-top:10px;" 
                     Visible='<%# Not Eval("EmbeddedMapHTML") is DBNull.Value %>'>
                <%#Eval("EmbeddedMapHTML")%>
            </asp:Panel>
            
        </ItemTemplate>
    </asp:FormView>
    
    <asp:ObjectDataSource ID="odsFacilityDetails" runat="server"
            SelectMethod="GetFacilityById" TypeName="FacilityBll">
        <SelectParameters>
            <asp:QueryStringParameter Name="facilityId" QueryStringField="FacilityId" />
        </SelectParameters>
    </asp:ObjectDataSource>
    
</asp:Content>

