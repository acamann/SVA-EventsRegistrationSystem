<%@ Control Language="VB" AutoEventWireup="false" CodeFile="EventPageHeader.ascx.vb" Inherits="App_UserControls_EventPageHeader" %>

<asp:FormView ID="fvEventTitle" runat="server" DataKeyNames="EventId" 
        DataSourceID="odsEvent" style="width:100%;">
    <ItemTemplate>
    
       <div style="text-align:center;margin-bottom:5px;" runat="server" 
                Visible='<%# Not Eval("PhotoUrl") is DBNull.Value %>'>
            <asp:Image ID="imgEvent" runat="server" style="padding:4px;" 
                ImageUrl='<%# Eval("PhotoUrl", "~/images/Events/{0}") %>'
                AlternateText='<%#Eval("Title")%>' Width="550px" />
        </div>         
        <h1 runat="server">
            <%#Eval("Title")%>
        </h1>
        <asp:Literal ID="lblSubTitle" runat="server"></asp:Literal>
        
    </ItemTemplate>
</asp:FormView>

<asp:ObjectDataSource ID="odsEvent" runat="server" 
        SelectMethod="GetEventById" 
        TypeName="EventBll">
    <SelectParameters>
        <asp:Parameter Name="eventId" Type="Int32" />
    </SelectParameters>
</asp:ObjectDataSource>