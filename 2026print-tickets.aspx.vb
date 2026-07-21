Imports System.Data
Imports System.Net
Imports Newtonsoft.Json.Linq
Imports MySql.Data.MySqlClient

Imports System.Configuration
Imports Newtonsoft.Json


Public Class print2026tickets
    Inherits System.Web.UI.Page

    ' ---------------------------------------------------------------
    ' TicketCo API settings
    ' ---------------------------------------------------------------
    Private Const FixtureId As String = "1127619"
    Private Const ApiToken As String = "nk6t4EzmDNuB3vAZ1gMy"
    Private Const BaseUrl As String = "https://ticketco.events/api/public/v1/item_grosses"

    ' ViewState key to persist the DataTable across postbacks
    Private Const VsKey As String = "TicketData"

    ' ---------------------------------------------------------------
    ' Page_Load
    ' ---------------------------------------------------------------
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            Dim dt As DataTable = LoadFromDatabase()
            ViewState(VsKey) = dt
            BindGrid(dt)
            BindOnlineOrders()
        End If
    End Sub

    ' ---------------------------------------------------------------
    ' FetchFromApi - pages through all TicketCo results and returns
    ' a DataTable matching the existing GridView columns
    ' ---------------------------------------------------------------
    Private Function FetchFromApi() As DataTable
        Dim dt As New DataTable()
        dt.Columns.Add("PurchaseDate", GetType(String))
        dt.Columns.Add("TicketID", GetType(String))        ' uuid  (used for QR code)
        dt.Columns.Add("TicketCoRef", GetType(String))     ' ref_number
        dt.Columns.Add("GroundArea", GetType(String))      ' section_name
        dt.Columns.Add("SeatRow", GetType(String))
        dt.Columns.Add("SeatNumber", GetType(String))      ' seat
        dt.Columns.Add("TicketType", GetType(String))      ' item_type_title
        dt.Columns.Add("BuyerFirstName", GetType(String))
        dt.Columns.Add("BuyerLastName", GetType(String))
        dt.Columns.Add("PrintName", GetType(String))       ' holder first + last name
        dt.Columns.Add("EventName", GetType(String))
        dt.Columns.Add("QuestionAnswers", GetType(String))

        ' Force TLS 1.2 - required by TicketCo API
        System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12

        Dim page As Integer = 1

        Using client As New WebClient()
            Do
                Dim url As String = String.Format("{0}?token={1}&event_id={2}&page={3}",
                                                  BaseUrl, ApiToken, FixtureId, page)
                Dim json As String = client.DownloadString(url)
                Dim root As JObject = JObject.Parse(json)
                Dim items As JArray = TryCast(root("item_grosses"), JArray)

                If items Is Nothing OrElse items.Count = 0 Then Exit Do

                For Each item As JToken In items
                    Dim row As DataRow = dt.NewRow()
                    row("PurchaseDate")    = CStr(If(item("transaction_datestamp"), ""))
                    row("TicketID")        = CStr(If(item("uuid"), ""))
                    row("TicketCoRef")     = CStr(If(item("ref_number"), ""))
                    row("GroundArea")      = CStr(If(item("section_name"), ""))
                    row("SeatRow")         = CStr(If(item("row"), ""))
                    row("SeatNumber")      = CStr(If(item("seat"), ""))
                    row("TicketType")      = CStr(If(item("item_type_title"), ""))
                    row("BuyerFirstName")  = CStr(If(item("buyer_first_name"), ""))
                    row("BuyerLastName")   = CStr(If(item("buyer_last_name"), ""))
                    row("PrintName")       = (CStr(If(item("holder_first_name"), "")) & " " &
                                              CStr(If(item("holder_last_name"), ""))).Trim()
                    row("EventName")       = CStr(If(item("event_name"), ""))
                    row("QuestionAnswers") = CStr(If(item("answers"), ""))
                    dt.Rows.Add(row)
                Next

                page += 1
            Loop
        End Using

        Return dt
    End Function

    ' ---------------------------------------------------------------
    ' LoadFromDatabase - reads season tickets from ticketco_cardprint_2627
    ' ---------------------------------------------------------------
    Private Function LoadFromDatabase() As DataTable
        Dim dt As New DataTable()
        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)
            Using cmd As New MySqlCommand(
                "SELECT PurchaseDate, TicketID, TicketCoRef, GroundArea, SeatRow, SeatNumber, " &
                "TicketType, BuyerFirstName, BuyerLastName, PrintName, EventName, Questions, GroupOrderID " &
                "FROM ticketco_seasontickets_2627 ORDER BY PurchaseDate DESC", con)
                Using sda As New MySqlDataAdapter(cmd)
                    sda.Fill(dt)
                End Using
            End Using
        End Using
        Return dt
    End Function

    ' ---------------------------------------------------------------
    ' BindOnlineOrders - populates the Online Orders tab (gvOrders)
    ' ---------------------------------------------------------------
    Private Sub BindOnlineOrders()
        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Dim dt As New DataTable()
        Using con As New MySqlConnection(constr)
            Using cmd As New MySqlCommand(
                "SELECT GroupOrderID, BuyerFirstName, BuyerLastName, " &
                "MIN(PurchaseDate) AS PurchaseDate, COUNT(*) AS TicketCount, " &
                "CASE MIN(OrderSettlement) " &
                "  WHEN 'cash'   THEN 'Admin' " &
                "  WHEN 'mobile' THEN 'Online' " &
                "  WHEN 'online' THEN 'Online' " &
                "  ELSE MIN(OrderSettlement) " &
                "END AS OrderSettlement " &
                "FROM ticketco_cardprint_2627 " &
                "WHERE GroupOrderID IS NOT NULL AND GroupOrderID <> '' " &
                "GROUP BY GroupOrderID, BuyerFirstName, BuyerLastName " &
                "ORDER BY MIN(PurchaseDate) DESC", con)
                Using sda As New MySqlDataAdapter(cmd)
                    sda.Fill(dt)
                End Using
            End Using
        End Using
        gvOrders.DataSource = dt
        gvOrders.DataBind()
        If gvOrders.Rows.Count > 0 Then
            gvOrders.HeaderRow.TableSection = TableRowSection.TableHeader
        End If
    End Sub

    ' ---------------------------------------------------------------
    ' BindGrid
    ' ---------------------------------------------------------------
    Private Sub BindGrid(ByVal dt As DataTable)
        GridView1.DataSource = dt
        GridView1.DataBind()
        If GridView1.Rows.Count > 0 Then
            GridView1.HeaderRow.TableSection = TableRowSection.TableHeader
        End If
    End Sub

    ' ---------------------------------------------------------------
    ' Row data bound
    ' ---------------------------------------------------------------
    Protected Sub gvDays_RowDataBound(ByVal sender As Object,
                                       ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If (e.Row.RowState And DataControlRowState.Edit) = DataControlRowState.Edit Then
            e.Row.Cells(3).Controls(0).Focus()
        End If
    End Sub

    ' ---------------------------------------------------------------
    ' Edit / Cancel / Update - operates on the in-memory DataTable
    ' stored in ViewState. No database writes.
    ' ---------------------------------------------------------------
    Protected Sub OnRowEditing(sender As Object, e As GridViewEditEventArgs)
        GridView1.EditIndex = e.NewEditIndex
        BindGrid(CType(ViewState(VsKey), DataTable))
    End Sub

    Protected Sub OnRowCancelingEdit(sender As Object, e As EventArgs)
        GridView1.EditIndex = -1
        BindGrid(CType(ViewState(VsKey), DataTable))
    End Sub

    Protected Sub OnRowUpdating(ByVal sender As Object, ByVal e As GridViewUpdateEventArgs)
        Dim row As GridViewRow = GridView1.Rows(e.RowIndex)

        Dim ticketCoRef As String = (TryCast(row.FindControl("LBTicketID"), Label)).Text
        Dim newPrintName As String = (TryCast(row.FindControl("txtprintname"), TextBox)).Text

        ' Update PrintName in the cached DataTable
        Dim dt As DataTable = CType(ViewState(VsKey), DataTable)
        Dim matches() As DataRow = dt.Select("TicketCoRef = '" & ticketCoRef.Replace("'", "''") & "'")
        If matches.Length > 0 Then
            matches(0)("PrintName") = newPrintName
        End If
        ViewState(VsKey) = dt

        GridView1.EditIndex = -1
        BindGrid(dt)
    End Sub

    ' ---------------------------------------------------------------
    ' Sorting - sorts the in-memory DataTable
    ' ---------------------------------------------------------------
    Protected Sub OnSorting(ByVal sender As Object, ByVal e As GridViewSortEventArgs)
        Dim dt As DataTable = CType(ViewState(VsKey), DataTable)
        Dim dv As New DataView(dt)
        dv.Sort = e.SortExpression
        BindGrid(dv.ToTable())
    End Sub

    ' ---------------------------------------------------------------
    ' TriggerN8nRefresh - called via jQuery AJAX (no postback).
    ' Makes a server-side POST to the n8n webhook so there is no
    ' browser CORS restriction, and waits for n8n to respond before
    ' returning - relies on n8n "Last Node" response mode.
    ' ---------------------------------------------------------------
    <System.Web.Services.WebMethod()>
    Public Shared Function TriggerN8nRefresh() As String
        Dim req As System.Net.HttpWebRequest = CType(
            System.Net.WebRequest.Create("https://n8n.qosfc.com/webhook/82cdcc09-9bf3-4fe8-a661-2e96f2428f81"),
            System.Net.HttpWebRequest)
        req.Method = "POST"
        req.ContentLength = 0
        req.Timeout = 120000  ' 2-minute timeout
        Using resp As System.Net.HttpWebResponse = CType(req.GetResponse(), System.Net.HttpWebResponse)
            Return "ok"
        End Using
    End Function

    ' ---------------------------------------------------------------
    ' Refresh button - triggers n8n workflow then reloads from DB
    ' ---------------------------------------------------------------
    Protected Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Try
            Dim req As System.Net.HttpWebRequest = CType(
                System.Net.WebRequest.Create("https://n8n.qosfc.com/webhook/82cdcc09-9bf3-4fe8-a661-2e96f2428f81"),
                System.Net.HttpWebRequest)
            req.Method = "POST"
            req.ContentLength = 0
            req.Timeout = 120000
            Using resp As System.Net.HttpWebResponse = CType(req.GetResponse(), System.Net.HttpWebResponse)
            End Using
        Catch ex As Exception
            ' Webhook failed - still reload from DB with whatever data is there
        End Try

        Response.Redirect("2026print-tickets.aspx")
    End Sub

End Class
