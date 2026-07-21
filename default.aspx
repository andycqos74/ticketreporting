<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="default.aspx.vb" Inherits="admintickets._default" %>
<%@ register TagPrefix="UCHeader" tagname="Header" Src="~/UC_header.ascx" %>
<%@ register TagPrefix="UCFooter" tagname="Footer" Src="~/UC_footer.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>TMS Home</title>
          <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />


    <link href="css/jquery-ui.min.css" rel="stylesheet" />
    
    <link href="css/bs4_custom.css" rel="stylesheet" />
    <link href="css/print.css" rel="stylesheet" />
    <link href="css/all.min.css" rel="stylesheet" />


        <style>
        .chart {
  width: 100%; 
  min-height: 250px;
}
.row {
  margin:0 !important;
}
.badge {font-size: 100%!important;}

.manage-wrappers {
    min-height: 20vh;
     background-size: cover; 
     border: 5px solid #fff;
}
.non-btn, .non-btn:focus  {
         -webkit-appearance: none;
-moz-appearance: none;
appearance: none;
background-color: inherit;
border: none;
outline: none;
        }

.body-reports .card-header {
    background-color: #E5EBF1!important;
}

.text-75 {
    font-size: 75%!important;
}

    </style>
</head>
<body class="body-reports flex">
    <form id="form1" runat="server">
     <UCHeader:Header runat="server" ID="UCHeader" ></UCHeader:Header>
        <div class="container mt-4 d-none d-lg-block">

            <div class="row p-3 background-white border">
<div class="col-4 rounded text-center p-4 manage-wrappers " style=" background-image: url('images/main.jpg'); ">

<div class=" p-3 h-100 d-flex align-items-start flex-column" style="backdrop-filter: blur(10px); ">
    <div class="col mb-auto text-center">
    <h5 class=" text-white">Main Stand</h5>
        </div>
    <div class="col d-flex align-items-end flex-column">
    <a class="btn btn-success mx-auto mt-auto" href="stand.aspx"><span><i class="far fa-edit  text-white mr-2"></i></span>MANAGE TICKETS</a>
</div>
    </div>

</div>

    <div class="col-4 rounded text-center p-4   manage-wrappers" style=" background-image: url('images/new.jpg'); ">

<div class=" p-3 h-100 d-flex align-items-start flex-column" style="backdrop-filter: blur(10px); ">
    <div class="col mb-auto text-center">
    <h5 class=" text-white">New Stand</h5>
        </div>
    <div class="col d-flex align-items-end flex-column">
    <a class="btn btn-success  mx-auto mt-auto" href="newstand.aspx"><span><i class="far fa-edit  text-white mr-2"></i></span>MANAGE TICKETS</a>
</div>
    </div>

</div>
 <div class="col-4 rounded text-center p-4  manage-wrappers" style=" background-image: url('images/terrace.jpg');">

<div class=" p-3 h-100 d-flex align-items-start flex-column" style="backdrop-filter: blur(10px); ">
    <div class="col mb-auto text-center">
    <h5 class=" text-white">Terrace</h5>
        </div>
    <div class="col d-flex align-items-end flex-column">
    <a class="btn btn-success mx-auto mt-auto" href="terrace.aspx?fixtureid=16"><span><i class="far fa-edit  text-white mr-2"></i></span>MANAGE TICKETS</a>
</div>


    </div>

</div>

</div>
            <div class="row p-3 background-white border">
                <div class="col-12 d-flex justify-content-around">
                    <%--<a href="2021all.aspx" class="btn btn-success mx-auto mt-auto" style="font-size:1.5rem;"><span><i class="fas fa-video mr-2"></i></span>FULL LIST</a>--%>
                     <a href="fixtureselect.aspx" class="btn btn-success mx-auto mt-auto" style="font-size:1.5rem;"><span><i class="fas fa-ticket-alt mr-2"></i></span>MANAGE BALLOT</a>

                </div>

            </div>


        </div>

  <div class="container-fluid mt-4">
            <div class="row">
                <div class="col">
                    <div class="card">
                        <div class="card-header h5 d-flex justify-content-center">
                            <span class="">All Areas : 2020/21</span>
                          <%--  <span class="ml-auto"><button class="non-btn" id="refreshgraphs"><i class="fas fa-sync-alt text-muted"></i></button></span>--%>
                        </div>
                        <div class="card-body">
       <div class="container-fluid">

                           <div class="row">
                                <div class="col-lg-4 text-center">

                                    <p class="font-weight-bold mb-1">Totals
