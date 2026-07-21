Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports System.Net
Imports System.Data

Public Class printtickets
    Inherits System.Web.UI.Page

    ' ---------------------------------------------------------------
    ' TicketCo API settings
    ' ---------------------------------------------------------------
    Private Const FixtureId As String = "573988"
    Private Const ApiToken As String = "nk6t4EzmDNuB3vAZ1gMy"
    Private Const BaseUrl As String = "https://ticketco.events/api/public/v1/item_grosses"

    ' ---------------------------------------------------------------
    ' ViewState key used to persist the fetched DataTable across
    ' postbacks so that Edit / Update work without re-calling the API
    ' ---------------------------------------------------------------
    Private Const VsKey As String = "TicketData"

    ' ==============================================================
    ' Page_Load
    ' ==============================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            Dim dt As DataTable = FetchFromApi()
            ViewState(VsKey) = dt
            BindGrid(dt)
        End If
    End Sub

    ' ==============================================================
    ' FetchFromApi  –  pages through every page of results and
    '                  returns a DataTable matching the grid columns
    ' ==============================================================
    Private Function FetchFromApi() As DataTable

        Dim dt As New DataTable()
        dt.Columns.Add("PurchaseDate", GetType(String))
        dt.Columns.Add("TicketID", GetType(String))       ' uuid  (used for QR)
        dt.Columns.Add("TicketCoRef", GetType(String))    ' ref_number
        dt.Columns.Add("GroundArea", GetType(String))     ' section_name
        dt.Columns.Add("SeatRow", GetType(String))
        dt.Columns.Add("SeatNumber", GetType(String))     ' seat
        dt.Columns.Add("TicketType", GetType(String))     ' item_type_title
        dt.Columns.Add("BuyerFirstName", GetType(String))
        dt.Columns.Add("BuyerLastName", GetType(String))
        dt.Columns.Add("PrintName", GetType(String))      ' holder first + last
        dt.Columns.Add("EventName", GetType(String))
        dt.Columns.Add("QuestionAnswers", GetType(String))

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
                    row("PurchaseDate") = CStr(item("transaction_datestamp") & "")
                    row("TicketID") = CStr(item("uuid") & "")
                    row("TicketCoRef") = CStr(item("ref_number") & "")
                    row("GroundArea") = CStr(item("section_name") & "")
                    row("SeatRow") = CStr(item("row") & "")
                    row("SeatNumber") = CStr(item("seat") & "")
                    row("TicketType") = CStr(item("item_type_title") & "")
                    row("BuyerFirstName") = CStr(item("buyer_first_name") & "")
                    row("BuyerLastName") = CStr(item("buyer_last_name") & "")
                    row("PrintName") = (CStr(item("holder_first_name") & "") & " " &
                                        CStr(item("holder_last_name") & "")).Trim()
                    row("EventName") = CStr(item("event_name") & "")
                    row("QuestionAnswers") = CStr(item("answers") & "")
                    dt.Rows.Add(row)
                Next

                page += 1
            Loop
        End Using

        Return dt
    End Function

    ' ==============================================================
    ' BindGrid  –  accepts the DataTable directly so we avoid
    '              double-fetching on postbacks
    ' ==============================================================
    Private Sub BindGrid(ByVal dt As DataTable)
        GridView1.DataSource = dt
        GridView1.DataBind()
        If GridView1.Rows.Count > 0 Then
            GridView1.HeaderRow.TableSection = TableRowSection.TableHeader
        End If
    End Sub

    ' ==============================================================
    ' Refresh button  –  re-fetch from the API and update ViewState
    ' ==============================================================
    Protected Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Dim dt As DataTable = FetchFromApi()
        ViewState(VsKey) = dt
        GridView1.EditIndex = -1
        BindGrid(dt)
    End Sub

    ' ==============================================================
    ' GridView events
    ' ==============================================================
    Private Sub gvDays_RowDataBound(ByVal sender As Object,
                                     ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) _
                                     Handles GridView1.RowDataBound
        If (e.Row.RowState And DataControlRowState.Edit) = DataControlRowState.Edit Then
            e.Row.Cells(3).Controls(0).Focus()
        End If
    End Sub

    Protected Sub OnRowEditing(sender As Object, e As GridViewEditEventArgs)
        GridView1.EditIndex = e.NewEditIndex
        BindGrid(CType(ViewState(VsKey), DataTable))
    End Sub

    Protected Sub OnRowCancelingEdit(sender As Object, e As EventArgs)
        GridView1.EditIndex = -1
        BindGrid(CType(ViewState(VsKey), DataTable))
    End Sub

    ' Update PrintName in the in-memory DataTable stored in ViewState.
    ' Nothing is written to a database.
    Protected Sub OnRowUpdating(ByVal sender As Object, ByVal e As GridViewUpdateEventArgs)
        Dim row As GridViewRow = GridView1.Rows(e.RowIndex)

        Dim ticketCoRef As String = (TryCast(row.FindControl("LBTicketID"), Label)).Text
        Dim newPrintName As String = (TryCast(row.FindControl("txtprintname"), TextBox)).Text

        ' Update the cached DataTable so the change survives the postback
        Dim dt As DataTable = CType(ViewState(VsKey), DataTable)
        Dim matches() As DataRow = dt.Select("TicketCoRef = '" & ticketCoRef.Replace("'", "''") & "'")
        If matches.Length > 0 Then
            matches(0)("PrintName") = newPrintName
        End If
        ViewState(VsKey) = dt

        GridView1.EditIndex = -1
        BindGrid(dt)
    End Sub

    Protected Sub OnSorting(ByVal sender As Object, ByVal e As GridViewSortEventArgs)
        ' Sort the in-memory DataTable
        Dim dt As DataTable = CType(ViewState(VsKey), DataTable)
        Dim dv As New DataView(dt)
        dv.Sort = e.SortExpression
        BindGrid(dv.ToTable())
    End Sub

End Class
