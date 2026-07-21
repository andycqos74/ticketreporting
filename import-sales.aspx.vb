Imports System.IO
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Imports MySql.Data.MySqlClient

Public Class WebFormimportsales
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
            For i As Int32 = 1 To 50 'colCount
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


            gridview1.DataSource = tbl

            gridview1.DataBind()




            For Each dr As DataRow In tbl.Rows
                Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                Using con As MySqlConnection = New MySqlConnection(constr)
                    Using cmd As MySqlCommand = New MySqlCommand("REPLACE INTO ticketco_matchsales (PurchaseDate,  TicketCoRef,GroundArea,TicketType, EventName, QtySold, QtyCheckedIn, CheckedInDate, CheckedInOperator) VALUES (@PurchaseDate, @TicketCoRef,@GroundArea,@TicketType, @EventName, @QtySold, @QtyCheckedIn, @CheckedInDate, @CheckedInOperator)")
                        Using sda As MySqlDataAdapter = New MySqlDataAdapter()
                            cmd.Parameters.AddWithValue("@PurchaseDate", dr.Item("Column_1"))

                            cmd.Parameters.AddWithValue("@TicketCoRef", dr.Item("Column_7"))
                            cmd.Parameters.AddWithValue("@GroundArea", dr.Item("Column_8"))

                            cmd.Parameters.AddWithValue("@TicketType", dr.Item("Column_13"))

                            cmd.Parameters.AddWithValue("@EventName", dr.Item("Column_12"))
                            cmd.Parameters.AddWithValue("@QtySold", dr.Item("Column_35"))
                            cmd.Parameters.AddWithValue("@QtyCheckedIn", dr.Item("Column_36"))
                            cmd.Parameters.AddWithValue("@CheckedInDate", dr.Item("Column_37"))
                            cmd.Parameters.AddWithValue("@CheckedInOperator", dr.Item("Column_38"))




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


End Class