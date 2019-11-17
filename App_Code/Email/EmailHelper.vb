Imports Microsoft.VisualBasic
Imports System.Net.Mail

'Automatic Emails as a result of registration
Public Class EmailHelper

#Region " Email Types "

#Region "    Contact Us "

    'Send a contact e-mail to SVA
    Public Shared Function ContactUs(ByVal fromName As String, ByVal fromEmail As String, ByVal message As String, ByVal contactId As Nullable(Of Integer)) As Boolean

        'Get the contact that we need to email
        Dim contactBll As New ContactBll
        Dim toEmail As String = contactBll.GetContactToEmail(contactId)

        Try
            Dim smtp As New SmtpClient
            smtp.Send("no-reply@sva.com", toEmail, "Events System - Contact Us", "Events System Message from " & fromEmail & ": " & message)
        Catch ex As Exception
            'If it doesn't work, save the exception and display a message
            ExceptionHandler.Thrown(ex)
            Tools.ErrorMessage("There was a problem sending the 'Contact Us' e-mail.", False)
            Return False
        End Try

        Return True

    End Function

#End Region

#Region "    Invitation from Registrant to a friend "

    'Sends an event invitation for someone added as an invitee during registration
    Public Shared Function EmailInvitation(ByVal toEmail As String, ByVal toName As String, ByVal registrationId As Integer) As Boolean

        Dim emailBll As New EmailBll

        'EmailTypeId=4 > User Invitation
        'TODO: Maybe we want a different e-mail template for each event?
        Dim template As EmailTemplateDAL.EmailTemplateRow = emailBll.GetDefaultTemplateByTypeId(4)
        If Not template Is Nothing Then

            'If the template exists, replace any variables with event specific information
            Dim messageHtml As String
            messageHtml = RenderRegistrationTags(template.TemplateHtml, registrationId)

            Dim mailMessage As New MailMessage
            mailMessage.To.Add(New MailAddress(toEmail, toName))
            mailMessage.From = New MailAddress("noreply@sva.com", "SVA Events")
            mailMessage.IsBodyHtml = True
            mailMessage.Subject = template.EmailSubject
            mailMessage.Body = messageHtml

            Dim smtp As New SmtpClient
            smtp.Send(mailMessage)

        Else

            'There wasn't one, so save and send the error, but continue anyway
            ExceptionHandler.Thrown(New Exception("Couldn't find an email template to send an invite from within the registration.  No e-mail was sent, but the user's experience went on smoothly. (ToEmail=" & toEmail & "; ToName=" & toName & "; registrationId=" & registrationId))
            Return False

        End If

    End Function

#End Region

#Region "    Registration Receipt "

    'Sends event registration information to registrant upon completing registration
    Public Shared Function EmailReceipt(ByVal registrationId As Integer) As Boolean

        Dim registrationBll As New RegistrationBll
        Dim regTable As RegistrationDAL.RegistrationDataTable
        regTable = registrationBll.GetRegistrationById(registrationId)
        If regTable.Rows.Count > 0 Then

            Dim userBll As New UserProfileBll

            Dim userRow As UserProfileDAL.UserProfileRow = userBll.GetUserById(regTable(0).UserId)
            If Not userRow Is Nothing Then
                'Ok, so we know that the User is found and the Registration is found,
                'lets send the e-mail

                Dim emailBll As New EmailBll

                'EmailTypeId=6 > Receipt
                'TODO: Maybe we want a different receipt template for each event?
                Dim template As EmailTemplateDAL.EmailTemplateRow = emailBll.GetDefaultTemplateByTypeId(6)
                If Not template Is Nothing Then

                    'If the template exists, replace any variables with event specific information
                    Dim messageHtml As String
                    messageHtml = RenderRegistrationTags(template.TemplateHtml, registrationId)

                    Dim mailMessage As New MailMessage
                    mailMessage.To.Add(New MailAddress(userRow.Email, userRow.FirstName & " " & userRow.LastName))
                    mailMessage.From = New MailAddress("noreply@sva.com", "SVA Events")
                    mailMessage.IsBodyHtml = True
                    mailMessage.Subject = template.EmailSubject
                    mailMessage.Body = messageHtml

                    'Try to blind copy the event contact:;
                    Dim contactBll As New ContactBll
                    Dim contact As EventDAL.ContactDataTable = contactBll.GetContactByEventId(regTable(0).EventId)
                    If contact.Rows.Count > 0 Then
                        Dim contactEmail As String = contact(0).Email
                        mailMessage.Bcc.Add(New MailAddress(contactEmail))
                    End If

                    'Send the message
                    Dim smtp As New SmtpClient
                    smtp.Send(mailMessage)

                Else

                    'There wasn't one, so save and send the error, but continue anyway
                    ExceptionHandler.Thrown(New Exception("Couldn't find an email template to send the receipt.  No e-mail was sent, but the user's experience went on smoothly."))
                    Return False

                End If

            Else
                'Couldn't find the user
                ExceptionHandler.Thrown(New Exception("Couldn't find the User information to auto-send the receipt.  The registration was still added and the user has seen the receipt page, but they haven't received an e-mail."))
                Return False
            End If

        Else

            'If we can't find the registration
            ExceptionHandler.Thrown(New Exception("Couldn't find the registration information to auto-send the receipt.  The registration was still added and the user has seen the receipt page, but they haven't received an e-mail."))
            Return False

        End If

    End Function

