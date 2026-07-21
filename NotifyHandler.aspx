<%@ Page Language="VB" %>
<%@ Assembly Name="admintickets" %>
<%@ Import Namespace="admintickets" %>

<script runat="server">

    Protected Sub Page_Load(sender As Object, e As EventArgs)

        Dim secret As String = Request.Headers("X-Secret")
        If secret <> "ABCDEFG123456hijklmnop" Then
            Response.StatusCode = 401
            Response.Write("Unauthorized")
            Response.End()
            Return
        End If

        If Request.HttpMethod <> "POST" Then
            Response.StatusCode = 405
            Response.Write("Method Not Allowed")
            Response.End()
            Return
        End If

        Dim eventid As String = If(Request.QueryString("eventid"), "")

        Try
            Dim hub As New ChatHubticketco()
            hub.PopulateDataTable(eventid)

            Response.ContentType = "application/json"
            Response.StatusCode = 200
            Response.Write("{""status"":""ok""}")

        Catch ex As Exception
            Response.StatusCode = 500
            Response.Write("{""status"":""error"",""message"":""" & ex.Message & """}")
        End Try

        Response.End()

    End Sub

</script>