<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="dash_display.aspx.vb" Inherits="admintickets.dash_display" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Live Ticket Report</title>
    <link href="https://fonts.googleapis.com/css2?family=Barlow:wght@400;500;600;700&family=Barlow+Condensed:wght@600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --bg:#081524; --card:#0e2136; --border:#1e3a5c; --track:#132c49;
            --text:#eaf1f9; --muted:#8fa5bd; --dim:rgba(234,241,249,.6);
            --green:#46c06d; --green-d:#2c9a55; --blue:#82b6ea;
            --gate:#123156; --gate-b:#24487a;
        }
        * { box-sizing:border-box; margin:0; padding:0; }
        html, body { overflow-x:hidden; }
        body { background:var(--bg); color:var(--text); font-family:'Barlow',Arial,sans-serif; -webkit-font-smoothing:antialiased; }
        .num { font-family:'Barlow Condensed','Barlow',sans-serif; }
        .card { background:var(--card); border:1px solid var(--border); border-radius:14px; }
        .muted { color:var(--muted); }
        .dim { color:var(--dim); }
        .track { height:8px; border-radius:999px; background:var(--track); overflow:hidden; }
        .track > i { display:block; height:100%; border-radius:999px; background:var(--green); width:0; transition:width .4s ease; }
        @keyframes pulse { 0%,100%{opacity:1;} 50%{opacity:.35;} }
        .tick { transition:opacity .3s ease; }
        .eyebrow { font-weight:600; color:var(--green); letter-spacing:.14em; text-transform:uppercase; }
        .gate { display:inline-flex; align-items:baseline; gap:6px; background:var(--gate); border:1px solid var(--gate-b); border-radius:999px; padding:5px 12px; }
        .gate b { font-weight:600; font-size:9px; color:var(--blue); letter-spacing:.08em; }
        .gate span { font-weight:700; font-size:16px; color:#fff; }
        .cell { border-radius:10px; border:1px solid var(--border); display:flex; flex-direction:column; align-items:center; justify-content:center; gap:1px; padding:6px 2px; transition:background .5s ease; }
        .cell .lbl { font-weight:600; font-size:11px; color:var(--dim); letter-spacing:.06em; }
        .cell .in  { font-weight:700; font-size:28px; color:var(--text); line-height:1; }
        .cell .sold{ font-weight:500; font-size:12px; color:var(--dim); }

        /* view switching */
        .view-desktop { display:block; }
        .view-mobile  { display:none; }
        @media (max-width:820px) {
            .view-desktop { display:none; }
            .view-mobile  { display:block; }
        }

        /* ---- 2a desktop ---- */
        .wrap { padding:28px; display:flex; flex-direction:column; gap:20px; max-width:1600px; margin:0 auto; }
        .hdr { display:flex; align-items:flex-end; justify-content:space-between; gap:16px; }
        .hdr .fx { font-weight:700; font-size:42px; color:var(--text); line-height:1; }
        .live { display:flex; align-items:center; gap:8px; background:var(--card); border:1px solid var(--border); border-radius:999px; padding:8px 16px; }
        .live .dot { width:9px; height:9px; border-radius:50%; background:var(--green); animation:pulse 2s infinite; }
        .hero { padding:22px 28px; display:flex; align-items:center; gap:36px; }
        .hero .big { font-weight:700; font-size:72px; color:var(--text); line-height:1.05; }
        .hero .rep { font-weight:700; font-size:50px; color:var(--green); line-height:1.1; }
        .lab { font-weight:600; font-size:12px; color:var(--muted); letter-spacing:.1em; text-transform:uppercase; }
        .type-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; }
        .tcard { padding:16px 18px; }
        .tcard .tt { font-weight:600; font-size:14px; color:var(--text); letter-spacing:.08em; }
        .chip { font-weight:700; font-size:12px; color:var(--green); background:rgba(70,192,109,.14); border-radius:999px; padding:2px 8px; }
        .tcard .val { font-weight:700; font-size:34px; line-height:1; }
        .map { padding:20px 24px; }
        .map .mtitle { font-weight:700; font-size:20px; color:var(--text); letter-spacing:.04em; }
        .mapgrid { display:grid; grid-template-columns:88px 1fr 88px; grid-template-rows:36px 108px 250px 108px 36px; gap:10px; }
        .side { border-radius:10px; border:1px solid var(--border); display:flex; flex-direction:column; align-items:center; justify-content:center; gap:8px; padding:10px 4px; transition:background .5s ease; }
        .side .rl { writing-mode:vertical-rl; font-weight:600; font-size:11px; color:var(--dim); letter-spacing:.1em; }
        .pitch { position:relative; border-radius:12px; overflow:hidden; background:repeating-linear-gradient(90deg,#1c5a34 0 64px,#17502d 64px 128px); }
        .pitch .mk { position:absolute; border:2px solid rgba(255,255,255,.4); }
        .bottom { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        .cardpad { padding:16px 20px; display:flex; flex-direction:column; gap:14px; }
        .barrow .cap { display:flex; justify-content:space-between; font-weight:600; font-size:13px; color:var(--text); margin-bottom:6px; }
        .standrow { display:flex; align-items:center; gap:12px; }

        /* ---- 2b mobile ---- */
        .mwrap { padding:18px 14px; display:flex; flex-direction:column; gap:14px; }
        .mcell { border-radius:6px; border:1px solid var(--border); display:flex; align-items:center; justify-content:center; transition:background .5s ease; }
    </style>
</head>
<body>
    <form id="form1" runat="server">

    <!-- =========================== DESKTOP (2a) =========================== -->
    <div class="view-desktop">
      <div class="wrap">

        <!-- header -->
        <div class="hdr">
          <div>
            <div class="eyebrow" style="font-size:12px;margin-bottom:4px;">Live ticket report &middot; Palmerston Park</div>
            <div class="fx num tick" data-f="fixturename">Loading &hellip;</div>
          </div>
          <div class="live">
            <span class="dot"></span>
            <span style="font-weight:600;font-size:14px;">LIVE</span>
            <span class="muted tick" style="font-weight:500;font-size:14px;" data-f="lastupdate">&mdash;</span>
          </div>
        </div>

        <!-- attendance hero -->
        <div class="card hero">
          <div style="flex:none;">
            <div class="lab">Checked in</div>
            <div class="big num tick" data-f="TotalCheckedIn">0</div>
            <div class="muted" style="font-weight:500;font-size:15px;">of <span class="tick" data-f="totalSold">&mdash;</span> tickets sold</div>
          </div>
          <div style="flex:1;">
            <div style="display:flex;justify-content:space-between;font-weight:600;font-size:14px;color:var(--muted);margin-bottom:8px;">
              <span><span class="tick" data-f="overallPct">&mdash;</span>% of sold tickets are inside</span>
              <span class="tick" data-f="totalSold">&mdash;</span>
            </div>
            <div class="track" style="height:18px;"><i data-bar="overall" style="background:linear-gradient(90deg,var(--green-d),var(--green));"></i></div>
          </div>
          <div style="flex:none;text-align:right;border-left:1px solid var(--border);padding-left:32px;">
            <div class="lab">Reported attendance</div>
            <div class="rep num tick" data-f="ReportedCrowd">0</div>
          </div>
        </div>

        <!-- ticket-type cards -->
        <div class="type-grid">
          <div class="card tcard">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
              <span class="tt">ONLINE</span><span class="chip tick" data-f="onlinePct">&mdash;</span>
            </div>
            <div style="display:flex;gap:24px;margin-bottom:10px;">
              <div><div class="lab" style="font-size:11px;">SOLD</div><div class="val num muted tick" data-f="OnlineSold">0</div></div>
              <div><div class="lab" style="font-size:11px;">CHECKED IN</div><div class="val num tick" data-f="OnlineCheckedIn">0</div></div>
            </div>
            <div class="track"><i data-bar="online"></i></div>
          </div>
          <div class="card tcard">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
              <span class="tt">SEASON TICKETS</span><span class="chip tick" data-f="seasonPct">&mdash;</span>
            </div>
            <div style="display:flex;gap:24px;margin-bottom:10px;">
              <div><div class="lab" style="font-size:11px;">ISSUED</div><div class="val num muted tick" data-f="seasonIssued">&mdash;</div></div>
              <div><div class="lab" style="font-size:11px;">CHECKED IN</div><div class="val num tick" data-f="SeasonTicketsCheckedIn">0</div></div>
            </div>
            <div class="track"><i data-bar="season"></i></div>
          </div>
          <div class="card tcard">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
              <span class="tt">WALK-UPS</span><span class="chip tick" data-f="walkupPct">&mdash;</span>
            </div>
            <div style="display:flex;gap:24px;margin-bottom:10px;">
              <div><div class="lab" style="font-size:11px;">SOLD</div><div class="val num muted tick" data-f="walkupSold">&mdash;</div></div>
              <div><div class="lab" style="font-size:11px;">CHECKED IN</div><div class="val num tick" data-f="WalkUpCheckedIn">0</div></div>
            </div>
            <div class="track"><i data-bar="walkup"></i></div>
          </div>
          <div class="card tcard">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
              <span class="tt">OTHER / COMPS</span><span class="chip tick" data-f="otherPct">&mdash;</span>
            </div>
            <div style="display:flex;gap:24px;margin-bottom:10px;">
              <div><div class="lab" style="font-size:11px;">SOLD</div><div class="val num muted tick" data-f="otherSold">0</div></div>
              <div><div class="lab" style="font-size:11px;">CHECKED IN</div><div class="val num tick" data-f="otherCheckedIn">0</div></div>
            </div>
            <div class="track"><i data-bar="other"></i></div>
          </div>
        </div>

        <!-- stadium map -->
        <div class="card map">
          <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:14px;">
            <div class="mtitle num">PALMERSTON PARK &mdash; CHECKED IN BY SECTION</div>
            <div style="display:flex;align-items:center;gap:10px;font-weight:500;font-size:12px;color:var(--muted);">
              <span>empty</span>
              <span style="width:90px;height:10px;border-radius:999px;background:linear-gradient(90deg,rgba(70,192,109,.1),rgba(70,192,109,.65));"></span>
              <span>full (checked in vs sold)</span>
            </div>
          </div>
          <div class="mapgrid">
            <!-- row 1 gates -->
            <div style="grid-column:1;grid-row:1;display:flex;align-items:center;justify-content:center;">
              <div class="gate"><b>TERRACE GATE</b><span class="num tick" data-f="TerraceTS1">0</span></div>
            </div>
            <div style="grid-column:2;grid-row:1;display:flex;align-items:center;justify-content:space-around;">
              <div class="gate"><b>BDS HOME</b><span class="num tick" data-f="BDSTS1">0</span></div>
              <div class="gate"><b>BDS AWAY</b><span class="num tick" data-f="BDSTS2">0</span></div>
            </div>
            <!-- BDS stand -->
            <div style="grid-column:2;grid-row:2;display:flex;flex-direction:column;gap:4px;">
              <div style="font-weight:600;font-size:11px;color:var(--muted);letter-spacing:.1em;text-align:center;">BDS STAND</div>
              <div style="display:grid;grid-template-columns:repeat(9,1fr);gap:8px;flex:1;" id="bdsRow"></div>
            </div>
            <!-- oakbank side -->
            <div style="grid-column:1;grid-row:2/5;" class="side" data-heat="oak">
              <div class="rl" style="transform:rotate(180deg);">OAKBANK SERVICES TERRACE</div>
              <div class="in num tick" data-f="OakbankCheckedIn" style="font-weight:700;font-size:28px;line-height:1;">0</div>
              <div class="sold tick" data-f="oakSold" style="font-weight:500;font-size:12px;color:var(--dim);">of &mdash;</div>
            </div>
            <!-- walkups side -->
            <div style="grid-column:3;grid-row:2/5;" class="side" data-heat="wup">
              <div class="rl">WALK-UPS</div>
              <div class="in num tick" data-f="WalkUpCheckedIn" style="font-weight:700;font-size:28px;line-height:1;">0</div>
              <div class="sold tick" data-f="wupSold" style="font-weight:500;font-size:12px;color:var(--dim);">of &mdash;</div>
            </div>
            <!-- pitch -->
            <div style="grid-column:2;grid-row:3;" class="pitch">
              <div class="mk" style="inset:14px;border-radius:2px;"></div>
              <div class="mk" style="top:14px;bottom:14px;left:50%;width:2px;border:none;background:rgba(255,255,255,.4);"></div>
              <div class="mk" style="top:50%;left:50%;width:120px;height:120px;margin:-60px 0 0 -60px;border-radius:50%;"></div>
              <div class="mk" style="top:50%;left:14px;width:70px;height:130px;margin-top:-65px;border-left:none;"></div>
              <div class="mk" style="top:50%;right:14px;width:70px;height:130px;margin-top:-65px;border-right:none;"></div>
              <div style="position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);font-family:'Barlow Condensed';font-weight:700;font-size:15px;color:rgba(255,255,255,.6);letter-spacing:.3em;">PALMERSTON PARK</div>
            </div>
            <!-- alpha stand -->
            <div style="grid-column:2;grid-row:4;display:flex;flex-direction:column;gap:4px;">
              <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:8px;flex:1;" id="alphaRow"></div>
              <div style="font-weight:600;font-size:11px;color:var(--muted);letter-spacing:.1em;text-align:center;">ALPHA STAND</div>
            </div>
            <!-- row 5 gates -->
            <div style="grid-column:1;grid-row:5;display:flex;align-items:center;justify-content:center;">
              <div class="gate"><b>ENCLOSURE GATE</b><span class="num tick" data-f="EncTS1">0</span></div>
            </div>
            <div style="grid-column:2;grid-row:5;display:flex;align-items:center;justify-content:space-around;">
              <div class="gate"><b>MAIN 3/4</b><span class="num tick" data-f="AlphaTS2">0</span></div>
              <div style="font-weight:600;font-size:11px;color:var(--muted);background:var(--track);border-radius:6px;padding:4px 10px;">HOSPITALITY BOX</div>
              <div style="font-weight:600;font-size:11px;color:var(--muted);background:var(--track);border-radius:6px;padding:4px 10px;">DIRECTORS BOX</div>
              <div class="gate"><b>MAIN 1</b><span class="num tick" data-f="AlphaTS1">0</span></div>
            </div>
          </div>
        </div>

        <!-- bottom -->
        <div class="bottom">
          <div class="card cardpad">
            <div class="num" style="font-weight:700;font-size:18px;letter-spacing:.04em;">HOME v AWAY (ONLINE SALES)</div>
            <div class="barrow">
              <div class="cap"><span>HOME</span><span class="muted" style="font-weight:500;"><span class="tick" data-f="homecheckedin">0</span> in &middot; <span class="tick" data-f="HomeSold">0</span> sold</span></div>
              <div class="track" style="height:10px;"><i data-bar="home" style="background:var(--blue);"></i></div>
            </div>
            <div class="barrow">
              <div class="cap"><span>AWAY</span><span class="muted" style="font-weight:500;"><span class="tick" data-f="awaycheckedin">0</span> in &middot; <span class="tick" data-f="AwaySold">0</span> sold</span></div>
              <div class="track" style="height:10px;"><i data-bar="away"></i></div>
            </div>
          </div>
          <div class="card cardpad" style="gap:10px;">
            <div class="num" style="font-weight:700;font-size:18px;letter-spacing:.04em;">BY STAND</div>
            <div class="standrow"><span style="width:170px;font-weight:600;font-size:13px;">BDS Stand</span><div class="track" style="flex:1;"><i data-bar="stBds"></i></div><span style="width:120px;text-align:right;font-weight:500;font-size:13px;color:var(--muted);"><span class="tick" data-f="bdsIn">0</span> / <span class="tick" data-f="bdsSold">&mdash;</span></span></div>
            <div class="standrow"><span style="width:170px;font-weight:600;font-size:13px;">Alpha Stand</span><div class="track" style="flex:1;"><i data-bar="stAlpha"></i></div><span style="width:120px;text-align:right;font-weight:500;font-size:13px;color:var(--muted);"><span class="tick" data-f="alphaIn">0</span> / <span class="tick" data-f="alphaSold">&mdash;</span></span></div>
            <div class="standrow"><span style="width:170px;font-weight:600;font-size:13px;">Oakbank Terrace</span><div class="track" style="flex:1;"><i data-bar="stOak"></i></div><span style="width:120px;text-align:right;font-weight:500;font-size:13px;color:var(--muted);"><span class="tick" data-f="OakbankCheckedIn">0</span> / <span class="tick" data-f="oakSold2">&mdash;</span></span></div>
            <div class="standrow"><span style="width:170px;font-weight:600;font-size:13px;">Walk-ups</span><div class="track" style="flex:1;"><i data-bar="stWalk"></i></div><span style="width:120px;text-align:right;font-weight:500;font-size:13px;color:var(--muted);"><span class="tick" data-f="WalkUpCheckedIn">0</span> / <span class="tick" data-f="wupSold2">&mdash;</span></span></div>
          </div>
        </div>

      </div>
    </div>

    <!-- =========================== MOBILE (2b) =========================== -->
    <div class="view-mobile">
      <div class="mwrap">
        <div style="display:flex;justify-content:space-between;align-items:center;gap:8px;">
          <div>
            <div class="eyebrow" style="font-size:10px;">Live ticket report</div>
            <div class="num tick" style="font-weight:700;font-size:20px;line-height:1.1;" data-f="fixturename">Loading &hellip;</div>
          </div>
          <div class="live" style="padding:6px 10px;gap:6px;flex:none;">
            <span class="dot" style="width:8px;height:8px;"></span>
            <span class="num tick" style="font-weight:600;font-size:12px;white-space:nowrap;" data-f="lastupdateShort">&mdash;</span>
          </div>
        </div>

        <div class="card" style="padding:14px 16px;">
          <div style="display:flex;justify-content:space-between;align-items:flex-end;margin-bottom:8px;">
            <div>
              <div class="lab" style="font-size:10px;">CHECKED IN</div>
              <div class="num tick" style="font-weight:700;font-size:40px;line-height:1;" data-f="TotalCheckedIn">0</div>
            </div>
            <div style="text-align:right;">
              <div class="lab" style="font-size:10px;">ATTENDANCE</div>
              <div class="num tick" style="font-weight:700;font-size:28px;line-height:1;color:var(--green);" data-f="ReportedCrowd">0</div>
            </div>
          </div>
          <div class="track" style="height:12px;margin-bottom:6px;"><i data-bar="overall" style="background:linear-gradient(90deg,var(--green-d),var(--green));"></i></div>
          <div class="muted" style="font-weight:500;font-size:12px;"><span class="tick" data-f="overallPct">&mdash;</span>% of <span class="tick" data-f="totalSold">&mdash;</span> sold tickets are inside</div>
        </div>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;">
          <div class="card" style="padding:10px 12px;">
            <div style="font-weight:600;font-size:11px;letter-spacing:.06em;margin-bottom:4px;">ONLINE</div>
            <div class="num" style="font-weight:700;font-size:24px;line-height:1;"><span class="tick" data-f="OnlineCheckedIn">0</span> <span class="muted" style="font-weight:500;font-size:13px;font-family:'Barlow';">/ <span class="tick" data-f="OnlineSold">0</span></span></div>
            <div class="track" style="height:6px;margin-top:8px;"><i data-bar="online"></i></div>
          </div>
          <div class="card" style="padding:10px 12px;">
            <div style="font-weight:600;font-size:11px;letter-spacing:.06em;margin-bottom:4px;">SEASON</div>
            <div class="num" style="font-weight:700;font-size:24px;line-height:1;"><span class="tick" data-f="SeasonTicketsCheckedIn">0</span> <span class="muted" style="font-weight:500;font-size:13px;font-family:'Barlow';">/ <span class="tick" data-f="seasonIssued">&mdash;</span></span></div>
            <div class="track" style="height:6px;margin-top:8px;"><i data-bar="season"></i></div>
          </div>
          <div class="card" style="padding:10px 12px;">
            <div style="font-weight:600;font-size:11px;letter-spacing:.06em;margin-bottom:4px;">WALK-UPS</div>
            <div class="num" style="font-weight:700;font-size:24px;line-height:1;"><span class="tick" data-f="WalkUpCheckedIn">0</span> <span class="muted" style="font-weight:500;font-size:13px;font-family:'Barlow';">/ <span class="tick" data-f="walkupSold">&mdash;</span></span></div>
            <div class="track" style="height:6px;margin-top:8px;"><i data-bar="walkup"></i></div>
          </div>
          <div class="card" style="padding:10px 12px;">
            <div style="font-weight:600;font-size:11px;letter-spacing:.06em;margin-bottom:4px;">OTHER</div>
            <div class="num" style="font-weight:700;font-size:24px;line-height:1;"><span class="tick" data-f="otherCheckedIn">0</span> <span class="muted" style="font-weight:500;font-size:13px;font-family:'Barlow';">/ <span class="tick" data-f="otherSold">0</span></span></div>
            <div class="track" style="height:6px;margin-top:8px;"><i data-bar="other"></i></div>
          </div>
        </div>

        <div class="card" style="padding:12px;">
          <div class="num" style="font-weight:700;font-size:14px;letter-spacing:.04em;margin-bottom:10px;">CHECKED IN BY SECTION</div>
          <div style="display:grid;grid-template-columns:22px 1fr 22px;grid-template-rows:44px 90px 44px;gap:5px;">
            <div class="mcell" style="grid-column:1;grid-row:1/4;" data-heat="oak"><span class="num tick" style="writing-mode:vertical-rl;transform:rotate(180deg);font-weight:700;font-size:12px;" data-f="OakbankCheckedIn">0</span></div>
            <div style="grid-column:2;grid-row:1;display:grid;grid-template-columns:repeat(9,1fr);gap:4px;" id="bdsRowM"></div>
            <div class="mcell" style="grid-column:3;grid-row:1/4;" data-heat="wup"><span class="num tick" style="writing-mode:vertical-rl;font-weight:700;font-size:12px;" data-f="WalkUpCheckedIn">0</span></div>
            <div class="pitch" style="grid-column:2;grid-row:2;border-radius:8px;background:repeating-linear-gradient(90deg,#1c5a34 0 30px,#17502d 30px 60px);">
              <div class="mk" style="inset:8px;border-width:1px;"></div>
              <div class="mk" style="top:8px;bottom:8px;left:50%;width:1px;border:none;background:rgba(255,255,255,.4);"></div>
              <div class="mk" style="top:50%;left:50%;width:36px;height:36px;margin:-18px 0 0 -18px;border-width:1px;border-radius:50%;"></div>
            </div>
            <div style="grid-column:2;grid-row:3;display:grid;grid-template-columns:repeat(4,1fr);gap:4px;" id="alphaRowM"></div>
          </div>
          <div style="display:flex;justify-content:space-between;font-weight:600;font-size:9px;color:var(--muted);letter-spacing:.08em;margin-top:6px;"><span>OAKBANK</span><span>BDS (top) &middot; ALPHA (bottom)</span><span>WALK-UPS</span></div>
        </div>

        <div class="card" style="padding:12px;">
          <div class="num" style="font-weight:700;font-size:14px;letter-spacing:.04em;margin-bottom:8px;">GATES &mdash; FANS THROUGH TURNSTILES</div>
          <div style="display:flex;flex-wrap:wrap;gap:6px;">
            <div class="gate" style="padding:4px 10px;"><b>BDS HOME</b><span class="num tick" style="font-size:14px;" data-f="BDSTS1">0</span></div>
            <div class="gate" style="padding:4px 10px;"><b>BDS AWAY</b><span class="num tick" style="font-size:14px;" data-f="BDSTS2">0</span></div>
            <div class="gate" style="padding:4px 10px;"><b>MAIN 3/4</b><span class="num tick" style="font-size:14px;" data-f="AlphaTS2">0</span></div>
            <div class="gate" style="padding:4px 10px;"><b>MAIN 1</b><span class="num tick" style="font-size:14px;" data-f="AlphaTS1">0</span></div>
            <div class="gate" style="padding:4px 10px;"><b>TERRACE GATE</b><span class="num tick" style="font-size:14px;" data-f="TerraceTS1">0</span></div>
            <div class="gate" style="padding:4px 10px;"><b>ENCLOSURE GATE</b><span class="num tick" style="font-size:14px;" data-f="EncTS1">0</span></div>
          </div>
        </div>
      </div>
    </div>

    </form>

    <script src="Scripts/jquery-3.4.1.min.js"></script>
    <script src="Scripts/jquery.signalR-2.2.2.min.js"></script>
    <script src="signalr/hubs"></script>
    <script type="text/javascript">
        // ---- section cell templates (desktop + mobile) --------------------
        (function buildCells() {
            var bds = document.getElementById("bdsRow"), alpha = document.getElementById("alphaRow");
            var i;
            for (i = 1; i <= 9; i++) {
                bds.insertAdjacentHTML("beforeend",
                    '<div class="cell" data-heat="bds' + i + '"><div class="lbl">S' + i + '</div>' +
                    '<div class="in num tick" data-f="bdsIn' + i + '">0</div>' +
                    '<div class="sold tick" data-f="bdsSold' + i + '">of \u2014</div></div>');
            }
            // Alpha displayed S4 S3 S2 S1 (left-to-right)
            [4, 3, 2, 1].forEach(function (n) {
                alpha.insertAdjacentHTML("beforeend",
                    '<div class="cell" data-heat="alpha' + n + '"><div class="lbl">S' + n + '</div>' +
                    '<div class="in num tick" data-f="alphaIn' + n + '">0</div>' +
                    '<div class="sold tick" data-f="alphaSold' + n + '">of \u2014</div></div>');
            });
            var bdsM = document.getElementById("bdsRowM"), alphaM = document.getElementById("alphaRowM");
            for (i = 1; i <= 9; i++) {
                bdsM.insertAdjacentHTML("beforeend",
                    '<div class="mcell" style="flex-direction:column;" data-heat="bds' + i + '">' +
                    '<span style="font-weight:600;font-size:8px;color:var(--dim);">' + i + '</span>' +
                    '<span class="num tick" style="font-weight:700;font-size:13px;" data-f="bdsIn' + i + '">0</span></div>');
            }
            [4, 3, 2, 1].forEach(function (n) {
                alphaM.insertAdjacentHTML("beforeend",
                    '<div class="mcell" style="gap:4px;" data-heat="alpha' + n + '">' +
                    '<span style="font-weight:600;font-size:9px;color:var(--dim);">S' + n + '</span>' +
                    '<span class="num tick" style="font-weight:700;font-size:14px;" data-f="alphaIn' + n + '">0</span></div>');
            });
        })();

        // ---- helpers -------------------------------------------------------
        function num(v) { var x = parseInt(String(v).replace(/[^0-9-]/g, ""), 10); return isNaN(x) ? 0 : x; }
        function fmt(x) { return (x === null || x === undefined || isNaN(x)) ? "\u2014" : Number(x).toLocaleString("en-GB"); }
        // percentage in/sold; null when sold is unknown or zero
        function pct(inn, sold) { return (sold === null || isNaN(sold) || sold <= 0) ? null : Math.round(inn / sold * 100); }

        function setText(field, val) {
            var els = document.querySelectorAll('[data-f="' + field + '"]');
            for (var i = 0; i < els.length; i++) {
                var el = els[i], s = (val === null || val === undefined) ? "\u2014" : String(val);
                if (el.textContent !== s) {
                    el.style.opacity = ".35";
                    (function (e, t) { setTimeout(function () { e.textContent = t; e.style.opacity = "1"; }, 150); })(el, s);
                }
            }
        }
        function setBar(name, p) {
            var els = document.querySelectorAll('[data-bar="' + name + '"]');
            for (var i = 0; i < els.length; i++) { els[i].style.width = (p === null || isNaN(p)) ? "0%" : Math.max(0, Math.min(100, p)) + "%"; }
        }
        // heat: rgba(70,192,109, 0.10 + 0.55*ratio); ratio = in/sold, else in/maxIn fallback
        function setHeat(name, inn, sold, maxIn) {
            var ratio = (sold !== null && !isNaN(sold) && sold > 0) ? inn / sold : (maxIn > 0 ? inn / maxIn : 0);
            ratio = Math.max(0, Math.min(1, ratio));
            var bg = "rgba(70,192,109," + (0.10 + 0.55 * ratio).toFixed(3) + ")";
            var els = document.querySelectorAll('[data-heat="' + name + '"]');
            for (var i = 0; i < els.length; i++) { els[i].style.background = bg; }
        }

        // ---- render one feed snapshot -------------------------------------
        function render(d) {
            // ---- ticket-type buckets (sold = SUM(QtySold) rows; in = checked in) ----
            var onlineSold = num(d.OnlineSold), onlineIn = num(d.OnlineCheckedIn);
            var seasonIn = num(d.SeasonTicketsCheckedIn), seasonIssued = num(d.SeasonTicketsSold);
            var walkIn = num(d.WalkUpCheckedIn), walkSold = walkIn;   // walk-ups sold at gate = checked in
            var allSold = num(d.AllSold);
            // "other" = explicit count from the view: not online/season/walk-up
            // (comp / carer / explicit "other" / untyped ticket types)
            var otherSold = num(d.OtherSold), otherIn = num(d.OtherCheckedIn);

            setText("fixturename", d.fixturename || "");
            setText("lastupdate", d.lastupdate || "");
            // short HH:MM:SS for the mobile pill (server sends "Last Update :  15:04:22")
            var tm = (String(d.lastupdate || "").match(/\d{1,2}:\d{2}(:\d{2})?/) || [""])[0];
            setText("lastupdateShort", tm || (d.lastupdate || ""));
            setText("TotalCheckedIn", fmt(num(d.TotalCheckedIn)));
            setText("ReportedCrowd", fmt(num(d.ReportedCrowd)));

            setText("OnlineSold", fmt(onlineSold)); setText("OnlineCheckedIn", fmt(onlineIn));
            setText("SeasonTicketsCheckedIn", fmt(seasonIn)); setText("seasonIssued", fmt(seasonIssued));
            setText("WalkUpCheckedIn", fmt(walkIn)); setText("walkupSold", fmt(walkSold));
            setText("otherSold", fmt(otherSold)); setText("otherCheckedIn", fmt(otherIn));

            var pOnline = pct(onlineIn, onlineSold), pSeason = pct(seasonIn, seasonIssued),
                pWalk = pct(walkIn, walkSold), pOther = pct(otherIn, otherSold);
            setText("onlinePct", pOnline === null ? "\u2014" : pOnline + "% in");
            setText("seasonPct", pSeason === null ? "\u2014" : pSeason + "% in");
            setText("walkupPct", pWalk === null ? "\u2014" : pWalk + "% in");
            setText("otherPct", pOther === null ? "\u2014" : pOther + "% in");
            setBar("online", pOnline); setBar("season", pSeason); setBar("walkup", pWalk); setBar("other", pOther);

            // ---- attendance hero: totalSold = every ticket out ----
            var totalSold = allSold;
            var totalIn = num(d.TotalCheckedIn);
            var pOverall = pct(totalIn, totalSold);
            setText("totalSold", fmt(totalSold));
            setText("overallPct", pOverall === null ? "\u2014" : pOverall);
            setBar("overall", pOverall);

            // ---- home v away (online) ----
            var homeIn = num(d.homecheckedin), homeSold = num(d.HomeSold);
            var awayIn = num(d.awaycheckedin), awaySold = num(d.AwaySold);
            setText("homecheckedin", fmt(homeIn)); setText("HomeSold", fmt(homeSold));
            setText("awaycheckedin", fmt(awayIn)); setText("AwaySold", fmt(awaySold));
            setBar("home", pct(homeIn, homeSold)); setBar("away", pct(awayIn, awaySold));

            // ---- gates (turnstiles) ----
            ["TerraceTS1", "BDSTS1", "BDSTS2", "EncTS1", "AlphaTS1", "AlphaTS2"].forEach(function (g) {
                setText(g, fmt(num(d[g])));
            });

            // ---- stadium sections + heat (real checked-in vs sold) ----
            var i, vin, vsold, bdsInSum = 0, bdsSoldSum = 0, alphaInSum = 0, alphaSoldSum = 0;
            var oakIn = num(d.OakbankCheckedIn), oakSold = num(d.OakbankSold);
            // busiest section, for the fallback shade when a section has no sold figure
            var maxIn = Math.max(1, oakIn, walkIn);
            for (i = 1; i <= 9; i++) { maxIn = Math.max(maxIn, num(d["BDS" + i + "CheckedIn"])); }
            for (i = 1; i <= 4; i++) { maxIn = Math.max(maxIn, num(d["Alpha" + i + "CheckedIn"])); }

            for (i = 1; i <= 9; i++) {
                vin = num(d["BDS" + i + "CheckedIn"]); vsold = num(d["BDS" + i + "Sold"]);
                bdsInSum += vin; bdsSoldSum += vsold;
                setText("bdsIn" + i, fmt(vin));
                setText("bdsSold" + i, "of " + fmt(vsold));
                setHeat("bds" + i, vin, vsold, maxIn);
            }
            for (i = 1; i <= 4; i++) {
                vin = num(d["Alpha" + i + "CheckedIn"]); vsold = num(d["Alpha" + i + "Sold"]);
                alphaInSum += vin; alphaSoldSum += vsold;
                setText("alphaIn" + i, fmt(vin));
                setText("alphaSold" + i, "of " + fmt(vsold));
                setHeat("alpha" + i, vin, vsold, maxIn);
            }
            setText("OakbankCheckedIn", fmt(oakIn)); setText("oakSold", "of " + fmt(oakSold));
            setHeat("oak", oakIn, oakSold, maxIn);
            setText("WalkUpCheckedIn", fmt(walkIn)); setText("wupSold", "of " + fmt(walkSold));
            setHeat("wup", walkIn, walkSold, maxIn);

            // ---- by stand (sums of the stand's sections) ----
            setText("bdsIn", fmt(bdsInSum)); setText("bdsSold", fmt(bdsSoldSum));
            setText("alphaIn", fmt(alphaInSum)); setText("alphaSold", fmt(alphaSoldSum));
            setText("oakSold2", fmt(oakSold)); setText("wupSold2", fmt(walkSold));
            setBar("stBds", pct(bdsInSum, bdsSoldSum));
            setBar("stAlpha", pct(alphaInSum, alphaSoldSum));
            setBar("stOak", pct(oakIn, oakSold));
            setBar("stWalk", pct(walkIn, walkSold));
        }

        // ---- SignalR (existing contract, unchanged 36-arg signature) -------
        $(function () {
            var chat = $.connection.chatHubticketco;

            chat.client.broadcastMessage = function (TotalCheckedIn, WalkUpCheckedIn, OnlineCheckedIn, OnlineSold, SeasonTicketsCheckedIn, AwaySold, HomeSold, awaycheckedin, homecheckedin, BDS1CheckedIn, BDS2CheckedIn, BDS3CheckedIn, BDS4CheckedIn, BDS5CheckedIn, BDS7CheckedIn, BDS8CheckedIn, BDS9CheckedIn, OakbankCheckedIn, TerreglesCheckedIn, Alpha1CheckedIn, Alpha2CheckedIn, Alpha3CheckedIn, Alpha4CheckedIn, AlphaTS1, AlphaTS2, EncTS1, TerraceTS1, BDSTS1, BDSTS2, lastupdate, BDS6CheckedIn, ReportedCrowd, other, CompsCheckedIn, fixturename, errormsg, SeasonTicketsSold, WalkUpSold, BDS1Sold, BDS2Sold, BDS3Sold, BDS4Sold, BDS5Sold, BDS6Sold, BDS7Sold, BDS8Sold, BDS9Sold, Alpha1Sold, Alpha2Sold, Alpha3Sold, Alpha4Sold, OakbankSold, AllSold, AllCheckedIn, OtherSold, OtherCheckedIn) {
                render({
                    TotalCheckedIn: TotalCheckedIn, WalkUpCheckedIn: WalkUpCheckedIn, OnlineCheckedIn: OnlineCheckedIn,
                    OnlineSold: OnlineSold, SeasonTicketsCheckedIn: SeasonTicketsCheckedIn, AwaySold: AwaySold, HomeSold: HomeSold,
                    awaycheckedin: awaycheckedin, homecheckedin: homecheckedin,
                    BDS1CheckedIn: BDS1CheckedIn, BDS2CheckedIn: BDS2CheckedIn, BDS3CheckedIn: BDS3CheckedIn,
                    BDS4CheckedIn: BDS4CheckedIn, BDS5CheckedIn: BDS5CheckedIn, BDS6CheckedIn: BDS6CheckedIn,
                    BDS7CheckedIn: BDS7CheckedIn, BDS8CheckedIn: BDS8CheckedIn, BDS9CheckedIn: BDS9CheckedIn,
                    OakbankCheckedIn: OakbankCheckedIn, TerreglesCheckedIn: TerreglesCheckedIn,
                    Alpha1CheckedIn: Alpha1CheckedIn, Alpha2CheckedIn: Alpha2CheckedIn, Alpha3CheckedIn: Alpha3CheckedIn, Alpha4CheckedIn: Alpha4CheckedIn,
                    AlphaTS1: AlphaTS1, AlphaTS2: AlphaTS2, EncTS1: EncTS1, TerraceTS1: TerraceTS1, BDSTS1: BDSTS1, BDSTS2: BDSTS2,
                    lastupdate: lastupdate, ReportedCrowd: ReportedCrowd, other: other, CompsCheckedIn: CompsCheckedIn,
                    fixturename: fixturename, errormsg: errormsg,
                    SeasonTicketsSold: SeasonTicketsSold, WalkUpSold: WalkUpSold,
                    BDS1Sold: BDS1Sold, BDS2Sold: BDS2Sold, BDS3Sold: BDS3Sold, BDS4Sold: BDS4Sold, BDS5Sold: BDS5Sold,
                    BDS6Sold: BDS6Sold, BDS7Sold: BDS7Sold, BDS8Sold: BDS8Sold, BDS9Sold: BDS9Sold,
                    Alpha1Sold: Alpha1Sold, Alpha2Sold: Alpha2Sold, Alpha3Sold: Alpha3Sold, Alpha4Sold: Alpha4Sold,
                    OakbankSold: OakbankSold, AllSold: AllSold, AllCheckedIn: AllCheckedIn,
                    OtherSold: OtherSold, OtherCheckedIn: OtherCheckedIn
                });
            };

            function paint() { chat.server.populateDataTable('').fail(function (e) { console.log("populateDataTable failed", e); }); }

            function connect() {
                $.connection.hub.start()
                    .done(function () { paint(); })
                    .fail(function () { setTimeout(connect, 5000); });
            }

            $.connection.hub.disconnected(function () {
                setText("lastupdate", "Reconnecting\u2026");
                setTimeout(connect, 5000);
            });

            connect();
        });
    </script>
</body>
</html>
