Imports MySql.Data.MySqlClient

Public Class _default
    Inherits System.Web.UI.Page
    Dim currentseason As String = "16"


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            Me.BindGrid("0")

            Me.GetLastUpdate()
        End If

    End Sub

    Private Sub BindGrid(ByVal searchterm As String)
        Dim sqlstring As String
        Dim sqlstring2 As String

        Dim TotalSold As Int16 = 0
        Dim TotalProv As Int16 = 0
        Dim TotalAdult As Int16 = 0
        Dim TotalConc As Int16 = 0
        Dim TotalJB As Int16 = 0
        Dim TotalOther As Int16 = 0

        Dim TotalMain As Int16 = 0
        Dim TotalNew As Int16 = 0
        Dim TotalTerrace As Int16 = 0

        Dim MainAdult As Int16 = 0
        Dim MainConc As Int16 = 0
        Dim MainJB As Int16 = 0
        Dim MainOther As Int16 = 0

        Dim NewAdult As Int16 = 0
        Dim NewConc As Int16 = 0
        Dim NewJB As Int16 = 0
        Dim NewOther As Int16 = 0

        Dim TerrAdult As Int16 = 0
        Dim TerrConc As Int16 = 0
        Dim TerrJB As Int16 = 0
        Dim TerrOther As Int16 = 0

        Dim TotalShirtDraw As Int16 = 0

        If searchterm = "0" Then
            sqlstring = "SELECT * FROM vw_stand_sales_totals_" & currentseason & ";"
            sqlstring2 = "SELECT * FROM vw_terrace_sales_totals;"

        Else
            sqlstring = ""
            sqlstring2 = ""
        End If
        Try


            Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con As New MySqlConnection(constr)
                Using cmd As New MySqlCommand(sqlstring)
                    Using sda As New MySqlDataAdapter()
                        cmd.Connection = con
                        sda.SelectCommand = cmd
                        Using dt As New DataTable()
                            sda.Fill(dt)


                            TotalAdult += CInt(dt.Rows(0).Item(0)) + CInt(dt.Rows(0).Item(6))
                            TotalConc += CInt(dt.Rows(0).Item(1)) + CInt(dt.Rows(0).Item(7))
                            TotalJB += CInt(dt.Rows(0).Item(2)) + CInt(dt.Rows(0).Item(8))
                            TotalOther += CInt(dt.Rows(0).Item(3)) + CInt(dt.Rows(0).Item(9))
                            TotalSold += CInt(dt.Rows(0).Item(4)) + CInt(dt.Rows(0).Item(10))
                            TotalProv += CInt(dt.Rows(0).Item(5)) + CInt(dt.Rows(0).Item(11))
                            TotalMain += CInt(dt.Rows(0).Item(4))
                            TotalNew += CInt(dt.Rows(0).Item(10))
                            MainAdult += CInt(dt.Rows(0).Item(0))
                            MainConc += CInt(dt.Rows(0).Item(1))
                            MainJB += CInt(dt.Rows(0).Item(2))
                            MainOther += CInt(dt.Rows(0).Item(3))
                            NewAdult += CInt(dt.Rows(0).Item(6))
                            NewConc += CInt(dt.Rows(0).Item(7))
                            NewJB += CInt(dt.Rows(0).Item(8))
                            NewOther += CInt(dt.Rows(0).Item(9))
                            TotalShirtDraw += CInt(dt.Rows(0).Item(12)) + CInt(dt.Rows(0).Item(13))


                        End Using
                    End Using
                End Using
            End Using

            Dim constr2 As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con2 As New MySqlConnection(constr2)
                Using cmd2 As New MySqlCommand(sqlstring2)
                    Using sda2 As New MySqlDataAdapter()
                        cmd2.Connection = con2
                        sda2.SelectCommand = cmd2
                        Using dt2 As New DataTable()
                            sda2.Fill(dt2)


                            TotalAdult += CInt(dt2.Rows(0).Item(0))
                            TotalConc += CInt(dt2.Rows(0).Item(1))
                            TotalJB += CInt(dt2.Rows(0).Item(2))
                            TotalOther += CInt(dt2.Rows(0).Item(3))
                            TotalSold += CInt(dt2.Rows(0).Item(4))
                            TotalProv += CInt(dt2.Rows(0).Item(5))
                            TotalTerrace += CInt(dt2.Rows(0).Item(4))

                            TerrAdult += CInt(dt2.Rows(0).Item(0))
                            TerrConc += CInt(dt2.Rows(0).Item(1))
                            TerrJB += CInt(dt2.Rows(0).Item(2))
                            TerrOther += CInt(dt2.Rows(0).Item(3))

                        End Using
                    End Using
                End Using
            End Using

        Catch ex As Exception

        End Try




        LBTotalTotalSold.Text = TotalSold
        LBTotalProv.Text = TotalProv
        LBTotalAdultSold.Text = TotalAdult
        LBTotalConcSold.Text = TotalConc
        LBTotalJBSold.Text = TotalJB
        LBTotalOtherSold.Text = TotalOther

        LBTotalMain.Text = TotalMain
        LBTotalNew.Text = TotalNew
        LBTotalTerrace.Text = TotalTerrace

        LBMainAdult.Text = MainAdult
        LBMainConc.Text = MainConc
        LBMainJB.Text = MainJB
        LBMainOther.Text = MainOther


        LBNewAdult.Text = NewAdult
        LBNewConc.Text = NewConc
        LBNewJB.Text = NewJB
        LBNewOther.Text = NewOther

        LBTerrAdult.Text = TerrAdult
        LBTerrConc.Text = TerrConc
        LBTerrJB.Text = TerrJB
        LBTerrOther.Text = TerrOther

        LBTotalShirtDraw.Text = TotalShirtDraw



    End Sub

    Public Sub GetLastUpdate()

        Dim sqlstring As String = "Select * From vw_lastupdate Order By seatlastupdated DESC limit 1;"


        Dim constr As String = ConfigurationManager.ConnectionStrings("QosTickets").ConnectionString
            Using con As New MySqlConnection(constr)
                Using cmd As New MySqlCommand(sqlstring)
                    Using sda As New MySqlDataAdapter()
                        cmd.Connection = con
                        sda.SelectCommand = cmd
                        Using dt As New DataTable()
                            sda.Fill(dt)


                        '        LBlastupdated.Text = "Last Update : " & Day(dt.Rows(0).Item(0).ToString) & " " & MonthName(dt.Rows(0).Item(0).ToString) & " " & Year(dt.Rows(0).Item(0).ToString) & " " & Hour(dt.Rows(0).Item(0).ToString) & ":" & Minute(dt.Rows(0).Item(0).ToString)

                        LBlastupdated.Text = "Last Update : " & dt.Rows(0).Item(0).ToString



                    End Using
                    End Using
                End Using
            End Using


    End Sub


End Class