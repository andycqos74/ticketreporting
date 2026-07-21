Imports MySql.Data.MySqlClient
Imports System.Data

Public Class ballot_list
    Inherits System.Web.UI.Page
    Public currentseason As String
    Public homeoraway As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        currentseason = Request.QueryString("fixtureid")    '"15"
        SeasonID.InnerText = currentseason

        homeoraway = Request.QueryString("homeoraway")

        render_list()

    End Sub

    Public Sub render_list()

        Dim selectedstatus1 As String = ""
        Dim selectedstatus2 As String = ""
        Dim selectedstatus3 As String = ""
        Dim selectedstatus4 As String = ""
        Dim selectedstatus5 As String = ""
        Dim selectedstatus6 As String = ""
        Dim selectedstatus7 As String = ""
        Dim selectedstatus8 As String = ""
        Dim selectedstatus9 As String = ""

        Dim sqlstring As String

        If homeoraway = "A" Then

            sqlstring = "SELECT DISTINCT * FROM vw_ballot_list where fixtureid =  " & currentseason & " AND rawseat = 'AWAY' group by seasonticketnumber, email order by ballotentryid;"

        Else
            sqlstring = "SELECT DISTINCT * FROM vw_ballot_list where fixtureid =  " & currentseason & " AND rawseat <> 'AWAY' group by seasonticketnumber, email order by ballotentryid;"

        End If

        'Try
        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)

            Using cmd As New MySqlCommand(sqlstring)
                Using sda As New MySqlDataAdapter()
                    cmd.Connection = con
                    sda.SelectCommand = cmd
                    Using tableE As New DataTable()
                        sda.Fill(tableE)


                        Dim nmbrows As Int16 = tableE.Rows.Count - 1
                        Dim entrycount As Int16 = 0
                        Dim spectatorcount As Int16 = 0
                        Dim uncheckedcount As Int16 = 0
                        Dim checkedcorrect As Int16 = 0
                        Dim checkedincorrect As Int16 = 0
                        Dim selectedcount As Int16 = 0
                        Dim notselectedcount As Int16 = 0
                        Dim allocatedcount As Int16 = 0
                        Dim mainallocatedcount As Int16 = 0
                        Dim terraceallocatedcount As Int16 = 0
                        Dim excludedcount As Int16 = 0

                        Dim terracepref As Int16 = 0
                        Dim seatpref As Int16 = 0
                        Dim nopref As Int16 = 0




                        If nmbrows > -1 Then 'not no results




                            'loop through rows

                            For r = 0 To nmbrows

                                '***TODO - update css classes from status of entry from DB
                                Dim entrybordercss As String = ""
                                Dim entrybackcss As String = ""
                                Dim bottomborder As String = ""

                                selectedstatus1 = ""
                                selectedstatus2 = ""
                                selectedstatus3 = ""
                                selectedstatus4 = ""
                                selectedstatus5 = ""
                                selectedstatus6 = ""
                                selectedstatus7 = ""
                                selectedstatus8 = ""
                                selectedstatus9 = ""





                                Dim fantotal As Int16

                                If tableE(r)(20) <> 6 Then

                                    If tableE(r)(12) = "true" Then 'check for carer
                                        fantotal = CInt(tableE(r)(14)) + 1

                                    Else
                                        fantotal = CInt(tableE(r)(14))
                                    End If

                                    spectatorcount = spectatorcount + fantotal


                                    entrycount = entrycount + 1

                                Else

                                    spectatorcount = spectatorcount + fantotal
                                    entrycount = entrycount + 1
                                    fantotal = CInt(tableE(r)(14))


                                End If


                                If tableE(r)(20) = 1 Then
                                    selectedstatus1 = "selected"
                                    entrybordercss = "border-dark"
                                    uncheckedcount = uncheckedcount + fantotal

                                ElseIf tableE(r)(20) = 2 Then
                                    selectedstatus2 = "selected"
                                    entrybordercss = "border-primary"
                                    checkedcorrect = checkedcorrect + fantotal

                                ElseIf tableE(r)(20) = 3 Then
                                    selectedstatus3 = "selected"
                                    entrybordercss = "border-warning"
                                    checkedincorrect = checkedincorrect + fantotal

                                ElseIf tableE(r)(20) = 4 Then
                                    selectedstatus4 = "selected"
                                    entrybordercss = "border-success"
                                    selectedcount = selectedcount + fantotal

                                ElseIf tableE(r)(20) = 5 Then
                                    selectedstatus5 = "selected"
                                    entrybordercss = "border-danger"
                                    notselectedcount = notselectedcount + fantotal

                                ElseIf tableE(r)(20) = 6 Then
                                    selectedstatus6 = "selected"
                                    entrybordercss = "border-danger"
                                    entrybackcss = "table-danger"
                                    excludedcount = excludedcount + fantotal

                                ElseIf tableE(r)(20) = 7 Then
                                    selectedstatus7 = "selected"
                                    entrybordercss = "border-success"
                                    entrybackcss = "table-success"
                                    allocatedcount = allocatedcount + fantotal

                                ElseIf tableE(r)(20) = 8 Then
                                    selectedstatus8 = "selected"
                                    entrybordercss = "border-success"
                                    entrybackcss = "table-success"
                                    terraceallocatedcount = terraceallocatedcount + fantotal

                                ElseIf tableE(r)(20) = 9 Then
                                    selectedstatus9 = "selected"
                                    entrybordercss = "border-success"
                                    entrybackcss = "table-success"
                                    mainallocatedcount = mainallocatedcount + fantotal

                                End If

                                If Not IsDBNull(tableE(r)(15)) Then



                                    If tableE(r)(15) = "Terrace" Then
                                        terracepref = terracepref + fantotal

                                    ElseIf tableE(r)(15) = "Seated" Then
                                        seatpref = seatpref + fantotal

                                    ElseIf tableE(r)(15) = "No Pref" Then
                                        nopref = nopref + fantotal

                                    End If
                                End If


                                Dim uniqueID As String = Left(tableE(r)(11), 1) & tableE(r)(1)

                                PNlist.Controls.Add(New LiteralControl("<div id = '" & tableE(r)(16) & "' class='border-thick my-4 px-1 border-left border-top border-right border-bottom " & entrybordercss & " " & entrybackcss & "'>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-row'>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>#</label>"))
                                PNlist.Controls.Add(New LiteralControl("<p class=' pb-0'>" & tableE(r)(1) & "</p></div>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Name</label>"))
                                PNlist.Controls.Add(New LiteralControl("<p class=' pb-0'>" & tableE(r)(2) & "</p></div>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Postcode</label>"))
                                PNlist.Controls.Add(New LiteralControl("<p class=' pb-0'>" & tableE(r)(4) & "</p></div>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Age</label>"))
                                PNlist.Controls.Add(New LiteralControl("<p class=' pb-0'>" & tableE(r)(10) & "</p></div>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Carer?</label>"))
                                PNlist.Controls.Add(New LiteralControl("<span class='form-control'>" & tableE(r)(12) & "</span></div>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Low?</label>"))
                                PNlist.Controls.Add(New LiteralControl("<span class='form-control'>" & tableE(r)(13) & "</span></div>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Prefer</label>"))
                                PNlist.Controls.Add(New LiteralControl("<p class=' pb-0'>" & tableE(r)(15) & "</p></div>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Nmb</label>"))
                                PNlist.Controls.Add(New LiteralControl("<p class=' pb-0'>" & fantotal & "</p></div>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Status</label>"))
                                PNlist.Controls.Add(New LiteralControl("<select id='status" & tableE(r)(16) & "' class='form-control'>"))
                                PNlist.Controls.Add(New LiteralControl("<option value='1' " & selectedstatus1 & ">Not Checked</option>"))
                                PNlist.Controls.Add(New LiteralControl("<option value='2' " & selectedstatus2 & ">Checked-Correct</option>"))
                                PNlist.Controls.Add(New LiteralControl("<option value='3' " & selectedstatus3 & ">Checked-Incorrect</option>"))
                                PNlist.Controls.Add(New LiteralControl("<option value='4' " & selectedstatus4 & ">Successful</option>"))
                                PNlist.Controls.Add(New LiteralControl("<option value='5' " & selectedstatus5 & ">Unsuccessful</option>"))
                                PNlist.Controls.Add(New LiteralControl("<option value='6' " & selectedstatus6 & ">Excluded</option>"))
                                PNlist.Controls.Add(New LiteralControl("<option value='7' " & selectedstatus7 & ">BDS Seat Allocated</option>"))
                                PNlist.Controls.Add(New LiteralControl("<option value='9' " & selectedstatus9 & ">Alpha Seat Allocated</option>"))
                                PNlist.Controls.Add(New LiteralControl("<option value='8' " & selectedstatus8 & ">Terrace Allocated</option>"))
                                PNlist.Controls.Add(New LiteralControl("</select></div>"))






                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Notes</label>"))
                                PNlist.Controls.Add(New LiteralControl("<input id='notes" & tableE(r)(16) & "' class='form-control' value='" & tableE(r)(21) & "' /></div>"))





                                PNlist.Controls.Add(New LiteralControl("</div>")) 'end of first row

                                PNlist.Controls.Add(New LiteralControl("<div class='form-row'>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Address</label>"))
                                PNlist.Controls.Add(New LiteralControl("<p class=' pb-0'>" & tableE(r)(3) & "</p></div>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Phone</label>"))
                                PNlist.Controls.Add(New LiteralControl("<p class=' pb-0'>" & tableE(r)(6) & "</p></div>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Email</label>"))
                                PNlist.Controls.Add(New LiteralControl("<p class=' pb-0'>" & tableE(r)(5) & "</p></div>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Type</label>"))
                                PNlist.Controls.Add(New LiteralControl("<p class=' pb-0'>" & tableE(r)(11) & "</p></div>"))

                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Stand</label>"))
                                PNlist.Controls.Add(New LiteralControl("<p class=' pb-0'>" & tableE(r)(7) & "</p></div>"))



                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col'>"))
                                PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>Seat</label>"))
                                PNlist.Controls.Add(New LiteralControl("<p class='pb-0'>" & tableE(r)(22) & "</p></div>"))


                                PNlist.Controls.Add(New LiteralControl("<div class='form-group col text-right'>"))

                                PNlist.Controls.Add(New LiteralControl(" <button id='" & tableE(r)(16) & "'  class='savechanges" & tableE(r)(16) & " btn btn-primary' type='submit' class='btn btn-primary'>SAVE</button></div>"))


                                PNlist.Controls.Add(New LiteralControl("</div>")) 'end of second row



                                If CInt(tableE(r)(14)) > 1 Then

                                    'call function


                                    gethousehold(tableE(r)(5).ToString) 'change to 1 for seasonticket ID - 5 is email




                                End If


                                PNlist.Controls.Add(New LiteralControl("</div>")) ' end of containing div



                            Next





                            totalentries.InnerText = entrycount & " (" & spectatorcount & ")"
                            Luncheckedcount.InnerText = uncheckedcount
                            Lcheckedcorrect.InnerText = checkedcorrect
                            Lcheckedincorrect.InnerText = checkedincorrect
                            Lselectedcount.InnerText = selectedcount
                            Lnotselectedcount.InnerText = notselectedcount
                            Lallocatedcount.InnerText = allocatedcount
                            Lmainallocatedcount.InnerText = mainallocatedcount
                            Lterraceallocatedcount.InnerText = terraceallocatedcount
                            Lexcludedcount.InnerText = excludedcount

                            Lseatpref.InnerText = seatpref
                            Lterracepref.InnerText = terracepref
                            Lnopref.InnerText = nopref






                        Else
                            PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold'>No records</label>"))
                        End If





                    End Using
                End Using
            End Using
        End Using

    End Sub

    Public Sub gethousehold(ByVal seasonticketid As String)

        '     PNlist.Controls.Add(New LiteralControl("<div class='d-none'>hit sub</div>"))

        'Try
        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)
            Using cmd As New MySqlCommand("select distinct fixtureid, masterseasonticketid, householdseasonticketid, householdname, householdaddress, householdpostcode from household_applications WHERE fixtureid = '" & currentseason & "' AND masterseasonticketid = '" & seasonticketid & "';")
                Using sda As New MySqlDataAdapter()
                    cmd.Connection = con
                    sda.SelectCommand = cmd
                    Using tableH As New DataTable()
                        sda.Fill(tableH)

                        Dim nmbrows As Int16 = tableH.Rows.Count - 1


                        '       PNlist.Controls.Add(New LiteralControl("<div class='d-none'>rows : " & nmbrows & "</div>"))

                        '    If nmbrows > 0 Then 'not no results




                        PNlist.Controls.Add(New LiteralControl("<div class='row'>"))



                            'loop through rows

                            For r = 0 To nmbrows

                                PNlist.Controls.Add(New LiteralControl("<div class='col'>"))
                            PNlist.Controls.Add(New LiteralControl("<h5 class=' mb-0 pb-0'>Household " & r + 1 & "</h5>"))

                            PNlist.Controls.Add(New LiteralControl("<div class='form-group row pb-0 mb-0'>"))
                            PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold col-2'>Season Ticket</label>"))
                            PNlist.Controls.Add(New LiteralControl("<div class='col-10'><p class='pb-0'>" & tableH(r)(2) & "</p></div></div>"))


                            PNlist.Controls.Add(New LiteralControl("<div class='form-group row pb-0 mb-0'>"))
                            PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold col-2'>Name</label>"))
                            PNlist.Controls.Add(New LiteralControl("<div class='col-10'><p class='pb-0'>" & tableH(r)(3) & "</p></div></div>"))


                            PNlist.Controls.Add(New LiteralControl("<div class='form-group row pb-0 mb-0'>"))
                            PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold col-2'>Address</label>"))
                            PNlist.Controls.Add(New LiteralControl("<div class='col-10'><p class='pb-0'>" & tableH(r)(4) & "</p></div></div>"))


                            PNlist.Controls.Add(New LiteralControl("<div class='form-group row pb-0 mb-0'>"))
                            PNlist.Controls.Add(New LiteralControl("<label class='font-weight-bold col-2'>Postcode</label>"))
                            PNlist.Controls.Add(New LiteralControl("<div class='col-10'><p class='pb-0'>" & tableH(r)(5) & "</p></div></div>"))







                            PNlist.Controls.Add(New LiteralControl("</div>"))

                            Next

                        PNlist.Controls.Add(New LiteralControl("</div>")) ' end of row

                        '    End If



                    End Using
                End Using
            End Using
        End Using




    End Sub

End Class