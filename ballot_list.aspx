<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ballot_list.aspx.vb" Inherits="admintickets.ballot_list" %>

<%@ register TagPrefix="UCHeader" tagname="Header" Src="~/UC_header.ascx" %>
<%@ register TagPrefix="UCFooter" tagname="Footer" Src="~/UC_footer.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>QOS Ballot Entry Admin</title>
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />


    <link href="css/jquery-ui.min.css" rel="stylesheet" />
    
    <link href="css/bs4_custom.css" rel="stylesheet" />
    <link href="css/print.css" rel="stylesheet" />
    <link href="css/all.min.css" rel="stylesheet" />

    <style>

        input[type=checkbox]:checked+label {
            background-color: inherit!important;
            color: inherit!important;
        }
        .reset {
            position:inherit!important;
            left: inherit!important;
            top: inherit!important;
            width: inherit!important;
            height:inherit!important;
        }

        .table-seperated {
            border-collapse:separate; 
border-spacing:0 1em;
        }

        .table-seperated .border-left, .table-seperated .border-right, .table-seperated .border-top, .table-seperated .border-bottom, .border-thick {
            border-width: 5px!important;
        }
        .table-key {
            font-size: 0.8rem;
        }
        .table-key td {
            padding: 5px;
        }
        .border-bottom-thin {
            border-width: 1px!important;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
       <UCHeader:Header runat="server" ID="UCHeader" ></UCHeader:Header>
        <div class="container">
            <div class="row mt-4">
                <div class="col-7 alert alert-primary">
                    <h5>Kilmarnock
                    </h5>
                    <p class="font-weight-bold">Saturday 8th January</p>

                <div class="row no-gutters">
                    <div class="col-6">
                    <p>Ballot Entries (fans) : <span id="totalentries" runat="server"></span></p>
                    <p>Entries Unchecked : <span id="Luncheckedcount" runat="server"></span></p>
                    <p>Entries Checked - correct : <span id="Lcheckedcorrect" runat="server"></span></p>
                    <p>Entries Checked - incorrect : <span id="Lcheckedincorrect" runat="server"></span></p>
                    <p>Ballot Succesful : <span id="Lselectedcount" runat="server"></span></p>
                    <p>Ballot Unsuccesful : <span id="Lnotselectedcount" runat="server"></span></p>
                    <p>BDS Seat Allocated : <span id="Lallocatedcount" runat="server"></span></p>
                        <p>Alpha Seat Allocated : <span id="Lmainallocatedcount" runat="server"></span></p>
                    <p>Terrace Allocated : <span id="Lterraceallocatedcount" runat="server"></span></p>
                    <p>Excluded : <span id="Lexcludedcount" runat="server"></span></p>
                    </div>
                    <div class="col-6 text-right">
                    <p>Prefer Seat : <span id="Lseatpref" runat="server"></span></p>
                    <p>Prefer Terrace : <span id="Lterracepref" runat="server"></span></p>
                    <p>No Preference: <span id="Lnopref" runat="server"></span></p>
                        </div>
                    </div>



                   
                </div>
                <div class="col-3 offset-2 bg-white">
                    <h5>Key</h5>
                    <table class="table table-seperated table-key table-borderless">
                        <tr>
                            <td class="border-left border-top border-right border-bottom border-dark">&nbsp;</td>
                            <td class="pl-4">Unchecked</td>
<%--                            <td>&nbsp;</td>
                            <td>&nbsp;</td>--%>

                            </tr>
                        <tr>
                                                         <td class="border-left border-top border-right border-bottom border-primary">&nbsp;</td>
                            <td class="pl-4">Details Confirmed</td>
                                                        </tr>
                        <tr>
                                                         <td class="border-left border-top border-right border-bottom border-warning">&nbsp;</td>
                            <td class="pl-4">Details Incorrect</td>
                        </tr>
                        <tr>


                            <td class="border-left border-top border-right border-bottom border-success">&nbsp;</td>
                            <td class="pl-4">Selected</td>
                                                        </tr>
                        <tr>
                             <td class="border-left border-top border-right border-bottom border-success table-success">&nbsp;</td>
                            <td class="pl-4">Seat Allocated</td>
                        </tr>
                            <tr>
                            <td class="border-left border-top border-right border-bottom border-danger ">&nbsp;</td>
                            <td class="pl-4">Not Selected</td>
                                                            </tr>
                        <tr>

                            <td class="border-left border-top border-right border-bottom border-danger table-danger">&nbsp;</td>
                            <td class="pl-4">Excluded</td>
                        </tr>

                    </table>
                </div>

            </div>
            </div>
        <div class="container-fluid">
            <div class="row bg-white mt-4">
                <div class="col-12">

                           <asp:panel ID="PNlist" runat="server" Visible="true">
           
           </asp:panel>



                    </div>
            </div>


        </div>
     <div class="d-none" >

           <span class="d-none" id="SeasonID" runat="server"></span>
        </div>


    </form>
      <!--Script references. 
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->


    <!--Reference the jQuery library. -->
    <script src="Scripts/jquery-3.4.1.min.js" ></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
    <script src="Scripts/jquery-ui.min.js"></script>

<%--    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.debug.js" integrity="sha384-NaWTHo/8YCBYJ59830LTz/P4aQZK1sS0SneOgAvhsIl3zBu8r9RevNg5lHCHAuQ/" crossorigin="anonymous"></script>
    --%>


    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.65/pdfmake.min.js" crossorigin="anonymous" type="text/javascript"></script>
  <%--  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.65/pdfmake.min.js.map" crossorigin="anonymous" type="text/javascript"></script>--%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.65/vfs_fonts.min.js" crossorigin="anonymous" type="text/javascript"></script>


    <!--Reference the SignalR library. -->
    <script src="Scripts/jquery.signalR-2.2.2.min.js"></script>
    <!--Reference the autogenerated SignalR hub script. -->
    <script src="signalr/hubs"></script>
    <!--Add script to update the page and send messages.--> 
    <script type="text/javascript">






        $(function () {
            // Declare a proxy to reference the hub. 
            var chat = $.connection.chatHubnewrestricted;
            // Create a function that the hub can call to broadcast messages.
            chat.client.broadcastMessage = function (action, seat, seatname, seatemail, seatpostcode, seattype, seatstatus, card, seatCSSclass, seatDOB, seatAddress, ticketid, seasonid) {
                // Html encode display name and message. 
                var encodedaction = $('<div />').text(action).html();
                var encodedseat = $('<div />').text(seat).html();
                var encodedname = $('<div />').text(seatname).html();
                var encodedemail = $('<div />').text(seatemail).html();
                var encodedpostcode = $('<div />').text(seatpostcode).html();
                var encodedtype = $('<div />').text(seattype).html();
                var encodedstatus = $('<div />').text(seatstatus).html();
                var encodedcard = $('<div />').text(card).html();
                var encodedcss = $('<div />').text(seatCSSclass).html();
                var encodedDOB = $('<div />').text(seatDOB).html();
                var encodedaddress = $('<div />').text(seatAddress).html();
                var encodedticketid = $('<div />').text(ticketid).html();
                var encodedseasonid = $('<div />').text(seasonid).html();
                console.log("encodedseasonid = " + encodedseasonid);
                var fixtureid = $("#SeasonID").text();

                if (encodedseasonid == fixtureid) {
                    console.log("matched fixture");

                    if (encodedaction == "status_update") {
                        
                        var seasonticketid = encodedticketid;
                        var statusid = parseInt(encodedseat);
                        var statusnotes = encodedname;
                        var cssborderclass = '';
                        var cssbackclass = '';

                        console.log("status: " + statusid);

                        if (statusid == 1) {

                            cssborderclass = 'border-dark';

                        }
                        else if (statusid == 2) {
                            cssborderclass = 'border-primary';

                        }
                        else if (statusid == 3) {
                            cssborderclass = 'border-warning';
                        }
                        else if (statusid == 4) {
                            cssborderclass = 'border-success';
                            
                        }
                        else if (statusid == 5) {
                        cssborderclass = 'border-danger';
                        }
                        else if (statusid == 6) {

                           cssborderclass = 'border-danger';
                            cssbackclass = 'table-danger'
                        }
                        else if (statusid == 7) {
                            cssborderclass = 'border-success';
                            cssbackclass = 'table-success'
                        }
                        else if (statusid == 8) {
                            cssborderclass = 'border-success';
                            cssbackclass = 'table-success'
                        }

                        else if (statusid == 9) {
                            cssborderclass = 'border-success';
                            cssbackclass = 'table-success'
                        }

                        $("#" + seasonticketid).removeClass("border-dark");
                        $("#" + seasonticketid).removeClass("border-primary");
                        $("#" + seasonticketid).removeClass("border-warning");
                        $("#" + seasonticketid).removeClass("border-success");
                        $("#" + seasonticketid).removeClass("border-danger");
                        $("#" + seasonticketid).removeClass("table-danger");
                        $("#" + seasonticketid).removeClass("table-success");



                        $("#" + seasonticketid).addClass(cssborderclass);
                        $("#" + seasonticketid).addClass(cssbackclass);


                        $("#status" + seasonticketid).val('');
                        $("#status" + seasonticketid).val(statusid);
                        $("#notes" + seasonticketid).val(statusnotes);
                        
                                                                                          
                    } //end of status update


                    if (encodedaction == "save") {
                        console.log("matched save action");
                        var seasonticketid = encodedticketid;

                        $("#" + seasonticketid).removeClass("border-dark");
                        $("#" + seasonticketid).removeClass("border-primary");
                        $("#" + seasonticketid).removeClass("border-warning");
                        $("#" + seasonticketid).removeClass("border-success");
                        $("#" + seasonticketid).removeClass("border-danger");
                        $("#" + seasonticketid).removeClass("table-danger");
                        $("#" + seasonticketid).removeClass("table-success");



                        $("#" + seasonticketid).addClass("border-success");
                        $("#" + seasonticketid).addClass("table-success");


                        $("#status" + seasonticketid).val('');
                        $("#status" + seasonticketid).val(7);

                    }




                }; //end of check for season id being correct (fixtureid)

            };



            $.connection.hub.start().done(function () {
                var fixtureid = $("#SeasonID").text();



                $(document).on('click', '[class^="savechanges"]', function () {

              //  $(document).on('click', ".savechanges", function () {

                    event.stopPropagation();
                    event.stopImmediatePropagation();
                    event.preventDefault();

                    var fullcssclass = $(this).attr('class');
                    var shortcssclass = fullcssclass.replace("btn btn-primary", "");
                    console.log(shortcssclass);
                    var Rowid = shortcssclass.replace("savechanges", "");
                    Rowid = $.trim(Rowid);
                    

                    var ticketid = $(this).attr("id");
                    console.log("row:" + Rowid);
                    console.log("ticket:" + ticketid);
                    var currentstatus = $("#status" + ticketid).val();
                console.log("current status:" + currentstatus);

                var notes = $("#notes" + ticketid).val();
                console.log("notes:" + notes);
                

                //send to hub to write to server
                    chat.server.updatestatus(fixtureid, ticketid, Rowid, currentstatus, notes);


                });

                //function onsaveclick(rowID) {

                //    event.stopPropagation();
                //    event.stopImmediatePropagation();
                //    event.preventDefault();
                //    console.log("button clicked");


                //    //console.log("row:" + rowID);
                //    //console.log("click save" + $(this).attr("id"));
                //    //var seasonticketid = $(this).attr("id");
                //    //var currentstatus = $("#status" + seasonticketid).val();
                //    //console.log("current status:" + currentstatus);

                //    //var notes = $("#notes" + seasonticketid).val();
                //    //console.log("notes:" + notes);


                ////send to hub to write to server



                //}


            });


        });



    </script>
         <UCFooter:Footer runat="server" ID="Footer1" ></UCFooter:Footer>
    </body>
</html>
