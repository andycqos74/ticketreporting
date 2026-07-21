Imports MySql.Data.MySqlClient

Public Class stand
    Inherits System.Web.UI.Page
    Dim MainStandSeats As Int16 = 96
    Dim MainStandSeatsSection1 As Int16 = 25
    Dim MainStandSeatsSection2 As Int16 = 48
    Dim MainStandSeatsSection3 As Int16 = 70
    Dim MainStandSeatsSection4 As Int16 = 96
    Dim MainStandRows As Int16 = 17
    Dim MainStandRowsString As String = "QPONMLKJIHGFEDCBA"
    Dim numbersections As Int16 = 4
    Dim currentseason As String = "16"

    Dim standid As Int16 = 1

    Dim CardCount As Int16 = 1
    Public PubSeatNumber As Int16 = 0
    Public PubSeatStateCss As String = ""
    Public CBStandID As Int16 = 1
    Public loadcount As Int16


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load



        Render_Full_Map_MainStand()



    End Sub

    Public Sub Render_Full_Map_MainStand()

        Dim MatchedException As Boolean = False
        Dim exceptiontype As Int16 = 0
        'populate exceptions DG - Stand 1, 

        PNplan.Controls.Add(New LiteralControl("<div class='container-fluid'>"))

        'Try
        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)
            Using cmd As New MySqlCommand("SELECT * FROM vw_seat_exceptions where StandID =  " & standid & ";")
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
                            Using cmd2 As New MySqlCommand("SELECT *  FROM vw_seat_status_" & currentseason & " WHERE saleid IN (SELECT MAX(saleid) FROM vw_seat_status_" & currentseason & " GROUP BY standid, seatrow,seatnumber) AND StandID= " & standid & ";")
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

                                        For c = 1 To numbersections 'number of sections

                                            If c = 1 Then

                                                sectionstart = 0
                                                sectionend = MainStandSeatsSection1

                                            ElseIf c = 2 Then

                                                sectionstart = MainStandSeatsSection1

                                                sectionend = MainStandSeatsSection2

                                            ElseIf c = 3 Then

                                                sectionstart = MainStandSeatsSection2
                                                sectionend = MainStandSeatsSection3

                                            ElseIf c = 4 Then

                                                sectionstart = MainStandSeatsSection3
                                                sectionend = MainStandSeatsSection4

                                                'ElseIf c = 5 Then

                                                '    sectionstart = MainStandSeatsSection4
                                                '    sectionend = mainStandSeatsSection5

                                                'ElseIf c = 6 Then

                                                '    sectionstart = mainStandSeatsSection5
                                                '    sectionend = mainStandSeatsSection6

                                                'ElseIf c = 7 Then

                                                '    sectionstart = mainStandSeatsSection6
                                                '    sectionend = mainStandSeatsSection7

                                                'ElseIf c = 8 Then

                                                '    sectionstart = mainStandSeatsSection7
                                                '    sectionend = mainStandSeatsSection8

                                                'ElseIf c = 9 Then

                                                '    sectionstart = mainStandSeatsSection8
                                                '    sectionend = mainStandSeatsSection9

                                            End If


                                            '*******************Start  of section 1 ****************************

                                            ''section 1 
                                            PNplan.Controls.Add(New LiteralControl("<div class='col-sm-12 col-md-6 mt-2 '><h5 class='p-0 m-0 background-darkblue'>Section " & c & "</h5>"))

                                            ''add seat rows - dflex divs
                                            'one holder first


                                            ''cycle through columns
                                            For r = 0 To MainStandRows
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
                                                            PNplan.Controls.Add(New LiteralControl("<div class=' flex-fill minwidth " & GetChar(MainStandRowsString, r) & " ' style='border: 1px solid black;'>" & GetChar(MainStandRowsString, r) & "</div>"))
                                                        Else

                                                            ''cycle through exception gridview to check if seat has exception

                                                            '********************** replace with lookup in dataset *****************************************************************************
                                                            Try

                                                                Dim foundRows() As DataRow
                                                                '  foundRows = table.Select("SeatRow = 'F' AND SeatNumber = 71")
                                                                foundRows = tableE.Select("SeatRow = '" & GetChar(MainStandRowsString, r) & "' AND SeatNumber = '" & s.ToString & "'")

                                                                exceptiontype = 0
                                                                If foundRows.Length > 0 Then 'matched exception
                                                                    '     LBOutput.Text &= " - Found:" & foundRows.Length.ToString

                                                                    If foundRows(0)(4) <> 7 Then
                                                                        MatchedException = True

                                                                        Dim exceptcss As String = foundRows(0)(5)

                                                                        If s < 10 Then
                                                                            PNplan.Controls.Add(New LiteralControl("<div class='flex-fill " & exceptcss & "' id='" & GetChar(MainStandRowsString, r) & s.ToString & "'><span style='visibility: hidden;'>0" & s & "</span></div>"))
                                                                        Else
                                                                            PNplan.Controls.Add(New LiteralControl("<div class='flex-fill " & exceptcss & "' id='" & GetChar(MainStandRowsString, r) & s.ToString & "'><span style='visibility: hidden;'>" & s & "</span></div>"))
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

                                                                    foundRowsS = tableS.Select("SeatRow = '" & GetChar(MainStandRowsString, r) & "' AND SeatNumber = '" & s.ToString & "'")


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



                                                                PNplan.Controls.Add(New LiteralControl("<div Class='flex-fill cellhover " & PubSeatStateCss & "'  id='" & GetChar(MainStandRowsString, r) & s.ToString & "'>"))

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