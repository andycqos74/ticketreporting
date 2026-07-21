Imports System.Net
Imports System.Data
Imports Newtonsoft.Json


Public Class JSONtest
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Dim webAddress As String = "https://tickets.qosfc.com/import_json.php"
        Process.Start(webAddress)



        '   If Not Me.IsPostBack Then




        ServicePointManager.Expect100Continue = True
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 & SecurityProtocolType.Ssl3 & SecurityProtocolType.Tls & SecurityProtocolType.Tls11

        'Dim webclient As New WebClient

        'webclient.Headers("User-Agent") = "Mozilla/4.0 (Compatible; Windows NT 5.1; MSIE 6.0) (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"

        ''   Dim str As String = "https://ticketco.events:443/api/public/v1/item_grosses?token=nk6t4EzmDNuB3vAZ1gMy&event_id=216517&page=1"

        'Dim str As String = "https://tickets.qosfc.com/import_json.php"


        ''   Dim json As String = (New WebClient).DownloadString("https://ticketco.events:443/api/public/v1/item_grosses?token=nk6t4EzmDNuB3vAZ1gMy&event_id=216517&page=1")

        'webclient.DownloadString(str)



        'Dim JsonDataTable As DataTable = New DataTable()




        'JsonDataTable = JsonConvert.DeserializeObject(Of DataTable)(JsonString)


        'JsonDataTable.TableName = "JSON_MAST"

        ''Dim tbl As DataTable = JsonConvert.DeserializeObject(Of DataTable)(json)

        'GridView1.DataSource = JsonDataTable("JSON_MAST")

        'GridView1.DataBind()




        '    End If
    End Sub

End Class