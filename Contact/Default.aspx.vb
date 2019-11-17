
Partial Class Contact_Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        'Set Submit button as default
        Me.Page.Form.DefaultButton = lbSubmit.UniqueID

        Dim eventId As Integer
        If Not Integer.TryParse(Request.QueryString("EventId"), eventId) Then
            hlEventsDetails.Visible = False
        Else
            'Set up the "Back to Event" link
            hlEventsDetails.NavigateUrl = "~/Details/Default.aspx?EventId=" & eventId
            hlEventsDetails.Visible = True
        End If

        If Not IsPostBack Then

            'Auto fill textboxes if user is logged in
            Dim userBll As New UserProfileBll
            Dim user As UserProfileDAL.UserProfileRow
            user = userBll.GetUser()
            If Not user Is Nothing Then
                txtName.Text = user.FirstName & " " & user.LastName
                txtEmail.Text = user.Email
            End If

        End If

    End Sub

    Protected Sub lbSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbSubmit.Click

        Dim contactId As Integer
        Integer.TryParse(Request.QueryString("ContactId"), contactId)

        If EmailHelper.ContactUs( _
                txtName.Text, _
                txtEmail.Text, _
                txtMessage.Text, _
                contactId) Then

            'Successfully e-mailed
            rmpContact.SelectedIndex = 1

        End If

    End Sub

End Class
