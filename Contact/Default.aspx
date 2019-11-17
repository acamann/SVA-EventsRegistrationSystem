<%@ Page Language="VB" MasterPageFile="~/Events.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="Contact_Default" title="Untitled Page" %>

<%@ Register Assembly="RadTabStrip.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>

<%@ Register Assembly="RadSpell.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>

<%@ Register Assembly="RadEditor.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" Runat="Server">
    <asp:HyperLink ID="hlEventsDetails" runat="server"
            CssClass="leftlink"
            NavigateUrl="">
        <img id="Img1" src="~/App_Themes/Events/Images/return.gif" alt="Back" runat="server" />
        Back to Event
    </asp:HyperLink>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCenterCol" Runat="Server">

    <h1>Contact Us</h1>
    
    <rad:RadMultiPage ID="rmpContact" runat="server" SelectedIndex="0">
        <rad:PageView ID="pageForm" runat="server">
            
            <div class="bodytext">
                <div class="row clearfix">
                    <div class="left">Name:</div>
                    <div class="right">
                        <asp:TextBox ID="txtName" runat="server" Columns="30"></asp:TextBox>
                    </div>
                </div>

                <div class="row clearfix">
                    <div class="left">Email:</div>
                    <div class="right">
                        <asp:TextBox ID="txtEmail" runat="server" Columns="30"></asp:TextBox>
                    </div>
                </div>

                <div class="row clearfix">
                    <div class="left">Message:</div>
                    <div class="right">
                        <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" Columns="40"></asp:TextBox>
                    </div>
                </div>
                
                <div class="row clearfix">
                    <div class="left"></div>
                    <div class="right">
                        <asp:LinkButton ID="lbSubmit" runat="server" CssClass="formyellowbutton">Send</asp:LinkButton>
                    </div>
                </div>
            
            </div>
    
        </rad:PageView>
        <rad:PageView ID="pageSuccess" runat="server">
            Your message was successfully sent.
        </rad:PageView>
    </rad:RadMultiPage>
    
</asp:Content>

