
Partial Class App_UserControls_EditProfile
    Inherits System.Web.UI.UserControl


    Protected Sub fvUserProfile_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles fvUserProfile.DataBound
        If fvUserProfile.DataItemCount = 0 Then
            fvUserProfile.ChangeMode(FormViewMode.Insert)
        End If
    End Sub

#Region " Mode Changed Event "

    Public Event ModeChanged(ByVal currentMode As FormViewMode)

    Protected Sub fvUserProfile_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles fvUserProfile.ItemUpdating
        'Dim pnlSpecialAccommodations As Panel = fvUserProfile.FindControl("pnlSpecialAccommodations")

        Dim chkSpecial As CheckBox = fvUserProfile.FindControl("chkSpecial")
        If Not chkSpecial.Checked Then
            e.NewValues("SpecialAccommodations") = Nothing
        End If

    End Sub

    Protected Sub fvUserProfile_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles fvUserProfile.PreRender
        RaiseEvent ModeChanged(fvUserProfile.CurrentMode)
    End Sub

#End Region

    Protected Sub chkSpecial_CheckedChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim chkSpecial As CheckBox = sender
        Dim pnlSpecialAccommodations As Panel = fvUserProfile.FindControl("pnlSpecialAccommodations")
        pnlSpecialAccommodations.Visible = chkSpecial.Checked
    End Sub

End Class
