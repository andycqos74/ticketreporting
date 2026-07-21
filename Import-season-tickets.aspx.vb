Imports System.IO
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Imports MySql.Data.MySqlClient

Public Class WebForm1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub Upload(sender As Object, e As EventArgs)
        'Upload and save the file.
        Dim csvPath As String = Server.MapPath("~/Files/") + Path.GetFileName(FileUpload1.PostedFile.FileName)
        FileUpload1.SaveAs(csvPath)



        Try


            Dim lines = IO.File.ReadAllLines(csvPath)
            Dim tbl = New DataTable
            Dim colCount = lines.First.Split(",").Length
            For i As Int32 = 1 To 100 'colCount
                tbl.Columns.Add(New DataColumn("Column_" & i))
            Next
            Dim firstlline As Boolean = True
            For Each line In lines
                If firstlline = True Then
                    firstlline = False
                Else
                    Dim objFields = From field In line.Split(",")
                                    Select CType((field), Object)
                    Dim newRow = tbl.Rows.Add()
                    newRow.ItemArray = objFields.ToArray()
                End If


            Next


            'gridview1.DataSource = tbl

            'gridview1.DataBind()




            For Each dr As DataRow In tbl.Rows
                Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                Using con As MySqlConnection = New MySqlConnection(constr)
                    Using cmd As MySqlCommand = New MySqlCommand("INSERT IGNORE INTO ticketco_seasontickets (PurchaseDate, TicketID, TicketCoRef,GroundArea,SeatRow,SeatNumber,TicketType,BuyerFirstName,BuyerLastName, EventName) VALUES (@PurchaseDate, @TicketID, @TicketCoRef,@GroundArea,@SeatRow,@SeatNumber,@TicketType,@BuyerFirstName,@BuyerLastName, @EventName)")
                        Using sda As MySqlDataAdapter = New MySqlDataAdapter()
                            cmd.Parameters.AddWithValue("@PurchaseDate", dr.Item("Column_1"))
                            cmd.Parameters.AddWithValue("@TicketID", dr.Item("Column_6"))
                            cmd.Parameters.AddWithValue("@TicketCoRef", dr.Item("Column_7"))
                            cmd.Parameters.AddWithValue("@GroundArea", dr.Item("Column_8"))
                            cmd.Parameters.AddWithValue("@SeatRow", dr.Item("Column_9"))
                            cmd.Parameters.AddWithValue("@SeatNumber", dr.Item("Column_10"))
                            cmd.Parameters.AddWithValue("@TicketType", dr.Item("Column_13"))
                            cmd.Parameters.AddWithValue("@BuyerFirstName", dr.Item("Column_21"))
                            cmd.Parameters.AddWithValue("@BuyerLastName", dr.Item("Column_22"))
                            cmd.Parameters.AddWithValue("@EventName", "2022-23 Season Tickets")


                            'cmd.Parameters.AddWithValue("@Printed", 0)
                            cmd.Connection = con
                            con.Open()
                            cmd.ExecuteNonQuery()
                            con.Close()
                        End Using
                    End Using
                End Using

            Next

            LabelStatus.Text = "Import Successful"


        Catch ex As Exception
            LabelStatus.Text = vbCrLf & ex.Message

        End Try






    End Sub

    Protected Sub UploadQuestions(sender As Object, e As EventArgs)
        'Upload and save the file.
        Dim csvPath As String = Server.MapPath("~/Files/") + Path.GetFileName(FileUpload2.PostedFile.FileName)
        FileUpload2.SaveAs(csvPath)
        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString


        Dim lines = IO.File.ReadAllLines(csvPath)
        Dim tbl = New DataTable
        Dim colCount = lines.First.Split(","c).Length
        For i As Int32 = 1 To colCount
            tbl.Columns.Add(New DataColumn("Column_" & i))
        Next
        Dim firstlline As Boolean = True
        For Each line In lines
            If firstlline = True Then
                firstlline = False
            Else
                Dim objFields = From field In line.Split(","c)
                                Select CType((field), Object)
                Dim newRow = tbl.Rows.Add()
                newRow.ItemArray = objFields.ToArray()
            End If


        Next


        'gridview1.DataSource = tbl

        'gridview1.DataBind()


        Try
            For Each dr As DataRow In tbl.Rows

                Using con As MySqlConnection = New MySqlConnection(constr)
                    Using cmd As MySqlCommand = New MySqlCommand("update ticketco_seasontickets SET printname = @printname where TicketCoRef = @ticketcoref AND printname is null and importid > 0;")
                        Using sda As MySqlDataAdapter = New MySqlDataAdapter()
                            cmd.Parameters.AddWithValue("@ticketcoref", dr.Item("Column_5"))
                            cmd.Parameters.AddWithValue("@printname", dr.Item("Column_8"))
                            'cmd.Parameters.AddWithValue("@TicketCoRef", dr.Item("Column_7"))
                            'cmd.Parameters.AddWithValue("@GroundArea", dr.Item("Column_8"))
                            'cmd.Parameters.AddWithValue("@SeatRow", dr.Item("Column_9"))
                            'cmd.Parameters.AddWithValue("@SeatNumber", dr.Item("Column_10"))
                            'cmd.Parameters.AddWithValue("@TicketType", dr.Item("Column_13"))
                            'cmd.Parameters.AddWithValue("@BuyerFirstName", dr.Item("Column_21"))
                            'cmd.Parameters.AddWithValue("@BuyerLastName", dr.Item("Column_22"))
                            'cmd.Parameters.AddWithValue("@Printed", 0)
                            cmd.Connection = con
                            con.Open()
                            cmd.ExecuteNonQuery()
                            con.Close()
                        End Using
                    End Using
                End Using

            Next
            LabelQStatus.Text = "Import Successful"

        Catch ex As Exception
            LabelQStatus.Text = vbCrLf & ex.Message

        End Try


        Dim SQLstr = "update ticketco_seasontickets SET "
        SQLstr &= "printname = concat(ticketco_seasontickets.buyerfirstname, ' ', ticketco_seasontickets.buyerlastname) "

        SQLstr &= "where printname Is null And importid > 0;"



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



End Class