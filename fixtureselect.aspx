<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="fixtureselect.aspx.vb" Inherits="admintickets.fixtureselect" %>

<%@ register TagPrefix="UCHeader" tagname="Header" Src="~/UC_header.ascx" %>
<%@ register TagPrefix="UCFooter" tagname="Footer" Src="~/UC_footer.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>TMS Ballot Fixture Select</title>
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />


    <link href="css/jquery-ui.min.css" rel="stylesheet" />
    
    <link href="css/bs4_custom.css" rel="stylesheet" />
    <link href="css/print.css" rel="stylesheet" />
    <link href="css/all.min.css" rel="stylesheet" />

</head>
<body>
    <form id="form1" runat="server">
              <UCHeader:Header runat="server" ID="UCHeader" ></UCHeader:Header>

        <div class="container">
            <div class="row">

<div class="card-deck w-100">
<%--  <div class="card">

    <div class="card-body">
         <img src="https://www.qosfc.com/images/clubs/queenspark.png" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">Queens Park</h5>
          <p class="card-text text-center">Premier Sports Cup</p>
      <p class="card-text text-center">Sat 10th July</p>
<%--        <p class="card-text text-muted">Ballot Entries : 500</p>

      <small class="text-muted">BALLOT CLOSED</small>

       
    </div>
            <div class="card-footer text-center" style="background-color: inherit; border-top: none;">
                  <a href="newstandrestricted.aspx?fixtureid=2360" class="btn btn-primary ">Allocate New Stand</a>
                <a href="standrestricted.aspx?fixtureid=2360" class="btn btn-primary ">Allocate Main Stand</a>
                <a href="ballot_list.aspx?fixtureid=2360" class="btn btn-primary">Manage Entries</a>
          </div>
  </div>--%>

<%--      <div class="card">

    <div class="card-body">
         <img src="https://www.qosfc.com/images/clubs/Airdrieonians_FC_logo.png" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">Airdrie</h5>
          <p class="card-text text-center">Premier Sports Cup</p>
      <p class="card-text text-center">Sat 24th July</p>
      
<%--        <p class="card-text text-muted">Ballot Entries : 500</p>

      <small class="text-muted">BALLOT CLOSED</small>

       
    </div>
            <div class="card-footer text-center" style="background-color: inherit; border-top: none;">
                  <a href="newstandrestricted.aspx?fixtureid=2363" class="btn btn-primary ">Allocate New Stand</a>
                <a href="standrestricted.aspx?fixtureid=2363" class="btn btn-primary ">Allocate Main Stand</a>
                <a href="ballot_list.aspx?fixtureid=2363" class="btn btn-primary">Manage Entries</a>
          </div>
  </div>--%>

