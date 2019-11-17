<%@ Control Language="VB" AutoEventWireup="false" CodeFile="EditProfile.ascx.vb" Inherits="App_UserControls_EditProfile" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Assembly="RadInput.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>
<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="RadTabStrip.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>

<asp:FormView ID="fvUserProfile" runat="server" 
        DataSourceID="odsUserProfile" Width="100%">
    <ItemTemplate>
        <div class="bodytext">
            <div style="padding:5px;">
                Please verify that the following information is accurate.
            </div>
            <div style="padding:5px;"></div>
            <div class="row">
                <div class="left">
                    Name:
                </div>
                <div class="right">
                    <%#Eval("FirstName")%> <%#Eval("LastName")%>
                </div>
            </div>
            <div class="row">
                <div class="left">
                   Email/Login:
                </div>
                <div class="right">
                    <%#Eval("Email")%>
                </div>
            </div>
            <div class="row">
                <div class="left">
                    Phone:
                </div>
                <div class="right">
                    <%#Eval("Phone")%>
                </div>
            </div>
            <div class="row">
                <div class="left">
                    Address:
                </div>
                <div class="right">
                    <%#Eval("Address", "{0}<br />")%>
                    <%#Eval("Address2", "{0}<br />")%>
                    <%#Eval("City")%>, <%#Eval("State")%> <%#Eval("Zip")%><br />
                    <%#Eval("Country")%>                                    
                </div>
            </div>
            <div class="row">
                <div class="left">
                    Company:
                </div>
                <div class="right">
                    <%#Eval("Company")%>
                </div>
            </div>
            <div class="row">
                <div class="left">
                    Title:
                </div>
                <div class="right">
                    <%#Eval("Title")%>
                </div>
            </div>
            <div class="row">
                <div class="left">
                    Special Accom.:
                </div>
                <div class="right">
                    <%#Eval("SpecialAccommodations")%>
                </div>
            </div>
            <div class="row">
                <div class="left">
                </div>
                <div class="right">
                    <asp:LinkButton ID="lbEditContact" runat="server" CommandName="Edit">
                        Edit
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </ItemTemplate>
    <EditItemTemplate>
        <div class="bodytext">
            <div class="row">
                <div class="left">
                    * First:
                </div>
                <div class="right">
                    <asp:TextBox ID="txtFirstName" runat="server" Columns="25" MaxLength="50" 
                        Text='<%#Bind("FirstName") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="txtFirstName" ErrorMessage="*" />
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Last:
                </div>
                <div class="right">
                    <asp:TextBox ID="txtLastName" runat="server" Columns="25" MaxLength="50" 
                        Text='<%#Bind("LastName") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                        ControlToValidate="txtLastName" ErrorMessage="*" />
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Email/Login:
                </div>
                <div class="right">
                    <asp:TextBox ID="txtEmail" runat="server" Columns="35" MaxLength="256" 
                        Text='<%#Bind("Email") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ControlToValidate="txtEmail" ErrorMessage="*" />
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Phone:
                </div>
                <div class="right">
                    <rad:RadMaskedTextBox ID="rmtbPhone" runat="server" 
                        Mask="(###) ###-####" DisplayMask="(###) ###-####" 
                        Text='<%#Bind("Phone")%>'>
                    </rad:RadMaskedTextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" 
                        ControlToValidate="rmtbPhone" ErrorMessage="*" />
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Address:
                </div>
                <div class="right">
                    <asp:TextBox ID="txtAddress1" runat="server" Columns="35" MaxLength="100" 
                        Text='<%#Bind("Address") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                        ControlToValidate="txtAddress1" ErrorMessage="*" />
                    <br />
                    <asp:TextBox ID="txtAddress2" runat="server" Columns="35" MaxLength="100" 
                        Text='<%#Bind("Address2") %>' />                                
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * City:
                </div>
                <div class="right">
                    <asp:TextBox ID="txtCity" runat="server" Columns="20" MaxLength="50" 
                        Text='<%#Bind("City") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" 
                        ControlToValidate="txtCity" ErrorMessage="*" />           
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * State:
                </div>
                <div class="right">
                    <rad:RadComboBox ID="rcbState" runat="server" 
                            SelectedValue='<%#Bind("State")%>' 
                            SelectOnTab="true" MarkFirstMatch="true"
                            Height="150">
                        <Items>
                            <rad:RadComboBoxItem Value="" Selected="true" Text="" />
                            <rad:RadComboBoxItem Value="AL" Text="Alabama" />
                            <rad:RadComboBoxItem Value="AK" Text="Alaska" />
                            <rad:RadComboBoxItem Value="AZ" Text="Arizona" />
                            <rad:RadComboBoxItem Value="AR" Text="Arkansas" />
                            <rad:RadComboBoxItem Value="CA" Text="California" />
                            <rad:RadComboBoxItem Value="CO" Text="Colorado" />
                            <rad:RadComboBoxItem Value="CT" Text="Connecticut" />
                            <rad:RadComboBoxItem Value="DC" Text="District of Columbia" />
                            <rad:RadComboBoxItem Value="DE" Text="Delaware" />
                            <rad:RadComboBoxItem Value="FL" Text="Florida" />
                            <rad:RadComboBoxItem Value="GA" Text="Georgia" />
                            <rad:RadComboBoxItem Value="HI" Text="Hawaii" />
                            <rad:RadComboBoxItem Value="ID" Text="Idaho" />
                            <rad:RadComboBoxItem Value="IL" Text="Illinois" />
                            <rad:RadComboBoxItem Value="IN" Text="Indiana" />
                            <rad:RadComboBoxItem Value="IA" Text="Iowa" />
                            <rad:RadComboBoxItem Value="KS" Text="Kansas" />
                            <rad:RadComboBoxItem Value="KY" Text="Kentucky" />
                            <rad:RadComboBoxItem Value="LA" Text="Louisiana" />
                            <rad:RadComboBoxItem Value="ME" Text="Maine" />
                            <rad:RadComboBoxItem Value="MD" Text="Maryland" />
                            <rad:RadComboBoxItem Value="MA" Text="Massachusetts" />
                            <rad:RadComboBoxItem Value="MI" Text="Michigan" />
                            <rad:RadComboBoxItem Value="MN" Text="Minnesota" />
                            <rad:RadComboBoxItem Value="MS" Text="Mississippi" />
                            <rad:RadComboBoxItem Value="MO" Text="Missouri" />
                            <rad:RadComboBoxItem Value="MT" Text="Montana" />
                            <rad:RadComboBoxItem Value="NE" Text="Nebraska" />
                            <rad:RadComboBoxItem Value="NV" Text="Nevada" />
                            <rad:RadComboBoxItem Value="NH" Text="New Hampshire" />
                            <rad:RadComboBoxItem Value="NJ" Text="New Jersey" />
                            <rad:RadComboBoxItem Value="NM" Text="New Mexico" />
                            <rad:RadComboBoxItem Value="NY" Text="New York" />
                            <rad:RadComboBoxItem Value="NC" Text="North Carolina" />
                            <rad:RadComboBoxItem Value="ND" Text="North Dakota" />
                            <rad:RadComboBoxItem Value="OH" Text="Ohio" />
                            <rad:RadComboBoxItem Value="OK" Text="Oklahoma" />
                            <rad:RadComboBoxItem Value="OR" Text="Oregon" />
                            <rad:RadComboBoxItem Value="PA" Text="Pennsylvania" />
                            <rad:RadComboBoxItem Value="RI" Text="Rhode Island" />
                            <rad:RadComboBoxItem Value="SC" Text="South Carolina" />
                            <rad:RadComboBoxItem Value="SD" Text="South Dakota" />
                            <rad:RadComboBoxItem Value="TN" Text="Tennessee" />
                            <rad:RadComboBoxItem Value="TX" Text="Texas" />
                            <rad:RadComboBoxItem Value="UT" Text="Utah" />
                            <rad:RadComboBoxItem Value="VT" Text="Vermont" />
                            <rad:RadComboBoxItem Value="VA" Text="Virginia" />
                            <rad:RadComboBoxItem Value="WA" Text="Washington" />
                            <rad:RadComboBoxItem Value="WV" Text="West Virginia" />
                            <rad:RadComboBoxItem Value="WI" Text="Wisconsin" />
                            <rad:RadComboBoxItem Value="WY" Text="Wyoming" />
                            <rad:RadComboBoxItem Value="AB" Text="Alberta" />
                            <rad:RadComboBoxItem Value="BC" Text="British Columbia" />
                            <rad:RadComboBoxItem Value="MB" Text="Manitoba" />
                            <rad:RadComboBoxItem Value="NB" Text="New Brunswick" />
                            <rad:RadComboBoxItem Value="NL" Text="Newfoundland and Labrador" />
                            <rad:RadComboBoxItem Value="NT" Text="Northwest Territories" />
                            <rad:RadComboBoxItem Value="NS" Text="Nova Scotia" />
                            <rad:RadComboBoxItem Value="NU" Text="Nunavut" />
                            <rad:RadComboBoxItem Value="ON" Text="Ontario" />
                            <rad:RadComboBoxItem Value="PE" Text="Prince Edward Island" />
                            <rad:RadComboBoxItem Value="QC" Text="Quebec" />
                            <rad:RadComboBoxItem Value="SK" Text="Saskatchewan" />
                            <rad:RadComboBoxItem Value="YT" Text="Yukon" />
                        </Items>
                    </rad:RadComboBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" 
                        ControlToValidate="rcbState" ErrorMessage="*" InitialValue="" />          
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Zip:
                </div>
                <div class="right">
                     <asp:TextBox ID="txtZip" runat="server" Columns="10" MaxLength="10" 
                        Text='<%#Bind("Zip") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" 
                        ControlToValidate="txtZip" ErrorMessage="*" />          
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Country:
                </div>
                <div class="right">
                    <rad:RadComboBox ID="rcbCountry" runat="server" 
                            SelectedValue='<%#Bind("Country")%>'>
                        <Items>
                            <rad:RadComboBoxItem Text="United States" Value="USA" />
                            <rad:RadComboBoxItem Text="Other" Value="Other" />
                        </Items>
                    </rad:RadComboBox>     
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Company:
                </div>
                <div class="right">
                    <asp:TextBox ID="txtCompany" runat="server" Columns="35" MaxLength="100" 
                        Text='<%#Bind("Company") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                        ControlToValidate="txtCompany" ErrorMessage="*" />
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Title:
                </div>
                <div class="right">
                    <asp:TextBox ID="txtTitle" runat="server" Columns="35" MaxLength="50" 
                        Text='<%#Bind("Title") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                        ControlToValidate="txtTitle" ErrorMessage="*" />
                </div>
            </div>
            
             <radA:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
                <div class="row">
                    <div class="left"></div>
                    <div class="right">
                        <asp:CheckBox ID="chkSpecial" AutoPostBack="true" 
                            OnCheckedChanged="chkSpecial_CheckedChanged" runat="server"
                            Checked='<%# Not Eval("SpecialAccommodations") is Nothing %>' />
                        I require special accommodations
                    </div>
                </div>
                <asp:Panel ID="pnlSpecialAccommodations" runat="server" CssClass="row" 
                        Visible='<%# Not Eval("SpecialAccommodations") is Nothing %>'>
                    <div class="left">
                        Special Accom.:
                    </div>
                    <div class="right">
                        <asp:TextBox ID="txtSpecialAccommodations" runat="server" Columns="35" 
                            MaxLength="250" Rows="3" Text='<%#Bind("SpecialAccommodations") %>' 
                            TextMode="MultiLine" />
                    </div>
                </asp:Panel>
            </radA:RadAjaxPanel>
            
            <div class="row">
                <div class="left">
                </div>
                <div class="right">
                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel">
                    </asp:LinkButton>
                    &nbsp;
                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="true" CommandName="Update" Text="Save">
                    </asp:LinkButton>
                </div>
            </div>
        </div>

    </EditItemTemplate>
    <InsertItemTemplate>
        <div class="bodytext">
            <div style="padding:5px;">
                To continue, please supply the following information.
            </div>
            <div style="padding:5px;"></div>
            <div class="row">
                <div class="left">
                    * First:
                </div>
                <div class="right">
                    <asp:TextBox ID="txtFirstName" runat="server" Columns="25" MaxLength="50" 
                        Text='<%#Bind("FirstName") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="txtFirstName" ErrorMessage="*" />
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Last:
                </div>
                <div class="right">
                    <asp:TextBox ID="txtLastName" runat="server" Columns="25" MaxLength="50" 
                        Text='<%#Bind("LastName") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                        ControlToValidate="txtLastName" ErrorMessage="*" />
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Phone:
                </div>
                <div class="right">
                    <rad:RadMaskedTextBox ID="rmtbPhone" runat="server" 
                        Mask="(###) ###-####" DisplayMask="(###) ###-####" Text='<%#Bind("Phone")%>'>
                    </rad:RadMaskedTextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" 
                        ControlToValidate="rmtbPhone" ErrorMessage="*" />
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Address:
                </div>
                <div class="right">
                    <asp:TextBox ID="txtAddress1" runat="server" Columns="35" MaxLength="100" 
                        Text='<%#Bind("Address") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                        ControlToValidate="txtAddress1" ErrorMessage="*" />
                    <br />
                    <asp:TextBox ID="txtAddress2" runat="server" Columns="35" MaxLength="100" 
                        Text='<%#Bind("Address2") %>' />                                
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * City:
                </div>
                <div class="right">
                    <asp:TextBox ID="txtCity" runat="server" Columns="20" MaxLength="50" 
                        Text='<%#Bind("City") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" 
                        ControlToValidate="txtCity" ErrorMessage="*" />           
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * State:
                </div>
                <div class="right">
                    <rad:RadComboBox ID="rcbState" runat="server" SelectOnTab="true" MarkFirstMatch="true" 
                            SelectedValue='<%#Bind("State")%>' Height="150">
                        <Items>
                            <rad:RadComboBoxItem Value="" Selected="true" Text="" />
                            <rad:RadComboBoxItem Value="AL" Text="Alabama" />
                            <rad:RadComboBoxItem Value="AK" Text="Alaska" />
                            <rad:RadComboBoxItem Value="AZ" Text="Arizona" />
                            <rad:RadComboBoxItem Value="AR" Text="Arkansas" />
                            <rad:RadComboBoxItem Value="CA" Text="California" />
                            <rad:RadComboBoxItem Value="CO" Text="Colorado" />
                            <rad:RadComboBoxItem Value="CT" Text="Connecticut" />
                            <rad:RadComboBoxItem Value="DC" Text="District of Columbia" />
                            <rad:RadComboBoxItem Value="DE" Text="Delaware" />
                            <rad:RadComboBoxItem Value="FL" Text="Florida" />
                            <rad:RadComboBoxItem Value="GA" Text="Georgia" />
                            <rad:RadComboBoxItem Value="HI" Text="Hawaii" />
                            <rad:RadComboBoxItem Value="ID" Text="Idaho" />
                            <rad:RadComboBoxItem Value="IL" Text="Illinois" />
                            <rad:RadComboBoxItem Value="IN" Text="Indiana" />
                            <rad:RadComboBoxItem Value="IA" Text="Iowa" />
                            <rad:RadComboBoxItem Value="KS" Text="Kansas" />
                            <rad:RadComboBoxItem Value="KY" Text="Kentucky" />
                            <rad:RadComboBoxItem Value="LA" Text="Louisiana" />
                            <rad:RadComboBoxItem Value="ME" Text="Maine" />
                            <rad:RadComboBoxItem Value="MD" Text="Maryland" />
                            <rad:RadComboBoxItem Value="MA" Text="Massachusetts" />
                            <rad:RadComboBoxItem Value="MI" Text="Michigan" />
                            <rad:RadComboBoxItem Value="MN" Text="Minnesota" />
                            <rad:RadComboBoxItem Value="MS" Text="Mississippi" />
                            <rad:RadComboBoxItem Value="MO" Text="Missouri" />
                            <rad:RadComboBoxItem Value="MT" Text="Montana" />
                            <rad:RadComboBoxItem Value="NE" Text="Nebraska" />
                            <rad:RadComboBoxItem Value="NV" Text="Nevada" />
                            <rad:RadComboBoxItem Value="NH" Text="New Hampshire" />
                            <rad:RadComboBoxItem Value="NJ" Text="New Jersey" />
                            <rad:RadComboBoxItem Value="NM" Text="New Mexico" />
                            <rad:RadComboBoxItem Value="NY" Text="New York" />
                            <rad:RadComboBoxItem Value="NC" Text="North Carolina" />
                            <rad:RadComboBoxItem Value="ND" Text="North Dakota" />
                            <rad:RadComboBoxItem Value="OH" Text="Ohio" />
                            <rad:RadComboBoxItem Value="OK" Text="Oklahoma" />
                            <rad:RadComboBoxItem Value="OR" Text="Oregon" />
                            <rad:RadComboBoxItem Value="PA" Text="Pennsylvania" />
                            <rad:RadComboBoxItem Value="RI" Text="Rhode Island" />
                            <rad:RadComboBoxItem Value="SC" Text="South Carolina" />
                            <rad:RadComboBoxItem Value="SD" Text="South Dakota" />
                            <rad:RadComboBoxItem Value="TN" Text="Tennessee" />
                            <rad:RadComboBoxItem Value="TX" Text="Texas" />
                            <rad:RadComboBoxItem Value="UT" Text="Utah" />
                            <rad:RadComboBoxItem Value="VT" Text="Vermont" />
                            <rad:RadComboBoxItem Value="VA" Text="Virginia" />
                            <rad:RadComboBoxItem Value="WA" Text="Washington" />
                            <rad:RadComboBoxItem Value="WV" Text="West Virginia" />
                            <rad:RadComboBoxItem Value="WI" Text="Wisconsin" />
                            <rad:RadComboBoxItem Value="WY" Text="Wyoming" />
                            <rad:RadComboBoxItem Value="AB" Text="Alberta" />
                            <rad:RadComboBoxItem Value="BC" Text="British Columbia" />
                            <rad:RadComboBoxItem Value="MB" Text="Manitoba" />
                            <rad:RadComboBoxItem Value="NB" Text="New Brunswick" />
                            <rad:RadComboBoxItem Value="NL" Text="Newfoundland and Labrador" />
                            <rad:RadComboBoxItem Value="NT" Text="Northwest Territories" />
                            <rad:RadComboBoxItem Value="NS" Text="Nova Scotia" />
                            <rad:RadComboBoxItem Value="NU" Text="Nunavut" />
                            <rad:RadComboBoxItem Value="ON" Text="Ontario" />
                            <rad:RadComboBoxItem Value="PE" Text="Prince Edward Island" />
                            <rad:RadComboBoxItem Value="QC" Text="Quebec" />
                            <rad:RadComboBoxItem Value="SK" Text="Saskatchewan" />
                            <rad:RadComboBoxItem Value="YT" Text="Yukon" />
                        </Items>
                    </rad:RadComboBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" 
                        ControlToValidate="rcbState" ErrorMessage="*" InitialValue="" />          
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Zip:
                </div>
                <div class="right">
                     <asp:TextBox ID="txtZip" runat="server" Columns="10" MaxLength="10" 
                        Text='<%#Bind("Zip") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" 
                        ControlToValidate="txtZip" ErrorMessage="*" />          
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Country:
                </div>
                <div class="right">
                     <rad:RadComboBox ID="rcbCountry" runat="server" 
                            SelectedValue='<%#Bind("Country")%>'>
                        <Items>
                            <rad:RadComboBoxItem Text="United States" Value="USA" />
                            <rad:RadComboBoxItem Text="Other" Value="Other" />
                        </Items>
                    </rad:RadComboBox>       
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Company:
                </div>
                <div class="right">
                    <asp:TextBox ID="txtCompany" runat="server" Columns="35" MaxLength="100" 
                        Text='<%#Bind("Company") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                        ControlToValidate="txtCompany" ErrorMessage="*" />
                </div>
            </div>
            <div class="row">
                <div class="left">
                    * Title:
                </div>
                <div class="right">
                    <asp:TextBox ID="txtTitle" runat="server" Columns="35" MaxLength="50" 
                        Text='<%#Bind("Title") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                        ControlToValidate="txtTitle" ErrorMessage="*" />
                </div>
            </div>
            
            <radA:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
                <div class="row">
                    <div class="left"></div>
                    <div class="right">
                        <asp:CheckBox ID="chkSpecial" AutoPostBack="true" 
                            OnCheckedChanged="chkSpecial_CheckedChanged" runat="server"
                            Checked='<%# Not Eval("SpecialAccommodations") is Nothing %>' />
                        I require special accommodations
                    </div>
                </div>
                <asp:Panel ID="pnlSpecialAccommodations" runat="server" CssClass="row" 
                        Visible='<%# Not Eval("SpecialAccommodations") is Nothing %>'>
                    <div class="left">
                        Special Accom.:
                    </div>
                    <div class="right">
                        <asp:TextBox ID="txtSpecialAccommodations" runat="server" Columns="35" 
                            MaxLength="250" Rows="3" Text='<%#Bind("SpecialAccommodations") %>' 
                            TextMode="MultiLine" />
                    </div>
                </asp:Panel>
            </radA:RadAjaxPanel>
            
            <div class="row">
                <div class="left">
                </div>
                <div class="right">
                    <asp:LinkButton ID="lbUpdateContact" runat="server" CausesValidation="true" CommandName="Insert">
                        Save
                    </asp:LinkButton>
                </div>
            </div>
        </div>
        
        
    </InsertItemTemplate>
