Imports System.IO
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Imports MySql.Data.MySqlClient

Imports System.Collections.Generic
Imports DocumentFormat.OpenXml.Packaging
Imports DocumentFormat.OpenXml.Spreadsheet

Public Class WebForm1_excel
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load





    End Sub

    Protected Sub ImportExcel(sender As Object, e As EventArgs)
        'Save the uploaded Excel file.
        Dim filePath As String = Server.MapPath("~/Files/") + Path.GetFileName(FileUpload1.PostedFile.FileName)
        FileUpload1.SaveAs(filePath)

        'Open the Excel file in Read Mode using OpenXml.
        Using doc As SpreadsheetDocument = SpreadsheetDocument.Open(filePath, False)
            'Read the first Sheet from Excel file.
            Dim sheet As Sheet = doc.WorkbookPart.Workbook.Sheets.GetFirstChild(Of Sheet)()

            'Get the Worksheet instance.
            Dim worksheet As Worksheet = TryCast(doc.WorkbookPart.GetPartById(sheet.Id.Value), WorksheetPart).Worksheet

            'Fetch all the rows present in the Worksheet.
            Dim rows As IEnumerable(Of Row) = worksheet.GetFirstChild(Of SheetData)().Descendants(Of Row)()

            'Create a new DataTable.
            Dim dt As New DataTable()

            'Loop through the Worksheet rows.
            For Each row As Row In rows
                'Use the first row to add columns to DataTable.
                If row.RowIndex.Value = 1 Then
                    For Each cell As Cell In row.Descendants(Of Cell)()
                        dt.Columns.Add(GetValue(doc, cell))
                    Next
                Else
                    'Add rows to DataTable.
                    dt.Rows.Add()
                    Dim i As Integer = 0
                    For Each cell As Cell In row.Descendants(Of Cell)()
                        dt.Rows(dt.Rows.Count - 1)(i) = GetValue(doc, cell)
                        i += 1
                    Next
                End If
            Next
            GridView1.DataSource = dt
            GridView1.DataBind()



            Try
                For Each dr As DataRow In dt.Rows
                    Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                    Using con As MySqlConnection = New MySqlConnection(constr)
                        Using cmd As MySqlCommand = New MySqlCommand("INSERT INTO ticketco_seasontickets (PurchaseDate, TicketID, TicketCoRef,GroundArea,SeatRow,SeatNumber,TicketType,BuyerFirstName,BuyerLastName) VALUES (@PurchaseDate, @TicketID, @TicketCoRef,@GroundArea,@SeatRow,@SeatNumber,@TicketType,@BuyerFirstName,@BuyerLastName)")
                            Using sda As MySqlDataAdapter = New MySqlDataAdapter()
                                cmd.Parameters.AddWithValue("@PurchaseDate", dr.Item("Purchase timestamp"))
                                cmd.Parameters.AddWithValue("@TicketID", dr.Item("Ticket ID"))
                                cmd.Parameters.AddWithValue("@TicketCoRef", dr.Item("Reference Number"))
                                cmd.Parameters.AddWithValue("@GroundArea", dr.Item("Section Name"))
                                cmd.Parameters.AddWithValue("@SeatRow", dr.Item("Row"))
                                cmd.Parameters.AddWithValue("@SeatNumber", dr.Item("Seat"))
                                cmd.Parameters.AddWithValue("@TicketType", dr.Item("Ticket Type name"))
                                cmd.Parameters.AddWithValue("@BuyerFirstName", dr.Item("Ticketbuyer First name"))
                                cmd.Parameters.AddWithValue("@BuyerLastName", dr.Item("Ticketbuyer last name"))
                                cmd.Connection = con
                                con.Open()
                                cmd.ExecuteNonQuery()
                                con.Close()
                            End Using
                        End Using
                    End Using
                    Console.WriteLine(dr.Item(0))
                Next
            Catch ex As Exception
                LabelStatus.Text = vbCrLf & ex.Message

            End Try

        End Using
    End Sub

    Private Function GetValue(doc As SpreadsheetDocument, cell As Cell) As String


        Dim value As String = cell.CellValue.InnerText


        If cell.DataType IsNot Nothing AndAlso cell.DataType.Value = CellValues.SharedString Then
            Return doc.WorkbookPart.SharedStringTablePart.SharedStringTable.ChildElements.GetItem(Integer.Parse(value)).InnerText
        End If



        Return value
    End Function













End Class