<%--      <div class="card">

    <div class="card-body">
         <img src="https://www.qosfc.com/images/clubs/10Kilmarnock.jpg" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">Kilmarnock</h5>
          <p class="card-text text-center">cinch Championship</p>
      <p class="card-text text-center">Sat 7th August</p>
        <p class="card-text text-muted">Ballot Entries : 500</p>

      <small class="text-muted">BALLOT CLOSED</small>

       
    </div>
            <div class="card-footer" style="background-color: inherit; border-top: none;">
                <div class="row no-gutters">
                    <div class="col-6"><a href="newstandrestricted.aspx?fixtureid=2368&homeoraway=H" class="btn btn-success ">Allocate New Stand - Home</a></div>
                    <div class="col-6"> <a href="newstandrestricted.aspx?fixtureid=2368&homeoraway=A" class="btn btn-primary ">Allocate New Stand - Away</a></div>


                </div>
                                <div class="row no-gutters">
                    <div class="col-6">
                        <a href="standrestricted.aspx?fixtureid=2368" class="btn btn-success ">Allocate Main Stand - Home</a>
                        </div>
                                    </div>
                    <div class="row no-gutters">
                    <div class="col-6">
             <a href="terrace.aspx?fixtureid=2368&homeoraway=H" class="btn btn-success ">Allocate Terrace - Home</a>
                        </div>                    <div class="col-6">
             <a href="terrace.aspx?fixtureid=2368&homeoraway=A" class="btn btn-primary " >Allocate Terrace - Away</a>
                        </div>
                                    </div>
                                   <div class="row no-gutters">
                    <div class="col-6">
                         <a href="ballot_list.aspx?fixtureid=2368&homeoraway=H" class="btn btn-secondary">Manage Home Entries</a>
                        </div>
                                       <div class="col-6">
                                             <a href="ballot_list.aspx?fixtureid=2368&homeoraway=A" class="btn btn-secondary">Manage Away Entries</a>

                                       </div>
                </div>
           <div class="row no-gutters">
                    <div class="col-6">
                         <a href="storetoballot.aspx?fixtureid=2368&productid=454" class="btn btn-secondary">Copy Home Orders From Store</a>
                        </div>
                                       <div class="col-6">
                                             <a href="storetoballot.aspx?fixtureid=2368&productid=456" class="btn btn-secondary">Copy Away Stand Orders From Store</a>
                                           <a href="storetoballot.aspx?fixtureid=2368&productid=457" class="btn btn-secondary">Copy Away Terrace Orders From Store</a>

                                       </div>
                </div>

                <div class="row no-gutters">
                    <div class="col">
                         <a href="export_emails.aspx" class="btn btn-info">GENERATE EMAIL LISTS</a>
                    </div>"
                </div>
               


                
               
          </div>
  </div>--%>

          <div class="card">

    <div class="card-body">
         <img src="https://www.qosfc.com/images/clubs/10hamilton.jpg" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">Hamilton</h5>
          <p class="card-text text-center">cinch Championship</p>
      <p class="card-text text-center">Sun 2nd Jan</p>
<%--        <p class="card-text text-muted">Ballot Entries : 500</p>

      <small class="text-muted">BALLOT CLOSED</small>--%>

       
    </div>
            <div class="card-footer" style="background-color: inherit; border-top: none;">
<%--                <div class="row no-gutters">
                    <div class="col-6"><a href="newstandrestricted.aspx?fixtureid=2368&homeoraway=H" class="btn btn-success ">Allocate New Stand - Home</a></div>
                    <div class="col-6"> <a href="newstandrestricted.aspx?fixtureid=2368&homeoraway=A" class="btn btn-primary ">Allocate New Stand - Away</a></div>


                </div>--%>
<%--                                <div class="row no-gutters">
                    <div class="col-6">
                        <a href="standrestricted.aspx?fixtureid=2368" class="btn btn-success ">Allocate Main Stand - Home</a>
                        </div>
                                    </div>--%>
<%--                    <div class="row no-gutters">
                    <div class="col-6">
             <a href="terrace.aspx?fixtureid=2368&homeoraway=H" class="btn btn-success ">Allocate Terrace - Home</a>
                        </div>                    <div class="col-6">
             <a href="terrace.aspx?fixtureid=2368&homeoraway=A" class="btn btn-primary " >Allocate Terrace - Away</a>
                        </div>
                                    </div>--%>
                                   <div class="row no-gutters">
                    <div class="col-6">
                         <a href="ballot_list.aspx?fixtureid=2385&homeoraway=H" class="btn btn-secondary">Manage Home Entries</a>
                        </div>
<%--                                       <div class="col-6">
                                             <a href="ballot_list.aspx?fixtureid=2368&homeoraway=A" class="btn btn-secondary">Manage Away Entries</a>

                                       </div>--%>
                </div>
           <div class="row no-gutters">
                    <div class="col-6">
                         <a href="storetoballot.aspx?fixtureid=2385&productid=470" class="btn btn-secondary">Copy Orders From Store</a>
                        </div>
<%--                                       <div class="col-6">
                                             <a href="storetoballot.aspx?fixtureid=2368&productid=456" class="btn btn-secondary">Copy Away Stand Orders From Store</a>
                                           <a href="storetoballot.aspx?fixtureid=2368&productid=457" class="btn btn-secondary">Copy Away Terrace Orders From Store</a>

                                       </div>--%>
                </div>

                <div class="row no-gutters">
                    <div class="col">
                         <a href="export_emails.aspx" class="btn btn-info">GENERATE EMAIL LISTS</a>
                    </div>
                </div>
               


                
               
          </div>
  </div>


     <div class="card">

    <div class="card-body">
         <img src="https://www.qosfc.com/images/clubs/10Kilmarnock.jpg" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">Kilmarnock</h5>
          <p class="card-text text-center">cinch Championship</p>
      <p class="card-text text-center">Sat 8th January</p>
        <%--<p class="card-text text-muted">Ballot Entries : 500</p>--%>

  <%--    <small class="text-muted">BALLOT CLOSED</small>--%>

       
    </div>
            <div class="card-footer" style="background-color: inherit; border-top: none;">
