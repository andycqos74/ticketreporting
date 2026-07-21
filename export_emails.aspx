<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="export_emails.aspx.vb" Inherits="admintickets.export_emails" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title></title>
	      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />


    <link href="css/jquery-ui.min.css" rel="stylesheet" />
    
    <link href="css/bs4_custom.css" rel="stylesheet" />
    <link href="css/print.css" rel="stylesheet" />
    <link href="css/all.min.css" rel="stylesheet" />
</head>
<body>
	<form id="form2" runat="server">
	<div class="container">
		<div class="row my-3">
			<div class="col-4">
				<asp:Button Class="btn btn-warning" ID="btnUpdateSections" runat="server" Text="UPDATE SECTIONS" />
			</div>
			<div class="col-8">
                <asp:Label ID="LBupdatesections" CssClass="alert alert-success" runat="server" Text="" Visible="false"></asp:Label>
			</div>
		</div>
		<div class="row my-3">
			<div class="col-3">
				<asp:Button Class="btn btn-primary" ID="btnLoadSuccesful" runat="server" Text="LOAD ALL SUCCESFUL" />
			</div>
			</div>
		<div class="row my-3">
			<div class="col-3">
				<asp:Button Class="btn btn-primary" ID="btnLoadBDSH" runat="server" Text="LOAD BDS HOME" />
			</div>
						<div class="col-3">
				<asp:Button Class="btn btn-secondary" ID="btnLoadBDSA" runat="server" Text="LOAD BDS AWAY" />
			</div>
						<div class="col-3">
				<asp:Button Class="btn btn-primary" ID="btnLoadPortland" runat="server" Text="LOAD PORTLAND" />
			</div>
						<div class="col-3">
				<asp:Button Class="btn btn-secondary" ID="btnLoadTerregles" runat="server" Text="LOAD TERREGLES" />
			</div>
			</div>
		<div class="row my-3">
			<div class="col text-center">
			<asp:Button Class="btn btn-success btn-lg" ID="btntoCsv" runat="server" Text="EXPORT TO EXCEL" />
			</div>
		</div>
		<br/>

	<asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="true">
	</asp:GridView>
	</div>

	</form>

	  <script src="Scripts/jquery-3.4.1.min.js" ></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
    <script src="Scripts/jquery-ui.min.js"></script>
</body>
</html>


