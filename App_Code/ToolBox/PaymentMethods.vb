Imports Microsoft.VisualBasic
Imports System.IO
Imports System.Net
Imports System.Security.Cryptography.X509Certificates

Public Class PaymentMethods

#Region " Get Token "

    Public Shared Function GetToken(ByVal registrationId As Integer) As String

        Dim token As String = Nothing

        'Get EventId and UserId information from Registration Table
        Dim registrationBll As New RegistrationBll
        Dim registrationTable As RegistrationDAL.RegistrationDataTable
        registrationTable = registrationBll.GetRegistrationById(registrationId)

        'If the registration exists in the database
        If registrationTable.Rows.Count > 0 Then
            Dim eventId As Integer = registrationTable(0).EventId
            Dim userId As String = registrationTable(0).UserId.ToString

            'Verify that the currently logged in user has access to this registration
            '   If not, the verification method will redirect
            UserMethods.VerifyCurrentUser(userId)

            'Get the User Object for the current user
            Dim userBll As New UserProfileBll
            Dim user As UserProfileDAL.UserProfileRow = userBll.GetUser()

            'Get MerchantId and Pin information from Entity Table
            Dim eventBll As New EventBll
            Dim eventTable As EventDAL.EventDataTable = eventBll.GetEventById(eventId)

            'If the event exists in the database
            If eventTable.Rows.Count > 0 Then

                Dim entityBll As New EntityBll
                Dim entityTable As EventDAL.EntityDataTable = entityBll.GetEntityById(eventTable(0).EntityId)
                Dim description As String = eventTable(0).Title & " - Registration"

                If entityTable.Rows.Count > 0 Then
                    'If the entity has a merchantId or pin
                    If Not (entityTable(0).MerchantId Is DBNull.Value Or entityTable(0).MerchantPin Is DBNull.Value) Then
                        Dim customerId As String = entityTable(0).MerchantId
                        Dim password As String = entityTable(0).MerchantPin

                        Dim tcTrustee As New TcTrustee
                        token = tcTrustee.GetToken(customerId, password)

                    End If
                End If
            End If
        End If

        Return token
    End Function

#End Region

#Region " Post Payment "

    Public Shared Function PostPayment( _
            ByVal tcTrusteeToken As String, _
            ByVal amountDue As Double) _
                As Boolean

        If amountDue > 0 Then

            Dim userBll As New UserProfileBll
            Dim userRow As UserProfileDAL.UserProfileRow = userBll.GetUser()

            Dim name As String = userRow.FirstName & " " & userRow.LastName

            Dim trustee As New TcTrustee
            Return trustee.Post( _
                    tcTrusteeToken, amountDue, name, _
                    userRow.Address, userRow.Address2, _
                    userRow.City, userRow.State, userRow.Zip)

        End If

        Return True

    End Function

#End Region



End Class

#Region " TCTrustee Class "

Public Class TcTrustee

#Region " Properties "

    ''    'Private _custId As String
    ''    'Public Property CustomerId() As String
    ''    '    Get
    ''    '        Return _custId
    ''    '    End Get
    ''    '    Set(ByVal value As String)
    ''    '        _custId = value
    ''    '    End Set
    ''    'End Property

    ''    'Private _registrationId As Integer
    ''    'Public Property RegistrationId() As Integer
    ''    '    Get
    ''    '        Return _registrationId
    ''    '    End Get
    ''    '    Set(ByVal value As Integer)
    ''    '        _registrationId = value
    ''    '    End Set
    ''    'End Property

    ''    'Private _password As String
    ''    'Public Property Password() As String
    ''    '    Get
    ''    '        Return _password
    ''    '    End Get
    ''    '    Set(ByVal value As String)
    ''    '        _password = value
    ''    '    End Set
    ''    'End Property

    ''    'Private _token As String
    ''    'Public Property Token() As String
    ''    '    Get
    ''    '        Return _token
    ''    '    End Get
    ''    '    Set(ByVal value As String)
    ''    '        _token = value
    ''    '    End Set
    ''    'End Property

    ''    Private _amount As String
    ''    Public Property Amount() As String
    ''        Get
    ''            Return _amount
    ''        End Get
    ''        Set(ByVal value As String)
    ''            _amount = value
    ''        End Set
    ''    End Property

    ''    Private _name As String
    ''    Public Property Name() As String
    ''        Get
    ''            Return _name
    ''        End Get
    ''        Set(ByVal value As String)
    ''            _name = value
    ''        End Set
    ''    End Property

    ''    Private _address1 As String
    ''    Public Property Address1() As String
    ''        Get
    ''            Return _address1
    ''        End Get
    ''        Set(ByVal value As String)
    ''            _address1 = value
    ''        End Set
    ''    End Property

    ''    Private _address2 As String
    ''    Public Property Address2() As String
    ''        Get
    ''            Return _address2
    ''        End Get
    ''        Set(ByVal value As String)
    ''            _address2 = value
    ''        End Set
    ''    End Property

    ''    Private _city As String
    ''    Public Property City() As String
    ''        Get
    ''            Return _city
    ''        End Get
    ''        Set(ByVal value As String)
    ''            _city = value
    ''        End Set
    ''    End Property

    ''    Private _state As String
    ''    Public Property State() As String
    ''        Get
    ''            Return _state
    ''        End Get
    ''        Set(ByVal value As String)
    ''            _state = value
    ''        End Set
    ''    End Property

    ''    Private _zip As String
    ''    Public Property Zip() As String
    ''        Get
    ''            Return _zip
    ''        End Get
    ''        Set(ByVal value As String)
    ''            _zip = value
    ''        End Set
    ''    End Property

