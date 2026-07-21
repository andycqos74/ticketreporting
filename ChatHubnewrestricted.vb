Imports System
Imports System.Web
Imports Microsoft.AspNet.SignalR
Imports System.Data
Imports System.Windows

Imports System.Configuration
Imports MySql.Data.MySqlClient

Namespace SignalRChatNewRestrict

    Public Class ChatHubnewrestricted
    Inherits Hub
        '   Dim currentseason As String = "1415"
        Dim standid As Int16 = 3


        Public Sub Send(ByVal name As String, ByVal message As String)
            Clients.All.broadcastMessage("message", name, message)

        End Sub

        Public Sub Setcssclass(ByVal seat As String, ByVal cssclass As String, ByVal othercssclass As String, ByVal seasonID As String)
            'split seat
            Dim seatrow As String = Left(seat, 1)
            Dim seatnumber As String = Mid(seat, 2, 3)
            Dim SQLstr As String


            If othercssclass = "selectedother" Then


                SQLstr = "INSERT INTO seat_exceptions SET standID = " & standid & ", section = 9, SeatRow = '" & seatrow & "', SeatNumber = '" & seatnumber & "', seasonid = '" & seasonID & "', ExceptionTypeID = 7"

                Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                Using con As New MySqlConnection(constr)
                    Using cmd As New MySqlCommand(SQLstr)
                        Using sda As New MySqlDataAdapter()
                            cmd.Connection = con
                            sda.SelectCommand = cmd
                            Using dt As New DataTable()
                                sda.Fill(dt)

                            End Using
                        End Using
                    End Using
                End Using

            Else

                deleteException(seatrow, seatnumber, seasonID)

            End If



            Clients.Caller.broadcastMessage("setcss", seat, "", "", "", "", "", "", cssclass, "", "", "", seasonID)

            Clients.Others.broadcastMessage("setcss", seat, "", "", "", "", "", "", othercssclass, "", "", "", seasonID)



        End Sub
        Public Sub deleteException(ByVal seatrow As String, ByVal seatnumber As String, ByVal seasonid As String)

            Dim SQLstr As String


            SQLstr = "DELETE FROM seat_exceptions WHERE standID = " & standid & " AND SeatRow = '" & seatrow & "' AND SeatNumber = '" & seatnumber & "' AND seasonID = '" & seasonid & "' AND ExceptionTypeID = 7"
            Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con As New MySqlConnection(constr)
                Using cmd As New MySqlCommand(SQLstr)
                    Using sda As New MySqlDataAdapter()
                        cmd.Connection = con
                        sda.SelectCommand = cmd
                        Using dt As New DataTable()
                            sda.Fill(dt)

                        End Using
                    End Using
                End Using
            End Using

        End Sub


        Public Sub Getdetails(ByVal seat As String, ByVal seasonID As String)

            '   Clients.All.broadcastMessage("hit", "getdetails")
            'split seat into row and number

            Dim seatrow As String = Left(seat, 1)
            Dim seatnumber As String = Mid(seat, 2)


            '  Clients.All.broadcastMessage("card", seatrow, seatnumber, "")
            Try


                Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                Using con As New MySqlConnection(constr)
                    Using cmd As New MySqlCommand("SELECT * FROM vw_seat_status_match  where SaleSeasonID = " & seasonID & " AND StandID = " & standid & " AND SeatRow = '" & seatrow & "' AND SeatNumber = " & seatnumber & " ORDER BY SaleID DESC LIMIT 1")
                        Using sda As New MySqlDataAdapter()
                            cmd.Connection = con
                            sda.SelectCommand = cmd
                            Using dt As New DataTable()
                                sda.Fill(dt)



                                Dim foundRows() As DataRow
                                '  foundRows = dt.Select("SeatRow = 'F' AND SeatNumber = 24")
                                foundRows = dt.Select("SeatRow = '" & seatrow & "' AND SeatNumber = " & seatnumber & "")



                                If foundRows.Length > 0 Then 'matched exception


                                    'add null checks
                                    Dim holdername As String = foundRows(0)(6)
                                    Dim holderemail As String = foundRows(0)(7)
                                    Dim holderpostcode As String = foundRows(0)(8)
                                    Dim seattype As String = foundRows(0)(4)
                                    Dim seatstatus As String = foundRows(0)(5)
                                    Dim seatcss As String = foundRows(0)(9)
                                    Dim seatDOB As String = foundRows(0)(11)
                                    Dim seatAddress As String = foundRows(0)(12)
                                    Dim ticketID As String = foundRows(0)(14)


                                    Clients.Caller.broadcastMessage("card", seat, holdername, holderemail, holderpostcode, seattype, seatstatus, "0", "", seatDOB, seatAddress, ticketID, seasonID)


                                Else
                                    Clients.Caller.broadcastMessage("card", seat, "no match", "", "", "", "", "", "", "", "", "", seasonID)

                                End If


                            End Using
                        End Using
                    End Using
                End Using

            Catch ex As Exception

                Clients.Caller.broadcastMessage("card", "error", ex, "", "", "", "", "", "", "", "", "", seasonID)
            End Try


        End Sub

        Public Sub Updatedetails(ByVal saleseasonID As String, ByVal SeatStandID As String, ByVal SeatSection As String, ByVal Seat As String, ByVal SeatTypeID As String, ByVal SeatStatusID As String, ByVal SeatName As String, ByVal SeatContactemail As String, ByVal SeatPostcode As String, ByVal Card As String, ByVal SeatDOB As String, ByVal SeatAddress As String, ByVal SeatTicketId As String)

            Dim SQLStr As String
            ' Dim saleseasonID = 2
            '  Dim SeatStandID = 1
            ' Dim SeatSection = 0
            Dim seatrow As String = Left(Seat, 1)
            Dim seatnumber As String = Mid(Seat, 2, 3)
            'Dim SeatTypeID = 3
            'Dim SeatStatusID = 3
            'Dim SeatName = "SQL INSERT"
            'Dim SeatContactemail = "@sql.com"
            'Dim SeatPostcode = "SQ1 L"
            Dim SeatLastUpdated = Year(Now()) & "-" & Month(Now()) & "-" & Day(Now()) & " " & Hour(Now()) & ":" & Minute(Now()) & ":" & Second(Now())
            Dim seatCSSclass = ""
            Dim ticketid As Int16 = CInt(SeatTicketId)

            If IsNumeric(ticketid) = False Then
                ticketid = 0

            End If

            'reset fields to empty if set to available

            If SeatStatusID = 1 Then

                SeatTypeID = 0
                SeatName = ""
                SeatContactemail = ""
                SeatAddress = ""
                SeatPostcode = ""
                SeatDOB = ""

            End If

            ' get last ticketid if seat status is sold and ticketid doesnt already exist
            If ticketid = 0 Then

                ticketid = GetTicketID()


            End If

            Try


                SeatTypeID = "99"
                SeatDOB = "01/01/1990"
                '       SeatContactemail = "na"
                SeatAddress = "na"
                SeatPostcode = "na"

                Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                Using con As New MySqlConnection(constr)


                    SQLStr = "INSERT INTO seat_sales_match SET "

                    SQLStr &= "saleseasonID = " & saleseasonID
                    SQLStr &= ", "
                    SQLStr &= "SeatStandID = " & SeatStandID
                    SQLStr &= ", "
                    SQLStr &= "SeatSection = " & SeatSection
                    SQLStr &= ", "
                    SQLStr &= "SeatRow = '" & seatrow & "'"
                    SQLStr &= ", "
                    SQLStr &= "SeatNumber = " & seatnumber
                    SQLStr &= ", "
                    SQLStr &= "SeatTypeID = " & SeatTypeID
                    SQLStr &= ", "
                    SQLStr &= "SeatStatusID = " & SeatStatusID
                    SQLStr &= ", "
                    SQLStr &= "SeatName = '" & SeatName & "'"
                    SQLStr &= ", "
                    SQLStr &= "SeatDOB = '" & SeatDOB & "'"
                    SQLStr &= ", "
                    SQLStr &= "SeatContactemail = '" & SeatContactemail & "'"
                    SQLStr &= ", "
                    SQLStr &= "SeatAddress = '" & SeatAddress & "'"
                    SQLStr &= ", "
                    SQLStr &= "SeatPostcode = '" & SeatPostcode & "'"
                    SQLStr &= ", "
                    SQLStr &= "SeatLastUpdated = '" & SeatLastUpdated & "'"
                    SQLStr &= ", "
                    SQLStr &= "TicketID = " & ticketid & ""


                    Using cmd As New MySqlCommand(SQLStr)
                        Using sda As New MySqlDataAdapter()
                            cmd.Connection = con
                            sda.SelectCommand = cmd
                            Using dt As New DataTable()
                                sda.Fill(dt)

                            End Using
                        End Using
                    End Using
                End Using

                ''broadcast success and css change

                If SeatStatusID = 1 Then
                    seatCSSclass = "available"
                ElseIf SeatStatusID = 2 Then
                    seatCSSclass = "provisional"
                ElseIf SeatStatusID = 3 Then
                    seatCSSclass = "sold"

                End If

                deleteException(seatrow, seatnumber, saleseasonID)
                Clients.Caller.broadcastMessage("confirm", Seat, SeatName, SeatContactemail, SeatPostcode, SeatTypeID, SeatStatusID, Card, seatCSSclass, SeatDOB, SeatAddress, ticketid, saleseasonID)
                Clients.All.broadcastMessage("save", Seat, SeatName, SeatContactemail, SeatPostcode, SeatTypeID, SeatStatusID, "0", seatCSSclass, SeatDOB, SeatAddress, ticketid, saleseasonID)

            Catch ex As Exception
                'broadcast fail and css change
                '  Clients.Caller.broadcastMessage("fail", "SQL Fail", ex, "", "", "", "", "", "", "", "", "", "")
                Send("SQL Error", ex.ToString)
            End Try




        End Sub

        Public Function GetTicketID()
            Dim newticketid As Int16

            Try


                Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                Using con As New MySqlConnection(constr)
                    Using cmd As New MySqlCommand("SELECT * FROM ticketids;")
                        Using sda As New MySqlDataAdapter()
                            cmd.Connection = con
                            sda.SelectCommand = cmd
                            Using dt As New DataTable()
                                sda.Fill(dt)

                                Dim foundRows() As DataRow
                                foundRows = dt.Select("idTicketIDs = 1")

                                If foundRows.Length > 0 Then
                                    newticketid = foundRows(0)(1)

                                Else

                                End If


                            End Using
                        End Using
                    End Using
                End Using

            Catch ex As Exception


            End Try


            UpdateTicketID(newticketid)

            Return newticketid

        End Function

        Public Sub UpdateTicketID(newticketid)
            Dim SQLStr As String
            Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con As New MySqlConnection(constr)


                SQLStr = "UPDATE ticketids SET LastUsedID = " & newticketid + 1 & " WHERE idTicketIDs = 1;"

                Using cmd As New MySqlCommand(SQLStr)
                    Using sda As New MySqlDataAdapter()
                        cmd.Connection = con
                        sda.SelectCommand = cmd
                        Using dt As New DataTable()
                            sda.Fill(dt)

                        End Using
                    End Using
                End Using
            End Using


        End Sub

        Public Sub Insertballotentry(ByVal fixtureid As String, ByVal custname As String, ByVal custnumber As String, ByVal custaddress As String, ByVal custpostcode As String, ByVal custemail As String, ByVal custtelephone As String, ByVal cardtypeid As String, ByVal standid As String, ByVal custage As String, ByVal custseat As String, ByVal requirecarer As String, ByVal requestlowrow As String, ByVal NmbApplicants As Int16, ByVal hhticket1 As String, ByVal hhname1 As String, ByVal hhaddress1 As String, ByVal hhpostcode1 As String, ByVal hhticket2 As String, ByVal hhname2 As String, ByVal hhaddress2 As String, ByVal hhpostcode2 As String, ByVal hhticket3 As String, ByVal hhname3 As String, ByVal hhaddress3 As String, ByVal hhpostcode3 As String, ByVal prefarea As String)

            '   Send("got to server save", "")

            Dim SQLStr As String


            Dim seatrow As String = Left(custseat, 1)
            Dim seatnumber As String = Mid(custseat, 2, 3)


            Dim SeatLastUpdated = Year(Now()) & "-" & Month(Now()) & "-" & Day(Now()) & " " & Hour(Now()) & ":" & Minute(Now()) & ":" & Second(Now())
            Dim seatCSSclass = ""

            If standid <> "1" And standid <> "2" Then
                seatrow = ""
                seatnumber = ""
            End If

            If cardtypeid <> "5" And cardtypeid <> "16" Then
                custage = ""
            End If

            If cardtypeid <> "9" And cardtypeid <> "10" And cardtypeid <> "14" And cardtypeid <> "15" And cardtypeid <> "16" Then
                requirecarer = "false"
            End If


            SQLStr = "INSERT INTO ballot_entries SET "

            SQLStr &= "fixtureid = " & fixtureid
            SQLStr &= ", "
            SQLStr &= "seasonticketnumber = '" & custnumber & "'"
            SQLStr &= ", "
            SQLStr &= "name = '" & custname & "'"
            SQLStr &= ", "
            SQLStr &= "address = '" & custaddress & "'"
            SQLStr &= ", "
            SQLStr &= "postcode = '" & custpostcode & "'"
            SQLStr &= ", "
            SQLStr &= "email = '" & custemail & "'"
            SQLStr &= ", "
            SQLStr &= "telephone = '" & custtelephone & "'"
            SQLStr &= ", "
            SQLStr &= "seasonticketstandid = '" & standid & "'"
            SQLStr &= ", "
            SQLStr &= "seasontickettypeid = '" & cardtypeid & "'"
            SQLStr &= ", "
            SQLStr &= "seasonticketrow = '" & seatrow & "'"
            SQLStr &= ", "
            SQLStr &= "seasonticketseatnumber = '" & seatnumber & "'"
            SQLStr &= ", "
            SQLStr &= "entrydate = '" & SeatLastUpdated & "'"
            SQLStr &= ", "
            SQLStr &= "acceptedtandcs = '1'"
            SQLStr &= ", "
            SQLStr &= "age = '" & custage & "'"
            SQLStr &= ", "
            SQLStr &= "carerrequired = '" & requirecarer & "'"
            SQLStr &= ", "
            SQLStr &= "requestedlowrow = '" & requestlowrow & "'"
            SQLStr &= ", "
            SQLStr &= "numberapplicants = " & NmbApplicants & ""
            SQLStr &= ", "
            SQLStr &= "preferarea = '" & prefarea & "'"
            SQLStr &= ", "
            SQLStr &= "rawseat = '" & custseat & "'"
            SQLStr &= ", "
            SQLStr &= "currentstatusID = 1"


            '   Send("SQL", SQLStr)




            Try

                If NmbApplicants > 1 Then

                    If NmbApplicants = 2 Then

                        '         WriteHouseholdApplications(fixtureid, custnumber, hhticket1, hhname1, hhaddress1, hhpostcode1) ''use this for season ticket number
                        WriteHouseholdApplications(fixtureid, custemail, hhticket1, hhname1, hhaddress1, hhpostcode1)

                    End If

                    If NmbApplicants = 3 Then

                        'WriteHouseholdApplications(fixtureid, custnumber, hhticket1, hhname1, hhaddress1, hhpostcode1)
                        'WriteHouseholdApplications(fixtureid, custnumber, hhticket2, hhname2, hhaddress2, hhpostcode2)
                        WriteHouseholdApplications(fixtureid, custemail, hhticket1, hhname1, hhaddress1, hhpostcode1)
                        WriteHouseholdApplications(fixtureid, custemail, hhticket2, hhname2, hhaddress2, hhpostcode2)

                    End If

                    If NmbApplicants = 4 Then

                        'WriteHouseholdApplications(fixtureid, custnumber, hhticket1, hhname1, hhaddress1, hhpostcode1)
                        'WriteHouseholdApplications(fixtureid, custnumber, hhticket2, hhname2, hhaddress2, hhpostcode2)
                        'WriteHouseholdApplications(fixtureid, custnumber, hhticket3, hhname3, hhaddress3, hhpostcode3)

                        WriteHouseholdApplications(fixtureid, custemail, hhticket1, hhname1, hhaddress1, hhpostcode1)
                        WriteHouseholdApplications(fixtureid, custemail, hhticket2, hhname2, hhaddress2, hhpostcode2)
                        WriteHouseholdApplications(fixtureid, custemail, hhticket3, hhname3, hhaddress3, hhpostcode3)

                    End If

                End If


                Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                Using con As New MySqlConnection(constr)




                    Using cmd As New MySqlCommand(SQLStr)
                        Using sda As New MySqlDataAdapter()
                            cmd.Connection = con
                            sda.SelectCommand = cmd
                            Using dt As New DataTable()
                                sda.Fill(dt)

                            End Using
                        End Using
                    End Using
                End Using






                Clients.Caller.broadcastMessage("submit_success", "", "", "", "", "", "", "", "", "", "", "", "")


            Catch ex As Exception
                'broadcast fail and css change
                'Clients.Caller.broadcastMessage("fail", "SQL Fail", ex, "", "", "", "", "", "", "", "", "", "")
                '  Send("SQL Error", ex.ToString)
            End Try


        End Sub


        Public Sub WriteHouseholdApplications(ByVal fixtureid As String, ByVal mainapplicant As String, ByVal ticketnumber As String, ByVal hhname As String, ByVal hhaddress As String, ByVal hhpostcode As String)
            Dim SQLStr As String


            SQLStr = "INSERT INTO household_applications SET "

            SQLStr &= "fixtureID = '" & fixtureid & "'"
            SQLStr &= ", "
            SQLStr &= "masterseasonticketID = '" & mainapplicant & "'"
            SQLStr &= ", "
            SQLStr &= "householdseasonticketID = '" & ticketnumber & "'"
            SQLStr &= ", "
            SQLStr &= "householdname = '" & hhname & "'"
            SQLStr &= ", "
            SQLStr &= "householdaddress = '" & hhaddress & "'"
            SQLStr &= ", "
            SQLStr &= "householdpostcode = '" & hhpostcode & "'"

            Try
                Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                Using con As New MySqlConnection(constr)




                    Using cmd As New MySqlCommand(SQLStr)
                        Using sda As New MySqlDataAdapter()
                            cmd.Connection = con
                            sda.SelectCommand = cmd
                            Using dt As New DataTable()
                                sda.Fill(dt)

                            End Using
                        End Using
                    End Using
                End Using
            Catch ex As Exception

            End Try


        End Sub

        Public Sub Updatestatus(ByVal fixtureid As Int16, seasonticketid As String, rowid As Int16, statusID As Int16, statusnotes As String)

            Dim SQLStr As String

            SQLStr = "UPDATE ballot_entries SET "
            SQLStr &= "currentstatusid = " & statusID
            SQLStr &= ", "
            SQLStr &= "statusnotes = '" & statusnotes & "' "
            SQLStr &= "WHERE ballotentryid = " & rowid

            Try
                Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                Using con As New MySqlConnection(constr)




                    Using cmd As New MySqlCommand(SQLStr)
                        Using sda As New MySqlDataAdapter()
                            cmd.Connection = con
                            sda.SelectCommand = cmd
                            Using dt As New DataTable()
                                sda.Fill(dt)

                            End Using
                        End Using
                    End Using
                End Using



                Clients.All.broadcastMessage("status_update", statusID, statusnotes, "", "", "", "", "", "", "", "", seasonticketid, fixtureid)


            Catch ex As Exception

            End Try




        End Sub

    End Class
End Namespace