#End Region

#Region "    Event Waiting List "

    ' A spot has opened for this event and there's a waiting list
    '   send an email to the coordinator to let them know
    Public Shared Function EmailEventWaitOver(ByVal eventId As Integer) As Boolean

        ' Email the event coordinator
        Dim eventBll As New EventBll
        Dim eventTable As EventDAL.EventDataTable = eventBll.GetEventById(eventId)
        If eventTable.Rows.Count > 0 Then

            'Get the contact that we need to email
            Dim contactBll As New ContactBll
            Dim toEmail As String = contactBll.GetContactToEmail(eventTable(0).ContactId)

            'Create message text
            Dim message As New StringBuilder
            message.AppendLine("<h2>A space has opened in Event #" & eventId & ": " & eventTable(0).Title & "<br /><br /></h2>")
            message.AppendLine("Here is the waiting list for this event:<br /><br />")
            message.AppendLine("<table><tr><th>Name</th><th>Company</th><th>Phone</th><th>Email</th><th>Waiting</th></tr>")
            Dim waitingListBll As New WaitingListBll
            Dim waitingList As EventDAL.EventWaitingListDataTable = waitingListBll.GetWaitingList(eventId, Nothing)
            For Each waiter As EventDAL.EventWaitingListRow In waitingList
                message.AppendLine("<tr><td>" & waiter.FirstName & " " & waiter.LastName & "</td>")
                message.AppendLine("<td>" & waiter.Company & "</td>")
                message.AppendLine("<td>" & waiter.Phone & "</td>")
                message.AppendLine("<td>" & waiter.Email & "</td>")
                message.AppendLine("<td>" & waiter.DateWaiting & "</td></tr>")
            Next
            message.AppendLine("</table>")

            Try
                Dim smtp As New SmtpClient
                Dim mailMessage As New MailMessage("no-reply@sva.com", toEmail, "Event Waiting List", message.ToString)
                mailMessage.IsBodyHtml = True
                smtp.Send(mailMessage)
                Return True

            Catch ex As Exception
                'If it doesn't work, throw/send the exception
                ExceptionHandler.Thrown(ex)
                Return False
            End Try

        End If

        Return False

    End Function

#End Region

#Region "    Breakout Waiting List "

    ' A spot has opened for this breakout and there is a waiting list
    '   e-mail the coordinator and tell them to get it done!
    Public Shared Function EmailBreakoutWaitOver(ByVal breakoutId As Integer, ByVal eventId As Integer) As Boolean

        ' Email the event coordinator
        Dim breakoutbll As New BreakoutBll
        Dim breakoutTable As EventDAL.BreakoutDataTable = breakoutbll.GetBreakoutById(breakoutId)
        If breakoutTable.Rows.Count > 0 Then

            Dim eventBll As New EventBll
            Dim eventTable As EventDAL.EventDataTable = eventBll.GetEventById(eventId)
            If eventTable.Rows.Count > 0 Then

                'Get the contact that we need to email
                Dim contactBll As New ContactBll
                Dim toEmail As String = contactBll.GetContactToEmail(eventTable(0).ContactId)

                'Create message text
                Dim message As New StringBuilder
                message.AppendLine("<h2>A space has opened in Breakout: '" & breakoutTable(0).Title & "' for event #" & eventId & ": " & eventTable(0).Title & "<br /><br /></h2>")
                message.AppendLine("Here is the waiting list for this breakout:<br /><br />")
                message.AppendLine("<table><tr><th>Name</th><th>Company</th><th>Phone</th><th>Email</th><th>Waiting</th></tr>")
                Dim waitingListBll As New WaitingListBll
                Dim waitingList As RegistrationDAL.BreakoutWaitingListDataTable = waitingListBll.GetBreakoutWaitingListById(breakoutId)
                For Each waiter As RegistrationDAL.BreakoutWaitingListRow In waitingList
                    message.AppendLine("<tr><td>" & waiter.FirstName & " " & waiter.LastName & "</td>")
                    message.AppendLine("<td>" & waiter.Company & "</td>")
                    message.AppendLine("<td>" & waiter.Phone & "</td>")
                    message.AppendLine("<td>" & waiter.Email & "</td>")
                    message.AppendLine("<td>" & waiter.DateWaiting & "</td></tr>")
                Next
                message.AppendLine("</table>")

                Try
                    Dim smtp As New SmtpClient
                    Dim mailMessage As New MailMessage("no-reply@sva.com", toEmail, "Event Breakout Waiting List", message.ToString)
                    mailMessage.IsBodyHtml = True
                    smtp.Send(mailMessage)
                    Return True

                Catch ex As Exception
                    'If it doesn't work, save the exception
                    ExceptionHandler.Thrown(ex)
                    Return False
                End Try

            End If
        End If

        Return False

    End Function

