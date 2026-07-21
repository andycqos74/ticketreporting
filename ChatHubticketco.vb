Imports System
Imports System.Web
Imports Microsoft.AspNet.SignalR
Imports System.Data
Imports System.Windows

Imports System.Configuration
Imports MySql.Data.MySqlClient
Imports Newtonsoft.Json
Imports System.Net
Imports System.IO

Public Class ChatHubticketco
    Inherits Hub




    Public Sub ImportJSON()


        'Dim req As WebRequest = WebRequest.Create("http://phpupdates.qosfc.com/import_json.php")
        'Dim res As WebResponse = req.GetResponse()
        'Dim sr As StreamReader = New StreamReader(res.GetResponseStream())
        'Dim html As String = sr.ReadToEnd()

        ''then run populate datatable to send values back to page
        'PopulateDataTable("924084")



        '***********send fixture ID from javascript on control page

        '**********add event ID to JSON URL



        '''add JSON import here - copy from json test
        'Dim tbl = New DataTable
        'ServicePointManager.Expect100Continue = True
        'ServicePointManager.SecurityProtocol = CType(3072, SecurityProtocolType)
        '  Dim json As String = (New WebClient).("http://mysafeinfo.com/api/data?list=englishmonarchs&format=json")



        'tbl = JsonConvert.DeserializeObject(Of DataTable)(json)



        ''**********add to DB
        'For Each dr As DataRow In tbl.Rows

        '    Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        '    Using con As MySqlConnection = New MySqlConnection(constr)
        '        Using cmd As MySqlCommand = New MySqlCommand("REPLACE INTO ticketco_matchsales (PurchaseDate,  TicketCoRef,GroundArea,TicketType, EventName, QtySold, QtyCheckedIn, CheckedInDate, CheckedInOperator) VALUES (@PurchaseDate, @TicketCoRef,@GroundArea,@TicketType, @EventName, @QtySold, @QtyCheckedIn, @CheckedInDate, @CheckedInOperator)")
        '            Using sda As MySqlDataAdapter = New MySqlDataAdapter()
        '                cmd.Parameters.AddWithValue("@PurchaseDate", dr.Item("Column_1"))

        '                cmd.Parameters.AddWithValue("@TicketCoRef", dr.Item("Column_7"))
        '                cmd.Parameters.AddWithValue("@GroundArea", dr.Item("Column_8"))

        '                cmd.Parameters.AddWithValue("@TicketType", dr.Item("Column_13"))

        '                cmd.Parameters.AddWithValue("@EventName", dr.Item("Column_12"))
        '                cmd.Parameters.AddWithValue("@QtySold", dr.Item("Column_35"))
        '                cmd.Parameters.AddWithValue("@QtyCheckedIn", dr.Item("Column_36"))
        '                cmd.Parameters.AddWithValue("@CheckedInDate", dr.Item("Column_37"))
        '                cmd.Parameters.AddWithValue("@CheckedInOperator", dr.Item("Column_38"))


        '                '***********get eventname from import???

        '                cmd.Connection = con
        '                con.Open()
        '                cmd.ExecuteNonQuery()
        '                con.Close()
        '            End Using
        '        End Using
        '    End Using

        'Next


        '***********get eventname from import??? - send to populate data table



    End Sub





    Public Sub PopulateDataTable(ByVal eventid As String)

        If eventid = "" Then
            eventid = "924084"
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

        Dim fixturename As String


        '        sqlstring = "Select * From qosfctickets.ticketco_matchsales Where fixtureid = '" & eventid & "';"
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









                            ''''''AwayCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "tickettype Like '%away%'")))
                            ''''''HomeCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "tickettype  Like '%home%'")))
                            ''''''AwaySold = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea <> 'MATCHDAY WALK-UP' AND tickettype Like '%away%'")))
                            '''''''old --------HomeSold = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "tickettype not Like '%away%' and tickettype Not Like '%season%' And tickettype Not Like '%shirt draw%' And tickettype Not Like '%walk%' AND tickettype not like '%comp%'  AND tickettype not like '%executive%'")))
                            ''''''HomeSold = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea <> 'MATCHDAY WALK-UP'' AND tickettype Like '%HOME%'  AND ticketcotickettype not Like '%season%'")))
                            ''''''''ticketcotype <> season and tickettype <> walk ticketype <> away

                            ''''''other = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "tickettype  Like '%other%'")))

                            '''''TotalCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", String.Empty)))

                            '''''WalkUpCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'MATCHDAY WALK-UP' AND tickettype not Like '%comp%'")))
                            '''''AwayWalkUpCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'MATCHDAY WALK-UP' AND (CheckedInOperator = '3299870' OR CheckedInOperator = '3299872')")))
                            '''''HomeWalkUpCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'MATCHDAY WALK-UP' AND (CheckedInOperator <> '3299870' AND CheckedInOperator <> '3299872')")))




                            '''''''old-----OnlineCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "tickettype Not Like '%season%' And tickettype Not Like '%shirt draw%' And tickettype Not Like '%walk%' AND tickettype not like '%comp%'  AND tickettype not like '%executive%'")))
                            ''''''OnlineCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea <> 'MATCHDAY WALK-UP'  AND ticketcotickettype not like '%season%' AND tickettype not Like '%comp%' AND tickettype not Like '%carer%'")))
                            '''''''ticketcotype <> season and tickettype <> walk


                            '''''''old-----OnlineSold = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "tickettype Not Like '%season%' And tickettype Not Like '%shirt draw%' And tickettype Not Like '%walk%' AND tickettype not like '%comp%'  AND tickettype not like '%executive%'")))
                            ''''''OnlineSold = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea <> 'MATCHDAY WALK-UP' AND tickettype not Like '%comp%' AND ticketcotickettype not like '%season%'  AND tickettype not Like '%carer")))
                            '''''''ticketcotype <> season and tickettype <> walk


                            ''''''SeasonTicketsCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "ticketcotickettype Like '%season%'  AND tickettype not Like '%comp%'  AND tickettype not Like '%carer")))

                            ''''''CompsCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "tickettype  Like '%comp%'")))
                            '''''''ticketcotype = season

                            '''''''******************* normal data for checked in against section ******************************************************************

                            ''''''BDS1CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'SECTION 1 - BDS DIGITAL STAND'")))
                            ''''''BDS2CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'SECTION 2 - BDS DIGITAL STAND'")))
                            ''''''BDS3CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'SECTION 3 - BDS DIGITAL STAND'")))
                            ''''''BDS4CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'SECTION 4 - BDS DIGITAL STAND'")))
                            ''''''BDS5CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'SECTION 5 - BDS DIGITAL STAND'")))
                            ''''''BDS6CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'SECTION 6 - BDS DIGITAL STAND'")))
                            ''''''BDS7CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'SECTION 7 - BDS DIGITAL STAND'")))
                            ''''''BDS8CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'SECTION 8 - BDS DIGITAL STAND'")))
                            ''''''BDS9CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'SECTION 9 - BDS DIGITAL STAND'")))
                            ''''''OakbankCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'OAKBANK SERVICES TERRACE'")))
                            ''''''TerreglesCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'TERREGLES STREET TERRACE'")))
                            ''''''Alpha1CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'SECTION 1 - MAIN STAND'")))
                            ''''''Alpha2CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'SECTION 2 - MAIN STAND'")))
                            ''''''Alpha3CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'SECTION 3 - MAIN STAND'")))
                            ''''''Alpha4CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "groundarea = 'SECTION 4 - MAIN STAND'")))



                            '**********************************************************************************************************************************

                            '******************* temp data to show sold **************************************************************************************

                            'BDS1CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'SECTION 1 - BDS DIGITAL STAND'")))
                            'BDS2CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'SECTION 2 - BDS DIGITAL STAND'")))
                            'BDS3CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'SECTION 3 - BDS DIGITAL STAND'")))
                            'BDS4CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'SECTION 4 - BDS DIGITAL STAND'")))
                            'BDS5CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'SECTION 5 - BDS DIGITAL STAND'")))
                            'BDS6CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'SECTION 6 - BDS DIGITAL STAND'")))
                            'BDS7CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'SECTION 7 - BDS DIGITAL STAND'")))
                            'BDS8CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'SECTION 8 - BDS DIGITAL STAND'")))
                            'BDS9CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'SECTION 9 - BDS DIGITAL STAND'")))
                            'OakbankCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'OAKBANK SERVICES TERRACE'")))
                            'TerreglesCheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'TERREGLES STREET TERRACE'")))
                            'Alpha1CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'SECTION 1 - MAIN STAND'")))
                            'Alpha2CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'SECTION 2 - MAIN STAND'")))
                            'Alpha3CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'SECTION 3 - MAIN STAND'")))
                            'Alpha4CheckedIn = CheckNull(Convert.ToString(dt.Compute("SUM(QTYSold)", "groundarea = 'SECTION 4 - MAIN STAND'")))

                            '**********************************************************************************************************************************

                            '''''AlphaTS1 = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "CheckedInOperator = '3169864'")))
                            '''''AlphaTS2 = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "CheckedInOperator = '3169868' OR CheckedInOperator = '3169871'")))
                            '''''EncTS1 = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "CheckedInOperator = '3299860'")))
                            '''''TerraceTS1 = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "CheckedInOperator = '3299862' OR CheckedInOperator = '3299865'")))
                            '''''BDSTS1 = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "CheckedInOperator = '3299867'  OR CheckedInOperator = '3299868'")))
                            '''''BDSTS2 = CheckNull(Convert.ToString(dt.Compute("SUM(QTYCheckedIn)", "CheckedInOperator = '3299870' OR CheckedInOperator = '3299872'")))





                            'HomeCheckedIn walkup checked in
                            'AwayCheckedIn walkup checked in - from tunrstile

                            ReportedCrowd = CInt(OnlineSold) + CInt(SeasonTicketsCheckedIn) + CInt(WalkUpCheckedIn) + CInt(other)



                            'Clients.All.broadcastMessage(TotalCheckedIn, WalkUpCheckedIn, OnlineCheckedIn, OnlineSold, SeasonTicketsCheckedIn, AwaySold, HomeSold, AwayCheckedIn, HomeCheckedIn, BDS1CheckedIn, BDS2CheckedIn, BDS3CheckedIn, BDS4CheckedIn, BDS5CheckedIn, BDS7CheckedIn, BDS8CheckedIn, BDS9CheckedIn, OakbankCheckedIn, TerreglesCheckedIn, Alpha1CheckedIn, Alpha2CheckedIn, Alpha3CheckedIn, Alpha4CheckedIn, AlphaTS1, AlphaTS2, EncTS1, TerraceTS1, BDSTS1, BDSTS2, "Last Update : " & DateTime.Now.ToString(" HH:mm:ss"), BDS6CheckedIn, ReportedCrowd, other, CompsCheckedIn, fixturename, "OK")

                            Dim hubContext = GlobalHost.ConnectionManager.GetHubContext(Of ChatHubticketco)()
                            hubContext.Clients.All.broadcastMessage(TotalCheckedIn, WalkUpCheckedIn, OnlineCheckedIn, OnlineSold, SeasonTicketsCheckedIn, AwaySold, HomeSold, AwayCheckedIn, HomeCheckedIn, BDS1CheckedIn, BDS2CheckedIn, BDS3CheckedIn, BDS4CheckedIn, BDS5CheckedIn, BDS7CheckedIn, BDS8CheckedIn, BDS9CheckedIn, OakbankCheckedIn, TerreglesCheckedIn, Alpha1CheckedIn, Alpha2CheckedIn, Alpha3CheckedIn, Alpha4CheckedIn, AlphaTS1, AlphaTS2, EncTS1, TerraceTS1, BDSTS1, BDSTS2, "Last Update : " & DateTime.Now.ToString(" HH:mm:ss"), BDS6CheckedIn, ReportedCrowd, other, CompsCheckedIn, fixturename, "OK")


                        End Using
                    End Using
                End Using
            End Using




        Catch ex As Exception


            'Clients.All.broadcastMessage(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ex)


            Dim hubContext = GlobalHost.ConnectionManager.GetHubContext(Of ChatHubticketco)()
            hubContext.Clients.All.broadcastMessage(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ex)
        End Try






    End Sub

    Private Function CheckNull(ByRef value As String) As String
        If String.IsNullOrEmpty(value) Then
            value = "0"
        End If
        Return value
    End Function



End Class
