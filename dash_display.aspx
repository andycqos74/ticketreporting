<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="dash_display.aspx.vb" Inherits="admintickets.dash_display" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Live Ticket Report</title>
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />


    <link href="css/jquery-ui.min.css" rel="stylesheet" />
     <style>

 .card-header {
    background-color: #E5EBF1!important;
}

 .checked-back {
     background-color: #c7eed1!important;
 }

 .sold-back {
     background-color : #e2f0fd!important;
 }

.text-75 {
    font-size: 75%!important;
}
.text-25x {
    font-size : 2.5rem;
}
.text-2x {
    font-size : 2rem;
}
.text-15x {
    font-size : 1.5rem;
}

body {
    background-color: #f2f8fe;
}
.border-thick {
    border-width : 15px!important;
}
         </style>

</head>
<body class="flex">
    <form id="form1" runat="server">


        <div class="container-fluid pt-4">
                        <div class="row">
                            <div class="col-6">
            <h2><span id="hfixturename">Loading ...</span></h2>
                                </div>

                <div class="col-6 text-right">
                    <h5 id="lastupdate">NA</h5>
                </div>
            </div>

            <div class="row pb-4 border-bottom border-thick ">
                <div class="col-3">

                    <div class="card h-100">
  <div class="card-header text-center">
 <h5 class="mb-0">TOTALS</h5>
  </div>

  <div class="card-body text-center p-0 py-4 ">
        <h2 class="card-title pb-2" style="color: #003977;">
    CHECKED IN</h2>
    <h1 class="badge badge-pill badge-primary mb-4 text-25x"><span id="TotalCheckedIn">NA</span></h1>


              <h2 class="card-title pb-2 pt-4 mt-4" style="color: #1f6530;">
    ATTENDANCE</h2>
    <h1 class="badge badge-pill badge-success mb-4 text-25x"><span id="ReportedCrowd">NA</span></h1>

  </div>
</div>
</div>

 
                <div class="col-9">
     <%--               <div class="card-deck">--%>
                    <div class="row row-cols-1 row-cols-lg-2 row-cols-xl-4">
  <div class="col mb-4">
    

       <div class="card">
  <div class="card-header text-center">
 <h5 class="mb-0">ONLINE</h5>
  </div>
  <div class="card-body p-0 py-2">
  
          <div class="row no-gutters">
              <div class="col-6 no-gutters text-center">
            <h5 class="card-title pb-0" style="color: #1f6530;">SOLD</h5>

       <h6 class="badge badge-pill badge-success my-1 text-15x"><span id="OnlineSold">NA</span></h6>
              </div>
              <div class="col-6 no-gutters text-center">
               <h5 class="card-title pb-0" style="color: #003977;">CHECKED IN</h5>

       <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="OnlineCheckedIn">NA</span></h6>
              </div>

          </div>

</div>
</div>

</div>
                          <div class="col mb-4">

                        <div class="card">
  <div class="card-header text-center">
     <h5 class="mb-0">SEASON TICKETS</h5>
  </div>
  <div class="card-body text-center p-0 py-2">
                <h5 class="card-title pb-0" style="color: #1f6530;">CHECKED IN</h5>
        <h6 class="badge badge-pill badge-success my-1 text-15x"><span id="SeasonTicketsCheckedIn">NA</span></h6>


  </div>
</div>
</div>
                          <div class="col mb-4">
  <div class="card">
  <div class="card-header text-center">
     <h5 class="mb-0">WALK-UPS</h5>
  </div>
  <div class="card-body text-center p-0 py-1">

          <div class="row no-gutters">
              <div class="col-6 no-gutters text-center">
            <h5 class="card-title pb-0" style="color: #003977;">SOLD</h5>

       <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="WalkupSold">NA</span></h6>
              </div>
              <div class="col-6 no-gutters text-center">
               <h5 class="card-title pb-0" style="color: #1f6530;">CHECKED IN</h5>
        <h6 class="badge badge-pill badge-success my-1 text-15x"><span id="WalkUpCheckedIn">NA</span></h6>
</div>

  </div>
</div>


                        </div>
                              </div>
                          <div class="col mb-4">
                        <div class="card">
  <div class="card-header text-center">
     <h5 class="mb-0">OTHER</h5>
  </div>
  <div class="card-body text-center p-0 py-2">
                <h5 class="card-title pb-0" style="color: #1f6530;">SOLD</h5>
        <h6 class="badge badge-pill badge-success my-1 text-15x"><span id="other">NA</span></h6>


  </div>
</div>
</div>

                        </div>

                    
               
 