#End Region

#End Region

#Region " Format Emails "

#Region "    User Tags "

    Public Shared Function RenderUserTags(ByVal template As String, ByVal userId As Guid) As String
        Dim userBll As New UserProfileBll

        Dim userRow As UserProfileDAL.UserProfileRow = userBll.GetUserById(userId)
        If Not userRow Is Nothing Then
            template = HandleTable(template, "User", userRow)
        End If

        Return template

    End Function

#End Region

#Region "    Registration Tags "

    Public Shared Function RenderRegistrationTags(ByVal template As String, ByVal registrationId As Integer) As String
        Dim registrationBll As New RegistrationBll
        Dim registrationTable As RegistrationDAL.RegistrationDataTable = registrationBll.GetRegistrationById(registrationId)

        If registrationTable.Rows.Count > 0 Then
            Dim registrationRow As RegistrationDAL.RegistrationRow = registrationTable(0)

            'Take care of User and Event tags all in one bang:
            template = RenderEventTags(template, registrationRow.EventId)
            template = RenderUserTags(template, registrationRow.UserId)

            template = HandleTable(template, "Registration", registrationRow)

        Else
            ExceptionHandler.Thrown(New Exception("Couldn't find the registration information to render email (RegistrationId=" & registrationId & ".  The email will not be sent."))
        End If

        Return template
    End Function

#End Region

#Region "    Event Tags "

    'Event specific information that is the same for everyone receiving the e-mail
    Public Shared Function RenderEventTags(ByVal template As String, ByVal eventId As Integer) As String

        Dim eventsRoot As String = ConfigurationManager.AppSettings("EventsRoot")

        Dim eventBll As New EventBll
        Dim eventTable As EventDAL.EventDataTable = eventBll.GetEventById(eventId)

        If eventTable.Rows.Count > 0 Then
            Dim eventRow As EventDAL.EventRow = eventTable(0)
            template = HandleTable(template, "Event", eventRow)

            Dim contactBll As New ContactBll
            Dim contactTable As EventDAL.ContactDataTable = contactBll.GetContactByContactId(eventRow.ContactId)
            If eventTable.Rows.Count > 0 Then
                Dim contactRow As EventDAL.ContactRow = contactTable(0)
                template = HandleTable(template, "Contact", contactRow)
            End If

        End If

        Return template

    End Function

#End Region

