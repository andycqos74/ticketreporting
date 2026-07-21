Imports System.Drawing
Imports System.Data.SqlClient
Imports MySql.Data.MySqlClient
Imports System.Data

Public Class export_emails
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Dim adapter As New SqlDataAdapter()
        'Dim ds As New DataSet()
        'Dim i As Integer = 0
        'Dim sql As String = Nothing
        'Dim connetionString As String = "Initial Catalog=nopcommerce39;Integrated Security=False;Persist Security Info=False;User ID=nopqosfc32;Password=P@ssword;MultipleActiveResultSets=True"

        'sql = "select FirstName ,LastName,Email,Quantity, AttributeDescription AS AdditionalInfo,  Address1,City,ZipPostalCode,PhoneNumber from vw_AirdrieTickets ORDER BY CreatedOnUtc ASC"
        'Dim connection As New SqlConnection(connetionString)
        'connection.Open()
        'Dim command As New SqlCommand(sql, connection)
        'adapter.SelectCommand = command
        'adapter.Fill(ds)
        'adapter.Dispose()
        'command.Dispose()
        'connection.Close()
        'GridView1.DataSource = ds.Tables(0)
        'GridView1.DataBind()


        LBupdatesections.Visible = False
    End Sub



    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)
        'Tell the compiler that the control is rendered
        'explicitly by overriding the VerifyRenderingInServerForm event.
    End Sub




    Protected Sub btntoCsv_Click(sender As Object, e As EventArgs) Handles btntoCsv.Click

        Response.Clear()
        Response.Buffer = True
        Response.AddHeader("content-disposition", "attachment;filename=email_list_xxxxxxx.csv")
        Response.Charset = ""
        Response.ContentType = "application/text"
        Dim sBuilder As StringBuilder = New System.Text.StringBuilder()
        For index As Integer = 0 To GridView1.HeaderRow.Cells.Count - 1
            sBuilder.Append(GridView1.HeaderRow.Cells(index).Text + ",")
        Next
        sBuilder.Append(vbCr & vbLf)
        For i As Integer = 0 To GridView1.Rows.Count - 1
            For k As Integer = 0 To GridView1.HeaderRow.Cells.Count - 1
                sBuilder.Append(GridView1.Rows(i).Cells(k).Text.Replace(",", "|") + ",")
            Next
            sBuilder.Append(vbCr & vbLf)
        Next
        Response.Output.Write(sBuilder.ToString())
        Response.Flush()
        Response.[End]()







    End Sub
    Protected Sub btnLoadSuccesful_Click(sender As Object, e As EventArgs) Handles btnLoadSuccesful.Click


        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)
            Using cmd As New MySqlCommand("SELECT * FROM qosfctickets.vw_kilmarnockjan_allocation_export_home;")
                Using sda As New MySqlDataAdapter()
                    cmd.Connection = con
                    sda.SelectCommand = cmd
                    Using tableE As New DataTable()
                        sda.Fill(tableE)


                        GridView1.DataSource = tableE
                        GridView1.DataBind()

                    End Using
                End Using
            End Using
        End Using

    End Sub
    Protected Sub btnLoadBDSH_Click(sender As Object, e As EventArgs) Handles btnLoadBDSH.Click


        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)
            Using cmd As New MySqlCommand("SELECT * FROM qosfctickets.vw_allpcatedseats_export_kilmarnock WHERE (`SeatSection` < 7);")
                Using sda As New MySqlDataAdapter()
                    cmd.Connection = con
                    sda.SelectCommand = cmd
                    Using tableE As New DataTable()
                        sda.Fill(tableE)


                        GridView1.DataSource = tableE
                        GridView1.DataBind()

                    End Using
                End Using
            End Using
        End Using

    End Sub

    Protected Sub btnLoadBDSA_Click(sender As Object, e As EventArgs) Handles btnLoadBDSA.Click

        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)
            Using cmd As New MySqlCommand("SELECT * FROM qosfctickets.vw_allpcatedseats_export_kilmarnock WHERE (`SeatSection` > 6);")
                Using sda As New MySqlDataAdapter()
                    cmd.Connection = con
                    sda.SelectCommand = cmd
                    Using tableE As New DataTable()
                        sda.Fill(tableE)


                        GridView1.DataSource = tableE
                        GridView1.DataBind()

                    End Using
                End Using
            End Using
        End Using

    End Sub

    Protected Sub btnLoadPortland_Click(sender As Object, e As EventArgs) Handles btnLoadPortland.Click

        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)
            Using cmd As New MySqlCommand("SELECT * FROM qosfctickets.vw_terrace_allocation_export_home;")
                Using sda As New MySqlDataAdapter()
                    cmd.Connection = con
                    sda.SelectCommand = cmd
                    Using tableE As New DataTable()
                        sda.Fill(tableE)


                        GridView1.DataSource = tableE
                        GridView1.DataBind()

                    End Using
                End Using
            End Using
        End Using

    End Sub

    Protected Sub btnLoadTerregles_Click(sender As Object, e As EventArgs) Handles btnLoadTerregles.Click

        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)
            Using cmd As New MySqlCommand("SELECT * FROM qosfctickets.vw_terrace_allocation_export_away;")
                Using sda As New MySqlDataAdapter()
                    cmd.Connection = con
                    sda.SelectCommand = cmd
                    Using tableE As New DataTable()
                        sda.Fill(tableE)


                        GridView1.DataSource = tableE
                        GridView1.DataBind()

                    End Using
                End Using
            End Using
        End Using

    End Sub

    Protected Sub btnUpdateSections_Click(sender As Object, e As EventArgs) Handles btnUpdateSections.Click

        Try


            Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con As New MySqlConnection(constr)
                Using cmd As New MySqlCommand("update qosfctickets.seat_sales_match set seatsection = 1 where saleseasonid = 2368 AND seatnumber > 0 and seatnumber < 16 AND saleid > 0;")
                    Using sda As New MySqlDataAdapter()
                        cmd.Connection = con
                        sda.SelectCommand = cmd
                        Using tableE As New DataTable()
                            sda.Fill(tableE)
                        End Using
                    End Using
                End Using
            End Using

            '  Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con As New MySqlConnection(constr)
                Using cmd As New MySqlCommand("update qosfctickets.seat_sales_match set seatsection = 2 where saleseasonid = 2368 AND seatnumber > 15 and seatnumber < 37 AND saleid > 0;")
                    Using sda As New MySqlDataAdapter()
                        cmd.Connection = con
                        sda.SelectCommand = cmd
                        Using tableE As New DataTable()
                            sda.Fill(tableE)
                        End Using
                    End Using
                End Using
            End Using

            '    Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con As New MySqlConnection(constr)
                Using cmd As New MySqlCommand("update qosfctickets.seat_sales_match set seatsection = 3 where saleseasonid = 2368 AND seatnumber > 36 and seatnumber < 58 AND saleid > 0;")
                    Using sda As New MySqlDataAdapter()
                        cmd.Connection = con
                        sda.SelectCommand = cmd
                        Using tableE As New DataTable()
                            sda.Fill(tableE)
                        End Using
                    End Using
                End Using
            End Using

            '    Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con As New MySqlConnection(constr)
                Using cmd As New MySqlCommand("update qosfctickets.seat_sales_match set seatsection = 4 where saleseasonid = 2368 AND seatnumber > 57 and seatnumber < 79 AND saleid > 0;")
                    Using sda As New MySqlDataAdapter()
                        cmd.Connection = con
                        sda.SelectCommand = cmd
                        Using tableE As New DataTable()
                            sda.Fill(tableE)
                        End Using
                    End Using
                End Using
            End Using

            '     Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con As New MySqlConnection(constr)
                Using cmd As New MySqlCommand("update qosfctickets.seat_sales_match set seatsection = 5 where saleseasonid = 2368 AND seatnumber > 78 and seatnumber < 100 AND saleid > 0;")
                    Using sda As New MySqlDataAdapter()
                        cmd.Connection = con
                        sda.SelectCommand = cmd
                        Using tableE As New DataTable()
                            sda.Fill(tableE)
                        End Using
                    End Using
                End Using
            End Using

            '    Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con As New MySqlConnection(constr)
                Using cmd As New MySqlCommand("update qosfctickets.seat_sales_match set seatsection = 7 where saleseasonid = 2368 AND seatnumber > 120 and seatnumber < 142 AND saleid > 0;")
                    Using sda As New MySqlDataAdapter()
                        cmd.Connection = con
                        sda.SelectCommand = cmd
                        Using tableE As New DataTable()
                            sda.Fill(tableE)
                        End Using
                    End Using
                End Using
            End Using

            '     Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con As New MySqlConnection(constr)
                Using cmd As New MySqlCommand("update qosfctickets.seat_sales_match set seatsection = 8 where saleseasonid = 2368 AND seatnumber > 141 and seatnumber < 163 AND saleid > 0;")
                    Using sda As New MySqlDataAdapter()
                        cmd.Connection = con
                        sda.SelectCommand = cmd
                        Using tableE As New DataTable()
                            sda.Fill(tableE)
                        End Using
                    End Using
                End Using
            End Using

            '     Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con As New MySqlConnection(constr)
                Using cmd As New MySqlCommand("update qosfctickets.seat_sales_match set seatsection = 9 where saleseasonid = 2368 AND seatnumber > 162 and seatnumber < 178 AND saleid > 0;")
                    Using sda As New MySqlDataAdapter()
                        cmd.Connection = con
                        sda.SelectCommand = cmd
                        Using tableE As New DataTable()
                            sda.Fill(tableE)
                        End Using
                    End Using
                End Using
            End Using





            LBupdatesections.Text = "Sections Updated"
            LBupdatesections.Visible = True



        Catch ex As Exception

            LBupdatesections.Text = "There was an error"
            LBupdatesections.Visible = True

        End Try




    End Sub







End Class

