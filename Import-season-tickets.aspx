<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Import-season-tickets.aspx.vb" Inherits="admintickets.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Import Season Tickets</title>
              <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
      <link href="css/jquery-ui.min.css" rel="stylesheet" />
    <link href="css/bs4_custom.css" rel="stylesheet" />
    <link href="css/all.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container mt-5">
<div class="card">
  <div class="card-header">
    Import Seasons Tickets
  </div>
  <div class="card-body">
    <h5 class="card-title">1. Click Choose File and select Season Ticket export csv</h5>
    <p class="card-text">NOTE - Ensure export excel has Questions column deleted then saved as csv</p>
 <asp:FileUpload ID="FileUpload1" runat="server" CssClass="btn btn-primary"  />
       <h5 class="card-title mt-2">2. Click UPLOAD</h5>
      <asp:Button id="button1" Text="UPLOAD" OnClick="Upload" runat="server" CssClass="btn btn-success" />
  </div>
    <div class="card-footer">
         <asp:Label ID="LabelStatus" runat="server" Text=""></asp:Label>
    </div>
</div>

            <div class="card mt-3">
  <div class="card-header">
    Upodate Card Names
  </div>
  <div class="card-body">
    <h5 class="card-title">1. Click Choose File and select Question report csv</h5>
    <p class="card-text">NOTE - Ensure export excel has been saved as csv</p>
<asp:FileUpload ID="FileUpload2" runat="server" CssClass="btn btn-secondary"  />
       <h5 class="card-title mt-2">2. Click UPLOAD</h5>
     <asp:Button ID="button2"  Text="UPLOAD" OnClick="UploadQuestions" runat="server" CssClass="btn btn-success"/>
  </div>
    <div class="card-footer">
         <asp:Label ID="LabelQStatus" runat="server" Text=""></asp:Label>
    </div>
</div>
              


            <asp:GridView runat="server" ID="gridview1"></asp:GridView>
        </div>
    </form>
</body>
</html>