<div class="row no-gutters mt-4">
    <div class="col-12 no-gutters">

     <div class="row row-cols-1 row-cols-lg-2 ">
            <div class="col mb-4">
       <div class="card">
  <div class="card-header text-center">
 <h5 class="mb-0">HOME</h5>
  </div>
  <div class="card-body text-center p-0 py-2">
          <div class="row no-gutters">
              <div class="col-2 no-gutters text-center">
            <h5 class="card-title pb-0" style="color: #003977;"></h5>       
              </div>
 <div class="col-5 no-gutters text-center">
            <h5 class="card-title pb-0" style="color: #003977;">SOLD</h5>       
              </div>
              <div class="col-5 no-gutters text-center">
               <h5 class="card-title pb-0" style="color: #003977;">CHECKED IN</h5>
              </div>

          </div>


                <div class="row no-gutters">
              <div class="col-2 no-gutters text-left">
            <h5 class="card-title pb-0" style="color: #003977; padding-top: 0.5em; padding-left: 0.5em;">ONLINE</h5>       
              </div>
 <div class="col-5 no-gutters text-center">
           <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="homesold">NA</span></h6>   
              </div>
              <div class="col-5 no-gutters text-center">
               <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="homecheckedin">NA</span></h6>
              </div>

          </div>

<%--                      <div class="row no-gutters">
              <div class="col-2 no-gutters text-left">
            <h5 class="card-title pb-0" style="color: #003977; padding-top: 0.5em; padding-left: 0.5em;">WALK-UP</h5>       
              </div>
 <div class="col-5 no-gutters text-center">
           <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="walkuphomesold">NA</span></h6>   
              </div>
              <div class="col-5 no-gutters text-center">
               <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="homewalkupcheckedin">NA</span></h6>
              </div>

          </div>--%>
                            <div class="row no-gutters" style="border-top: 1px #ddd solid; padding-top: 1em;">
              <div class="col-2 no-gutters text-left">
            <h5 class="card-title pb-0" style="color: #003977; padding-top: 0.5em; padding-left: 0.5em;">TOTAL</h5>       
              </div>
 <div class="col-5 no-gutters text-center">
           <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="totalhomesold">NA</span></h6>   
              </div>
              <div class="col-5 no-gutters text-center">
               <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="totalhomecheckedin">NA</span></h6>
              </div>

          </div>


</div>
</div>

   </div>
            <div class="col mb-4">
              






                        <div class="card">
  <div class="card-header text-center">
     <h5 class="mb-0">AWAY</h5>
  </div>

                              <div class="card-body text-center p-0 py-2">
          <div class="row no-gutters">
              <div class="col-2 no-gutters text-center">
            <h5 class="card-title pb-0" style="color: #003977;"></h5>       
              </div>
 <div class="col-5 no-gutters text-center">
            <h5 class="card-title pb-0" style="color: #003977;">SOLD</h5>       
              </div>
              <div class="col-5 no-gutters text-center">
               <h5 class="card-title pb-0" style="color: #003977;">CHECKED IN</h5>
              </div>

          </div>


                <div class="row no-gutters">
              <div class="col-2 no-gutters text-left">
            <h5 class="card-title pb-0" style="color: #003977; padding-top: 0.5em; padding-left: 0.5em;">ONLINE</h5>       
              </div>
 <div class="col-5 no-gutters text-center">
           <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="awaysold">NA</span></h6>   
              </div>
              <div class="col-5 no-gutters text-center">
               <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="awaycheckedin">NA</span></h6>
              </div>

          </div>

<%--                      <div class="row no-gutters">
              <div class="col-2 no-gutters text-left">
            <h5 class="card-title pb-0" style="color: #003977; padding-top: 0.5em; padding-left: 0.5em;">WALK-UP</h5>       
              </div>
 <div class="col-5 no-gutters text-center">
           <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="walkupawaysold">NA</span></h6>   
              </div>
              <div class="col-5 no-gutters text-center">
               <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="awaywalkupcheckedin">NA</span></h6>
              </div>

          </div>--%>

 <div class="row no-gutters" style="border-top: 1px #ddd solid; padding-top: 1em;">
              <div class="col-2 no-gutters text-left">
            <h5 class="card-title pb-0" style="color: #003977; padding-top: 0.5em; padding-left: 0.5em;">TOTAL</h5>       
              </div>
 <div class="col-5 no-gutters text-center">
           <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="totalawaysold">NA</span></h6>   
              </div>
              <div class="col-5 no-gutters text-center">
               <h6 class="badge badge-pill badge-primary my-1 text-15x"><span id="totalawaycheckedin">NA</span></h6>
              </div>

          </div>


