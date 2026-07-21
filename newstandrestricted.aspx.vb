Imports MySql.Data.MySqlClient
Imports System.Data


Public Class newstandrestricted
    Inherits System.Web.UI.Page


    Dim NewStandSeats As Int16 = 177
    Dim newStandSeatsSection1 As Int16 = 15
    Dim newStandSeatsSection2 As Int16 = 36
    Dim newStandSeatsSection3 As Int16 = 57
    Dim newStandSeatsSection4 As Int16 = 78
    Dim newStandSeatsSection5 As Int16 = 99
    Dim newStandSeatsSection6 As Int16 = 120
    Dim newStandSeatsSection7 As Int16 = 141
    Dim newStandSeatsSection8 As Int16 = 162
    Dim newStandSeatsSection9 As Int16 = 177

    Dim newStandRows As Int16 = 13
    Dim newStandRowsString As String = "NMLKJHGFEDCBA"
    Dim numbersections As Int16 = 9
    Public currentseason As String
    Dim standid As Int16 = 3
    Dim homeoraway As String
    Dim startsection As Int16 = 1


    Dim CardCount As Int16 = 1
    Public PubSeatNumber As Int16 = 0
    Public PubSeatStateCss As String = ""
    Public CBStandID As Int16 = 1
    Public loadcount As Int16

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        currentseason = Request.QueryString("fixtureid")    '"15"
        SeasonID.InnerText = currentseason

        homeoraway = Request.QueryString("homeoraway")

        If homeoraway = "A" Then
            startsection = 7 'check actual start section
            numbersections = 9

        ElseIf homeoraway = "H" Then
            startsection = 1
            numbersections = 5
        End If


        If currentseason = "2216" Then

            fixturetitle.InnerText = "ICT - FRIDAY 4th DECEMBER"

        ElseIf currentseason = "2219" Then
            fixturetitle.InnerText = "DUNDEE - SATURDAY 26th DECEMBER"

        ElseIf currentseason = "2221" Then
            fixturetitle.InnerText = "AYR - SATURDAY 2nd JANUARY"
        ElseIf currentseason = "2360" Then
            fixturetitle.InnerText = "NEW STAND : QUEENS PARK - SATURDAY 10TH JULY"
        ElseIf currentseason = "2368" And homeoraway = "H" Then
            fixturetitle.InnerText = "NEW STAND : KILMARNOCK : HOME - SATURDAY 7TH AUG"
        ElseIf currentseason = "2368" And homeoraway = "A" Then
            fixturetitle.InnerText = "NEW STAND : KILMARNOCK : AWAY - SATURDAY 7TH AUG"
        End If

        Render_Full_Map_NewStand()



    End Sub

    Public Sub Render_Full_Map_NewStand()

        Dim MatchedException As Boolean = False
        Dim exceptiontype As Int16 = 0
        'populate exceptions DG - Stand 1, 

        PNplan.Controls.Add(New LiteralControl("<div class='container-fluid'>"))

        'Try
        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)
            Using cmd As New MySqlCommand("SELECT * FROM vw_seat_exceptions where StandID =  " & standid & " AND (SeasonID = 0 or SeasonID = " & currentseason & ");")
                Using sda As New MySqlDataAdapter()
                    cmd.Connection = con
                    sda.SelectCommand = cmd
                    Using tableE As New DataTable()
                        sda.Fill(tableE)

                        'Catch ex As Exception

                        'End Try
                        '******end of seat exceptions   ********************


                        Dim constr2 As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                        Using con2 As New MySqlConnection(constr2)
                            Using cmd2 As New MySqlCommand("SELECT *  FROM vw_seat_status_match WHERE saleid IN (SELECT MAX(saleid) FROM vw_seat_status_match GROUP BY standid, seatrow,seatnumber) AND StandID= " & standid & " AND SaleSeasonID = " & currentseason & ";")
                                Using sda2 As New MySqlDataAdapter()
                                    cmd2.Connection = con2
                                    sda2.SelectCommand = cmd2
                                    Using tableS As New DataTable()
                                        sda2.Fill(tableS)

                                        '******end of seat status  ********************





                                        ''add main containers


                                        PNplan.Controls.Add(New LiteralControl("<div class='row'>"))

                                        ''add section headers
                                        PNplan.Controls.Add(New LiteralControl("<div class='col'><div class='row text-center'>"))

                                        'dim variables for seat loop
                                        Dim sectionstart As Int16
                                        Dim sectionend As Int16

                                        For c = startsection To numbersections 'number of sections

                                            If c = 1 Then

                                                sectionstart = 0
                                                sectionend = newStandSeatsSection1

                                            ElseIf c = 2 Then

                                                sectionstart = newStandSeatsSection1

                                                sectionend = newStandSeatsSection2

                                            ElseIf c = 3 Then

                                                sectionstart = newStandSeatsSection2
                                                sectionend = newStandSeatsSection3

                                            ElseIf c = 4 Then

                                                sectionstart = newStandSeatsSection3
                                                sectionend = newStandSeatsSection4



                                            ElseIf c = 5 Then

                                                sectionstart = newStandSeatsSection4
                                                sectionend = newStandSeatsSection5


                                            ElseIf c = 6 Then

                                                'sectionstart = newStandSeatsSection5
                                                'sectionend = newStandSeatsSection6
                                                Continue For

                                            ElseIf c = 7 Then

                                                sectionstart = newStandSeatsSection6
                                                sectionend = newStandSeatsSection7

                                            ElseIf c = 8 Then

                                                sectionstart = newStandSeatsSection7
                                                sectionend = newStandSeatsSection8

                                            ElseIf c = 9 Then

                                                sectionstart = newStandSeatsSection8
                                                sectionend = newStandSeatsSection9

                                            End If


                                            '*******************Start  of section 1 ****************************

                                            ''section 1 
                                            PNplan.Controls.Add(New LiteralControl("<div class='col-sm-12 col-md-6 mt-2 '><h5 class='p-0 m-0 background-darkblue'>Section " & c & "</h5>"))

                                            ''add seat rows - dflex divs
                                            'one holder first


                                            ''cycle through columns
                                            For r = 0 To newStandRows
                                                MatchedException = False
                                                PNplan.Controls.Add(New LiteralControl("<div class='d-flex flex-row background-white'>"))

                                                If r = 0 Then ' first row, show seat numbers


                                                    For s = sectionstart To sectionend

                                                        If s = sectionstart Then ' first column - set Row label
                                                            PNplan.Controls.Add(New LiteralControl("<div class=' flex-fill minwidth' style='border: 1px solid black; '></div>"))
                                                        Else
                                                            If s < 10 Then
                                                                PNplan.Controls.Add(New LiteralControl("<div id='" & s & "' class='flex-fill ' style='border: 1px solid black;'><span style ='visibility: hidden;'>0</span>" & s & "</div>"))
                                                            Else
                                                                PNplan.Controls.Add(New LiteralControl("<div id='" & s & "' class='flex-fill ' style='border: 1px solid black;' >" & s & "</div>"))
                                                            End If


                                                        End If

                                                    Next s


                                                Else ' for all other rows/columns check for seat exception (ie unsellable), then check for sold status

                                                    For s = sectionstart To sectionend
                                                        MatchedException = False
                                                        If s = sectionstart Then ' first column - show row letter
                                                            PNplan.Controls.Add(New LiteralControl("<div class=' flex-fill minwidth " & GetChar(newStandRowsString, r) & " ' style='border: 1px solid black;'>" & GetChar(newStandRowsString, r) & "</div>"))
                                                        Else

                                                            ''cycle through exception gridview to check if seat has exception

                                                            '********************** replace with lookup in dataset *****************************************************************************
                                                            Try

                                                                Dim foundRows() As DataRow
                                                                '  foundRows = table.Select("SeatRow = 'F' AND SeatNumber = 71")
                                                                foundRows = tableE.Select("SeatRow = '" & GetChar(newStandRowsString, r) & "' AND SeatNumber = '" & s.ToString & "'")

                                                                exceptiontype = 0
                                                                If foundRows.Length > 0 Then 'matched exception
                                                                    '     LBOutput.Text &= " - Found:" & foundRows.Length.ToString

                                                                    If foundRows(0)(4) <> 7 Then
                                                                        MatchedException = True

                                                                        Dim exceptcss As String = foundRows(0)(5)

                                                                        If s < 10 Then
                                                                            PNplan.Controls.Add(New LiteralControl("<div class='flex-fill " & exceptcss & "' id='" & GetChar(newStandRowsString, r) & s.ToString & "'><span style='visibility: hidden;'>0" & s & "</span></div>"))
                                                                        Else
                                                                            PNplan.Controls.Add(New LiteralControl("<div class='flex-fill " & exceptcss & "' id='" & GetChar(newStandRowsString, r) & s.ToString & "'><span style='visibility: hidden;'>" & s & "</span></div>"))
                                                                        End If

                                                                    Else
                                                                        exceptiontype = 7
                                                                    End If

                                                                    '        LBOutput.Text &= (foundRows(0)(6))

                                                                End If
                                                            Catch ex As Exception

                                                            End Try

                                                            '**********************************************************************************************************************************

                                                            'check if seat is sold, only if no exception found

                                                            If MatchedException = False Then ' seat has no exception so check sold status



                                                                '****** replace with lookup in dataset ***********************************************************************************************
                                                                Try
                                                                    Dim foundRowsS() As DataRow

                                                                    foundRowsS = tableS.Select("SeatRow = '" & GetChar(newStandRowsString, r) & "' AND SeatNumber = '" & s.ToString & "'")


                                                                    If foundRowsS.Length > 0 Then 'matched sale


                                                                        PubSeatNumber = foundRowsS(0)(3)
                                                                        PubSeatStateCss = foundRowsS(0)(9)

                                                                    Else

                                                                        PubSeatNumber = 0
                                                                        PubSeatStateCss = "available"

                                                                    End If

                                                                Catch ex As Exception

                                                                End Try

                                                                '**********************************************************************************************************************************




                                                                If exceptiontype = 7 Then
                                                                    PubSeatStateCss = "selectedother"
                                                                End If



                                                                PNplan.Controls.Add(New LiteralControl("<div Class='flex-fill cellhover " & PubSeatStateCss & "'  id='" & GetChar(newStandRowsString, r) & s.ToString & "'>"))

                                                                If s < 10 Then

                                                                    PNplan.Controls.Add(New LiteralControl("<span style='visibility: hidden;'>0" & s & "</span>"))

                                                                Else

                                                                    PNplan.Controls.Add(New LiteralControl("<span style='visibility: hidden;'>" & s & "</span>"))

                                                                End If
                                                                PNplan.Controls.Add(New LiteralControl("</div>"))





                                                            End If
                                                        End If
                                                    Next s


                                                End If
                                                'close row
                                                PNplan.Controls.Add(New LiteralControl("</div>"))
                                            Next r

                                            'close section 1
                                            PNplan.Controls.Add(New LiteralControl("</div>"))


                                            '*****************end of section 1 ************************************
                                        Next c




                                        'close section header
                                        PNplan.Controls.Add(New LiteralControl("</div></div>"))


                                        'close holder 
                                        PNplan.Controls.Add(New LiteralControl("</div>"))


                                        ''close main containers
                                        PNplan.Controls.Add(New LiteralControl("</div> <!--end of main row-->"))
                                        PNplan.Controls.Add(New LiteralControl("</div> <!--end of main row-->"))
                                        PNplan.Controls.Add(New LiteralControl("</div> <!-- end of main container -->"))



                                    End Using
                                End Using
                            End Using
                        End Using

                    End Using
                End Using
            End Using
        End Using
    End Sub




End Class