#Region "    Handle Single Table Values "

    '    Private Shared Function HandleTable(ByVal template As String, ByVal tableName As String, ByVal dataRow As Data.DataRow) As String
    '        'Take care of conditionals
    '        While template.Contains("{?If:" & tableName & ".")

    '            Dim startTagIndex As Integer = template.IndexOf("{?If:" & tableName & ".")
    '            Dim startTagLength As Integer = template.Substring(startTagIndex).IndexOf("?}") + 2
    '            Dim endTagIndex As Integer = template.IndexOf("{?End:" & tableName & ".")
    '            Dim endTagLength As Integer = template.Substring(endTagLength).IndexOf("?}") + 2

    '            Dim startTag As String = template.Substring(startTagIndex, startTagLength)
    '            Dim endTag As String = template.Substring(endTagIndex, endTagLength + 1)
    '            Dim content As String = template.Substring(startTagIndex + startTagLength, endTagIndex - (startTagIndex + startTagLength))
    '            Dim replacement As String = String.Empty

    '            Dim field As String = startTag.Substring(startTag.IndexOf(".") + 1, startTag.Length - startTag.IndexOf(".") - 3)

    '            Dim showField As Boolean = False

    '            Dim fieldObj As Object = dataRow(field)
    '            If Not fieldObj Is DBNull.Value Then
    '                Boolean.TryParse(fieldObj, showField)
    '                showField = True
    '            End If

    '            If Not showField Then
    '                template = template.Replace(content, "")
    '            End If

    '            template = template.Replace(startTag, "")
    '            template = template.Replace(endTag, "")

    '        End While

    '        'Take care of variables
    '        While template.Contains("{#" & tableName & ".")

    '            Dim startIndex As Integer = template.IndexOf("{#" & tableName & ".")
    '            Dim length As Integer = template.Substring(startIndex).IndexOf("#}") + 2

    '            Dim tag As String = template.Substring(startIndex, length)
    '            Dim replacement As String = String.Empty

    '            Dim field As String = tag.Substring(tag.IndexOf(".") + 1, tag.Length - tag.IndexOf(".") - 3)

    '            If field.Contains(":") Then
    '                'Apply formatting
    '                Dim format As String = field.Substring(field.IndexOf(":"))
    '                field = field.Substring(0, field.IndexOf(":") - 1)

    '                Select Case format
    '                    Case "LongDate"
    '                        replacement = FormatDateTime(dataRow(field), DateFormat.LongDate)
    '                    Case "ShortDate"
    '                        replacement = FormatDateTime(dataRow(field), DateFormat.ShortDate)
    '                    Case "LongTime"
    '                        replacement = FormatDateTime(dataRow(field), DateFormat.LongTime)
    '                    Case "ShortTime"
    '                        replacement = FormatDateTime(dataRow(field), DateFormat.ShortTime)
    '                    Case Else
    '                        replacement = dataRow(field)
    '                End Select
    '            Else
    '                replacement = dataRow(field)
    '            End If

    '            template = template.Replace(tag, replacement)

    '        End While

    '        Return template

    '    End Function

#End Region

#Region " Render Single Table Values "

#Region "       Handle Table "

    Private Shared Function HandleTable(ByVal template As String, ByVal tableName As String, ByVal dataRow As Data.DataRow) As String

        template = HandleConditionals(template, tableName, dataRow)
        template = HandleVariables(template, tableName, dataRow)
        template = HandleConstants(template, dataRow)

        Return template

    End Function

#End Region

#Region "       Handle Conditionals {?If:table.field?}something{?End:table.field?} "

    Private Shared Function HandleConditionals(ByVal template As String, ByVal tableName As String, ByVal dataRow As Data.DataRow) As String

        'Take care of conditionals
        '   {?If:[TABLE].[FIELD]?}
        '       [Any HTML mark up or other tags]
        '   {?End:[TABLE].[FIELD]?}

        While template.Contains("{?If:" & tableName & ".")

            'START TAG
            'Get the index within the template of the start of the next conditional statement - {?If:.....
            Dim startTagIndex As Integer = template.IndexOf("{?If:" & tableName & ".")
            'Get the length of the opening tag of the conditional statement - {?If: ... ?}
            Dim startTagLength As Integer = template.Substring(startTagIndex).IndexOf("?}") + 2
            'Get the entire start tag
            Dim startTag As String = template.Substring(startTagIndex, startTagLength)
            'Get the field name out of the start tag
            Dim field As String = startTag.Substring(startTag.IndexOf(".") + 1, startTag.Length - startTag.IndexOf(".") - 3)


            'END TAG
            'Get the index within the template of the end tag for this conditional statement (with the same table and field name) {?End:.....
            Dim endTagIndex As Integer = template.IndexOf("{?End:" & tableName & "." & field)
            'Get the length of the end tag of the conditional statement - {?End: ... ?}
            Dim endTagLength As Integer = template.Substring(endTagIndex).IndexOf("?}") + 2
            'Get entire end tag
            Dim endTag As String = template.Substring(endTagIndex, endTagLength + 1)


            'CONTENT
            'Pull the content between the two tags
            Dim content As String = template.Substring(startTagIndex + startTagLength, endTagIndex - (startTagIndex + startTagLength))
            'Start with an empty string as default to replace the content between the two tags
            Dim replacement As String = String.Empty


            'SHOULD WE SHOW IT?
            ' By default let's show it
            Dim showField As Boolean = True
            ' try to grab the field from the data table
            Dim fieldObj As Object = dataRow(field)
            If fieldObj Is DBNull.Value Then
                ' if it's null: don't show it
                showField = False
            Else
                ' if it isn't null, but it's a false boolean, don't show it
                If Boolean.TryParse(fieldObj, Nothing) Then
                    showField = fieldObj
                End If
            End If

            'HIDE IT IF WE NEED TO
            'If we don't want to show it, just replace the inside with nothing 
            '   (otherwise keep it the way it is, and further tag processing will take care of it)
            If Not showField Then
                template = template.Replace(content, "")
            End If

            'CLEAN UP
            'Knock out the start and end tags since we've taken care of them
            template = template.Replace(startTag, "")
            template = template.Replace(endTag, "")

        End While

        Return template

    End Function

