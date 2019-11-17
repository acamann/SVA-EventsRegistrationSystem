
Partial Class Events
    Inherits System.Web.UI.MasterPage

#Region " Page Config "

    Protected Sub pageConfig()

        'set the page title
        Dim pageTitle As String
        If Not SiteMap.CurrentNode Is Nothing Then
            pageTitle = SiteMap.CurrentNode.Title.ToString
        Else
            pageTitle = "SVA Events"
        End If

        If Not pageTitle = String.Empty Then
            Me.Page.Title = pageTitle
        End If

    End Sub

#End Region

#Region " Page Load "

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'configure the page
        pageConfig()

    End Sub

#End Region

End Class

