Imports Microsoft.VisualBasic
Imports EmailTemplateDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class EmailBll

    Private _adapter As EmailTemplateTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As EmailTemplateTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New EmailTemplateTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetTemplateByTypeId(ByVal emailTypeId As Byte) As EmailTemplateDAL.EmailTemplateDataTable
        Dim emailTemplates As EmailTemplateDAL.EmailTemplateDataTable
        emailTemplates = Adapter.GetTemplate(Nothing, emailTypeId, False)
        Return emailTemplates
        'If emailTemplates.Rows.Count > 0 Then
        'Return emailTemplates(0)
        'Else
        'Return Nothing
        'End If

    End Function


    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetDefaultTemplateByTypeId(ByVal emailTypeId As Byte) As EmailTemplateDAL.EmailTemplateRow
        Dim emailTemplates As EmailTemplateDAL.EmailTemplateDataTable
        emailTemplates = Adapter.GetTemplate(Nothing, emailTypeId, True)
        If emailTemplates.Rows.Count > 0 Then
            Return emailTemplates(0)
        Else
            Return Nothing
        End If
    End Function


    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetTemplateById(ByVal templateId As Byte) As EmailTemplateDAL.EmailTemplateRow
        Dim emailTemplates As EmailTemplateDAL.EmailTemplateDataTable
        emailTemplates = Adapter.GetTemplate(templateId, Nothing, True)
        If emailTemplates.Rows.Count > 0 Then
            Return emailTemplates(0)
        Else
            Return Nothing
        End If
    End Function

End Class
