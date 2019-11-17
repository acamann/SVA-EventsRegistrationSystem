
Partial Class App_UserControls_EventPageHeader
    Inherits System.Web.UI.UserControl

    Public Property EventId() As Nullable(Of Integer)
        Get
            Return odsEvent.SelectParameters("EventId").DefaultValue
        End Get
        Set(ByVal value As Nullable(Of Integer))
            If value.HasValue Then
                odsEvent.SelectParameters("EventId").DefaultValue = value
            Else
                odsEvent.SelectParameters("EventId").DefaultValue = Nothing
            End If
        End Set
    End Property

    Private _subtitle As String
    Public Property SubTitle() As String
        Get
            Return _subtitle
        End Get
        Set(ByVal value As String)
            _subtitle = value
        End Set
    End Property

    Protected Sub fvEventTitle_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles fvEventTitle.DataBound
        If fvEventTitle.DataItemCount > 0 Then
            If Not String.IsNullOrEmpty(SubTitle) Then
                Dim lblSubTitle As Literal = DirectCast(fvEventTitle.FindControl("lblSubTitle"), Literal)
                lblSubTitle.Text = "<h2>" & SubTitle & "</h2>"
            End If
        End If
    End Sub

End Class
