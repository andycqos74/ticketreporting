Imports System.Drawing
Imports System.Data.SqlClient
Imports System.Data
Imports MySql.Data.MySqlClient
Public Class storetoballot
    Inherits System.Web.UI.Page

    Public fixtureid As String
    Public productid As String


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        fixtureid = Request.QueryString("fixtureid")
        productid = Request.QueryString("productid")

        populateGridview()

        If Not Page.IsPostBack Then
            writetoballot()
        End If



    End Sub

    Public Sub populateGridview()

        Dim adapter As New SqlDataAdapter()
        Dim ds As New DataSet()
        Dim i As Integer = 0
        Dim sql As String = Nothing
        Dim connetionString As String = "Initial Catalog=nopcommerce39;Integrated Security=False;Persist Security Info=False;User ID=nopqosfc32;Password=P@ssword;MultipleActiveResultSets=True"

        sql = "select  * FROM vw_PaidProducts WHERE ProductID = " & productid
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

    Public Sub writetoballot()
        Dim ordernumber As String
        Dim name As String = "test"
        Dim postcode As String
        Dim emailaddress As String
        Dim entrydate As String
        Dim ticketype As String = "test"
        Dim numberorders As Int16
        Dim prefarea As String = "99"
        Dim homeoraway As String = "HOME"

        Dim householdemail As String
        Dim householdname As String
        Dim householdpost As String
        Dim householdticket As String

        Try



            If productid = "454" Then
                homeoraway = "HOME"
            ElseIf productid = "456" Then
                homeoraway = "AWAY"
            ElseIf productid = "457" Then
                homeoraway = "AWAY"
            End If

            Dim lastordernumber As String = ""



            For Each row As GridViewRow In GridView1.Rows

                ordernumber = ""

                'get order number

                ordernumber = row.Cells(0).Text
                Response.Write(ordernumber)

                'check for duplicate order number
                If checkduplicate(ordernumber) Then
                    'duplicate found 



                    If ordernumber = lastordernumber Then 'this is a household application
                        '   Response.Write("- write to household<br />")
                        'write to household table




                        If row.Cells(2).Text.Contains("Area of Ground: ") Then
                            householdname = row.Cells(2).Text.Substring(row.Cells(2).Text.IndexOf("Name:"), row.Cells(2).Text.IndexOf("Area of Ground:") - row.Cells(2).Text.IndexOf("Name:"))
                            householdname = householdname.Replace("Name: ", "")

                        Else

                            householdname = Right(row.Cells(2).Text, row.Cells(2).Text.Length() - row.Cells(2).Text.IndexOf("Name:"))
                            householdname = householdname.Replace("Name: ", "")
                        End If

                        householdpost = row.Cells(8).Text
                        householdemail = row.Cells(10).Text



                        householdticket = row.Cells(2).Text.Substring(0, row.Cells(2).Text.IndexOf("Name:"))
                        householdticket = householdticket.Replace("Ticket Type: ", "")

                        writehousehold(ordernumber, householdemail, householdname, householdpost, householdticket)




                    Else
                        Response.Write("- duplicate order<br />")


                    End If


                Else
                    'write to DB
                    Try
                        ' get other values from DB


                        If row.Cells(2).Text.Contains("Area of Ground: ") Then
                            prefarea = Right(row.Cells(2).Text, row.Cells(2).Text.Length() - row.Cells(2).Text.IndexOf("Area of Ground:"))
                            prefarea = prefarea.Replace("Area of Ground:", "")
                        End If

                        '   Response.Write("pref area is " & prefarea & "<br />")

                        If row.Cells(2).Text.Contains("Area of Ground: ") Then
                            name = row.Cells(2).Text.Substring(row.Cells(2).Text.IndexOf("Name:"), row.Cells(2).Text.IndexOf("Area of Ground:") - row.Cells(2).Text.IndexOf("Name:"))
                            name = name.Replace("Name: ", "")

                        Else

                            name = Right(row.Cells(2).Text, row.Cells(2).Text.Length() - row.Cells(2).Text.IndexOf("Name:"))
                            name = name.Replace("Name: ", "")
                        End If

                        '     Response.Write("name is " & name & "<br />")
                        postcode = row.Cells(8).Text
                        emailaddress = row.Cells(10).Text
                        entrydate = row.Cells(16).Text



                        ticketype = row.Cells(2).Text.Substring(0, row.Cells(2).Text.IndexOf("Name:"))
                        ticketype = ticketype.Replace("Ticket Type: ", "")



                        '    Response.Write("ticket type - " & ticketype & "<br />")
                        numberorders = countorders(ordernumber)




                        If ticketype.Contains("Adult") Then

                            ticketype = "3"

                        ElseIf ticketype.Contains("Concession") Then

                            ticketype = "4"


                        ElseIf ticketype.Contains("U16") Then

                            ticketype = "6"

                        ElseIf ticketype.Contains("Junior Blue") Then

                            ticketype = "5"

                        ElseIf ticketype.Contains("Accessible Adult") Then

                            ticketype = "9"

                        ElseIf ticketype.Contains("Accessible Concession") Then

                            ticketype = "10"

                        ElseIf ticketype.Contains("Accessible U16") Then

                            ticketype = "14"



                        End If




                        'convert pref area
                        If prefarea.Contains("Seated") Then

                            prefarea = 3

                        ElseIf prefarea.Contains("Standing") Then

                            prefarea = 4

                        End If


                        If productid = 456 Then
                            prefarea = 3

                        ElseIf productid = 457 Then
                            prefarea = 4

                        End If



                        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
                        Using con As New MySqlConnection(constr)
                            Dim sqlstr As String = ""



                            sqlstr = "insert into ballot_entries"
                            sqlstr &= " SET fixtureid = " & fixtureid
                            sqlstr &= ", "
                            sqlstr &= "seasonticketnumber = '" & ordernumber & "'"
                            sqlstr &= ", "
                            sqlstr &= "name = '" & name & "'"
                            sqlstr &= ", "
                            sqlstr &= "address = ''"
                            sqlstr &= ", "
                            sqlstr &= "postcode = '" & postcode & "'"
                            sqlstr &= ", "
                            sqlstr &= "email = '" & emailaddress & "'"
                            sqlstr &= ", "
                            sqlstr &= "telephone = ''"
                            sqlstr &= ", "
                            sqlstr &= "seasonticketstandid = ''"
                            sqlstr &= ", "
                            sqlstr &= "seasonticketrow = ''"
                            sqlstr &= ", "
                            sqlstr &= "seasonticketseatnumber = ''"
                            sqlstr &= ", "
                            sqlstr &= "entrydate = '" & entrydate & "'"
                            sqlstr &= ", "
                            sqlstr &= "acceptedtandcs = '1'"
                            sqlstr &= ", "
                            sqlstr &= "age = ''"
                            sqlstr &= ", "
                            sqlstr &= "seasontickettypeid = '" & ticketype & "'"
                            sqlstr &= ", "
                            sqlstr &= "carerrequired = 'false'"
                            sqlstr &= ", "
                            sqlstr &= "requestedlowrow = 'false'"
                            sqlstr &= ", "
                            sqlstr &= "numberapplicants = " & numberorders
                            sqlstr &= ", "
                            sqlstr &= "preferarea = '" & prefarea & "'"
                            sqlstr &= ", "
                            sqlstr &= "rawseat = '" & homeoraway & "'"
                            sqlstr &= ", "
                            sqlstr &= "currentstatusID = 4" ' set to 4 to write as succesful
                            sqlstr &= ", "
                            sqlstr &= "statusnotes = ''"



                            '     Response.Write(sqlstr)


                            Using cmd As New MySqlCommand(sqlstr)
                                Using sda As New MySqlDataAdapter()
                                    cmd.Connection = con
                                    sda.SelectCommand = cmd
                                    Using tableE As New DataTable()
                                        sda.Fill(tableE)

                                    End Using
                                End Using
                            End Using
                        End Using


                        lastordernumber = ordernumber

                        Response.Write(" - wrote to db<br />")



                    Catch ex As Exception
                        Response.Write(ex)

                    End Try







                End If






            Next

        Catch ex As Exception
            Response.Write(ex)

        End Try

        Response.Write("Orders Processed Successfully")




    End Sub

    Public Sub writehousehold(ByVal ordernumber As String, ByRef emailaddress As String, ByVal ticketname As String, ByVal postcode As String, ByVal householdadd As String)

        ''use household address to store ticket type

        Dim SQLStr As String


        SQLStr = "INSERT INTO household_applications SET "

        SQLStr &= "fixtureID = '" & fixtureid & "'"
        SQLStr &= ", "
        SQLStr &= "masterseasonticketID = '" & emailaddress & "'"
        SQLStr &= ", "
        SQLStr &= "householdseasonticketID = '" & ordernumber & "'"
        SQLStr &= ", "
        SQLStr &= "householdname = '" & ticketname & "'"
        SQLStr &= ", "
        SQLStr &= "householdaddress = '" & householdadd & "'"
        SQLStr &= ", "
        SQLStr &= "householdpostcode = '" & postcode & "'"

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

            Response.Write(" - wrote to household<br />")
        Catch ex As Exception
            Response.Write(ex)
        End Try




    End Sub

    Public Function checkduplicate(ByVal ordernumber As String)



        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
        Using con As New MySqlConnection(constr)

            Using cmd As New MySqlCommand("SELECT * FROM vw_ballot_list where fixtureid = 2368 AND seasonticketnumber = '" & ordernumber & "';")
                Using sda As New MySqlDataAdapter()
                    cmd.Connection = con
                    sda.SelectCommand = cmd
                    Using tableE As New DataTable()
                        sda.Fill(tableE)

                        If tableE.Rows.Count > 0 Then
                            Return True

                        Else

                            Return False

                        End If

                    End Using

                    con.Close()

                End Using
            End Using
        End Using





    End Function

    Public Function countorders(ByVal ordernumber As String)
        Dim numborders As String = 0

        Dim adapter As New SqlDataAdapter()
        Dim ds As New DataSet()
        Dim i As Integer = 0
        Dim sql As String = Nothing
        Dim connetionString As String = "Initial Catalog=nopcommerce39;Integrated Security=False;Persist Security Info=False;User ID=nopqosfc32;Password=P@ssword;MultipleActiveResultSets=True"

        sql = "select count(CustomOrderNumber) FROM vw_PaidProducts where CustomOrderNumber = '" & ordernumber & "'"
        Dim connection As New SqlConnection(connetionString)
        connection.Open()
        Dim command As New SqlCommand(sql, connection)
        adapter.SelectCommand = command
        adapter.Fill(ds)

        numborders = ds.Tables(0).Rows.Item(0).Item(0).ToString

        adapter.Dispose()
        command.Dispose()
        connection.Close()


        Return numborders


    End Function

    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        writetoballot()
    End Sub
End Class