#End Region

#Region " Get Token "

Public Function GetToken(ByVal customerId As String, ByVal password As String) As String

    'Me.CustomerId = customerId
    'Me.Password = password

    'Set up the URL that is always used to request the token from TC Trustee
    Dim url As String = "https://vault.trustcommerce.com/trustee/token.php"

    'Set up the POST data using the customer Id and password that are associated with this event
    Dim postData As String = "custid=" & customerId & "&password=" & password

    'Post the Data
    Dim req As HttpWebRequest = GetWebRequestForPostMethod(url, postData)

    'Grab the response data (the transaction token) and return it
    Dim token As String = GetResponseString(req)
    If String.IsNullOrEmpty(token) Then
        ExceptionHandler.Thrown(New Exception("There was a problem retreiving the payment Token from TrustCommerce.  The registration has been submitted, but the payment has not been made.  CustomerId=" & customerId))
        'Else
        'Me.Token = token
    End If
    Return token

End Function

#End Region

#Region " Post "

Public Function Post( _
        ByVal token As String, _
        ByVal amount As Double, _
        ByVal name As String, _
        ByVal address1 As String, _
        ByVal address2 As String, _
        ByVal city As String, _
        ByVal state As String, _
        ByVal zip As String) _
            As Boolean

    'Set up the URL that is always used to request the token from TC Trustee
    Dim url As String = "https://vault.trustcommerce.com/trustee/payment.php"

    ' ''Set up the QueryString data using the properties that have been populated
    Dim postData As New StringBuilder
    postData.Append("token=" & token)
    postData.Append("&amount=" & amount)
    'postData.Append("&ticket=" & registrationId)
    postData.Append("&name=" & name)
    postData.Append("&address1=" & address1)
    postData.Append("&address2=" & address2)
    postData.Append("&city=" & city)
    postData.Append("&state=" & state)
    postData.Append("&zip=" & zip)

    'Redirect to the TrustCommerce Trustee application
    'HttpContext.Current.Response.RedirectLocation = url
    'GetWebRequestForPostMethod(url, postData.ToString)
    HttpContext.Current.Response.Redirect(url & "?" & postData.ToString)

    Return True
End Function

#End Region

#Region " Web Request Helper Methods "

''' 
''' Gets the mutual authenticated HTTP POST Web Request object to the URL with the given client certificate. 
''' 
Private Function GetWebRequestForPostMethod(ByVal url As String, ByVal data As String) As HttpWebRequest
    Dim buffer As Byte() = Encoding.UTF8.GetBytes(data)

    Dim req As HttpWebRequest = DirectCast(WebRequest.Create(url), HttpWebRequest)
    req.Method = "POST"
    req.ContentType = "application/x-www-form-urlencoded"
    req.ContentLength = buffer.Length
    req.CookieContainer = New CookieContainer()

    Using reqst As Stream = req.GetRequestStream()
        ' add form data to request stream 
        reqst.Write(buffer, 0, buffer.Length)
    End Using

    Return req
End Function

''' Gets the response string of the http request. 
Private Function GetResponseString(ByVal req As HttpWebRequest) As String
    Using res As HttpWebResponse = DirectCast(req.GetResponse(), HttpWebResponse)
        Dim responseString As String
        Using responseStream As Stream = res.GetResponseStream()
            responseString = New StreamReader(responseStream).ReadToEnd()
        End Using

        Return responseString
    End Using
End Function

#End Region

#Region " OLD "

' ''#Region " Class Usage Info "

' ''    '********************************************
' ''    '* Author: Craig Brown                                                     *
' ''    '* Date: 7/14/2006                                                           *
' ''    '* Desc: This class is used to post form data to a 3rd party  *
' ''    '*          website via server-side code so that form data is    *
' ''    '*          not exposed to the client.                                      *
' ''    '********************************************

' ''    '***** Code for submitting page *************
' ''    '        Dim remotePost As New remotePost
' ''    '        remotePost.url = "http://someurltopostto"
' ''    '        remotePost.Add("field1", "value1")
' ''    '        remotePost.Add("field2", "value2")
' ''    '        remotePost.Post()
' ''    '
' ''    'Receiving page will get typical HTML form post info
' ''    '*************************************

' ''#End Region

' '' ''#Region " Declarations "

' '' ''    Protected inputs As NameValueCollection = New System.Collections.Specialized.NameValueCollection 'collection used to store namevalue pairs
' '' ''    Public url As String = String.Empty 'url that will be posted to
' '' ''    Public method As String = "post" 'method for html form

' '' ''#End Region

' '' ''#Region " Namevalue Pair Population "

