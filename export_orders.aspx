<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="export_orders.aspx.vb" Inherits="admintickets.export_orders" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title></title>
</head>
<body>
	<form id="form2" runat="server">
	<div>
			<asp:Button ID="btntoCsv" runat="server" Text="EXPORT TO EXCEL" />
		<br/>

	<asp:GridView ID="GridView1" runat="server">
	</asp:GridView>
	</div>

	</form>
</body>
</html>


