
Partial Class App_UserControls_DivRow
    Inherits System.Web.UI.UserControl


    Private _labelText As String
    Public Property LabelText() As String
        Get
            Return _labelText
        End Get
        Set(ByVal value As String)
            _labelText = value
        End Set
    End Property


    Private _content As ITemplate = Nothing
    <TemplateContainer(GetType(ITemplate))> _
    <PersistenceMode(PersistenceMode.InnerProperty)> Public Property Content() As ITemplate
        Get
            Return _content
        End Get
        Set(ByVal value As ITemplate)
            _content = value
        End Set
    End Property


    'Private _content As String
    'Public Property Content() As String
    '    Get
    '        Return _content
    '    End Get
    '    Set(ByVal value As String)
    '        _content = value
    '    End Set
    'End Property


End Class



