Imports Microsoft.VisualBasic
Imports RegistrationDALTableAdapters

Public Class PricingBll

#Region " Pricing "

    Private _adapter As PricingTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As PricingTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New PricingTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    Public Function SelectAllPricing(ByVal eventId As Integer) As RegistrationDAL.PricingDataTable
        Return Adapter.GetPricing(eventId, Nothing)
    End Function

    Public Function SelectCurrentPricing(ByVal eventId As Integer) As RegistrationDAL.PricingDataTable
        Return Adapter.GetPricing(eventId, Now)
    End Function


#End Region

End Class
