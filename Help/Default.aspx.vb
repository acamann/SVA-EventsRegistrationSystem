
Partial Class FAQ_Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        Select Case Request.QueryString("View")
            Case "CreateAccount"
                rmpHelp.SelectedIndex = 1
            Case "EventList"
                rmpHelp.SelectedIndex = 2
            Case "EventDescription"
                rmpHelp.SelectedIndex = 3
            Case "EventRegistration"
                rmpHelp.SelectedIndex = 4
            Case Else
                rmpHelp.SelectedIndex = 0
        End Select
    End Sub
End Class