<%--                                      <span class="text-muted" style="float:right;"><i class="far fa-question-circle"></i></span>--%>

                  <button type="button" class="non-btn text-muted float-right" data-html="true"  data-toggle="popover" title="Totals Help"
                      data-content="<p class='mb-0'>Other - All tickets EXCLUDING Shirt Draw</p><p class='mb-0'>Pending - online orders not entered on the system</p><p class='mb-0'>Provisional - previous season tickets not yet renewed.</p>">
                      <i class="far fa-question-circle"></i></button>



                                    </p>
                                 


                                            <ul class="list-group">
                                            
  <li class="list-group-item d-flex justify-content-between align-items-center">
  Adult

            <asp:Label ID="LBTotalAdultSold" runat="server" Text="" CssClass="badge badge-secondary badge-pill"></asp:Label>
  </li>
       <li class="list-group-item d-flex justify-content-between align-items-center">
 Concessions

            <asp:Label ID="LBTotalConcSold" runat="server" Text="" CssClass="badge badge-secondary badge-pill"></asp:Label>
  </li>
    <li class="list-group-item d-flex justify-content-between align-items-center">
 Junior Blues

            <asp:Label ID="LBTotalJBSold" runat="server" Text="" CssClass="badge badge-secondary badge-pill"></asp:Label>
  </li>
  <li class="list-group-item d-flex justify-content-start align-items-center">
Other
                        <button type="button" class="non-btn text-muted ml-2" data-html="true"  data-toggle="popover" 
                      data-content="<p class='mb-0'>All other ticket types, EXCLUDING Shirt Draw</p>">
                      <i class="far fa-question-circle"></i></button>

            <asp:Label ID="LBTotalOtherSold" runat="server" Text="" CssClass="ml-auto badge badge-secondary badge-pill"></asp:Label>
  </li>

        <li class="list-group-item d-flex justify-content-between align-items-center font-weight-bold border-dark border-top border-left-0 border-right-0">
Total

            <asp:Label ID="LBTotalTotalSold" runat="server" Text="" CssClass="badge badge-dark badge-pill"></asp:Label>
  </li>
  <%--<li class="list-group-item d-flex justify-content-start align-items-center  font-weight-light">
Pending
      <button type="button" class="non-btn text-muted ml-2" data-html="true"  data-toggle="popover" 
                      data-content="<p class='mb-0'>Online orders not entered on the system</p>">
                      <i class="far fa-question-circle"></i></button>


            <asp:Label ID="LBTotalPending" runat="server" Text="12" CssClass="ml-auto badge badge-light badge-pill"></asp:Label>
  </li>--%>
   <li class="list-group-item d-flex justify-content-start align-items-center  font-weight-light">
Shirt Draw
  


            <asp:Label ID="LBTotalShirtDraw" runat="server" Text="" CssClass="ml-auto badge badge-light badge-pill"></asp:Label>
  </li>
        <li class="list-group-item d-flex justify-content-start align-items-center font-weight-light">
Provisional
      <button type="button" class="non-btn text-muted ml-2" data-html="true"  data-toggle="popover" 
                      data-content="<p class='mb-0'>Previous season tickets not yet renewed.</p>">
                      <i class="far fa-question-circle"></i></button>

            <asp:Label ID="LBTotalProv" runat="server" Text="" CssClass="ml-auto badge badge-light badge-pill"></asp:Label>
  </li>
                                          


                                            </ul>

                                </div>
<div class="col-sm-6 col-lg-4 text-center">
    <p class="font-weight-bold mb-0">By Ticket Type</p>
                                            
    <div id="chartTotals_div" class="chart"></div><!--Div that will hold the pie chart-->
    </div>
<div class="col-sm-6 col-lg-4 text-center">
    <p class="font-weight-bold mb-0">By Area of Ground</p>
        <div id="chartStands_div" class="chart"></div><!--Div that will hold the pie chart-->

    

</div>


                            </div>
           </div>
                            <div class="container-fluid mt-4">


                            <div class="row">
                <div class="col-4">
                    <div class="card">
                        <div class="card-header h5 text-center">
                            Main Stand
                        </div>
                        <div class="card-body text-center">
