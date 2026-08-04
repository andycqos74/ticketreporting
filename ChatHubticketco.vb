Imports System
Imports System.Web
Imports Microsoft.AspNet.SignalR
Imports System.Data
Imports System.Configuration
Imports System.Net
Imports System.Threading
Imports MySql.Data.MySqlClient
Imports Newtonsoft.Json.Linq

' =============================================================================
'  ChatHubticketco
'  ---------------------------------------------------------------------------
'  Single, central place where the TicketCo API is polled, the results are
'  written to MySQL, and the dashboard is pushed an update -- all in the same
'  sequential operation so the "push" can never run ahead of the "import".
'
'  This replaces the previous split model (n8n -> import_JSON.php -> DB, plus a
'  browser tab on dash_control driving the broadcast). The server now owns the
'  loop, so no external scheduler and no open browser tab are required.
'
'  Flow of one tick (see TicketcoPoller.Tick):
'     1. TicketcoImporter.FetchAndStore  -> calls API, upserts ticketco_matchsales
'     2. PopulateDataTable               -> reads vw_ticketsalesreport, broadcasts
' =============================================================================
Public Class ChatHubticketco
    Inherits Hub

    ' -------------------------------------------------------------------------
    '  Hub methods callable from the browser (dash_control.aspx)
    ' -------------------------------------------------------------------------

    ''' <summary>
    ''' Start the server-side poll loop for a fixture. Called once from
    ''' dash_control; the loop then runs in the app regardless of whether the
    ''' browser tab stays open.
    ''' </summary>
    Public Sub StartPolling(ByVal eventid As String, ByVal intervalSeconds As Integer)
        TicketcoPoller.Start(eventid, intervalSeconds)
    End Sub

    ''' <summary>Stop the server-side poll loop.</summary>
    Public Sub StopPolling()
        TicketcoPoller.[Stop]()
    End Sub

    ''' <summary>
    ''' Report the poller's current state to the control page (running flag,
    ''' active fixture, and the interval in seconds). Serialised to JSON for the
    ''' browser as { running, eventId, intervalSeconds }.
    ''' </summary>
    Public Function GetStatus() As Object
        Return New With {
            .running = TicketcoPoller.IsRunning,
            .eventId = TicketcoPoller.ActiveEventId,
            .intervalSeconds = TicketcoPoller.IntervalSeconds,
            .auto = TicketcoPoller.IsAuto
        }
    End Function

    ' -------------------------------------------------------------------------
    '  Admin: per-fixture ticket-type mapping (dash_control.aspx)
    ' -------------------------------------------------------------------------

    ''' <summary>
    ''' Distinct ticket types seen in the sales data for a fixture, with sold
    ''' and checked-in counts, so the admin grid can be populated.
    ''' </summary>
    Public Function GetTicketTypes(ByVal eventid As String) As Object
        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Dim list As New List(Of Object)
        Using con As New MySqlConnection(constr)
            con.Open()
            Using cmd As New MySqlCommand(
                "SELECT TicketType, COUNT(*) AS sold, " &
                "SUM(CASE WHEN CheckedInDate IS NOT NULL AND CheckedInDate <> '' THEN 1 ELSE 0 END) AS checkedin " &
                "FROM ticketco_matchsales_live WHERE fixtureid = @f " &
                "GROUP BY TicketType ORDER BY sold DESC", con)
                cmd.Parameters.AddWithValue("@f", eventid)
                Using r = cmd.ExecuteReader()
                    While r.Read()
                        list.Add(New With {
                            .tickettype = r("TicketType").ToString(),
                            .sold = Convert.ToInt32(r("sold")),
                            .checkedin = Convert.ToInt32(r("checkedin"))
                        })
                    End While
                End Using
            End Using
        End Using
        Return list
    End Function

    ''' <summary>Existing mapping + manual "other" figure for a fixture (to pre-fill the grid).</summary>
    Public Function GetMapping(ByVal eventid As String) As Object
        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Dim maps As New List(Of Object)
        Dim otherManual As Integer = 0
        Using con As New MySqlConnection(constr)
            con.Open()
            Using cmd As New MySqlCommand(
                "SELECT tickettype, homeaway, attendance, channel, category FROM ticket_type_map WHERE fixtureid = @f", con)
                cmd.Parameters.AddWithValue("@f", eventid)
                Using r = cmd.ExecuteReader()
                    While r.Read()
                        maps.Add(New With {
                            .tickettype = r("tickettype").ToString(),
                            .homeaway = r("homeaway").ToString(),
                            .attendance = r("attendance").ToString(),
                            .channel = r("channel").ToString(),
                            .category = r("category").ToString()
                        })
                    End While
                End Using
            End Using
            Using cmd2 As New MySqlCommand("SELECT other_manual FROM fixture_admin WHERE fixtureid = @f", con)
                cmd2.Parameters.AddWithValue("@f", eventid)
                Dim o As Object = cmd2.ExecuteScalar()
                If o IsNot Nothing AndAlso o IsNot DBNull.Value Then otherManual = Convert.ToInt32(o)
            End Using
        End Using
        Return New With {.mappings = maps, .otherManual = otherManual}
    End Function

    ''' <summary>
    ''' Persist the mapping for a fixture. mappingJson is a JSON array of
    ''' { tickettype, homeaway, attendance, channel, category }.
    ''' </summary>
    Public Sub SaveMapping(ByVal eventid As String, ByVal mappingJson As String, ByVal otherManual As Integer)
        Dim rows As JArray = JArray.Parse(If(mappingJson, "[]"))
        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)
            con.Open()
            For Each m As JObject In rows
                Using cmd As New MySqlCommand(
                    "INSERT INTO ticket_type_map (fixtureid, tickettype, homeaway, attendance, channel, category) " &
                    "VALUES (@f, @t, @h, @a, @c, @g) ON DUPLICATE KEY UPDATE " &
                    "homeaway = VALUES(homeaway), attendance = VALUES(attendance), " &
                    "channel = VALUES(channel), category = VALUES(category)", con)
                    cmd.Parameters.AddWithValue("@f", eventid)
                    cmd.Parameters.AddWithValue("@t", m("tickettype").ToString())
                    cmd.Parameters.AddWithValue("@h", m("homeaway").ToString())
                    cmd.Parameters.AddWithValue("@a", m("attendance").ToString())
                    cmd.Parameters.AddWithValue("@c", m("channel").ToString())
                    cmd.Parameters.AddWithValue("@g", m("category").ToString())
                    cmd.ExecuteNonQuery()
                End Using
            Next
            Using cmd As New MySqlCommand(
                "INSERT INTO fixture_admin (fixtureid, other_manual) VALUES (@f, @o) " &
                "ON DUPLICATE KEY UPDATE other_manual = VALUES(other_manual)", con)
                cmd.Parameters.AddWithValue("@f", eventid)
                cmd.Parameters.AddWithValue("@o", otherManual)
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    ''' <summary>
    ''' Run a single import + broadcast immediately (used for a manual refresh
    ''' and for the very first paint when a dashboard connects).
    ''' </summary>
    Public Sub ImportJSON()
        Dim eventid As String = TicketcoPoller.ActiveEventId
        TicketcoImporter.FetchAndStore(eventid)
        PopulateDataTable(eventid)
    End Sub

    ' -------------------------------------------------------------------------
    '  Read the aggregated view and broadcast a snapshot to every dashboard.
    '  NOTE: the broadcastMessage argument order/count below is the contract
    '  consumed by dash_display.aspx -- do not change it without updating the
    '  page's JavaScript handler to match.
    ' -------------------------------------------------------------------------
    Public Sub PopulateDataTable(ByVal eventid As String)

        If String.IsNullOrEmpty(eventid) Then
            eventid = TicketcoPoller.ActiveEventId
        End If

        Dim sqlstring As String
        Dim TotalCheckedIn As String = 0
        Dim WalkUpCheckedIn As String = 0
        Dim AwayWalkUpCheckedIn As String = 0
        Dim HomeWalkUpCheckedIn As String = 0
        Dim OnlineCheckedIn As String = 0
        Dim OnlineSold As String = 0
        Dim SeasonTicketsCheckedIn As String = 0
        Dim AwayCheckedIn As String = 0
        Dim HomeCheckedIn As String = 0
        Dim AwaySold As String = 0
        Dim HomeSold As String = 0
        Dim BDS1CheckedIn As String = 0
        Dim BDS2CheckedIn As String = 0
        Dim BDS3CheckedIn As String = 0
        Dim BDS4CheckedIn As String = 0
        Dim BDS5CheckedIn As String = 0
        Dim BDS6CheckedIn As String = 0
        Dim BDS7CheckedIn As String = 0
        Dim BDS8CheckedIn As String = 0
        Dim BDS9CheckedIn As String = 0
        Dim OakbankCheckedIn As String = 0
        Dim TerreglesCheckedIn As String = 0
        Dim Alpha1CheckedIn As String = 0
        Dim Alpha2CheckedIn As String = 0
        Dim Alpha3CheckedIn As String = 0
        Dim Alpha4CheckedIn As String = 0

        Dim AlphaTS1 As String = 0
        Dim AlphaTS2 As String = 0
        Dim EncTS1 As String = 0
        Dim TerraceTS1 As String = 0
        Dim BDSTS1 As String = 0
        Dim BDSTS2 As String = 0

        Dim ReportedCrowd As String = 0
        Dim other As String = 0
        Dim CompsCheckedIn As String = 0

        ' Sold / issued counts (rows per category) added for the redesigned dashboard.
        Dim SeasonTicketsSold As String = 0
        Dim WalkUpSold As String = 0
        Dim BDS1Sold As String = 0
        Dim BDS2Sold As String = 0
        Dim BDS3Sold As String = 0
        Dim BDS4Sold As String = 0
        Dim BDS5Sold As String = 0
        Dim BDS6Sold As String = 0
        Dim BDS7Sold As String = 0
        Dim BDS8Sold As String = 0
        Dim BDS9Sold As String = 0
        Dim Alpha1Sold As String = 0
        Dim Alpha2Sold As String = 0
        Dim Alpha3Sold As String = 0
        Dim Alpha4Sold As String = 0
        Dim OakbankSold As String = 0
        Dim AllSold As String = 0
        Dim AllCheckedIn As String = 0
        Dim OtherBucketSold As String = 0
        Dim OtherBucketCheckedIn As String = 0

        Dim fixturename As String

        sqlstring = "Select * From qosfctickets.vw_ticketsalesreport;"

        Try

            Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con As New MySqlConnection(constr)
                Using cmd As New MySqlCommand(sqlstring)
                    Using sda As New MySqlDataAdapter()
                        cmd.Connection = con
                        sda.SelectCommand = cmd
                        Using dt As New DataTable()
                            sda.Fill(dt)

                            fixturename = dt.Rows(0)("EventName").ToString
                            TotalCheckedIn = dt.Rows(0)("TotalCheckedIn").ToString
                            WalkUpCheckedIn = dt.Rows(0)("WalkUpCheckedIn").ToString
                            AwayWalkUpCheckedIn = dt.Rows(0)("AwayWalkUpCheckedIn").ToString
                            HomeWalkUpCheckedIn = dt.Rows(0)("HomeWalkUpCheckedIn").ToString

                            OnlineCheckedIn = dt.Rows(0)("OnlineCheckedIn").ToString
                            OnlineSold = dt.Rows(0)("OnlineSold").ToString
                            SeasonTicketsCheckedIn = dt.Rows(0)("SeasonTicketsCheckedIn").ToString
                            CompsCheckedIn = dt.Rows(0)("CompsCheckedIn").ToString

                            AwayCheckedIn = dt.Rows(0)("AwayCheckedIn").ToString
                            HomeCheckedIn = dt.Rows(0)("HomeCheckedIn").ToString
                            AwaySold = dt.Rows(0)("AwaySold").ToString
                            HomeSold = dt.Rows(0)("HomeSold").ToString
                            other = dt.Rows(0)("othersold").ToString

                            BDS1CheckedIn = dt.Rows(0)("BDS1CheckedIn").ToString
                            BDS2CheckedIn = dt.Rows(0)("BDS2CheckedIn").ToString
                            BDS3CheckedIn = dt.Rows(0)("BDS3CheckedIn").ToString
                            BDS4CheckedIn = dt.Rows(0)("BDS4CheckedIn").ToString
                            BDS5CheckedIn = dt.Rows(0)("BDS5CheckedIn").ToString
                            BDS6CheckedIn = dt.Rows(0)("BDS6CheckedIn").ToString
                            BDS7CheckedIn = dt.Rows(0)("BDS7CheckedIn").ToString
                            BDS8CheckedIn = dt.Rows(0)("BDS8CheckedIn").ToString
                            BDS9CheckedIn = dt.Rows(0)("BDS9CheckedIn").ToString
                            OakbankCheckedIn = dt.Rows(0)("OakbankCheckedIn").ToString
                            TerreglesCheckedIn = dt.Rows(0)("TerreglesCheckedIn").ToString
                            Alpha1CheckedIn = dt.Rows(0)("Alpha1CheckedIn").ToString
                            Alpha2CheckedIn = dt.Rows(0)("Alpha2CheckedIn").ToString
                            Alpha3CheckedIn = dt.Rows(0)("Alpha3CheckedIn").ToString
                            Alpha4CheckedIn = dt.Rows(0)("Alpha4CheckedIn").ToString

                            AlphaTS1 = dt.Rows(0)("AlphaTS1").ToString
                            AlphaTS2 = dt.Rows(0)("AlphaTS2").ToString
                            EncTS1 = dt.Rows(0)("EncTS1").ToString
                            TerraceTS1 = dt.Rows(0)("TerraceTS1").ToString
                            BDSTS1 = dt.Rows(0)("BDSTS1").ToString
                            BDSTS2 = dt.Rows(0)("BDSTS2").ToString

                            SeasonTicketsSold = dt.Rows(0)("SeasonTicketsSold").ToString
                            WalkUpSold = dt.Rows(0)("WalkUpSold").ToString
                            BDS1Sold = dt.Rows(0)("BDS1Sold").ToString
                            BDS2Sold = dt.Rows(0)("BDS2Sold").ToString
                            BDS3Sold = dt.Rows(0)("BDS3Sold").ToString
                            BDS4Sold = dt.Rows(0)("BDS4Sold").ToString
                            BDS5Sold = dt.Rows(0)("BDS5Sold").ToString
                            BDS6Sold = dt.Rows(0)("BDS6Sold").ToString
                            BDS7Sold = dt.Rows(0)("BDS7Sold").ToString
                            BDS8Sold = dt.Rows(0)("BDS8Sold").ToString
                            BDS9Sold = dt.Rows(0)("BDS9Sold").ToString
                            Alpha1Sold = dt.Rows(0)("Alpha1Sold").ToString
                            Alpha2Sold = dt.Rows(0)("Alpha2Sold").ToString
                            Alpha3Sold = dt.Rows(0)("Alpha3Sold").ToString
                            Alpha4Sold = dt.Rows(0)("Alpha4Sold").ToString
                            OakbankSold = dt.Rows(0)("OakbankSold").ToString
                            AllSold = dt.Rows(0)("AllSold").ToString
                            AllCheckedIn = dt.Rows(0)("AllCheckedIn").ToString
                            OtherBucketSold = dt.Rows(0)("OtherBucketSold").ToString
                            OtherBucketCheckedIn = dt.Rows(0)("OtherBucketCheckedIn").ToString

                            ' Reported attendance = online sold + season checked in + walk-ups checked in
                            ' + comps checked in + other sold
                            ReportedCrowd = CInt(OnlineSold) + CInt(SeasonTicketsCheckedIn) + CInt(WalkUpCheckedIn) + CInt(CompsCheckedIn) + CInt(other)

                            Dim hubContext = GlobalHost.ConnectionManager.GetHubContext(Of ChatHubticketco)()
                            hubContext.Clients.All.broadcastMessage(TotalCheckedIn, WalkUpCheckedIn, OnlineCheckedIn, OnlineSold, SeasonTicketsCheckedIn, AwaySold, HomeSold, AwayCheckedIn, HomeCheckedIn, BDS1CheckedIn, BDS2CheckedIn, BDS3CheckedIn, BDS4CheckedIn, BDS5CheckedIn, BDS7CheckedIn, BDS8CheckedIn, BDS9CheckedIn, OakbankCheckedIn, TerreglesCheckedIn, Alpha1CheckedIn, Alpha2CheckedIn, Alpha3CheckedIn, Alpha4CheckedIn, AlphaTS1, AlphaTS2, EncTS1, TerraceTS1, BDSTS1, BDSTS2, "Last Update : " & DateTime.Now.ToString(" HH:mm:ss"), BDS6CheckedIn, ReportedCrowd, other, CompsCheckedIn, fixturename, "OK", SeasonTicketsSold, WalkUpSold, BDS1Sold, BDS2Sold, BDS3Sold, BDS4Sold, BDS5Sold, BDS6Sold, BDS7Sold, BDS8Sold, BDS9Sold, Alpha1Sold, Alpha2Sold, Alpha3Sold, Alpha4Sold, OakbankSold, AllSold, AllCheckedIn, OtherBucketSold, OtherBucketCheckedIn)

                        End Using
                    End Using
                End Using
            End Using

        Catch ex As Exception

            Dim hubContext = GlobalHost.ConnectionManager.GetHubContext(Of ChatHubticketco)()
            hubContext.Clients.All.broadcastMessage(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ex.Message, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        End Try

    End Sub

    Private Function CheckNull(ByRef value As String) As String
        If String.IsNullOrEmpty(value) Then
            value = "0"
        End If
        Return value
    End Function

End Class


' =============================================================================
'  TicketcoImporter
'  ---------------------------------------------------------------------------
'  Pulls the item_grosses feed for one event from the TicketCo public API and
'  upserts each line into ticketco_matchsales. This is the VB equivalent of the
'  old import_JSON.php, but parameterised (no SQL string interpolation) and with
'  the API token / DB credentials taken from configuration instead of hardcoded.
' =============================================================================
Public NotInheritable Class TicketcoImporter

    Private Sub New()
    End Sub

    Private Const ApiBase As String = "https://ticketco.events/api/public/v1/item_grosses"

    ''' <summary>
    ''' Fetch every page of item_grosses for <paramref name="eventid"/> and
    ''' upsert into ticketco_matchsales. Returns the number of rows written.
    ''' </summary>
    Public Shared Function FetchAndStore(ByVal eventid As String) As Integer

        If String.IsNullOrEmpty(eventid) Then
            Return 0
        End If

        Dim token As String = ConfigurationManager.AppSettings("TicketcoApiToken")
        If String.IsNullOrEmpty(token) Then
            Throw New ConfigurationErrorsException("Missing appSettings key 'TicketcoApiToken'.")
        End If

        ' TicketCo is HTTPS/TLS 1.2 only.
        ServicePointManager.Expect100Continue = True
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12

        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Dim rowsWritten As Integer = 0

        Using con As New MySqlConnection(constr)
            con.Open()

            Dim page As Integer = 1
            Dim keepGoing As Boolean = True

            Do While keepGoing

                Dim url As String = String.Format("{0}?token={1}&event_id={2}&page={3}",
                                                  ApiBase, Uri.EscapeDataString(token),
                                                  Uri.EscapeDataString(eventid), page)

                Dim json As String
                Using wc As New WebClient()
                    wc.Headers("User-Agent") = "QOSFC-Dashboard/1.0"
                    json = wc.DownloadString(url)
                End Using

                Dim root As JObject = JObject.Parse(json)
                Dim items As JArray = TryCast(root("item_grosses"), JArray)

                If items Is Nothing OrElse items.Count = 0 Then
                    keepGoing = False
                Else
                    For Each item As JObject In items
                        StoreRow(con, item, eventid)
                        rowsWritten += 1
                    Next
                    page += 1
                End If
            Loop
        End Using

        Return rowsWritten
    End Function

    ' Upsert a single item_grosses record. Mirrors the check-in / turnstile
    ' mapping that import_JSON.php used, so the downstream view is unchanged.
    Private Shared Sub StoreRow(ByVal con As MySqlConnection, ByVal item As JObject, ByVal fixtureid As String)

        Dim transactionDatestamp As String = GetStr(item, "transaction_datestamp")
        Dim refNumber As String = GetStr(item, "ref_number")
        Dim sectionName As String = GetStr(item, "section_name")
        Dim itemTypeTitle As String = GetStr(item, "item_type_title")
        Dim eventName As String = GetStr(item, "event_name")
        Dim checkedInAt As String = GetStr(item, "checked_in_at")
        Dim checkedOutAt As String = GetStr(item, "checked_out_at")
        Dim checkInUserId As String = GetStr(item, "check_in_user_id")
        Dim itemTypeType As String = GetStr(item, "item_type_type")

        Dim checkedInValue As Integer
        Dim checkedInTurnstile As String

        If Not String.IsNullOrEmpty(checkedInAt) Then
            If Not String.IsNullOrEmpty(checkedOutAt) Then
                checkedInValue = 0
                checkedInTurnstile = ""
            Else
                checkedInValue = 1
                checkedInTurnstile = "notset"
            End If
        Else
            checkedInValue = 0
            checkedInTurnstile = ""
        End If

        Select Case checkInUserId
            Case "3169864" : checkedInTurnstile = "turnstile1"
            Case "3169868" : checkedInTurnstile = "turnstile3"
            Case "3169871" : checkedInTurnstile = "turnstile4"
            Case "3299860" : checkedInTurnstile = "turnstile22"
            Case "3299862" : checkedInTurnstile = "turnstile16"
            Case "3299865" : checkedInTurnstile = "turnstile17"
            Case "3299867" : checkedInTurnstile = "turnstileE1"
            Case "3299868" : checkedInTurnstile = "turnstileE2"
            Case "3299870" : checkedInTurnstile = "turnstileE3"
            Case "3299872" : checkedInTurnstile = "turnstileE4"
        End Select

        ' Upsert into the LIVE table the dashboard view reads. Keyed on
        ' (fixtureid, TicketCoRef) so re-polls update a ticket in place and rows
        ' from different fixtures never collide (see migration.sql for the key).
        Const sql As String =
            "INSERT INTO ticketco_matchsales_live " &
            "(PurchaseDate, TicketCoRef, GroundArea, TicketType, EventName, QtySold, QtyCheckedIn, CheckedInDate, CheckedInOperator, ticketcotickettype, fixtureid) " &
            "VALUES (@PurchaseDate, @TicketCoRef, @GroundArea, @TicketType, @EventName, 1, @QtyCheckedIn, @CheckedInDate, @CheckedInOperator, @ticketcotickettype, @fixtureid) " &
            "ON DUPLICATE KEY UPDATE " &
            "PurchaseDate=VALUES(PurchaseDate), GroundArea=VALUES(GroundArea), TicketType=VALUES(TicketType), " &
            "EventName=VALUES(EventName), QtySold=VALUES(QtySold), QtyCheckedIn=VALUES(QtyCheckedIn), " &
            "CheckedInDate=VALUES(CheckedInDate), CheckedInOperator=VALUES(CheckedInOperator), " &
            "ticketcotickettype=VALUES(ticketcotickettype)"

        Using cmd As New MySqlCommand(sql, con)
            cmd.Parameters.AddWithValue("@PurchaseDate", NullIfEmpty(transactionDatestamp))
            cmd.Parameters.AddWithValue("@TicketCoRef", refNumber)
            cmd.Parameters.AddWithValue("@GroundArea", sectionName)
            cmd.Parameters.AddWithValue("@TicketType", itemTypeTitle)
            cmd.Parameters.AddWithValue("@EventName", eventName)
            cmd.Parameters.AddWithValue("@QtyCheckedIn", checkedInValue)
            cmd.Parameters.AddWithValue("@CheckedInDate", NullIfEmpty(checkedInAt))
            cmd.Parameters.AddWithValue("@CheckedInOperator", checkedInTurnstile)
            cmd.Parameters.AddWithValue("@ticketcotickettype", itemTypeType)
            cmd.Parameters.AddWithValue("@fixtureid", fixtureid)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    ''' <summary>
    ''' The TicketCo event id of the next home match, from
    ''' qosfclivecopy.vw_nexthomematch (its ticketcoid column). Empty if none.
    ''' </summary>
    Public Shared Function GetCurrentFixtureId() As String
        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)
            con.Open()
            Using cmd As New MySqlCommand("SELECT ticketcoid FROM qosfclivecopy.vw_nexthomematch LIMIT 1", con)
                Dim o As Object = cmd.ExecuteScalar()
                If o Is Nothing OrElse o Is DBNull.Value Then Return ""
                Return o.ToString()
            End Using
        End Using
    End Function

    ''' <summary>
    ''' Record the fixture the dashboard should display, in the single-row
    ''' dashboard_current_fixture table that vw_ticketsalesreport filters by.
    ''' Keeps the view in step with whatever the poller is importing.
    ''' </summary>
    Public Shared Sub SetCurrentFixture(ByVal fixtureid As String)
        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)
            con.Open()
            Using cmd As New MySqlCommand(
                "INSERT INTO dashboard_current_fixture (id, fixtureid) VALUES (1, @f) " &
                "ON DUPLICATE KEY UPDATE fixtureid = @f", con)
                cmd.Parameters.AddWithValue("@f", If(String.IsNullOrEmpty(fixtureid), CObj(DBNull.Value), fixtureid))
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Shared Function GetStr(ByVal item As JObject, ByVal name As String) As String
        Dim tok As JToken = item(name)
        If tok Is Nothing OrElse tok.Type = JTokenType.Null Then
            Return ""
        End If
        Return tok.ToString()
    End Function

    Private Shared Function NullIfEmpty(ByVal value As String) As Object
        If String.IsNullOrEmpty(value) Then
            Return DBNull.Value
        End If
        Return value
    End Function

End Class


' =============================================================================
'  TicketcoPoller
'  ---------------------------------------------------------------------------
'  Application-scoped background loop. One timer, one fixture at a time. Each
'  tick imports from the API and then broadcasts the refreshed snapshot, in
'  that order, so a dashboard update always reflects a completed import.
'
'  A re-entrancy guard means a slow import can never overlap the next tick.
' =============================================================================
Public NotInheritable Class TicketcoPoller

    Private Sub New()
    End Sub

    Private Shared ReadOnly SyncRoot As New Object()
    Private Shared _timer As Timer
    Private Shared _eventId As String = ""             ' last resolved/polled fixture
    Private Shared _manualEventId As String = ""       ' "" = auto (next home match)
    Private Shared _intervalSeconds As Integer = 0
    Private Shared _running As Integer = 0            ' 0 = idle, 1 = a tick is in progress
    Public Shared Property LastError As String = ""
    Public Shared Property LastRunUtc As DateTime = DateTime.MinValue

    ''' <summary>The fixture most recently resolved/polled (config default before the first tick).</summary>
    Public Shared ReadOnly Property ActiveEventId As String
        Get
            If Not String.IsNullOrEmpty(_eventId) Then
                Return _eventId
            End If
            Dim cfg As String = ConfigurationManager.AppSettings("TicketcoActiveEventId")
            If Not String.IsNullOrEmpty(cfg) Then
                Return cfg
            End If
            Return "924084"
        End Get
    End Property

    ''' <summary>True when the fixture is auto-picked from vw_nexthomematch (no manual override).</summary>
    Public Shared ReadOnly Property IsAuto As Boolean
        Get
            Return String.IsNullOrEmpty(_manualEventId)
        End Get
    End Property

    ' Decide which fixture to poll/display: an explicit manual override wins;
    ' otherwise the next home match; otherwise the Web.config fallback.
    Private Shared Function ResolveFixture() As String
        If Not String.IsNullOrEmpty(_manualEventId) Then Return _manualEventId
        Try
            Dim f As String = TicketcoImporter.GetCurrentFixtureId()
            If Not String.IsNullOrEmpty(f) Then Return f
        Catch
            ' fall through to the configured default
        End Try
        Dim cfg As String = ConfigurationManager.AppSettings("TicketcoActiveEventId")
        If Not String.IsNullOrEmpty(cfg) Then Return cfg
        Return "924084"
    End Function

    ''' <summary>True while the poll timer is armed.</summary>
    Public Shared ReadOnly Property IsRunning As Boolean
        Get
            Return _timer IsNot Nothing
        End Get
    End Property

    ''' <summary>The interval (seconds) the poll timer is currently using.</summary>
    Public Shared ReadOnly Property IntervalSeconds As Integer
        Get
            Return _intervalSeconds
        End Get
    End Property

    ''' <summary>
    ''' Start (or retarget) the poll loop. Pass an empty eventid for auto mode
    ''' (poll the next home match); pass a fixture id to force a manual override.
    ''' </summary>
    Public Shared Sub Start(ByVal eventid As String, ByVal intervalSeconds As Integer)
        If intervalSeconds < 5 Then intervalSeconds = 5   ' don't hammer the API
        SyncLock SyncRoot
            _manualEventId = If(eventid, "").Trim()
            _intervalSeconds = intervalSeconds
            If _timer Is Nothing Then
                _timer = New Timer(AddressOf TimerCallback, Nothing, 0, intervalSeconds * 1000)
            Else
                _timer.Change(0, intervalSeconds * 1000)
            End If
        End SyncLock
    End Sub

    ''' <summary>Stop the poll loop (leaves the last snapshot on screen).</summary>
    Public Shared Sub [Stop]()
        SyncLock SyncRoot
            If _timer IsNot Nothing Then
                _timer.Dispose()
                _timer = Nothing
            End If
        End SyncLock
    End Sub

    ''' <summary>
    ''' Optionally start the loop at application startup, driven purely by
    ''' Web.config (TicketcoAutoStart / TicketcoActiveEventId / TicketcoPollSeconds).
    ''' </summary>
    Public Shared Sub AutoStartFromConfig()
        Dim autoStart As Boolean
        Boolean.TryParse(ConfigurationManager.AppSettings("TicketcoAutoStart"), autoStart)
        If Not autoStart Then Return

        Dim seconds As Integer
        If Not Integer.TryParse(ConfigurationManager.AppSettings("TicketcoPollSeconds"), seconds) Then
            seconds = 30
        End If
        ' Empty fixture => auto mode (poll the next home match).
        Start("", seconds)
    End Sub

    Private Shared Sub TimerCallback(ByVal state As Object)
        ' Skip this tick if the previous one is still running.
        If Interlocked.CompareExchange(_running, 1, 0) <> 0 Then
            Return
        End If
        Try
            Tick()
        Finally
            Interlocked.Exchange(_running, 0)
        End Try
    End Sub

    ' The single place where import and push happen together, in order.
    Private Shared Sub Tick()
        Dim eventid As String = ResolveFixture()
        _eventId = eventid
        Try
            ' Point the dashboard view at this fixture first, so even if the API
            ' call fails the view still shows the right (current) match.
            TicketcoImporter.SetCurrentFixture(eventid)
            TicketcoImporter.FetchAndStore(eventid)
            LastError = ""
        Catch ex As Exception
            ' Import failed -- still broadcast so the page shows the last known
            ' figures plus the error, rather than going stale silently.
            LastError = ex.Message
        End Try

        LastRunUtc = DateTime.UtcNow

        Try
            Dim hub As New ChatHubticketco()
            hub.PopulateDataTable(eventid)
        Catch
            ' Broadcast failures are swallowed; the next tick will retry.
        End Try
    End Sub

End Class