</div>


</div>

</div>

    </div>



</div>

     </div>
                    </div>
                </div><!--end of first row -->

        <div class="row mt-4">
            <div class="col-12">
                <img class="" src="/images/ground6.png" style="width: 1200px;   "/>
                <div style="position: absolute; top: 144px; left: 187px;"><h5 class="font-weight-light" id="BDS1CheckedIn">0</h5></div>
                 <div  style="position: absolute; top: 144px; left: 287px;"><h5 class="font-weight-light" id="BDS2CheckedIn">0</h5></div>
                <div  style="position: absolute; top: 144px; left: 391px;"><h5 class="font-weight-light" id="BDS3CheckedIn">0</h5></div>
                <div  style="position: absolute; top: 144px; left: 492px;"><h5 class="font-weight-light" id="BDS4CheckedIn">0</h5></div>
                <div style="position: absolute; top: 144px; left: 594px;"><h5 class="font-weight-light" id="BDS5CheckedIn">0</h5></div>
                <div style="position: absolute; top: 144px; left: 706px;"><h5 class="font-weight-light" id="BDS6CheckedIn">0</h5></div>
                <div style="position: absolute; top: 144px; left: 801px;"><h5 class="font-weight-light" id="BDS7CheckedIn">0</h5></div>
                <div  style="position: absolute; top: 144px; left: 906px;"><h5 class="font-weight-light" id="BDS8CheckedIn">0</h5></div>
                <div  style="position: absolute; top: 144px; left: 1009px;"><h5 class="font-weight-light" id="BDS9CheckedIn">0</h5></div>

                 <div  style="position: absolute; top: 733px; left: 69px;"><h5 class="font-weight-light" id="OakbankCheckedIn">0</h5></div>

                <%--<div  style="position: absolute; top: 152px; left: 1124px;"><h5 class="font-weight-light" id="TerreglesCheckedIn">0</h5></div>--%>
                <div  style="position: absolute; top: 152px; left: 1124px;"><h5 class="font-weight-light" id="WalkUpCheckedInMap">0</h5></div>

                <div style="position: absolute; top: 756px; left: 950px;"><h5 class="font-weight-light" id="Alpha1CheckedIn">0</h5></div>
                <div  style="position: absolute; top: 756px; left: 722px;"><h5 class="font-weight-light" id="Alpha2CheckedIn">0</h5></div>
                <div  style="position: absolute; top: 756px; left: 483px;"><h5 class="font-weight-light" id="Alpha3CheckedIn">0</h5></div>
                <div style="position: absolute; top: 756px; left: 244px;"><h5 class="font-weight-light" id="Alpha4CheckedIn">0</h5></div>


                <div  class="badge badge-success text-15" style="position: absolute; top: 879px; left: 329px;"><h5 class="my-1" id="AlphaTS2">0</h5></div>
                <div class="badge badge-success text-15" style="position: absolute; top: 879px; left: 828px;"><h5 class="my-1" id="AlphaTS1">0</h5></div>
                <div class="badge badge-success text-15" style="position: absolute; top: 879px; left: 55px;"><h5  class="my-1" id="EncTS1">0</h5></div>
                <div class="badge badge-success text-15" style="position: absolute; top: 44px; left: 57px;"><h5 class="my-1" id="TerraceTS1">0</h5></div>
                <div class="badge badge-success text-15" style="position: absolute; top: 44px; left: 413px;"><h5 class="my-1" id="BDSTS1">0</h5></div>
                <div class="badge badge-success text-15" style="position: absolute; top: 44px; left: 846px;"><h5 class="my-1" id="BDSTS2">0</h5></div>

            </div>



        </div>


        </div> <!-- end of container -->










 

    </form>
      <!--Script references. 
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->


    <!--Reference the jQuery library. -->
    <script src="Scripts/jquery-3.4.1.min.js" ></script>
        
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
    <script src="Scripts/jquery-ui.min.js"></script>
   



  


    <!--Reference the SignalR library. -->
    <script src="Scripts/jquery.signalR-2.2.2.min.js"></script>
    <!--Reference the autogenerated SignalR hub script. -->
    <script src="signalr/hubs"></script>
    <!--Add script to update the page and send messages.--> 
    <script type="text/javascript">
        
        $(function () {
            // Declare a proxy to reference the hub. 
            var chat = $.connection.chatHubticketco;
            // Create a function that the hub can call to broadcast messages.
            chat.client.broadcastMessage = function (TotalCheckedIn, WalkUpCheckedIn, OnlineCheckedIn, OnlineSold, SeasonTicketsCheckedIn, AwaySold, HomeSold, awaycheckedin, homecheckedin, BDS1CheckedIn, BDS2CheckedIn, BDS3CheckedIn, BDS4CheckedIn, BDS5CheckedIn, BDS7CheckedIn, BDS8CheckedIn, BDS9CheckedIn, OakbankCheckedIn, TerreglesCheckedIn, Alpha1CheckedIn, Alpha2CheckedIn, Alpha3CheckedIn, Alpha4CheckedIn, AlphaTS1, AlphaTS2, EncTS1, TerraceTS1, BDSTS1, BDSTS2, lastupdate, BDS6CheckedIn, ReportedCrowd, other, CompsCheckedIn, fixturename,errormsg) {
                // Html encode display name and message. 
                var TotalCheckedIn = $('<div />').text(TotalCheckedIn).html();
                var WalkUpCheckedIn = $('<div />').text(WalkUpCheckedIn).html();


                //var HomeWalkUpCheckedInvalue = $('<div />').text(HomeWalkUpCheckedIn).html();
                //var AwayWalkUpCheckedIn = $('<div />').text(AwayWalkUpCheckedIn).html();

                var OnlineCheckedIn = $('<div />').text(OnlineCheckedIn).html();
                var OnlineSold = $('<div />').text(OnlineSold).html();
                var SeasonTicketsCheckedIn = $('<div />').text(SeasonTicketsCheckedIn).html();
                var awaycheckedin = $('<div />').text(awaycheckedin).html();
                var homecheckedin = $('<div />').text(homecheckedin).html();
                var awaysold = $('<div />').text(AwaySold).html();
                var homesold = $('<div />').text(HomeSold).html();
                var lastupdate = $('<div />').text(lastupdate).html();

                var BDS1CheckedIn = $('<div />').text(BDS1CheckedIn).html();
                var BDS2CheckedIn = $('<div />').text(BDS2CheckedIn).html();
                var BDS3CheckedIn = $('<div />').text(BDS3CheckedIn).html();
                var BDS4CheckedIn = $('<div />').text(BDS4CheckedIn).html();
                var BDS5CheckedIn = $('<div />').text(BDS5CheckedIn).html();
                var BDS6CheckedIn = $('<div />').text(BDS6CheckedIn).html();
                var BDS7CheckedIn = $('<div />').text(BDS7CheckedIn).html();
                var BDS8CheckedIn = $('<div />').text(BDS8CheckedIn).html();
                var BDS9CheckedIn = $('<div />').text(BDS9CheckedIn).html();
                var OakbankCheckedIn = $('<div />').text(OakbankCheckedIn).html();

                var TerreglesCheckedIn = $('<div />').text(TerreglesCheckedIn).html();

                var Alpha1CheckedIn = $('<div />').text(Alpha1CheckedIn).html();
                var Alpha2CheckedIn = $('<div />').text(Alpha2CheckedIn).html();
                var Alpha3CheckedIn = $('<div />').text(Alpha3CheckedIn).html();
                var Alpha4CheckedIn = $('<div />').text(Alpha4CheckedIn).html();

                var AlphaTS1 = $('<div />').text(AlphaTS1).html();
                var AlphaTS2 = $('<div />').text(AlphaTS2).html();
                var EncTS1 = $('<div />').text(EncTS1).html();
                var TerraceTS1 = $('<div />').text(TerraceTS1).html();
                var BDSTS1 = $('<div />').text(BDSTS1).html();
                var BDSTS2 = $('<div />').text(BDSTS2).html();

                var reportedcrowd = $('<div />').text(ReportedCrowd).html();
                var other = $('<div />').text(other).html();
                var CompsCheckedIn = $('<div />').text(CompsCheckedIn).html();
                var errormsg = $('<div />').text(errormsg).html();

                var homewalkupsold = 0;
                var awaywalkupsold = 0;



                //console.log(HomeWalkUpCheckedInvalue);
                //console.log(AwayWalkUpCheckedIn);
                //console.log(TotalCheckedIn);

                console.log(homecheckedin);
                console.log(TotalCheckedIn);
                console.log(errormsg);

                

                var totalhomesold = BigInt(homesold) + BigInt(homewalkupsold);
                //var totalhomecheckedin = BigInt(homecheckedin) + BigInt(HomeWalkUpCheckedInvalue);
             

                var totalawaysold = BigInt(awaysold) + BigInt(awaywalkupsold);
            //var totalawaycheckedin = BigInt(awaycheckedin) + BigInt(AwayWalkUpCheckedIn);
                //var totalawaycheckedin = 0

            var fixturename = $('<div />').text(fixturename).html();

           //    var fixturename = "Test java";



 $("#TotalCheckedIn").fadeTo(500, 0, function () {
                    $("#TotalCheckedIn").text(TotalCheckedIn)

                        .fadeTo(500, 1.0);
                });

                $("#lastupdate").fadeTo(500, 0, function () {
                    $("#lastupdate").text(lastupdate)

                        .fadeTo(500, 1.0);
                });

                $("#ReportedCrowd").fadeTo(500, 0, function () {
                    $("#ReportedCrowd").text(reportedcrowd)

                        .fadeTo(500, 1.0);
                });

                $("#hfixturename").fadeTo(500, 0, function () {
                    $("#hfixturename").text(fixturename)


                        .fadeTo(500, 1.0);
                });

           //        $("#hfixturename").text(fixturename);
                 
                $("#WalkUpCheckedIn").text(WalkUpCheckedIn);
                //$("#homewalkupcheckedin").text(HomeWalkUpCheckedInvalue);
                //$("#awaywalkupcheckedin").text(AwayWalkUpCheckedIn);
                $("#OnlineCheckedIn").text(OnlineCheckedIn);
                $("#OnlineSold").text(OnlineSold);
                $("#SeasonTicketsCheckedIn").text(SeasonTicketsCheckedIn);
                $("#awaycheckedin").text(awaycheckedin);
                $("#homecheckedin").text(homecheckedin);
                $("#awaysold").text(awaysold);
                $("#homesold").text(homesold);
               
                $("#BDS1CheckedIn").text(BDS1CheckedIn);
                $("#BDS2CheckedIn").text(BDS2CheckedIn);
                $("#BDS3CheckedIn").text(BDS3CheckedIn);
                $("#BDS4CheckedIn").text(BDS4CheckedIn);
                $("#BDS5CheckedIn").text(BDS5CheckedIn);
                $("#BDS6CheckedIn").text(BDS6CheckedIn);
                $("#BDS7CheckedIn").text(BDS7CheckedIn);
                $("#BDS8CheckedIn").text(BDS8CheckedIn);
                $("#BDS9CheckedIn").text(BDS9CheckedIn);

                $("#OakbankCheckedIn").text(OakbankCheckedIn);

                $("#TerreglesCheckedIn").text(TerreglesCheckedIn);
                $("#WalkUpCheckedInMap").text(WalkUpCheckedIn);



                

                $("#Alpha1CheckedIn").text(Alpha1CheckedIn);
                $("#Alpha2CheckedIn").text(Alpha2CheckedIn);
                $("#Alpha3CheckedIn").text(Alpha3CheckedIn);
                $("#Alpha4CheckedIn").text(Alpha4CheckedIn);


                $("#AlphaTS1").text(AlphaTS1);
                $("#AlphaTS2").text(AlphaTS2);
                $("#EncTS1").text(EncTS1);
                $("#TerraceTS1").text(TerraceTS1);
                $("#BDSTS1").text(BDSTS1);
                $("#BDSTS2").text(BDSTS2);
                $("#totalhomesold").text(totalhomesold);
                $("#totalhomecheckedin").text(homecheckedin);  //change back to totalhomecheckedin after issue fixed
                $("#totalawaysold").text(totalawaysold);
                $("#totalawaycheckedin").text(awaycheckedin);//change back to totalawaycheckedin after issue fixed

                $("#other").text(other);

               
         

                
            };


            // ----------------------------------------------------------------
            //  Connection lifecycle.
            //
            //  This page is now a pure RECEIVER. The server-side TicketcoPoller
            //  imports from the TicketCo API and broadcasts on its own timer, so
            //  the dashboard never has to poll. On (re)connect we ask the server
            //  once for the current figures (populateDataTable) so the screen
            //  paints immediately instead of waiting for the next poll tick.
            // ----------------------------------------------------------------

            function requestInitialPaint() {
                // Cheap DB read + broadcast; does NOT hit the TicketCo API.
                chat.server.populateDataTable('').fail(function (err) {
                    console.log("populateDataTable failed", err);
                });
            }

            function connect() {
                $.connection.hub.start()
                    .done(function () {
                        console.log("connected");
                        requestInitialPaint();
                    })
                    .fail(function () {
                        console.log("connect failed, retrying in 5s");
                        setTimeout(connect, 5000);
                    });
            }

            // Show the operator when the feed has dropped rather than silently
            // leaving stale numbers on screen.
            $.connection.hub.disconnected(function () {
                console.log("disconnected");
                $("#lastupdate").text("Reconnecting…");
                setTimeout(connect, 5000);
            });

            connect();

        });

    </script>
  

</body>
</html>