<p class="font-weight-bold mb-0">By Ticket Type</p>
                                            
    <div id="chartmain_div" class="chart"></div> <!--Div that will hold the pie chart-->


                        </div>
                          </div>


                </div>
                                <div class="col-4">
                    <div class="card">
                        <div class="card-header h5 text-center">
                            New Stand
                        </div>
                        <div class="card-body text-center">
                            <p class="font-weight-bold mb-0">By Ticket Type</p>
                                            <!--Div that will hold the pie chart-->
    <div id="chartnew_div" class="chart"></div>

                        </div>
                          </div>

                </div>
                                                                <div class="col-4">
                    <div class="card">
                        <div class="card-header h5 text-center">
                        Terrace
                        </div>
                        <div class="card-body text-center">
                            <p class="font-weight-bold mb-0">By Ticket Type</p>
                                            <!--Div that will hold the pie chart-->
    <div id="chartterrace_div" class="chart"></div>

                        </div>
                          </div>

                </div>

                            </div>
                                </div>

                        </div>
                        <div class="card-footer text-right pt-0 border-top-0 bg-white">
               <%--             <p class="text-muted font-weight-light mb-0">Last Updated : 13th July 2020 23:02</p>--%>
                            <asp:Label ID="LBlastupdated" runat="server" CssClass="text-muted font-weight-light mb-0 text-75" Text=""></asp:Label>
                        </div>
                    </div>
                </div>




            </div>
     

     </div>

       

        <!--hidden fields for graph values -->
        <asp:Label ID="LBTotalMain" runat="server" Text="" CssClass="d-none"></asp:Label>
           <asp:Label ID="LBTotalNew" runat="server" Text=""  CssClass="d-none"></asp:Label>
           <asp:Label ID="LBTotalTerrace" runat="server" Text=""  CssClass="d-none"></asp:Label>

        <asp:Label ID="LBMainAdult" runat="server" Text=""  CssClass="d-none"></asp:Label>
                   <asp:Label ID="LBMainConc" runat="server" Text=""  CssClass="d-none"></asp:Label>
                   <asp:Label ID="LBMainJB" runat="server" Text=""  CssClass="d-none"></asp:Label>
                   <asp:Label ID="LBMainOther" runat="server" Text=""  CssClass="d-none"></asp:Label>

                <asp:Label ID="LBNewAdult" runat="server" Text=""  CssClass="d-none"></asp:Label>
                   <asp:Label ID="LBNewConc" runat="server" Text=""  CssClass="d-none"></asp:Label>
                   <asp:Label ID="LBNewJB" runat="server" Text=""  CssClass="d-none"></asp:Label>
                   <asp:Label ID="LBNewOther" runat="server" Text=""  CssClass="d-none"></asp:Label>

        
                <asp:Label ID="LBTerrAdult" runat="server" Text=""  CssClass="d-none"></asp:Label>
                   <asp:Label ID="LBTerrConc" runat="server" Text=""  CssClass="d-none"></asp:Label>
                   <asp:Label ID="LBTerrJB" runat="server" Text=""  CssClass="d-none"></asp:Label>
                   <asp:Label ID="LBTerrOther" runat="server" Text=""  CssClass="d-none"></asp:Label>


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
    <script type="text/javascript">

        // Load the Visualization API and the corechart package.
        google.charts.load('current', { 'packages': ['corechart'] });

        // Set a callback to run when the Google Visualization API is loaded.
        google.charts.setOnLoadCallback(drawChartmain);
        google.charts.setOnLoadCallback(drawChartNew);
        google.charts.setOnLoadCallback(drawChartTotals);
        google.charts.setOnLoadCallback(drawChartStands);
        google.charts.setOnLoadCallback(drawChartTerr);

        // Callback that creates and populates a data table,
        // instantiates the pie chart, passes in the data and
        // draws it.
        function drawChartmain() {

            var mainAdults = parseInt($("#LBMainAdult").text(), 10);
            var mainConc = parseInt($("#LBMainConc").text(), 10);
            var mainJB = parseInt($("#LBMainJB").text(), 10);
            var mainOther = parseInt($("#LBMainOther").text(), 10);


            // Create the data table.
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Type');
            data.addColumn('number', 'Sold');
            data.addRows([
                ['Adult', mainAdults],
                ['Concessions', mainConc],
                ['Junior Blue', mainJB],
                ['Other', mainOther]

            ]);

            // Set chart options
            var options = {};

            // Instantiate and draw our chart, passing in some options.
            var chart = new google.visualization.PieChart(document.getElementById('chartmain_div'));
            chart.draw(data, options);
        }

        function drawChartNew() {

            var newAdults = parseInt($("#LBNewAdult").text(), 10);
            var newConc = parseInt($("#LBNewConc").text(), 10);
            var newJB = parseInt($("#LBNewJB").text(), 10);
            var newOther = parseInt($("#LBNewOther").text(), 10);

            // Create the data table.
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Type');
            data.addColumn('number', 'Sold');
            data.addRows([
                ['Adult', newAdults],
                ['Concessions', newConc],
                ['Junior Blue', newJB],
                ['Other', newOther]

            ]);

            // Set chart options
            var options = {

            };

            // Instantiate and draw our chart, passing in some options.
            var chart = new google.visualization.PieChart(document.getElementById('chartnew_div'));
            chart.draw(data, options);
        }

        function drawChartTotals() {

            //get data values from labels 
            var TotalAdults = parseInt($("#LBTotalAdultSold").text(), 10);
            var TotalConc = parseInt($("#LBTotalConcSold").text(), 10);
            var TotalJB = parseInt($("#LBTotalJBSold").text(), 10);

            var Totalother = parseInt($("#LBTotalOtherSold").text(), 10);


            // Create the data table.
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Type');
            data.addColumn('number', 'Sold');
            data.addRows([
                ['Adult', TotalAdults],
                ['Concessions', TotalConc],
                ['Junior Blue', TotalJB],
                ['Other', Totalother]



            ]);

            // Set chart options
            var options = {

            };

            // Instantiate and draw our chart, passing in some options.
            var chart = new google.visualization.PieChart(document.getElementById('chartTotals_div'));
            chart.draw(data, options);
        }

        function drawChartTerr() {

            //get data values from labels 
            var TerrAdults = parseInt($("#LBTerrAdult").text(), 10);
            var TerrConc = parseInt($("#LBTerrConc").text(), 10);
            var TerrJB = parseInt($("#LBTerrJB").text(), 10);

            var Totalother = parseInt($("#LBTerrOther").text(), 10);


            // Create the data table.
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Type');
            data.addColumn('number', 'Sold');
            data.addRows([
                ['Adult', TerrAdults],
                ['Concessions', TerrConc],
                ['Junior Blue', TerrJB],
                ['Other', Totalother]



            ]);

            // Set chart options
            var options = {

            };

            // Instantiate and draw our chart, passing in some options.
            var chart = new google.visualization.PieChart(document.getElementById('chartterrace_div'));
            chart.draw(data, options);
        }


        function drawChartStands() {

            //get data values from labels 
            var TotalMain = parseInt($("#LBTotalMain").text(), 10);
            var TotalNew = parseInt($("#LBTotalNew").text(), 10);
            var TotalTerrace = parseInt($("#LBTotalTerrace").text(), 10);



            // Create the data table.
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Type');
            data.addColumn('number', 'Sold');
            data.addRows([
                ['Main Stand', TotalMain],
                ['New Stand', TotalNew],
                ['Terrace', TotalTerrace],




            ]);

            // Set chart options
            var options = {

            };

            // Instantiate and draw our chart, passing in some options.
            var chart = new google.visualization.PieChart(document.getElementById('chartStands_div'));
            chart.draw(data, options);
        }





    </script>
    <script>
        $(window).resize(function () {
            drawChartMain();
            drawChartNew();
            drawChartTerr();

            drawChartTotals();
            drawChartStands();

        });


        $(document).on('click', "#refreshgraphs", function () {
            event.stopPropagation();
            event.stopImmediatePropagation();

            $(this).addClass("fa-spin");

            drawChartMain();
            drawChartNew();
            drawChartTerr();

            drawChartTotals();
            drawChartStands();

            $(this).removeClass("fa-spin");
        });

        $(function () {
            $('[data-toggle="popover"]').popover()
        })

    </script>

         <UCFooter:Footer runat="server" ID="Footer1" ></UCFooter:Footer>

</body>
</html>

