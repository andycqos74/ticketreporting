<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="dash_control.aspx.vb" Inherits="admintickets.dash_control" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>TMS Main Stand</title>
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
         </style>

</head>
<body class="flex">
    <form id="form1" runat="server">


        <div class="container pt-4">

                        <div class="row">
                <div class="col-12 text-right">
                    <h5 id="lastupdate">NP</h5>
                </div>
            </div>



            <div class="row pt-4">
                <div class="col-12">
                    <div class="form-group">
                        <label for="fixtureid">Fixture ID (leave blank for auto &ndash; next home match)</label>
                        <input id="fixtureid" class="form-control" type="text" placeholder="Blank = auto (next home match)" />

                    </div>

                      <div class="form-group">
                        <label for="fixtureid">Enter Update Interval (secs)</label>
                        <input id="updateInterval" class="form-control" type="text" placeholder="Update Interval (secs)" />

                    </div>

                     <button id="btnstart" type="submit" class="btn btn-success">Start</button>
                    <button id="btnstop" type="submit" class="btn btn-danger">Stop</button>

                </div>
            </div>

            <div class="row pt-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">Poller status</div>
                        <div class="card-body">
                            <p class="mb-2">
                                State:
                                <span id="statusState" class="badge badge-secondary">Unknown</span>
                            </p>
                            <p class="mb-2">Mode: <strong id="statusMode">-</strong></p>
                            <p class="mb-2">Current fixture ID: <strong id="statusFixture">-</strong></p>
                            <p class="mb-0">Current refresh interval: <strong id="statusInterval">-</strong> secs</p>
                        </div>
                    </div>
                </div>
            </div>

                           <div class="row pt-4">
                <div class="col-12 text-right">
                    <h5 id="log">NP</h5>
                </div>
            </div>

            <!-- ===================== Ticket-type mapping (admin) ===================== -->
            <div class="row pt-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">Ticket-type mapping (admin)</div>
                        <div class="card-body">
                            <div class="form-row align-items-end">
                                <div class="form-group col-md-6">
                                    <label for="mapFixtureSel">Fixture</label>
                                    <select id="mapFixtureSel" class="form-control">
                                        <option value="">(load fixtures&hellip;)</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-3">
                                    <label for="mapFixtureId">or Fixture ID</label>
                                    <input id="mapFixtureId" class="form-control" type="text" placeholder="TicketCo event id" />
                                </div>
                                <div class="form-group col-md-3">
                                    <button id="btnLoadFixtures" type="button" class="btn btn-outline-secondary">Load fixtures</button>
                                    <button id="btnUseCurrent" type="button" class="btn btn-outline-secondary">Use current</button>
                                    <button id="btnLoadTypes" type="button" class="btn btn-primary">Load ticket types</button>
                                </div>
                            </div>

                            <div class="form-row align-items-end">
                                <div class="form-group col-md-6">
                                    <label for="seasonRef">Season pass reference (one-time type import)</label>
                                    <input id="seasonRef" class="form-control" type="text" placeholder="TicketCo season pass id (blank = all active)" />
                                </div>
                                <div class="form-group col-md-6">
                                    <button id="btnImportSeason" type="button" class="btn btn-outline-secondary">Import season pass types</button>
                                    <small id="seasonLog" class="text-muted d-block mt-1"></small>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-sm" id="mapTable" style="display:none;">
                                    <thead>
                                        <tr>
                                            <th>Ticket type</th>
                                            <th class="text-right">Sold</th>
                                            <th class="text-right">Checked in</th>
                                            <th>Home / Away</th>
                                            <th>Attendance uses</th>
                                            <th>Channel</th>
                                            <th>Category</th>
                                        </tr>
                                    </thead>
                                    <tbody id="mapBody"></tbody>
                                </table>
                            </div>

                            <div class="form-row align-items-end mt-2">
                                <div class="form-group col-md-4">
                                    <label for="otherManual">Manual &ldquo;other&rdquo; figure (this fixture)</label>
                                    <input id="otherManual" class="form-control" type="number" value="0" />
                                </div>
                                <div class="form-group col-md-8">
                                    <button id="btnSaveMap" type="button" class="btn btn-success" style="display:none;">Save mapping</button>
                                </div>
                            </div>
                            <p class="mb-0"><small id="mapLog" class="text-muted"></small></p>
                        </div>
                    </div>
                </div>
            </div>



        </div> <!-- end of container -->










 

    </form>
      <!--Script references. 
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->


    <!--Reference the jQuery library. -->
    <script src="Scripts/jquery-3.4.1.min.js" ></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
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
            chat.client.broadcastMessage = function (TotalCheckedIn, WalkUpCheckedIn, OnlineCheckedIn, OnlineSold, SeasonTicketsCheckedIn, AwaySold, HomeSold, awaycheckedin, homecheckedin, BDS1CheckedIn, BDS2CheckedIn, BDS3CheckedIn, BDS4CheckedIn, BDS5CheckedIn, BDS7CheckedIn, BDS8CheckedIn, BDS9CheckedIn, OakbankCheckedIn, TerreglesCheckedIn, Alpha1CheckedIn, Alpha2CheckedIn, Alpha3CheckedIn, Alpha4CheckedIn, AlphaTS1, AlphaTS2, EncTS1, TerraceTS1, BDSTS1, BDSTS2, lastupdate) {
                // Html encode display name and message. 
                //var TotalCheckedIn = $('<div />').text(TotalCheckedIn).html();
                //var WalkUpCheckedIn = $('<div />').text(WalkUpCheckedIn).html();
                //var OnlineCheckedIn = $('<div />').text(OnlineCheckedIn).html();
                //var OnlineSold = $('<div />').text(OnlineSold).html();
                //var SeasonTicketsCheckedIn = $('<div />').text(SeasonTicketsCheckedIn).html();
                //var awaycheckedin = $('<div />').text(awaycheckedin).html();
                //var homecheckedin = $('<div />').text(homecheckedin).html();
                var lastupdate = $('<div />').text(lastupdate).html();
                //var BDS1CheckedIn = $('<div />').text(BDS1CheckedIn).html();
                //var BDS2CheckedIn = $('<div />').text(BDS2CheckedIn).html();
                //var BDS3CheckedIn = $('<div />').text(BDS3CheckedIn).html();
                //var BDS4CheckedIn = $('<div />').text(BDS4CheckedIn).html();
                //var BDS5CheckedIn = $('<div />').text(BDS5CheckedIn).html();
                //var BDS7CheckedIn = $('<div />').text(BDS7CheckedIn).html();
                //var BDS8CheckedIn = $('<div />').text(BDS8CheckedIn).html();
                //var BDS9CheckedIn = $('<div />').text(BDS9CheckedIn).html();
                //var OakbankCheckedIn = $('<div />').text(OakbankCheckedIn).html();

                //var TerreglesCheckedIn = $('<div />').text(TerreglesCheckedIn).html();

                //var Alpha1CheckedIn = $('<div />').text(Alpha1CheckedIn).html();
                //var Alpha2CheckedIn = $('<div />').text(Alpha2CheckedIn).html();
                //var Alpha3CheckedIn = $('<div />').text(Alpha3CheckedIn).html();
                //var Alpha4CheckedIn = $('<div />').text(Alpha4CheckedIn).html();


                //$("#TotalCheckedIn").text(TotalCheckedIn);
                //$("#WalkUpCheckedIn").text(WalkUpCheckedIn);
                //$("#OnlineCheckedIn").text(OnlineCheckedIn);
                //$("#OnlineSold").text(OnlineSold);
                //$("#SeasonTicketsCheckedIn").text(SeasonTicketsCheckedIn);
                //$("#awaycheckedin").text(awaycheckedin);
                //$("#homecheckedin").text(homecheckedin);
                $("#lastupdate").text(lastupdate);
                //$("#BDS1CheckedIn").text(BDS1CheckedIn);
                //$("#BDS2CheckedIn").text(BDS2CheckedIn);
                //$("#BDS3CheckedIn").text(BDS3CheckedIn);
                //$("#BDS4CheckedIn").text(BDS4CheckedIn);
                //$("#BDS5CheckedIn").text(BDS5CheckedIn);
                //$("#BDS7CheckedIn").text(BDS7CheckedIn);
                //$("#BDS8CheckedIn").text(BDS8CheckedIn);
                //$("#BDS9CheckedIn").text(BDS9CheckedIn);

                //$("#OakbankCheckedIn").text(OakbankCheckedIn);

                //$("#TerreglesCheckedIn").text(TerreglesCheckedIn);

                //$("#Alpha1CheckedIn").text(Alpha1CheckedIn);
                //$("#Alpha2CheckedIn").text(Alpha2CheckedIn);
                //$("#Alpha3CheckedIn").text(Alpha3CheckedIn);
                //$("#Alpha4CheckedIn").text(Alpha4CheckedIn);
            };


            ////reconnect connection
            //$.connection.hub.disconnected(function () {
            //    console.log("disconnected");
            //    setTimeout(function () {
            //        $.connection.hub.start();
            //    }, 5000); // Restart connection after 5 seconds.
            //    console.log("reconnected");
            //});

            //$.connection.hub.start().fail(function () {
            //    console.log("disconnected");
            //    setTimeout(function () {
            //        $.connection.hub.start();
            //    }, 5000); // Restart connection after 5 seconds.
            //    console.log("reconnected");
            //});


            var statusTimer = null;

            // Ask the server for the poller's real state and paint the status line.
            function refreshStatus() {
                chat.server.getStatus()
                    .done(function (s) {
                        if (s.running) {
                            $("#statusState").text("Running")
                                .removeClass("badge-secondary badge-danger").addClass("badge-success");
                        } else {
                            $("#statusState").text("Stopped")
                                .removeClass("badge-secondary badge-success").addClass("badge-danger");
                        }
                        $("#statusMode").text(s.auto ? "Auto (next home match)" : "Manual override");
                        $("#statusFixture").text(s.eventId);
                        $("#statusInterval").text(s.intervalSeconds);
                    });
            }

            // Start tells the SERVER to run its own poll loop (API import +
            // broadcast) for this fixture/interval. Once started the loop lives
            // in the web app, so this browser tab can be closed.
            $("#btnstart").click(function (event) {
                event.preventDefault();
                event.stopImmediatePropagation();

                var fixtureId = $.trim($("#fixtureid").val());   // blank = auto (next home match)
                var interval = parseInt($("#updateInterval").val(), 10) || 30;

                chat.server.startPolling(fixtureId, interval)
                    .done(function () {
                        $("#log").text(fixtureId
                            ? ("Server polling started for fixture " + fixtureId + " every " + interval + "s.")
                            : ("Server polling started in AUTO mode (next home match) every " + interval + "s."));
                        refreshStatus();
                    })
                    .fail(function (e) { $("#log").text("Start failed: " + e); });
            });

            $("#btnstop").click(function (event) {
                event.preventDefault();
                event.stopImmediatePropagation();

                chat.server.stopPolling()
                    .done(function () {
                        $("#log").text("Server polling stopped.");
                        refreshStatus();
                    })
                    .fail(function (e) { $("#log").text("Stop failed: " + e); });
            });

            function connect() {
                $.connection.hub.start()
                    .done(function () {
                        refreshStatus();
                        // Keep the status line honest even if the poller is
                        // started/stopped from another browser or by auto-start.
                        if (!statusTimer) { statusTimer = setInterval(refreshStatus, 5000); }
                    })
                    .fail(function () { setTimeout(connect, 5000); });
            }

            $.connection.hub.disconnected(function () {
                $("#statusState").text("Disconnected")
                    .removeClass("badge-success badge-danger").addClass("badge-secondary");
                setTimeout(connect, 5000);
            });

            connect();

            // ---------------- Ticket-type mapping (admin) ----------------
            var OPT_HOMEAWAY = [["home", "Home"], ["away", "Away"], ["na", "N/A"]];
            var OPT_ATT = [["checkedin", "Checked in"], ["sold", "Sold"], ["exclude", "Exclude"]];
            var OPT_CHAN = [["online", "Online"], ["walkup", "Walk-up"]];
            var OPT_CAT = [["match", "Match ticket"], ["season", "Season ticket"]];

            function esc(s) { return $("<div/>").text(s == null ? "" : s).html(); }

            function sel(cls, opts, val) {
                var h = '<select class="form-control form-control-sm ' + cls + '">';
                for (var i = 0; i < opts.length; i++) {
                    h += '<option value="' + opts[i][0] + '"' +
                         (opts[i][0] === val ? " selected" : "") + '>' + opts[i][1] + '</option>';
                }
                return h + "</select>";
            }

            function renderMap(types, existing, otherManual) {
                var byType = {};
                (existing || []).forEach(function (m) { byType[m.tickettype] = m; });
                var body = $("#mapBody").empty();
                types.forEach(function (t) {
                    var m = byType[t.tickettype] || {};
                    // Defaults for an un-mapped type: use the suggested category
                    // from the server (season vs match); season types default to
                    // Home. Any saved mapping always wins.
                    var suggestedCat = t.category || "match";
                    var defHa = (suggestedCat === "season") ? "home" : "na";
                    body.append('<tr data-type="' + esc(t.tickettype) + '">' +
                        '<td>' + esc(t.tickettype) + '</td>' +
                        '<td class="text-right">' + t.sold + '</td>' +
                        '<td class="text-right">' + t.checkedin + '</td>' +
                        '<td>' + sel("m-ha", OPT_HOMEAWAY, m.homeaway || defHa) + '</td>' +
                        '<td>' + sel("m-att", OPT_ATT, m.attendance || "checkedin") + '</td>' +
                        '<td>' + sel("m-chan", OPT_CHAN, m.channel || "online") + '</td>' +
                        '<td>' + sel("m-cat", OPT_CAT, m.category || suggestedCat) + '</td>' +
                        '</tr>');
                });
                $("#otherManual").val(otherManual || 0);
                $("#mapTable").show();
                $("#btnSaveMap").show();
            }

            // Resolve the fixture id: an explicit typed id wins, otherwise the
            // dropdown selection.
            function fixtureId() {
                var typed = $.trim($("#mapFixtureId").val());
                if (typed) { return typed; }
                return $("#mapFixtureSel").val() || "";
            }

            // Selecting a fixture from the dropdown clears any stale typed id.
            $("#mapFixtureSel").change(function () {
                if ($(this).val()) { $("#mapFixtureId").val(""); }
            });

            $("#btnLoadFixtures").click(function () {
                $("#mapLog").text("Loading fixtures…");
                chat.server.getFixtures().done(function (rows) {
                    var $s = $("#mapFixtureSel").empty();
                    $s.append('<option value="">(select a fixture)</option>');
                    (rows || []).forEach(function (f) {
                        var when = (f.startAt || "").substring(0, 10);
                        var label = f.title + (when ? " — " + when : "") +
                                    " (sold " + (f.sold || 0) + ", id " + f.id + ")";
                        $s.append($("<option/>").val(f.id).text(label));
                    });
                    $("#mapLog").text((rows ? rows.length : 0) + " fixtures loaded.");
                }).fail(function (e) { $("#mapLog").text("Fixtures load failed: " + e); });
            });

            $("#btnUseCurrent").click(function () {
                $("#mapFixtureId").val($("#statusFixture").text());
                $("#mapFixtureSel").val("");
            });

            // One-time import of season-pass ticket types into the catalogue.
            $("#btnImportSeason").click(function () {
                var ref = $.trim($("#seasonRef").val());
                $("#seasonLog").text("Importing…");
                chat.server.importSeasonTypes(ref).done(function (res) {
                    if (res && res.ok) {
                        $("#seasonLog").text("Imported " + res.imported + " season type(s): " +
                            (res.titles || []).join(", "));
                    } else {
                        $("#seasonLog").text("Import error: " + (res ? res.error : "unknown"));
                    }
                }).fail(function (e) { $("#seasonLog").text("Import failed: " + e); });
            });

            $("#btnLoadTypes").click(function () {
                var fid = fixtureId();
                if (!fid) { $("#mapLog").text("Select or enter a fixture."); return; }
                $("#mapLog").text("Loading…");
                chat.server.getTicketTypes(fid).done(function (types) {
                    chat.server.getMapping(fid).done(function (map) {
                        renderMap(types, map.mappings, map.otherManual);
                        $("#mapLog").text(types.length + " ticket types loaded.");
                    });
                }).fail(function (e) { $("#mapLog").text("Load failed: " + e); });
            });

            $("#btnSaveMap").click(function () {
                var fid = fixtureId();
                if (!fid) { $("#mapLog").text("Select or enter a fixture."); return; }
                var rows = [];
                $("#mapBody tr").each(function () {
                    var $t = $(this);
                    rows.push({
                        tickettype: $t.attr("data-type"),
                        homeaway: $t.find(".m-ha").val(),
                        attendance: $t.find(".m-att").val(),
                        channel: $t.find(".m-chan").val(),
                        category: $t.find(".m-cat").val()
                    });
                });
                var other = parseInt($("#otherManual").val(), 10) || 0;
                chat.server.saveMapping(fid, JSON.stringify(rows), other)
                    .done(function () { $("#mapLog").text("Mapping saved (" + rows.length + " types)."); })
                    .fail(function (e) { $("#mapLog").text("Save failed: " + e); });
            });



                       
        });

     
    </script>
  

</body>
</html>
