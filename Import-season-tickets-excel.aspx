<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Import-season-tickets-excel.aspx.vb" Inherits="admintickets.WebForm1_excel" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div> 
            <asp:Label ID="LabelStatus" runat="server" Text="import status"></asp:Label>
<asp:FileUpload ID="FileUpload1" runat="server" />
<asp:Button ID="btnImport" runat="server" Text="Import" OnClick="ImportExcel" />
<hr />
<asp:GridView ID="GridView1" runat="server">
</asp:GridView>
          
        </div>
    </form>
</body>
</html>
