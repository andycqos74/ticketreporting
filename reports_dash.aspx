<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="reports_dash.aspx.vb" Inherits="admintickets.reports_dash" %>
<%@ register TagPrefix="UCHeader" tagname="Header" Src="~/UC_header.ascx" %>
<%@ register TagPrefix="UCFooter" tagname="Footer" Src="~/UC_footer.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>TMS - Reports</title>

          <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />


    <link href="css/jquery-ui.min.css" rel="stylesheet" />
    
    <link href="css/bs4_custom.css" rel="stylesheet" />
    <link href="css/print.css" rel="stylesheet" />
    <link href="css/all.min.css" rel="stylesheet" />



   


</head>
<body >
    <form id="form1" runat="server">
           <UCHeader:Header runat="server" ID="UCHeader" ></UCHeader:Header>
        <div class="container mt-4">

            <div class="row">
          <div class="card-deck">
  <div class="card">
      <div class="card-body text-center d-flex align-items-center flex-column">
          <span class="mb-3"><i class="fas fa-pound-sign fa-3x"></i></span>
          <h5>REVENUE</h5>
                   
      </div>
      <div class="card-footer p-0  text-center">
          <p class="pb-0 mb-0">Coming soon</p>
      </div>
                     </div>

                <div class="card">
      <div class="card-body text-center d-flex align-items-center flex-column">
          <span class="mb-3"><i class="fas fa-chart-line fa-3x"></i></span>
          <h5>COMPARISON</h5>
                   
      </div>
      <div class="card-footer p-0 text-center">
          <p class="pb-0 mb-0">Coming soon</p>
      </div>



      </div>
                              <div class="card">
      <div class="card-body text-center d-flex align-items-center flex-column">
          <span class="mb-3"><i class="fas fa-users fa-3x"></i></span>
          <h5>AGE PROFILES</h5>
                   
      </div>
      <div class="card-footer p-0 text-center">
          <p class="pb-0 mb-0">Coming soon</p>
      </div>



      </div>
                                            <div class="card">
      <div class="card-body text-center d-flex align-items-center flex-column">
          <span class="mb-3"><i class="fas fa-chart-pie fa-3x"></i></span>
          <h5>DETAILED BREAKDOWNS</h5>
                  
      </div>
      <div class="card-footer p-0 text-center">
          <p class="pb-0 mb-0">Coming soon</p>
      </div>



      </div>


      </div>
                            </div>
           

     </div>

   

    </form>

        <script src="Scripts/jquery-3.4.1.min.js" ></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
    <script src="Scripts/jquery-ui.min.js"></script>

<%--    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.debug.js" integrity="sha384-NaWTHo/8YCBYJ59830LTz/P4aQZK1sS0SneOgAvhsIl3zBu8r9RevNg5lHCHAuQ/" crossorigin="anonymous"></script>
    --%>


    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.65/pdfmake.min.js" crossorigin="anonymous" type="text/javascript"></script>
  <%--  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.65/pdfmake.min.js.map" crossorigin="anonymous" type="text/javascript"></script>--%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.65/vfs_fonts.min.js" crossorigin="anonymous" type="text/javascript"></script>
      <!--Load the AJAX API-->
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
   
           <UCFooter:Footer runat="server" ID="Footer1" ></UCFooter:Footer>
</body>
</html>
