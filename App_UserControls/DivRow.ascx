<%@ Control Language="VB" AutoEventWireup="false" CodeFile="DivRow.ascx.vb" Inherits="App_UserControls_DivRow" %>

<div style="clear:both;height:1%;padding:1px;">
    <div style="width:125px;float:left;text-align:right;font-weight:bold;padding:2px;">
        <%=Me.LabelText%>
    </div>
    <asp:Panel ID="pnlContent" runat="server" style="width:auto;float:left;padding:2px;">
    </asp:Panel>
        <%=Me.Content %>
</div>
