Imports System.Drawing
Imports System.Data.SqlClient
Imports System.Data

Public Class export_orders
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim adapter As New SqlDataAdapter()
        Dim ds As New DataSet()
        Dim i As Integer = 0
        Dim sql As String = Nothing
        Dim connetionString As String = "Initial Catalog=nopcommerce39;Integrated Security=False;Persist Security Info=False;User ID=nopqosfc32;Password=P@ssword;MultipleActiveResultSets=True"

        sql = "select FirstName ,LastName,Email,Quantity, AttributeDescription AS AdditionalInfo,  Address1,City,ZipPostalCode,PhoneNumber from vw_AirdrieTickets ORDER BY CreatedOnUtc ASC"
        Dim connection As New SqlConnection(connetionString)
        connection.Open()
        Dim command As New SqlCommand(sql, connection)
        adapter.SelectCommand = command
        adapter.Fill(ds)
        adapter.Dispose()
        command.Dispose()
        connection.Close()
        GridView1.DataSource = ds.Tables(0)
        GridView1.DataBind()
    End Sub



    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)
            'Tell the compiler that the control is rendered
            'explicitly by overriding the VerifyRenderingInServerForm event.
        End Sub




    Protected Sub btntoCsv_Click(sender As Object, e As EventArgs) Handles btntoCsv.Click

        Response.Clear()
        Response.Buffer = True
        Response.AddHeader("content-disposition", "attachment;filename=gvtocsv.csv")
        Response.Charset = ""
        Response.ContentType = "application/text"
        Dim sBuilder As StringBuilder = New System.Text.StringBuilder()
        For index As Integer = 0 To GridView1.Columns.Count - 1
            sBuilder.Append(GridView1.Columns(index).HeaderText + ","c)
        Next
        sBuilder.Append(vbCr & vbLf)
        For i As Integer = 0 To GridView1.Rows.Count - 1
            For k As Integer = 0 To GridView1.HeaderRow.Cells.Count - 1
                sBuilder.Append(GridView1.Rows(i).Cells(k).Text.Replace(",", "") + ",")
            Next
            sBuilder.Append(vbCr & vbLf)
        Next
        Response.Output.Write(sBuilder.ToString())
        Response.Flush()
        Response.[End]()

    End Sub
End Class