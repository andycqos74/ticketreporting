Imports System
Imports System.Web
Imports Microsoft.AspNet.SignalR
Imports System.Data
Imports System.Windows

Imports System.Configuration
Imports MySql.Data.MySqlClient

Namespace SignalRChat
    Public Class ChatHub
        Inherits Hub

        Dim currentseason As String = "15"
        Dim standid As Int16 = 1
        Public Sub Send(ByVal name As String, ByVal message As String)
            Clients.All.broadcastMessage("message", name, message)

        End Sub

        Public Sub Setcssclass(ByVal seat As String, ByVal cssclass As String, ByVal othercssclass As String)
            'split seat
            Dim seatrow As String = Left(seat, 1)
            Dim seatnumber As String = Mid(seat, 2, 2)
            Dim SQLstr As String


            If othercssclass = "selectedother" Then


                SQLstr = "INSERT INTO seat_exceptions SET standID = " & standid & ", section = 9, SeatRow = '" & seatrow & "', SeatNumber = '" & seatnumber & "', ExceptionTypeID = 7"

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

                deleteException(seatrow, seatnumber)

            End If



            Clients.Caller.broadcastMessage("setcss", seat, "", "", "", "", "", "", cssclass, "", "")

            Clients.Others.broadcastMessage("setcss", seat, "", "", "", "", "", "", othercssclass, "", "")



        End Sub
        Public Sub deleteException(ByVal seatrow As String, ByVal seatnumber As String)

            Dim SQLstr As String


            SQLstr = "DELETE FROM seat_exceptions WHERE standID = 1 AND SeatRow = '" & seatrow & "' AND SeatNumber = '" & seatnumber & "' AND ExceptionTypeID = 7"
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


        Public Sub Getdetails(ByVal seat As String)

            '   Clients.All.broadcastMessage("hit", "getdetails")
            'split seat into row and number

            Dim seatrow As String = Left(seat, 1)
            Dim seatnumber As String = Mid(seat, 2)


            '  Clients.All.broadcastMessage("card", seatrow, seatnumber, "")
            Try


                Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                Using con As New MySqlConnection(constr)
                    Using cmd As New MySqlCommand("SELECT * FROM vw_seat_status_" & currentseason & "  where StandID = " & standid & " AND SeatRow = '" & seatrow & "' AND SeatNumber = " & seatnumber & " ORDER BY SaleID DESC LIMIT 1")
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


                                    Clients.Caller.broadcastMessage("card", seat, holdername, holderemail, holderpostcode, seattype, seatstatus, "0", "", seatDOB, seatAddress, ticketID)


                                Else
                                    Clients.Caller.broadcastMessage("card", seat, "no match", "")

                                End If


                            End Using
                        End Using
                    End Using
                End Using

            Catch ex As Exception

                Clients.Caller.broadcastMessage("card", "error", ex, "")
            End Try


        End Sub

        Public Sub Updatedetails(ByVal saleseasonID As String, ByVal SeatStandID As String, ByVal SeatSection As String, ByVal Seat As String, ByVal SeatTypeID As String, ByVal SeatStatusID As String, ByVal SeatName As String, ByVal SeatContactemail As String, ByVal SeatPostcode As String, ByVal Card As String, ByVal SeatDOB As String, ByVal SeatAddress As String, ByVal SeatTicketId As String)

            Dim SQLStr As String
            ' Dim saleseasonID = 2
            '  Dim SeatStandID = 1
            ' Dim SeatSection = 0
            Dim seatrow As String = Left(Seat, 1)
            Dim seatnumber As String = Mid(Seat, 2)
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
                SeatPostcode = ""

            End If

            ' get last ticketid if seat status is sold and ticketid doesnt already exist
            If ticketid < 1919 Then

                ticketid = GetTicketID()


            End If

            Try


                Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                Using con As New MySqlConnection(constr)


                    SQLStr = "INSERT INTO seat_sales_" & currentseason & "  SET "

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

                deleteException(seatrow, seatnumber)
                Clients.Caller.broadcastMessage("confirm", Seat, SeatName, SeatContactemail, SeatPostcode, SeatTypeID, SeatStatusID, Card, seatCSSclass, SeatDOB, SeatAddress, ticketid)
                Clients.All.broadcastMessage("save", Seat, SeatName, SeatContactemail, SeatPostcode, SeatTypeID, SeatStatusID, "0", seatCSSclass, SeatDOB, SeatAddress, ticketid)

            Catch ex As Exception
                'broadcast fail and css change
                Clients.Caller.broadcastMessage("fail", "SQL Fail", ex)
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
    End Class
End Namespace

