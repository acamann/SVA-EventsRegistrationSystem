Imports Microsoft.VisualBasic
Imports EventDALTableAdapters

<System.ComponentModel.DataObject()> _
Public Class EventBll

#Region " Full Events Table "

    Private _adapter As EventTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As EventTableAdapter
        Get
            If _adapter Is Nothing Then
                _adapter = New EventTableAdapter()
            End If

            Return _adapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetUpcomingEvents( _
            ByVal facilityId As Nullable(Of Integer), _
            ByVal areaId As Nullable(Of Byte), _
            ByVal eventTypeId As Nullable(Of Integer), _
            ByVal entityId As Nullable(Of Byte), _
            ByVal search As String) _
                As EventDAL.EventDataTable

        'Returns a table of events based on the search/filter values
        Return Adapter.GetEvents(Nothing, search, eventTypeId, facilityId, entityId, Nothing, True, True, False, True, Nothing)
    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetEventById( _
            ByVal eventId As Integer) _
                As EventDAL.EventDataTable

        'Returns the event that matches the eventId (it may or may not be published or cancelled)
        Return Adapter.GetEvents(eventId, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing)
    End Function


    <System.ComponentModel.DataObjectMethodAttribute _
            (System.ComponentModel.DataObjectMethodType.Select, False)> _
        Public Function GetEventsByUserId( _
                ByVal userId As Guid, _
                ByVal isFuture As Boolean) _
                    As EventDAL.EventDataTable

        'Gets a list of events that a user has registered for (either in the future or in the past based on isFuture)
        Return Adapter.GetEvents(Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, isFuture, Nothing, Nothing, Nothing, userId)
    End Function


    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetMyUpcomingEvents() As EventDAL.EventDataTable

        'Grabs the current user and then finds all of their future events
        Dim userId As Guid = UserMethods.GetUserId
        If Not userId = Nothing Then
            Return GetEventsByUserId(userId, True)
        End If
        Return Nothing

    End Function

    <System.ComponentModel.DataObjectMethodAttribute _
        (System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetMyPreviousEvents() As EventDAL.EventDataTable

        'Grabs the current user and then finds all of their previous events
        Dim userId As Guid = UserMethods.GetUserId
        If Not userId = Nothing Then
            Return GetEventsByUserId(userId, False)
        End If
        Return Nothing

    End Function

#End Region





End Class
