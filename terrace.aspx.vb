Imports MySql.Data.MySqlClient
Imports System.Data
Imports System.Configuration



Public Class terrace
    Inherits System.Web.UI.Page

    Public saleseasonid As Integer
    Public terraceid As Integer = 5
    Public homeoraway As String = "H"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        saleseasonid = Request.QueryString("fixtureid")
        homeoraway = Request.QueryString("homeoraway")

        If saleseasonid = "2216" Then

            fixturetitle.InnerText = "ICT - FRIDAY 4th DECEMBER"
            terraceid = 6

        ElseIf saleseasonid = "2219" Then
            fixturetitle.InnerText = "DUNDEE - SATURDAY 26th DECEMBER"
            terraceid = 6

        ElseIf saleseasonid = "2221" Then
            fixturetitle.InnerText = "AYR - SATURDAY 2nd JANUARY"
            terraceid = 6

        ElseIf saleseasonid = "2360" Then
            fixturetitle.InnerText = "HOME TERRACE : QUEENS PARK - SATURDAY 10TH JULY"
            terraceid = 6

        ElseIf saleseasonid = "2368" Then

            If homeoraway = "A" Then
                fixturetitle.InnerText = "AWAY TERRACE : KILMARNOCK - SATURDAY 7TH AUG"
                terraceid = 7
            Else
                fixturetitle.InnerText = "HOME TERRACE : KILMARNOCK - SATURDAY 7TH AUG"
                terraceid = 6
            End If


        End If

            If Not Me.IsPostBack Then
            Me.BindGrid("0")
            LBSearchrecordcount.Text = "0"
            ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
        Else


        End If

    End Sub

    Private Sub BindGrid(ByVal searchterm As String)
        Dim sqlstring As String

        If searchterm = "0" Then
            sqlstring = "SELECT * FROM vw_terrace_status WHERE saleseasonID = " & saleseasonid & " AND terraceID = " & terraceid & ";"

        Else
            sqlstring = "SELECT * FROM vw_terrace_status WHERE (SaleID = '" & searchterm & "' OR ticketid = '" & searchterm & "' OR ticketname like '%" & searchterm & "%' OR ticketemail like '%" & searchterm & "%' OR ticketpostcode like '%" & searchterm & "%') AND saleseasonID = " & saleseasonid & " AND terraceID = " & terraceid & ";"
        End If


        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)
            Using cmd As New MySqlCommand(sqlstring)
                Using sda As New MySqlDataAdapter()
                    cmd.Connection = con
                    sda.SelectCommand = cmd
                    Using dt As New DataTable()
                        sda.Fill(dt)
                        GridView1.DataSource = dt
                        GridView1.DataBind()
                    End Using
                End Using
            End Using
        End Using

        If searchterm = "0" Then
            LBTotalrecordcount.Text = GridView1.Rows.Count.ToString

        Else
            sqlstring = "Select * FROM vw_terrace_status WHERE (SaleID = '" & searchterm & "' OR ticketname like '%" & searchterm & "%') AND saleseasonID = " & saleseasonid & ";"
        End If

        LBSearchrecordcount.Text = GridView1.Rows.Count.ToString


    End Sub
    Protected Sub OnRowUpdating(ByVal sender As Object, ByVal e As GridViewUpdateEventArgs)
        Dim row As GridViewRow = GridView1.Rows(e.RowIndex)

        Dim SQLstr As String
        Dim saleid As Integer = (TryCast(row.FindControl("LBSaleID"), Label)).Text
        Dim ticketidstring As String = (TryCast(row.FindControl("LBTicketID"), Label)).Text
        Dim ticketid As Integer

        Dim terracetypeid As Integer = (TryCast(row.FindControl("DDType"), DropDownList)).SelectedValue
        Dim terracestatusid As Integer = (TryCast(row.FindControl("DDStatus"), DropDownList)).SelectedValue
        Dim ticketname As String = (TryCast(row.FindControl("txtName"), TextBox)).Text
        Dim ticketemail As String = (TryCast(row.FindControl("txtemail"), TextBox)).Text
        Dim ticketpostcode As String = (TryCast(row.FindControl("txtpostcode"), TextBox)).Text
        Dim ticketDOBraw As String = (TryCast(row.FindControl("txtDOB"), TextBox)).Text
        Dim ticketDOB As String
        Dim ticketaddress As String = (TryCast(row.FindControl("txtaddress"), TextBox)).Text
        Dim lastupdate As String = Year(Now()) & "-" & Month(Now()) & "-" & Day(Now()) & " " & Hour(Now()) & ":" & Minute(Now()) & ":" & Second(Now())

        If ticketDOBraw <> "" Then
            ticketDOB = Year(ticketDOBraw) & "-" & Month(ticketDOBraw) & "-" & Day(ticketDOBraw)
        Else
            ticketDOB = ""
        End If


        If ticketidstring = "" Then
            ticketid = 0
        Else
            ticketid = CInt(ticketidstring)

        End If

        'If ticketid Is DBNull Then
        '    ticketid = 0

        'End If

        ' get last ticketid if seat status is sold and ticketid doesnt already exist
        If ticketid < 1919 Then

            ticketid = GetTicketID()


        End If


        SQLstr = "Update terrace_sales SET "
        SQLstr &= "saleseasonID = " & saleseasonid
        SQLstr &= ", "
        SQLstr &= "terraceid = " & terraceid
        SQLstr &= ", "
        SQLstr &= "terracetypeid = " & terracetypeid
        SQLstr &= ", "
        SQLstr &= "terracestatusid = " & terracestatusid
        SQLstr &= ", "
        SQLstr &= "ticketname = '" & ticketname & "'"
        SQLstr &= ", "
        SQLstr &= "ticketemail = '" & ticketemail & "'"
        SQLstr &= ", "

        If ticketDOB <> "" Then
            SQLstr &= "ticketDOB = '" & ticketDOB & "'"
        Else
            SQLstr &= "ticketDOB = null"
        End If


        SQLstr &= ", "
        SQLstr &= "ticketaddress = '" & ticketaddress & "'"
        SQLstr &= ", "
        SQLstr &= "ticketpostcode = '" & ticketpostcode & "'"
        SQLstr &= ", "
        SQLstr &= "terracelastupdated = '" & lastupdate & "' "
        SQLstr &= ", "

        If ticketid = 0 Then
            SQLstr &= "ticketid = null "
        Else

            SQLstr &= "ticketid = " & ticketid & " "
        End If

        SQLstr &= "WHERE SaleID = " & saleid


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

        GridView1.EditIndex = -1
        Me.BindGrid(ticketid)


        Me.txtSearchTerm.Text = ticketid


    End Sub

    Protected Sub Insert(ByVal sender As Object, ByVal e As EventArgs)

        Dim SQLstr As String
        '   Dim saleid As Integer


        Dim terracetypeid As Integer = DDnewType.SelectedValue
        Dim terracestatusid As Integer = DDnewStatus.SelectedValue
        Dim ticketname As String = NewtxtName.Value
        Dim ticketemail As String = NewtxtEmail.Value
        Dim ticketDOBraw As String = NewtxtDOB.Value
        Dim ticketDOB As String
        Dim ticketaddress As String = NewtxtAddress.Value
        Dim ticketpostcode As String = NewtxtPostcode.Value
        Dim lastupdate As String = Year(Now()) & "-" & Month(Now()) & "-" & Day(Now()) & " " & Hour(Now()) & ":" & Minute(Now()) & ":" & Second(Now())
        Dim ticketid As Integer

        If ticketDOBraw <> "" Then
            ticketDOB = Year(ticketDOBraw) & "-" & Month(ticketDOBraw) & "-" & Day(ticketDOBraw)
        Else
            ticketDOB = ""
        End If



        ticketid = GetTicketID()




        SQLstr = "INSERT INTO terrace_sales SET "
        SQLstr &= "saleseasonID = " & saleseasonid
        SQLstr &= ", "
        SQLstr &= "terraceid = " & terraceid
        SQLstr &= ", "
        SQLstr &= "terracetypeid = " & terracetypeid
        SQLstr &= ", "
        SQLstr &= "terracestatusid = " & terracestatusid
        SQLstr &= ", "
        SQLstr &= "ticketname = '" & ticketname & "'"
        SQLstr &= ", "
        SQLstr &= "ticketemail = '" & ticketemail & "'"
        SQLstr &= ", "
        If ticketDOB <> "" Then
            SQLstr &= "ticketDOB = '" & ticketDOB & "'"
        Else
            SQLstr &= "ticketDOB = null"
        End If
        SQLstr &= ", "
        SQLstr &= "ticketaddress = '" & ticketaddress & "'"
        SQLstr &= ", "
        SQLstr &= "ticketpostcode = '" & ticketpostcode & "'"
        SQLstr &= ", "
        SQLstr &= "terracelastupdated = '" & lastupdate & "' "
        SQLstr &= ", "
        SQLstr &= "ticketid = " & ticketid & " "



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

        DDnewType.SelectedValue = 0
        NewtxtName.Value = ""
        NewtxtEmail.Value = ""
        NewtxtPostcode.Value = ""
        NewtxtAddress.Value = ""
        NewtxtDOB.Value = ""

        Try


            '    ''add code to retrieve saleid from DB by matching variables above
            '    Dim sqlstr2 As String
            '    sqlstr2 = "SELECT * FROM terrace_sales WHERE "
            '    sqlstr2 &= "saleseasonID = " & saleseasonid
            '    sqlstr2 &= " AND "
            '    sqlstr2 &= "terraceid = " & terraceid
            '    sqlstr2 &= " AND "
            '    sqlstr2 &= "terracetypeid = " & terracetypeid
            '    sqlstr2 &= " AND "
            '    sqlstr2 &= "terracestatusid = " & terracestatusid
            '    sqlstr2 &= " AND "
            '    sqlstr2 &= "ticketname = '" & ticketname & "'"
            '    sqlstr2 &= " AND "
            '    sqlstr2 &= "ticketemail = '" & ticketemail & "'"
            '    sqlstr2 &= " AND "
            '    If ticketDOB <> "" Then
            '        sqlstr2 &= "ticketDOB = '" & ticketDOB & "'"
            '    Else
            '        sqlstr2 &= "ticketDOB is null"
            '    End If
            '    sqlstr2 &= " AND "
            '    sqlstr2 &= "ticketaddress = '" & ticketaddress & "'"
            '    sqlstr2 &= " AND "
            '    sqlstr2 &= "ticketpostcode = '" & ticketpostcode & "'"
            '    sqlstr2 &= " AND "
            '    sqlstr2 &= "terracelastupdated = '" & lastupdate & "' "
            '    sqlstr2 &= " AND "
            '    sqlstr2 &= "ticketid = '" & ticketid & "' "



            '    Dim newsaleid As Int16
            '    Dim constr2 As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            '    Using con2 As New MySqlConnection(constr2)
            '        Using cmd2 As New MySqlCommand(SQLstr2)
            '            Using sda2 As New MySqlDataAdapter()
            '                cmd2.Connection = con2
            '                sda2.SelectCommand = cmd2
            '                Using dt As New DataTable()
            '                    sda2.Fill(dt)

            '                    If dt.Rows.Count > 0 Then
            '                        newsaleid = dt.Rows(0).Item(0)
            '                    Else
            '                        newsaleid = 0
            '                    End If


            '                End Using
            '            End Using
            '        End Using
            '    End Using

            txtSearchTerm.Text = ticketid.ToString
            Me.BindGrid(ticketid)
            GridView1.Visible = True
        Catch ex As Exception

        End Try

        LBTotalrecordcount.Text = (CInt(LBTotalrecordcount.Text) + 1).ToString

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


    Protected Sub OnRowEditing(sender As Object, e As GridViewEditEventArgs)
        GridView1.EditIndex = e.NewEditIndex


        Me.BindGrid(Me.txtSearchTerm.Text)
    End Sub
    Protected Sub OnRowCancelingEdit(sender As Object, e As EventArgs)

        GridView1.EditIndex = -1
        Me.BindGrid(Me.txtSearchTerm.Text)
    End Sub

    Protected Sub SearchData(ByVal sender As Object, ByVal e As EventArgs)

        If txtSearchTerm.Text = "" Then
            Me.BindGrid("abcdefghijk")
            GridView1.Visible = "false"

        Else

            Me.BindGrid(Me.txtSearchTerm.Text.Trim())
            GridView1.Visible = "true"

        End If


    End Sub

    Protected Sub SearchDataAll(ByVal sender As Object, ByVal e As EventArgs)
        txtSearchTerm.Text = ""
        Me.BindGrid("0")
        GridView1.Visible = "true"

    End Sub

End Class
