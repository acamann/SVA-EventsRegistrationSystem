Imports Microsoft.VisualBasic
Imports RegistrationDALTableAdapters
Imports EventDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class BreakoutBll

#Region " Breakout Receipt "

    Private _receiptAdapter As BreakoutReceiptTableAdapter = Nothing
    Protected ReadOnly Property ReceiptAdapter() As BreakoutReceiptTableAdapter
        Get
            If _receiptAdapter Is Nothing Then
                _receiptAdapter = New BreakoutReceiptTableAdapter()
            End If

            Return _receiptAdapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetBreakoutRegistration(ByVal sessionId As Integer, ByVal registrationId As Integer) As RegistrationDAL.BreakoutReceiptDataTable
        Return ReceiptAdapter.GetBreakoutReceipt(sessionId, registrationId)
    End Function

#End Region

#Region " Breakout "

    Private _adapter As BreakoutTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As BreakoutTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New BreakoutTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetBreakoutsBySessionId(ByVal sessionId As Integer) As EventDAL.BreakoutDataTable
        Return Adapter.GetBreakouts(sessionId, Nothing, Nothing)
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetBreakoutsByEventId(ByVal eventId As Integer) As EventDAL.BreakoutDataTable
        Return Adapter.GetBreakouts(Nothing, eventId, Nothing)
    End Function


    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetBreakoutById(ByVal breakoutId As Integer) As EventDAL.BreakoutDataTable
        Return Adapter.GetBreakouts(Nothing, Nothing, breakoutId)
    End Function

#End Region

#Region " Breakout Registration "

    Private _regAdapter As QueryTableAdapter = Nothing
    Protected ReadOnly Property RegAdapter() As QueryTableAdapter
        Get
            If _regAdapter Is Nothing Then
                _regAdapter = New QueryTableAdapter()
            End If

            Return _regAdapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Insert, False)> _
    Public Function BreakoutRegister(ByVal registrationId As Integer, ByVal breakoutId As Integer) As Boolean
        Return RegAdapter.BreakoutRegister(registrationId, breakoutId) = 1
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Insert, False)> _
    Public Function BreakoutUnRegister(ByVal registrationId As Integer, ByVal breakoutId As Integer) As Boolean
        Return RegAdapter.BreakoutUnRegister(registrationId, breakoutId) = 1
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Insert, False)> _
    Public Function BreakoutJoinWaitingList(ByVal registrationId As Integer, ByVal breakoutId As Integer) As Boolean
        Return RegAdapter.BreakoutJoinWaitingList(registrationId, breakoutId) = 1
    End Function


#End Region

End Class