' '' ''    Public Sub Add(ByVal name As String, ByVal value As String) 'adds keys to the namevalue collection

' '' ''        inputs.Add(name, value)

' '' ''    End Sub

' '' ''    Private Function GetInputs() As String 'Gets a string representation of the inputs
' '' ''        Dim inputString As New StringBuilder
' '' ''        For Each key As String In inputs.AllKeys
' '' ''            inputString.Append(key & "=" & inputs(key) & "&")
' '' ''        Next
' '' ''        If inputString.ToString.EndsWith("&") Then inputString.Remove(inputString.Length - 1, 1)
' '' ''        Return inputString.ToString
' '' ''    End Function

' '' ''#End Region

#Region " Form Generation / Post "

'' ' Performs a post request. 
''Public Function Post(ByVal custId As String, ByVal password As String, ByVal amount As String, ByVal creditCard As String, ByVal expiration As String) As String

''    Dim tclink As TCLinkNET.TClinkClass
''    tclink = New TCLinkNET.TClinkClass()

''    tclink.PushNameValue("custid=" & custId)
''    tclink.PushNameValue("password=" & password)
''    tclink.PushNameValue("action=sale")
''    tclink.PushNameValue("amount=" & amount)
''    tclink.PushNameValue("cc=" & creditCard)
''    tclink.PushNameValue("exp=" & expiration)
''    tclink.Submit()

''    Return tclink.GetResponse("status")

''    'Dim req As HttpWebRequest = GetWebRequestForPostMethod(url, GetInputs())
''    'Return GetResponseString(req)
''End Function

' ''Post the Data
''HttpContext.Current.Response.Write("<html><head><title>SVA Events Registration - TC Trustee Payment</title></head>")
''HttpContext.Current.Response.Write("<body onload='document.form1.submit();'><form name='form1' action='" & url & "' method='post'>")
''HttpContext.Current.Response.Write("<input type='hidden' name='token' value='" & Token & "' />")
' ''HttpContext.Current.Response.Write("<input type='hidden' name='password' value='" & Password & "' />")
''HttpContext.Current.Response.Write("<input type='hidden' name='amount' value='" & Amount & "' />")
''HttpContext.Current.Response.Write("<input type='hidden' name='name' value='" & Name & "' />")
''HttpContext.Current.Response.Write("<input type='hidden' name='address1' value='" & Address1 & "' />")
''HttpContext.Current.Response.Write("<input type='hidden' name='address2' value='" & Address2 & "' />")
''HttpContext.Current.Response.Write("<input type='hidden' name='city' value='" & City & "' />")
''HttpContext.Current.Response.Write("<input type='hidden' name='state' value='" & State & "' />")
''HttpContext.Current.Response.Write("<input type='hidden' name='zip' value='" & Zip & "' />")
''HttpContext.Current.Response.Write("</form></body></html>")
''HttpContext.Current.Response.End()


'' ''HttpContext.Current.Request.
'' ''HttpContext.Current.Request.Form.Add("token", Token)

' '' ''Dim req As HttpWebRequest = DirectCast(WebRequest.Create(url), HttpWebRequest)
' '' ''req.Method = "POST"
' '' ''req.ContentType = "application/x-www-form-urlencoded"
' '' ''req.ContentLength = postData.Length
'' '' ''req.Referer = url
'' '' ''req.CookieContainer = New CookieContainer()

' '' ''Dim myWriter As New StreamWriter(req.GetRequestStream())
' '' ''myWriter.Write(postData)
' '' ''myWriter.Close()

' '' ''Dim rep As HttpWebResponse = DirectCast(req.GetResponse, HttpWebResponse)
' '' ''Dim str As Stream = rep.GetResponseStream

'' '' ''HttpContext.Current.Response.Clear()
'' '' ''HttpContext.Current.Response.ClearContent()
'' '' ''HttpContext.Current.Response.ClearHeaders()

' '' ''Dim bufferSize As Integer = 1024
' '' ''Dim readBuffer As Byte() = New Byte(bufferSize - 1) {}
' '' ''Dim bytesRead As Integer

' '' ''While bytesRead = str.Read(readBuffer, 0, bufferSize) > 0
' '' ''    HttpContext.Current.Response.OutputStream.Write(readBuffer, 0, bytesRead)
' '' ''End While
' '' ''HttpContext.Current.Response.End()

'Dim req As HttpWebRequest = GetWebRequestForPostMethod(url, postData.ToString)

'Grab the response data (the transaction token) and return it

''Dim q As New System.Collections.Specialized.NameValueCollection
''q.Add("token", Token)
''q.Add("amount", Amount)
''q.Add("name", Name)
''q.Add("address1", Address1)
''q.Add("address2", Address2)
''q.Add("city", City)
''q.Add("state", State)
''q.Add("zip", Zip)

''Dim wc As New System.Net.WebClient
''wc.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
''Dim responseArray As Byte() = wc.UploadValues(url, "post", q)

'HttpContext.Current.Response.Write(Encoding.ASCII.GetString(responseArray).ToString)
'HttpContext.Current.Response.End()



#End Region

#End Region

End Class

#End Region