#End Region

#Region "       Handle Variables {#table.field#} "

    Private Shared Function HandleVariables(ByVal template As String, ByVal tableName As String, ByVal dataRow As Data.DataRow) As String

        'Take care of variables
        '   {#[TABLE].[FIELD]#}
        '   {#[TABLE].[FIELD]:[FORMAT]#} - optional formatting for dates, etc.

        While template.Contains("{#" & tableName & ".")

            'GET THE TAG INFORMATION
            'Get the start index of the tag
            Dim startIndex As Integer = template.IndexOf("{#" & tableName & ".")
            'Get the length of the tag
            Dim length As Integer = template.Substring(startIndex).IndexOf("#}") + 2
            'Get the entire tag
            Dim tag As String = template.Substring(startIndex, length)
            'Get the name of the field within this table
            Dim field As String = tag.Substring(tag.IndexOf(".") + 1, tag.Length - tag.IndexOf(".") - 3)

            'Start with a blank replacement (in case we don't find anything, it'll just erase whatevers inside)
            Dim replacement As String = String.Empty

            'If the tag contains a colon, that means we will apply formatting
            If field.Contains(":") Then
                'Get the name of the format to apply
                Dim format As String = field.Substring(field.IndexOf(":") + 1)
                'Since the field currently includes the formatting rule, get just the field name
                field = field.Substring(0, field.IndexOf(":"))

                'Apply formatting based on the format specified
                Select Case format
                    Case "LongDate"
                        replacement = FormatDateTime(dataRow(field), DateFormat.LongDate)
                    Case "ShortDate"
                        replacement = FormatDateTime(dataRow(field), DateFormat.ShortDate)
                    Case "LongTime"
                        replacement = FormatDateTime(dataRow(field), DateFormat.LongTime)
                    Case "ShortTime"
                        replacement = FormatDateTime(dataRow(field), DateFormat.ShortTime)
                    Case Else
                        'If the format doesn't match one of those specified, 
                        '   just return the value in whatever default format it comes
                        replacement = dataRow(field)
                End Select
            Else
                'If the tag doesn't contain formatting, just return it in it's default format
                Dim fieldObj As Object = dataRow(field)
                'If it's null, we don't want to go there, keep it blank
                If Not fieldObj Is DBNull.Value Then
                    replacement = dataRow(field)
                End If
            End If

            'Replace the tag within the template with whatever we returned
            template = template.Replace(tag, replacement)

        End While

        Return template

    End Function

#End Region

#Region "       Handle Constants {$constant$}"

    Private Shared Function HandleConstants(ByVal template As String, ByVal dataRow As Data.DataRow) As String

        'Take care of constants
        '   {$[CONSTANT]$}

        While template.Contains("{$")

            'GET THE TAG INFORMATION
            'Get the start index of the tag
            Dim startIndex As Integer = template.IndexOf("{$")
            'Get the length of the tag
            Dim length As Integer = template.Substring(startIndex).IndexOf("$}") + 2
            'Get the entire tag
            Dim tag As String = template.Substring(startIndex, length)
            'Get the name of the constant within this tag
            Dim constant As String = tag.Substring(tag.IndexOf("$") + 1, tag.Length - tag.IndexOf("$") - 3)

            'Start with a blank replacement (in case we don't find anything, it'll just erase whatevers inside)
            Dim replacement As String = String.Empty

            'Go through each known constant 
            Select Case constant

                Case "EventRoot"
                    'Give whichever Events application root is found in the web.config
                    replacement = ConfigurationManager.AppSettings("appPath")

            End Select

            'Replace the tag within the template with whatever we returned
            template = template.Replace(tag, replacement)

        End While

        Return template

    End Function


#End Region

#End Region

#End Region

End Class
