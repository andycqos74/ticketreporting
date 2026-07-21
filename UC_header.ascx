<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UC_header.ascx.vb" Inherits="admintickets.UC_header" %>
   <nav class="navbar navbar-expand-lg navbar-dark">
  <a class="navbar-brand" href="default.aspx">TMS</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li id="nav0" class="nav-item ">
        <a class="nav-link" href="default.aspx?pageid=0"><i class="fas fa-home"></i></a>
      </li>
      <li id="nav1" class="nav-item ">
        <a class="nav-link" href="stand.aspx?pageid=1">Main Stand</a>
      </li>
              <li id="nav2" class="nav-item ">
        <a class="nav-link" href="newstand.aspx?pageid=2">New Stand</a>
      </li>
              <li id="nav3" class="nav-item ">
        <a class="nav-link" href="terrace.aspx?pageid=3">Terrace</a>
      </li>
              <li id="nav4" class="nav-item ">
        <a class="nav-link" href="reports_dash.aspx?pageid=4">Reports</a>
      </li>


    </ul>
  
<%--      <input class="form-control mr-sm-2 col-2" type="search" placeholder="Search" aria-label="Search" />
      <button class="btn btn-light my-2 my-sm-0" type="submit">Search</button>--%>
 
  </div>
</nav>