</asp:FormView>

<asp:ObjectDataSource ID="odsUserProfile" runat="server" 
        InsertMethod="InsertUserProfile" SelectMethod="GetUser" 
        TypeName="UserProfileBll" UpdateMethod="UpdateUserProfile">
    <InsertParameters>
        <asp:Parameter Name="firstName" Type="String" />
        <asp:Parameter Name="lastName" Type="String" />
        <asp:Parameter Name="company" Type="String" />
        <asp:Parameter Name="title" Type="String" />
        <asp:Parameter Name="address" Type="String" />
        <asp:Parameter Name="address2" Type="String" />
        <asp:Parameter Name="city" Type="String" />
        <asp:Parameter Name="state" Type="String" />
        <asp:Parameter Name="zip" Type="String" />
        <asp:Parameter Name="country" Type="String" />
        <asp:Parameter Name="phone" Type="String" />
        <asp:Parameter Name="specialAccommodations" Type="String" />
    </InsertParameters>
    <UpdateParameters>
        <asp:Parameter Name="firstName" Type="String" />
        <asp:Parameter Name="lastName" Type="String" />
        <asp:Parameter Name="email" Type="String" />
        <asp:Parameter Name="company" Type="String" />
        <asp:Parameter Name="title" Type="String" />
        <asp:Parameter Name="address" Type="String" />
        <asp:Parameter Name="address2" Type="String" />
        <asp:Parameter Name="city" Type="String" />
        <asp:Parameter Name="state" Type="String" />
        <asp:Parameter Name="zip" Type="String" />
        <asp:Parameter Name="country" Type="String" />
        <asp:Parameter Name="phone" Type="String" />
        <asp:Parameter Name="specialAccommodations" Type="String" />
    </UpdateParameters>
</asp:ObjectDataSource>
