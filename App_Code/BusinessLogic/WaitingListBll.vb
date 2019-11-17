Imports Microsoft.VisualBasic
Imports EventDALTableAdapters
Imports RegistrationDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class WaitingListBll

#Region " Event Waiting List "

    Private _adapter As EventWaitingListTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As EventWaitingListTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New EventWaitingListTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetWaitingList(ByVal eventId As Nullable(Of Integer), ByVal userId As Nullable(Of Guid)) As EventDAL.EventWaitingListDataTable
        Return Adapter.GetWaitingList(eventId, userId)
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Delete, True)> _
    Public Function CancelWait(ByVal eventId As Integer, ByVal userId As Guid) As Boolean
        Return Adapter.Delete(userId, eventId) = 1
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Insert, True)> _
    Public Function InsertWait( _
            ByVal eventId As Integer, _
            ByVal userId As Guid) _
                As Boolean

        Return Adapter.Insert(userId, eventId) = 1
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Update, True)> _
    Public Function DoneWaiting( _
            ByVal eventId As Integer, _
            ByVal userId As Guid) _
                As Boolean

        Return Adapter.Update(userId, eventId) = 1
    End Function

#End Region

#Region " Breakout Waiting List "

    Private _breakoutAdapter As BreakoutWaitingListTableAdapter = Nothing
    Protected ReadOnly Property BreakoutAdapter() As BreakoutWaitingListTableAdapter
        Get
            If _breakoutAdapter Is Nothing Then
                _breakoutAdapter = New BreakoutWaitingListTableAdapter()
            End If

            Return _breakoutAdapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetBreakoutWaitingList(ByVal eventId As Integer) As RegistrationDAL.BreakoutWaitingListDataTable
        Return BreakoutAdapter.GetBreakoutWaitingList(eventId, Nothing)
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetBreakoutWaitingListById(ByVal breakoutId As Integer) As RegistrationDAL.BreakoutWaitingListDataTable
        Return BreakoutAdapter.GetBreakoutWaitingList(Nothing, breakoutId)
    End Function

#End Region

End Class