<%--                <div class="row no-gutters">
                    <div class="col-6"><a href="newstandrestricted.aspx?fixtureid=2368&homeoraway=H" class="btn btn-success ">Allocate New Stand - Home</a></div>
                    <div class="col-6"> <a href="newstandrestricted.aspx?fixtureid=2368&homeoraway=A" class="btn btn-primary ">Allocate New Stand - Away</a></div>


                </div>--%>
<%--                                <div class="row no-gutters">
                    <div class="col-6">
                        <a href="standrestricted.aspx?fixtureid=2368" class="btn btn-success ">Allocate Main Stand - Home</a>
                        </div>
                                    </div>--%>
 <%--                   <div class="row no-gutters">
                    <div class="col-6">
             <a href="terrace.aspx?fixtureid=2368&homeoraway=H" class="btn btn-success ">Allocate Terrace - Home</a>
                        </div>                    <div class="col-6">
             <a href="terrace.aspx?fixtureid=2368&homeoraway=A" class="btn btn-primary " >Allocate Terrace - Away</a>
                        </div>
                                    </div>--%>
                                   <div class="row no-gutters">
                    <div class="col-6">
                         <a href="ballot_list.aspx?fixtureid=2386&homeoraway=H" class="btn btn-secondary">Manage Home Entries</a>
                        </div>
<%--                                       <div class="col-6">
                                             <a href="ballot_list.aspx?fixtureid=2368&homeoraway=A" class="btn btn-secondary">Manage Away Entries</a>

                                       </div>--%>
                </div>
           <div class="row no-gutters">
                    <div class="col-6">
                         <a href="storetoballot.aspx?fixtureid=2386&productid=471" class="btn btn-secondary">Copy Orders From Store</a>
                        </div>
<%--                                       <div class="col-6">
                                             <a href="storetoballot.aspx?fixtureid=2368&productid=456" class="btn btn-secondary">Copy Away Stand Orders From Store</a>
                                           <a href="storetoballot.aspx?fixtureid=2368&productid=457" class="btn btn-secondary">Copy Away Terrace Orders From Store</a>

                                       </div>--%>
                </div>

                <div class="row no-gutters">
                    <div class="col">
                         <a href="export_emails.aspx" class="btn btn-info">GENERATE EMAIL LISTS</a>
                    </div>
                </div>
               


                
               
          </div>
  </div>







<%--      <div class="card">
     
    <div class="card-body">
              <img src="https://www.qosfc.com/images/clubs/10Dundee.jpg" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">Dundee</h5>
      <p class="card-text">Sat 26th Dec</p>
        <p class="card-text text-muted">Ballot Entries : 150</p>

      <small class="text-muted">BALLOT CLOSES : 10th Dec 1900</small>
       
    </div>
         <div class="card-footer text-center" style="background-color: inherit; border-top: none;">
               <a href="newstandrestricted.aspx?fixtureid=2219" class="btn btn-primary">Manage Seats</a>
             <a href="ballot_list.aspx?fixtureid=2219" class="btn btn-primary">Manage Entries</a>
          </div>
       
  </div>--%>

<%--          <div class="card">

    <div class="card-body">
              <img src="https://www.qosfc.com/images/clubs/ayr.png" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">Ayr</h5>
      <p class="card-text">Sat 2nd Jan</p>
        <p class="card-text text-muted">Ballot Entries : 0</p>

      <small class="text-muted">BALLOT NOT OPEN</small>
       
    </div>
              <div class="card-footer text-center" style="background-color: inherit; border-top: none;">
 <a href="newstandrestricted.aspx?fixtureid=2221" class="btn btn-primary stretched-link">Manage Seats</a>
          </div>
  </div>--%>
    </div>


            </div>

        </div>
        <div>
        </div>
    </form>
</body>
</html>
