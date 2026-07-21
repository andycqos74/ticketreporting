<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ballot_entry.aspx.vb" Inherits="admintickets.ballot_entry" %>
<%@ register TagPrefix="UCHeader" tagname="Header" Src="~/UC_header.ascx" %>
<%@ register TagPrefix="UCFooter" tagname="Footer" Src="~/UC_footer.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>QOS Ballot Entry Form</title>
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

        #households { font-size: 0.8rem;}
    </style>

</head>
<body>
    <form id="form1" runat="server">

        <nav class="pl-0 py-0 navbar navbar-expand-md  navbar-dark bg-blue py-1" id="navbar-main" style="font-family: 'Poppins', sans-serif;">
<a class="navbar-brand pl-1 py-0" href="/default.aspx">
<img src="https://www.qosfc.com/images/95-trans.png" width="50" height="50" />
Ticket Ballot
</a>
<%--<button class="navbar-toggler p-0 border-0" type="button" data-toggle="offcanvas">
<span class="navbar-toggler-icon"></span>
</button>--%>
<%--<div class="navbar-collapse offcanvas-collapse bg-lightblue pt-2" id="navbar-menu">


</div>--%>
</nav>

     <div class="container mb-5 pb-5">

         <div class="row mt-3 alert alert-primary">
             <div class="col-12">
             <h5>Ballot Process</h5>
                 <ul>
             <li>This form is for season ticket holders for 21/22 to notify the club of their intention to attend matches where crowd restrictions are in place.</li>
            <%--     <li><strong>ALL SEASON TICKET HOLDERS WILL BE GUARANTEED ATTENDANCE IF IF THEY COMPLETE THE NOTIFICATION FORM BEFORE THE CLOSING DATE.</strong></li>--%>

                     <li>The information you provide in this form <strong>MUST match the information the club holds on your season ticket.</strong> Shirt Draw ticket holders should enter the businsess information given at the time of entry into the Shirt Draw. If you do not have your season ticket number yet please leave this field blank.</li>
                 <li>Season ticket holders can submit an application to attend by themselves, or as part of a Household of up to 4 people in total. The Household must be a valid Household under the Scottish Government COVID-19 guidance.</li>
   <%--              <li>Due to SPFL COVID-19 rules <strong>ONLY FANS FROM THE LOCAL AREA CAN ATTEND GAMES.</strong> If you do not have a DG postcode, you will not be able to submit an entry for the ballot</li>--%>
                 <li>For Health & Safety reasons, only Junior Blues who are 12 or over will be able to attend on their own. Under 12s, however, are permitted as part of a Household.</li>
             <li>Separate ballots will be held for each home fixture. Season ticket numbers will be selected at random, although efforts will be made to make sure all fans have the opportunity to attend an even number of games.</li>
                     <li>Seats will not be allocated for this game, so it will not be possible to select a preference for the area of ground. Both the BDS Digital Stand and Oakbank Terrace will be open and places will be on a first-come basis.</li>
             <%--<li>Each ballot will have a closing date and time. Entries submitted after this will not be included. The successful ticket holders will be contacted by email with details of their allocated seat number, time to attend and other matchday procedures.</li>--%>
                     <li>Each ballot will have a closing date and time. Entries submitted after this will not be included. All entrants will be contacted by email with confirmation of whether or not they have been successful.</li>
        <li>Fans MUST provide some form of photoID when they attend the ground along with their season ticket card.</li>
                     <li><strong>PLEASE ONLY SUBMIT ONE NOTIFICATION PER SEASON TICKET. IF YOU ARE INCLUDED IN A HOUSEHOLD DO NOT NOTIFY SEPARATELY OR BE INCLUDED IN MORE THAN ONE HOUSEHOLD.</strong> </li>
                     </ul>
                 </div>
             </div>



         <div class="row   ">
             <div class="col-12 my-3 p-3 alert alert-secondary">
                 <h5 class="mb-0">Select Your Fixture <i class="fas fa-angle-double-right ml-2"></i></h5>
             </div>

         </div>

            <div class="row">

<div class="card-deck"> <%--removed w-100--%>
<%--  <div class="card py-2">

    <div class="card-body text-center">
         <img src="https://www.qosfc.com/images/clubs/10ICT.jpg" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">ICT</h5>
      <p class="card-text">Fri 4th Dec - 7.45pm</p>


      <p class="d-block text-center alert alert-danger">BALLOT CLOSED</p>

       
    </div>
            <div class="card-footer text-center" style="background-color: inherit; border-top: none;">
                  <%--<a href="#" class="btn btn-primary stretched-link">ENTER BALLOT</a>
          </div>
  </div>--%>

 <%--     <div class="card py-2">
     
    <div class="card-body text-center">
              <img src="https://www.qosfc.com/images/clubs/queenspark.png" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">Queens Park</h5>
      <p class="card-text">Sat 10th Jul - 3pm</p>


      <p class="d-block text-center  alert alert-danger">BALLOT CLOSED</p>
       
    </div>
         <div class="card-footer text-center" style="background-color: inherit; border-top: none;">
               <a href="#" class="btn btn-primary stretched-link" onclick="fixtureselected('2360')">SELECT</a>
          </div>
       
  </div>--%>

       <%--   <div class="card py-2">
     
    <div class="card-body text-center">
              <img src="https://www.qosfc.com/images/clubs/10Kilmarnock.jpg" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">Kilmarnock</h5>
      <p class="card-text">Sat 7th Aug - 3pm</p>


      <p class="d-block text-center  alert alert-danger">CLOSED</p>
       
    </div>
         <div class="card-footer text-center" style="background-color: inherit; border-top: none;">
  <a href="#" class="btn btn-primary stretched-link" onclick="fixtureselected('2368')">SELECT</a>
          </div>
       
  </div>--%>

<%--          <div class="card py-2">
     
    <div class="card-body text-center">
              <img src="https://www.qosfc.com/images/clubs/ayr.png" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">Ayr</h5>
      <p class="card-text">Sat Jan - 3pm</p>


      <p class="d-block text-center  alert alert-danger">NO BALLOT</p>
       
    </div>
         <div class="card-footer text-center" style="background-color: inherit; border-top: none;">
       <a href="#" class="btn btn-primary stretched-link" onclick="fixtureselected('2221')">SELECT</a>
          </div>
       
  </div>--%>

<%--          <div class="card py-2">

    <div class="card-body text-center">
              <img src="https://www.qosfc.com/images/clubs/ayr.png" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">Ayr</h5>
      <p class="card-text">Sat 2nd Jan - 3pm</p>


      <p class="d-block text-center  alert alert-warning">BALLOT OPENS : 20th Dec 00:00</p>
       
    </div>
              <div class="card-footer text-center" style="background-color: inherit; border-top: none;">

          </div>
  </div>--%>
                   <div class="card py-2">
     
    <div class="card-body text-center">
              <img src="https://www.qosfc.com/images/clubs/10hamilton.jpg" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">Hamilton</h5>
      <p class="card-text">Sun 2nd Jan - 3pm</p>


      <p class="d-block text-center  alert alert-danger">CLOSED</p>
       
    </div>
         <div class="card-footer text-center" style="background-color: inherit; border-top: none;">
      <%--         <a href="#" class="btn btn-primary stretched-link" onclick="fixtureselected('2385')">SELECT</a>--%>
          </div>
       
  </div>

              <div class="card py-2">
     
    <div class="card-body text-center">
              <img src="https://www.qosfc.com/images/clubs/10Kilmarnock.jpg" class="img-fluid d-block mx-auto" alt="..."/>
      <h5 class="card-title text-center">Kilmarnock</h5>
      <p class="card-text">Sat 8th Jan - 3pm</p>


      <p class="d-block text-center  alert alert-danger">CLOSED</p>
       
    </div>
         <div class="card-footer text-center" style="background-color: inherit; border-top: none;">
<%--  <a href="#" class="btn btn-primary stretched-link" onclick="fixtureselected('2386')">SELECT</a>--%>
          </div>
       
  </div>


    </div>
                </div>


         <div class="row d-none" id="form-holder">
           <div class="col-12 my-3 p-3 alert alert-secondary">
                 <h5 class="mb-0">Enter Your Details <i class="fas fa-angle-double-right ml-2"></i></h5>
             </div>

             <div class="col-12 bg-white px-5 py-4">

<h5 class="text-muted pb-2">Application for match versus Kilmarnock on Saturday 8th January 2022</h5>
      <h6 class="alert alert-secondary">Contact Information</h6>
  <div class="form-group">
    <label for="name">Name</label>
    <input type="text" class="form-control" id="name" />
  </div>
  <div class="form-group">
    <label for="address">Address</label>
    <input type="text" class="form-control" id="address" />
  </div>
               <div class="form-group">
    <label for="postcode">Postcode</label>
    <input type="text" class="form-control" id="postcode" data-placement="right" data-title="ERROR" data-content="Only Fans in DG postcodes can enter ballot" />
  </div>
      <div class="form-group">
    <label for="TBemail">Email address</label>
    <input type="email" class="form-control" id="TBemail" />

  </div>
   <div class="form-group">
    <label for="telephone">Contact Number</label>
    <input type="text" class="form-control" id="telephone" />
  </div>
    <h6 class="alert alert-secondary">Season Ticket Details</h6>
                 <div class="form-group">
    <label for="customernumber">Season Ticket Customer Number</label>
    <input type="text" class="form-control" id="customernumber" aria-describedby="cnHelp" />
    <small id="cnHelp" class="form-text text-muted">This is the number on your season ticket</small>
  </div>
<div class="form-group">
    <label for="DDcardtype">Season Ticket Type</label>
  <asp:DropDownList ID="DDcardtype" runat="server" CssClass="form-control">
                  <asp:ListItem Text="... Select Type ..." Value="0"></asp:ListItem>
             <asp:ListItem Text="Adult" Value="3"></asp:ListItem>
             <asp:ListItem Text="Concession" Value="4"></asp:ListItem>
             <asp:ListItem Text="Junior Blue" Value="5"></asp:ListItem>
             <asp:ListItem Text="16-21" Value="13"></asp:ListItem>
             <asp:ListItem Text="Student" Value="6"></asp:ListItem>
             <asp:ListItem Text="Shirt Draw" Value="7"></asp:ListItem>
             <asp:ListItem Text="Accessible Adult" Value="9"></asp:ListItem>
             <asp:ListItem Text="Accessible Conc." Value="10"></asp:ListItem>
             <asp:ListItem Text="Accessible JB" Value="16"></asp:ListItem>
             <asp:ListItem Text="Accessible 16-21" Value="15"></asp:ListItem>
             <asp:ListItem Text="Accessible Student" Value="14"></asp:ListItem>         
<%--              <asp:ListItem Text="Carer" Value="12"></asp:ListItem>
              
             <asp:ListItem Text="Complimentary" Value="8"></asp:ListItem>
             <asp:ListItem Text="Executive" Value="11"></asp:ListItem>--%>
            </asp:DropDownList>

  </div>

   <div class="form-group d-none" id="Ageform">
    <label for="age">Age</label>
    <input type="text" class="form-control" id="age" data-placement="right" data-title="ERROR" data-content="You must be 12 or over to attend these games. Your age will be checked at the ground" />
  </div>

    <div id="form-carer"  class="form-group form-check  pl-5 d-none">
    <input type="checkbox" class="form-check-input reset" id="TCcarer" />
    <label class="form-check-label checkbox-label-code" for="TCcarer">I require a carer</label>

  </div>


<div class="form-group">
    <label for="DDarea">Season Ticket Area of Ground</label>
  <asp:DropDownList ID="DDarea" runat="server" CssClass="form-control">
                  <asp:ListItem Text="... Select Area ..." Value="0"></asp:ListItem>
             <asp:ListItem Text="Alpha Solway Stand (Main)" Value="1"></asp:ListItem>
             <asp:ListItem Text="BDS Digital Stand (New)" Value="2"></asp:ListItem>
             <asp:ListItem Text="Oakbank Services Terrace" Value="9"></asp:ListItem>

            </asp:DropDownList>

  </div>
  <div class="form-group d-none" id="Seatform">
    <label for="seat">Season Ticket Seat</label>
    <input type="text" class="form-control" id="seat" placeholder="eg F71" />
  </div>
    <h6 class="alert alert-secondary">Application Details</h6>
<%--      <div class="form-group">
    <label for="DDperfarea">Preferred Area of the Ground</label>
  <asp:DropDownList ID="DDperfarea" runat="server" CssClass="form-control">
                  <asp:ListItem Text="... Select Area ..." Value="0"></asp:ListItem>
            <asp:ListItem Text="Seated" Value="3"></asp:ListItem>
             <asp:ListItem Text="Terrace" Value="4"></asp:ListItem>
      <asp:ListItem Text="No Preference" Value="99"></asp:ListItem>

            </asp:DropDownList>
                  <div class="alert alert-info mt-2">
            <p>NB - While we will try and accomodate requests for the area of the ground, we may have to allocate those successful to another area of the ground depending on availability.</p>
        </div>

  </div>--%>


<div class="form-group">
    <label for="DDhouseholdnumber">I would like to attend with </label>
  <asp:DropDownList ID="DDhouseholdnumber" runat="server" CssClass="form-control">
                  <asp:ListItem Text="0" Value="0"></asp:ListItem>
             <asp:ListItem Text="1" Value="1"></asp:ListItem>
             <asp:ListItem Text="2" Value="2"></asp:ListItem>
             <asp:ListItem Text="3" Value="3"></asp:ListItem>

            </asp:DropDownList>
    <label for="DDhouseholdnumber">members of my household </label>

  </div>

 
      <div class="card-group d-none " id="households">
          <div class="card d-none"  id="householdcard1">
           
       <div class="card-body">
              <h5 class="card-title">Household Member 1</h5>
               <div class="form-group " >
      <label for="seat">Season Ticket Number</label>
    <input type="text" class="form-control" id="H1seasonticket" />

          </div>
   <div class="form-group " >
      <label for="seat">Name</label>
    <input type="text" class="form-control" id="H1name" />
          </div>
       <div class="form-group " >
      <label for="seat">Address</label>
    <input type="text" class="form-control" id="H1address" />
          </div>
   <div class="form-group " >
      <label for="seat">Postcode</label>
    <input type="text" class="form-control" id="H1postcode"  data-placement="bottom" data-title="ERROR" data-content="Only Fans in DG postcodes can attend games" />
          </div>
</div>

</div>


                    <div class="card d-none"  id="householdcard2">
           
       <div class="card-body">
              <h5 class="card-title">Household Member 2</h5>
               <div class="form-group " >
      <label for="seat">Season Ticket Number</label>
    <input type="text" class="form-control" id="H2seasonticket" />

          </div>
   <div class="form-group " >
      <label for="seat">Name</label>
    <input type="text" class="form-control" id="H2name" />
          </div>
       <div class="form-group " >
      <label for="seat">Address</label>
    <input type="text" class="form-control" id="H2address" />
          </div>
   <div class="form-group " >
      <label for="seat">Postcode</label>
    <input type="text" class="form-control" id="H2postcode"  data-placement="bottom" data-title="ERROR" data-content="Only Fans in DG postcodes can attend games" />
          </div>
</div>

</div>

          <div class="card d-none"  id="householdcard3">
           
       <div class="card-body">
              <h5 class="card-title">Household Member 3</h5>
               <div class="form-group " >
      <label for="seat">Season Ticket Number</label>
    <input type="text" class="form-control" id="H3seasonticket" />

          </div>
   <div class="form-group " >
      <label for="seat">Name</label>
    <input type="text" class="form-control" id="H3name" />
          </div>
       <div class="form-group " >
      <label for="seat">Address</label>
    <input type="text" class="form-control" id="H3address" />
          </div>
   <div class="form-group " >
      <label for="seat">Postcode</label>
    <input type="text" class="form-control" id="H3postcode"  data-placement="bottom" data-title="ERROR" data-content="Only Fans in DG postcodes can attend games" />
          </div>
</div>

</div>
          <div class="col-12 alert alert-warning mt-2">
         
                  <p>By submitting an application for members of your household you acknowledge that you have formed a Household with these people, which is recognised and valid under the current Scottish Gorvermnet COVID guidance and that you are responsible for their data. If any household information is found to be deliberately falsified to avoid COVID restrictions the whole ballot entry will be excluded from this draw and all season ticket holders named risk exclusion from all future draws and having their season tickets invalidated. </p>
    
          </div>

      </div>


  




<%--        <div id="form-lowseat"  class="form-group form-check pl-5 d-flex align-content-center">
    <input type="checkbox" class="form-check-input reset" id="TClowseat" />
    <label class="form-check-label checkbox-label-lowseat pl-2" for="TClowseat">I would like to request a low row seat(s)</label>
  </div>--%>
       <div class="alert alert-primary col-12 my-2">
            <p>By completing this form you confirm you will be attending a sporting event that has a crowd admission, with social distancing measures in place, and that you accept the risks involved with that in relation to your own health.
             </p>
           <p>By completing this form you are also stating that the information you have given is correct and, to the best of your knowledge, matches the information the club already holds against the relevant season tickets. Anyone found deliberately providing false information to try and avoid COVID restrictions will be excluded from this draw and risks exclusion from all future draws and having their season ticket invalidated.</p>
        </div>

    <div id="form-conduct"  class="form-group form-check alert alert-warning pl-5  align-content-center d-none"> <%--had to remove d-flex--%>
    <input type="checkbox" class="form-check-input reset" id="TCcodeconduct" checked />
    <label class="form-check-label checkbox-label-code pl-2" for="TCcodeconduct">I have read and agree to the <a href="https://www.qosfc.com/docs/Supporters_Charter_2019-20.pdf" target="_blank">SUPPORTERS CODE OF CONDUCT</a></label>
  </div>

 <div id="form-covid" class="form-group form-check alert alert-warning pl-5 d-flex align-content-center">
    <input type="checkbox" class="form-check-input reset" id="TCcovid" />
    <label class="form-check-label checkbox-label-covid pl-2" for="TCcovid">I confirm that I will not attend this fixture if I am diagnosed with Covid -19, any member of my household is diagnosed with Covid-19 or if I or any member of my household experiences any symptoms of Covid-19 whether diagnosed or not and are required to self-isolate for the given period of time or have been advised to isolate through a test and trace requirement.</label>
  </div>


  <div id="form-privacy" class="form-group form-check alert alert-warning pl-5 d-flex align-content-center">
    <input type="checkbox" class="form-check-input reset" id="TCagree" />
    <label class="form-check-label checkbox-label-privacy pl-2" for="TCagree">I have read and agree to the <a href="#"  data-toggle="modal" data-target="#modprivacy">PRIVACY NOTICE</a></label>
      
  </div>




  <button  class="btn btn-primary" id="submit" disabled  >Submit</button>

    <div id="return-message-row" class="row d-none mt-2">
        <div id="return-message-div" class="col-12">
            <h5 id="return-message"></h5>

        </div>

    </div>


</div>



         </div>

     
        <span id="log" class="d-none">log</span>

        <div id="hidden" class="d-none">
            <span id="fixtureid" runat="server"></span>
        </div>
         </div>
    <div class="modal" tabindex="-1" id="modprivacy">
  <div class="modal-dialog modal-xl modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Privacy Notice</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
    <h5>How we respect privacy when we deal with personal information collected by our organisation.</h5>
          <p>This Privacy Policy applies to information we Queen of the South Football Club collect about individuals who interact with our organisation in respect of the Season 20/21 Season Ticket ballot. It explains what personal information we collect and how we use it. 
If you have any comments or questions about this notice, feel free to contact us at <a href="mailto:admin@qosfc.com">admin@qosfc.com</a></p>
        <h5>1. Personal data that we process</h5>
          <p>The following table explains the types of data we collect and the legal basis, under current data protection legislation, on which this data is processed.
</p>
          <table class="table">
              <tr>
                  <th>Purpose</th>
                  <th>Data (key elements)</th>
                  <th>Basis</th>
              </tr>
              <tr>
                  <td>
                      Complying with current Government Track & Trace programme
                  </td>
                  <td>Name, telephone, Address, Postcode</td>
                  <td>Legal Obligation - we are obliged by the Scottish Government to record this information in order to comply with their COVID-19 regulations</td>
              </tr>
                            <tr>
                  <td>
Processing ticket ballot entries; including confirmation of valid ticket,
processing of ticket ballot selection, communication with ballot entrants and managing entry process
                  </td>
                  <td>Season Ticket Number, email address, age</td>
                  <td>Contract - this information is necessary for us to provide access to games as part of the contract entered into on purchase of your ticket</td>
              </tr>
          </table>






        <h5>2.How we use your data</h5>
          <p>
We will only use your data in a manner that is appropriate considering the basis on which that data was collected, as set out in the table at the top of this policy. 
For example, we may use your personal information to:</p>
          <ul>
              <li>process your entry in the ticket ballot;</li>
              <li>communicate with you in regards to the ticket ballot; </li>          
              <li>confirm your identity on matchday and manage the process of entry to the ground</li>
          </ul>

<h5>3.When we share your data</h5>
          <p>We will only pass your data to third parties in the following circumstances:</p>
          <ul>
              <li>you have provided your explicit consent for us to pass data to a named third party; </li>
              <li>we are using a third party purely for the purposes of processing data on our behalf and we have in place a data processing agreement with that third party that fulfils our legal obligations in relation to the use of third party data processors; or</li>
              <li>we are required by law to share your data - this includes sharing your data with the Scottish Government track and trace programme in the event they deem it necessary.</li>
             
          </ul>
<p>In addition, we will only pass data to third parties outside of the EU where appropriate safeguards are in place as defined by Article 46 of the General Data Protection Regulation.</p>

<h5>4.How long we keep your data</h5>
          <p>We take the principles of data minimisation and removal seriously and have internal policies in place to ensure that we only ever ask for the minimum amount of data for the associated purpose and delete that data promptly once it is no longer required. 
In order to apply the fairest possible process to the ballot we will keep your data until the end of the season, the end of crowd restrictions and the need for ticket ballots, or the end of our internal review of the process whichever is the latter.
              </p>
          <h5>5.Rights you have over your data</h5>
          <p>You have a range of rights over your data, which include the following:</p>
          <ul>
              <li>Where data processing is based on consent, you may revoke this consent at any time and we will make it as easy as possible for you to do this (for example by putting ‘unsubscribe’ links at the bottom of all our marketing emails). </li>
              <li>You have the right to ask for rectification and/or deletion of your information. </li>
              <li>You have the right of access to your information. </li>
              <li>You have the right to lodge a complaint with the Information Commissioner if you feel your rights have been infringed. </li>
          </ul>
          <p>A full summary of your legal rights over your data can be found on the Information Commissioner’s website here: <a href="https://ico.org.uk/" target="_blank">https://ico.org.uk/</a>
If you would like to access the rights listed above, or any other legal rights you have over your data under current legislation, please get in touch with us. 
Please note that exercising your right to delete your data will make it impossible for us to continue to process your entry into future ticket ballots.
              </p>
          <h5>6.Security and Data Storage</h5>
          <p>We are committed to taking reasonable and appropriate steps to protect the Personal Information that we hold from misuse, loss, or unauthorised access. The Website is designed to secure the Personal Information you provide on computer servers in a controlled, secure environment, with protections from unauthorised access, use or disclosure. The data you submit to us via the ballot form is encrypted using Secure Socket Layer (SSL) protocol. Where we have the need to print physical copies of your data we will take appropriate operational steps to ensure this is only available to authorised personnel who have a legitimate need to access the data.
              </p>
          <h5>7.Modifications</h5>
          <p>
This privacy policy will apply while crowd restrictions are in place and ticket ballots are required. If any changes are made, any persons who we hold personal data for will be notified of the changes and the most up to date version will be available as a link on the ballot entry form.
              </p>
          <h5>8.Contact Us</h5>
          <a href="mailto:admin@qosfc.com">admin@qosfc.com</a>
          <address>
              Queen of the South FC<br />
Palmerston Park<br />
76-94 Terregles St<br />
Dumfries, DG2 9BA

          </address>
          
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
 
      </div>
    </div>
  </div>
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
        function fixtureselected(fixtureid) {
            event.stopPropagation();
            event.stopImmediatePropagation();
            event.preventDefault();

            $("#fixtureid").text(fixtureid);
            $("#form-holder").removeClass("d-none");

        };





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

                if (encodedaction == "fail") {
                    // Add the message to the page. 
                    console.log("message");
                    console.log(encodedseat);
                    console.log(encodedname);

                    encodedaction = "";

                }

                if (encodedaction == "message") {
                    // Add the message to the page. 
                    console.log("message");
                    console.log(encodedseat);
                    console.log(encodedname);
                   
                    encodedaction = "";

                    $("#log").text(encodedseat + " " + encodedname);

                }

                if (encodedaction == "submit_success") {

                    $("#submit").prop("disabled", "true");
                    // Add the message to the page. 
                    $("#return-message-row").removeClass("d-none");
                    $("#return-message-div").removeClass("alert alert-danger");
                    $("#return-message-div").addClass("alert alert-success");
                    $("#return-message").text("Thank You! Your entry has been received and you are in the ballot. You will be informed via email if you have been successful or not.");
                }


                


            }; //end of receiving messages from hub


            $.connection.hub.start().done(function () {

                function isDoubleClicked(element) {

                    console.log(element + " isclicked : " + element.data("isclicked"));
                    //if already clicked return TRUE to indicate this click is not allowed
                    if (element.data("isclicked")) return true;

                    //mark as clicked for 1 second
                    element.data("isclicked", true);
                    setTimeout(function () {
                        element.removeData("isclicked");
                    }, 2000);

                    //return FALSE to indicate this click was allowed
                    return false;
                }



              
                $(document).on('click', "#submit", function () {


                    event.stopPropagation();
                    event.stopImmediatePropagation();
                    event.preventDefault();


                    if (isDoubleClicked($("#submit"))) return;
                    var isvalid = true;
                    console.log("valid at start of save - " + isvalid);

                    var customernumber = $("#customernumber").val();
                    var customername = $("#name").val();
                    var seatemail = $("#TBemail").val();
                    var customeraddress = $("#address").val();
                    var customerpostcode = $("#postcode").val();
                    var cardtypeid = $("#DDcardtype").val();
                    var customerage = $("#age").val();
                    var standid = $("#DDarea").val();
                    var customerseat = $("#seat").val();
                    var customertel = $("#telephone").val();
                    var fixtureid = $("#fixtureid").text();
                    var requirecarer = $('#TCcarer').is(":checked");
                    var requestlowrow = $('#TClowseat').is(":checked");
                    var nmbapplicants = parseInt($("#DDhouseholdnumber").val(),10);
                    nmbapplicants = nmbapplicants + 1;
                    console.log("nmbapplicants = " + nmbapplicants);
                    var hhticket1 = $("#H1seasonticket").val();
                    var hhname1 = $("#H1name").val();
                    var hhaddress1 = $("#H1address").val();
                    var hhpostcode1 = $("#H1postcode").val();

                    var hhticket2 = $("#H2seasonticket").val();
                    var hhname2 = $("#H2name").val();
                    var hhaddress2 = $("#H2address").val();
                    var hhpostcode2 = $("#H2postcode").val();

                    var hhticket3 = $("#H3seasonticket").val();
                    var hhname3 = $("#H3name").val();
                    var hhaddress3 = $("#H3address").val();
                    var hhpostcode3 = $("#H3postcode").val();

                    var preferarea = $("#DDperfarea").val();



                    //invalid checks commented out below to remove check for season ticket number
                    if (nmbapplicants > 1) {
                        if ($("#H1seasonticket").val()) {
                            $("#H1seasonticket").removeClass("is-invalid");
                        }
                        else {
                            $("#H1seasonticket").addClass("is-invalid");
                            isvalid = false;
                        }
                        if ($("#H1name").val()) {
                            $("#H1name").removeClass("is-invalid");
                        }
                        else {
                            $("#H1name").addClass("is-invalid");
                            isvalid = false;
                        }
                        if ($("#H1address").val()) {
                            $("#H1address").removeClass("is-invalid");
                        }
                        else {
                            $("#H1address").addClass("is-invalid");
                            isvalid = false;
                        }
                        //if ($("#H1postcode").val()) {
                        //    var re = /^(DG|dg)/;
                        //    var is_postcode = re.test(hhpostcode1);
                        //    if (is_postcode) {
                        //        $("#H1postcode").removeClass("is-invalid");
                        //        $("#H1postcode").popover("hide");
                        //    }
                        //    else {
                        //        $("#H1postcode").addClass("is-invalid");
                        //        $("#H1postcode").popover("show");

                        //        isvalid = false;
                        //    }

                        //} else {
                        //    $("#H1postcode").addClass("is-invalid");
                        //    $("#H1postcode").popover("hide");

                        //    isvalid = false;
                        //}
                        if ($("#H1postcode").val()) {
                            $("#H1postcode").removeClass("is-invalid");
                        }
                        else {
                            $("#H1postcode").addClass("is-invalid");
                            isvalid = false;
                        }

                    } /*end of one household member*/

                    if (nmbapplicants > 2) {
                        if ($("#H2seasonticket").val()) {
                            $("#H2seasonticket").removeClass("is-invalid");
                        }
                        else {
                            //$("#H2seasonticket").addClass("is-invalid");
                            //isvalid = false;
                        }
                        if ($("#H2name").val()) {
                            $("#H2name").removeClass("is-invalid");
                        }
                        else {
                            $("#H2name").addClass("is-invalid");
                            isvalid = false;
                        }
                        if ($("#H2address").val()) {
                            $("#H2address").removeClass("is-invalid");
                        }
                        else {
                            $("#H2address").addClass("is-invalid");
                            isvalid = false;
                        }
                        //if ($("#H2postcode").val()) {
                        //    var re = /^(DG|dg)/;
                        //    var is_postcode = re.test(hhpostcode2);
                        //    if (is_postcode) {
                        //        $("#H2postcode").removeClass("is-invalid");
                        //        $("#H2postcode").popover("hide");
                        //    }
                        //    else {
                        //        $("#H2postcode").addClass("is-invalid");
                        //        $("#H2postcode").popover("show");
                        //        isvalid = false;
                        //    }

                        //} else {
                        //    $("#H2postcode").addClass("is-invalid");
                        //    $("#H2postcode").popover("hide");
                        //    isvalid = false;
                        //}
                        if ($("#H2postcode").val()) {
                            $("#H2postcode").removeClass("is-invalid");
                        }
                        else {
                            $("#H2postcode").addClass("is-invalid");
                            isvalid = false;
                        }



                    } /*end of two household member*/

                    if (nmbapplicants > 3) {
                        if ($("#H3seasonticket").val()) {
                            $("#H3seasonticket").removeClass("is-invalid");
                        }
                        else {
                            //$("#H3seasonticket").addClass("is-invalid");
                            //isvalid = false;
                        }

                        if ($("#H3name").val()) {
                            $("#H3name").removeClass("is-invalid");
                        }
                        else {
                            $("#H3name").addClass("is-invalid");
                            isvalid = false;
                        }
                        if ($("#H3address").val()) {
                            $("#H3address").removeClass("is-invalid");
                        }
                        else {
                            $("#H3address").addClass("is-invalid");
                            isvalid = false;
                        }
                        //if ($("#H3postcode").val()) {
                        //    var re = /^(DG|dg)/;
                        //    var is_postcode = re.test(hhpostcode3);
                        //    if (is_postcode) {
                        //        $("#H3postcode").removeClass("is-invalid");
                        //        $("#H3postcode").popover("hide");
                        //    }
                        //    else {
                        //        $("#H3postcode").addClass("is-invalid");
                        //        $("#H3postcode").popover("show");
                        //        isvalid = false;
                        //    }

                        //} else {
                        //    $("#H3postcode").addClass("is-invalid");
                        //    $("#H3postcode").popover("hide");
                        //    isvalid = false;
                        //}
                        if ($("#H3postcode").val()) {
                            $("#H3postcode").removeClass("is-invalid");
                        }
                        else {
                            $("#H3postcode").addClass("is-invalid");
                            isvalid = false;
                        }




                    } /*end of two household member*/



                 if ($("#customernumber").val()) {
                        $("#customernumber").removeClass("is-invalid");
                    }
                    else {
                        $("#customernumber").addClass("is-invalid");
                        //isvalid = false;
                    }

                    if ($("#name").val()) {
                        $("#name").removeClass("is-invalid");
                    }
                    else {
                        $("#name").addClass("is-invalid");
                        isvalid = false;
                    }

                    if ($("#address").val()) {
                        $("#address").removeClass("is-invalid");
                    }
                    else {
                        $("#address").addClass("is-invalid");
                        isvalid = false;
                    }

                   // ORIGINAL CHECK FOR BLANK POSTCODE
                    if ($("#postcode").val()) {
                        $("#postcode").removeClass("is-invalid");
                    }
                    else {
                        $("#postcode").addClass("is-invalid");
                        isvalid = false;
                    }

                    //check for DG postcode
                    //if (customerpostcode) {
                    //    var re = /^(DG|dg)/;
                    //    var is_postcode = re.test(customerpostcode);
                    //    if (is_postcode) {
                    //        $("#postcode").removeClass("is-invalid");
                    //        $("#postcode").popover("hide");
                    //    }
                    //    else {
                    //        $("#postcode").addClass("is-invalid");
                    //        $("#postcode").popover("show");
                    //        isvalid = false;
                    //    }

                    //} else {

                    //    $("#postcode").addClass("is-invalid");
                    //    $("#postcode").popover("hide");
                    //    isvalid = false;
                    //}







                    if (seatemail) {
                        var re = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                        var is_email = re.test(seatemail);
                        if (is_email) {
                            $("#TBemail").removeClass("is-invalid");
                        }
                        else {
                            $("#TBemail").addClass("is-invalid");
                            isvalid = false;
                        }

                    } else {
                        $("#TBemail").addClass("is-invalid");
                        isvalid = false;
                    }

                    if ($("#telephone").val()) {
                        $("#telephone").removeClass("is-invalid");
                    }
                    else {
                        $("#telephone").addClass("is-invalid");
                        isvalid = false;
                    }
               


                    if ($("#DDcardtype").val() != 0) {
                        $("#DDcardtype").removeClass("is-invalid");
                    }
                    else {
                        $("#DDcardtype").addClass("is-invalid");
                        isvalid = false;
                    }

                    if ($("#DDarea").val() != 0) {
                        $("#DDarea").removeClass("is-invalid");
                    }
                    else {
                        $("#DDarea").addClass("is-invalid");
                        isvalid = false;
                }



                    //if ($("#DDperfarea").val() != 0) {
                    //    $("#DDperfarea").removeClass("is-invalid");
                    //}
                    //else {
                    //    $("#DDperfarea").addClass("is-invalid");
                    //    isvalid = false;
                    //}


                if (($("#DDcardtype").val() == 5) || ($("#DDcardtype").val() == 16)) {

                   var is_age = $("#age").val();
                    if (($("#DDcardtype").val() == "5") || ($("#DDcardtype").val() == "16")) {
                        if (is_age) {

                            if (is_age < 12) {
                                $("#age").addClass("is-invalid");
                                $("#age").popover("show");

                            } else {
                                $("#age").removeClass("is-invalid");
                                $("#age").popover("hide");
                            }

                        }
                        else {
                            $("#age").addClass("is-invalid");

                        }
                    }


                }


                if (($("#DDarea").val() == 1) || ($("#DDarea").val() == 2)) {

                    if ($("#seat").val()) {
                        $("#seat").removeClass("is-invalid");
                    }
                    else {
                        $("#seat").addClass("is-invalid");
                        isvalid = false;
                    }


                }





                    if ($("#TCcodeconduct").is(":not(:checked)")) {
                        console.log("Checkbox is unchecked.");

                        //need to show error message to say T&Cs need agreed
                        isvalid = false;
                        $("#TCcodeconduct").addClass("is-invalid");
                        $("#form-conduct").removeClass("alert-warning");
                        $("#form-conduct").addClass("alert-danger");
                    }

                    if ($("#TCcovid").is(":not(:checked)")) {
                        console.log("Checkbox is unchecked.");

                        //need to show error message to say T&Cs need agreed
                        isvalid = false;
                        $("#TCcovid").addClass("is-invalid");
                        $("#form-covid").removeClass("alert-warning");
                        $("#form-covid").addClass("alert-danger");
                    }

                    if ($("#TCagree").is(":not(:checked)")) {
                        console.log("Checkbox is unchecked.");

                        //need to show error message to say T&Cs need agreed
                        isvalid = false;
                        $("#TCagree").addClass("is-invalid");
                        $("#form-privacy").removeClass("alert-warning");
                        $("#form-privacy").addClass("alert-danger");
                    }

                if (isvalid == false) {
                    console.log("isvalid at end - " + isvalid);
                    $("#return-message-row").removeClass("d-none");
                    $("#return-message-div").removeClass("alert alert-success");
                    $("#return-message-div").addClass("alert alert-danger");
                    $("#return-message").text("YOUR APPLICATION HAS NOT BEEN SUBMITTED. Your application is incomplete. Please check, complete the red boxes and submit again.");
                        return;
                    }
                console.log("isvalid at end - " + isvalid);
                    //otherwise send to DB
                //    chat.server.send("testing", "got to save");

                    chat.server.insertballotentry(fixtureid, customername, customernumber, customeraddress, customerpostcode, seatemail, customertel, cardtypeid, standid, customerage, customerseat, requirecarer, requestlowrow, nmbapplicants, hhticket1, hhname1, hhaddress1, hhpostcode1, hhticket2, hhname2, hhaddress2, hhpostcode2, hhticket3, hhname3, hhaddress3, hhpostcode3, preferarea);



                });


                //textbox validation on typing

                

                $('#H1seasonticket').on('input', function () {
                    var nmbapplicants = parseInt($("#DDhouseholdnumber").val(), 10);
                    nmbapplicants = nmbapplicants + 1;

                    if (nmbapplicants > 1) {
                        var input = $(this);
                        var is_name = input.val();
                        if (is_name) {
                            input.removeClass("is-invalid");
                        }
                        else {
                            input.addClass("is-invalid");
                        }
                    }


                });

                $('#H2seasonticket').on('input', function () {
                    var nmbapplicants = parseInt($("#DDhouseholdnumber").val(), 10);
                    nmbapplicants = nmbapplicants + 1;
                    if (nmbapplicants > 2) {
                        var input = $(this);
                        var is_name = input.val();
                        if (is_name) {
                            input.removeClass("is-invalid");
                        }
                        else {
                            input.addClass("is-invalid");
                        }
                    }


                });

                $('#H3seasonticket').on('input', function () {
                    var nmbapplicants = parseInt($("#DDhouseholdnumber").val(), 10);
                    nmbapplicants = nmbapplicants + 1;
                    if (nmbapplicants > 3) {
                        var input = $(this);
                        var is_name = input.val();
                        if (is_name) {
                            input.removeClass("is-invalid");
                        }
                        else {
                            input.addClass("is-invalid");
                        }
                    }


                });

                $('#H1name').on('input', function () {
                    var nmbapplicants = parseInt($("#DDhouseholdnumber").val(), 10);
                    nmbapplicants = nmbapplicants + 1;

                    if (nmbapplicants > 1) {
                        var input = $(this);
                        var is_name = input.val();
                        if (is_name) {
                            input.removeClass("is-invalid");
                        }
                        else {
                            input.addClass("is-invalid");
                        }
                    }


                });

                $('#H2name').on('input', function () {
                    var nmbapplicants = parseInt($("#DDhouseholdnumber").val(), 10);
                    nmbapplicants = nmbapplicants + 1;
                    if (nmbapplicants > 2) {
                        var input = $(this);
                        var is_name = input.val();
                        if (is_name) {
                            input.removeClass("is-invalid");
                        }
                        else {
                            input.addClass("is-invalid");
                        }
                    }


                });

                $('#H3name').on('input', function () {
                    var nmbapplicants = parseInt($("#DDhouseholdnumber").val(), 10);
                    nmbapplicants = nmbapplicants + 1;
                    if (nmbapplicants > 3) {
                        var input = $(this);
                        var is_name = input.val();
                        if (is_name) {
                            input.removeClass("is-invalid");
                        }
                        else {
                            input.addClass("is-invalid");
                        }
                    }


                });
                $('#H1address').on('input', function () {
                    var nmbapplicants = parseInt($("#DDhouseholdnumber").val(), 10);
                    nmbapplicants = nmbapplicants + 1;

                    if (nmbapplicants > 1) {
                        var input = $(this);
                        var is_name = input.val();
                        if (is_name) {
                            input.removeClass("is-invalid");
                        }
                        else {
                            input.addClass("is-invalid");
                        }
                    }


                });

                $('#H2address').on('input', function () {
                    var nmbapplicants = parseInt($("#DDhouseholdnumber").val(), 10);
                    nmbapplicants = nmbapplicants + 1;
                    if (nmbapplicants > 2) {
                        var input = $(this);
                        var is_name = input.val();
                        if (is_name) {
                            input.removeClass("is-invalid");
                        }
                        else {
                            input.addClass("is-invalid");
                        }
                    }


                });

                $('#H3address').on('input', function () {
                    var nmbapplicants = parseInt($("#DDhouseholdnumber").val(), 10);
                    nmbapplicants = nmbapplicants + 1;
                    if (nmbapplicants > 3) {
                        var input = $(this);
                        var is_name = input.val();
                        if (is_name) {
                            input.removeClass("is-invalid");
                        }
                        else {
                            input.addClass("is-invalid");
                        }
                    }


                });
                $('#H1postcode').on('input', function () {
                    var nmbapplicants = parseInt($("#DDhouseholdnumber").val(), 10);
                    nmbapplicants = nmbapplicants + 1;

                    if (nmbapplicants > 1) {
                        var input = $(this);
                        var re = /^(DG|dg)/;

                        if (input.val()) {


                            //var is_DG = re.test(input.val());
                            //if (is_DG) {
                            input.removeClass("is-invalid");
                            input.popover('hide');
                            //}
                            //else {
                            //    input.addClass("is-invalid");
                            //    input.popover('show');
                            //}

                        } else {
                            input.addClass("is-invalid");
                            input.popover('hide');
                        }
                    }

                    });

                $('#H2postcode').on('input', function () {
                    var nmbapplicants = parseInt($("#DDhouseholdnumber").val(), 10);
                    nmbapplicants = nmbapplicants + 1;
                    if (nmbapplicants > 2) {
                        var input = $(this);
                        var re = /^(DG|dg)/;

                        if (input.val()) {


                            //var is_DG = re.test(input.val());
                            //if (is_DG) {
                            input.removeClass("is-invalid");
                            input.popover('hide');
                            //}
                            //else {
                            //    input.addClass("is-invalid");
                            //    input.popover('show');
                            //}

                        } else {
                            input.addClass("is-invalid");
                            input.popover('hide');
                        }
                    }
                    });

                $('#H3postcode').on('input', function () {
                    var nmbapplicants = parseInt($("#DDhouseholdnumber").val(), 10);
                    nmbapplicants = nmbapplicants + 1;
                    if (nmbapplicants > 3) {
                        var input = $(this);
                        var re = /^(DG|dg)/;

                        if (input.val()) {


                            //var is_DG = re.test(input.val());
                            //if (is_DG) {
                            input.removeClass("is-invalid");
                            input.popover('hide');
                            //}
                            //else {
                            //    input.addClass("is-invalid");
                            //    input.popover('show');
                            //}

                        } else {
                            input.addClass("is-invalid");
                            input.popover('hide');
                        }
                    }
                    });
                












                $('#customernumber').on('input', function () {
                    var input = $(this);
                    var is_name = input.val();
                    if (is_name) {
                        input.removeClass("is-invalid");
                    }
                    else {
                        input.addClass("is-invalid");
                     }
                });
                $('#name').on('input', function () {
                    var input = $(this);
                    var is_name = input.val();
                    if (is_name) { input.removeClass("is-invalid"); }
                    else { input.addClass("is-invalid"); }
                });
                $('#address').on('input', function () {
                    var input = $(this);
                    var is_name = input.val();
                    if (is_name) { input.removeClass("is-invalid"); }
                    else { input.addClass("is-invalid"); }
                });

                //ORIGINAL CHECK FOR BLANK POSTCODE
                //$('#postcode').on('input', function () {
                //    var input = $(this);
                //    var is_name = input.val();
                //    if (is_name) { input.removeClass("is-invalid"); }
                //    else { input.addClass("is-invalid"); }
                //});


                $('#postcode').on('input', function () {
                    var input = $(this);
                    var re = /^(DG|dg)/;

                    if (input.val()) {


                        //var is_DG = re.test(input.val());
                        //if (is_DG) {
                            input.removeClass("is-invalid");
                            input.popover('hide');
                        //}
                        //else {
                        //    input.addClass("is-invalid");
                        //    input.popover('show');
                        //}

                    } else {
                        input.addClass("is-invalid");
                        input.popover('hide');
                    }
                });



                $('#TBemail').on('input', function () {
                    var input = $(this);
                    var re = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;

                    if (input.val()) {


                        var is_email = re.test(input.val());
                        if (is_email) {
                            input.removeClass("is-invalid");
                        }
                        else {
                            input.addClass("is-invalid");
                        }

                    } else {
                        input.addClass("is-invalid");
                    }
                });
                $('#telephone').on('input', function () {
                    var input = $(this);
                    var is_name = input.val();
                    if (is_name) { input.removeClass("is-invalid"); }
                    else { input.addClass("is-invalid"); }
                });

                $("#DDcardtype").change(function () {
                    var seattype = this.value;

                    if (seattype == 0) {
                        console.log("no type selected");
                        $("#DDcardtype").addClass("is-invalid");

                        return;
                    } else {

                        $("#DDcardtype").removeClass("is-invalid");

                    }

                    if ((seattype == 5) || (seattype == 16)) {
                        $("#Ageform").removeClass("d-none");

                    } else {
                        $("#Ageform").addClass("d-none");
                    }

                    if ((seattype == 9) || (seattype == 10) || (seattype == 14) || (seattype == 15) || (seattype == 16)) {
                        $("#form-carer").removeClass("d-none");

                    } else {
                        $("#form-carer").addClass("d-none");
                    }


                });
                $("#DDarea").change(function () {
                    var seattype = this.value;

                    if (seattype == 0) {
                        console.log("no type selected");
                        $("#DDarea").addClass("is-invalid");

                        return;
                    } else {

                        $("#DDarea").removeClass("is-invalid");
                        $("#Seatform").addClass("d-none");
                    }

                     if ((seattype == "1") || (seattype == "2")) {
                            $("#Seatform").removeClass("d-none");
                           
                           }
                        else {
                            $("#Seatform").addClass("d-none");
                            $("#seat").removeClass("is-invalid");
                       }


                });

                //$("#DDperfarea").change(function () {
                //    var prefseattype = this.value;

                //    if (prefseattype == 0) {
                      
                //        $("#DDperfarea").addClass("is-invalid");

                //        return;
                //    } else {

                //        $("#DDperfarea").removeClass("is-invalid");
   
                //    }

                //});




                

                $("#DDhouseholdnumber").change(function () {
                    var householdnumber = this.value;
               //     console.log("householdnumber = " + householdnumber);

                    if (householdnumber > 0) {
                        $("#households").removeClass("d-none");

                        for (x = 0; x < 4; x++) {
                            $("#householdcard" + x).addClass("d-none");
                            //console.log("x = " + x);
                            //console.log("#householdcard" + x);
                        }

                        for (i = 0; i <= householdnumber; i++) {
                            $("#householdcard" + i).removeClass("d-none");
                            //console.log("i = " + i);
                            //console.log("#householdcard" + i);
                            
                        }
                                                                                                              
                    } else {
                        $("#households").addClass("d-none");

                        for (y = 0; y < 4; y++) {
                            $("#householdcard" + y).addClass("d-none");
                            //console.log("x = " + y);
                            //console.log("#householdcard" + y);
                        }

                    }


                });
     
                $('#seat').on('input', function () {
                    var input = $(this);
                    var is_name = input.val();
                    if (($("#DDarea").val() == "1") || ($("#DDarea").val() == "2")) {
                        if (is_name) { input.removeClass("is-invalid"); }
                        else { input.addClass("is-invalid"); }
                    }
                });

                $('#age').on('input', function () {
                    var input = $(this);
                    var is_age = input.val();
                    if (($("#DDcardtype").val() == "5") || ($("#DDcardtype").val() == "16")) {
                        if (is_age) {

                            if (is_age < 12) {
                                input.addClass("is-invalid");
                                input.popover("show");
                            
                            } else {
                                input.removeClass("is-invalid");
                                input.popover("hide");
                            }
                                                                                
                        }
                        else {
                            input.addClass("is-invalid");
                            input.popover("hide");

                        }
                    }
                });

                $('#TCcodeconduct').change(function () {
                    console.log("texbox changed");

                    if ($(this).is(":checked")) {
                        $("#form-conduct").removeClass("alert-danger");
                        $("#form-conduct").removeClass("alert-warning");
                        $("#form-conduct").addClass("alert-success");
                  
                    } else {
                        $("#form-conduct").removeClass("alert-success");

                        $("#form-conduct").addClass("alert-danger");
                
                    }
                   
                });

                $('#TCcovid').change(function () {
                    console.log("texbox changed");

                    if ($(this).is(":checked")) {
                        $("#form-covid").removeClass("alert-danger");
                        $("#form-covid").removeClass("alert-warning");
                        $("#form-covid").addClass("alert-success");
                      
                    } else {
                        $("#form-covid").removeClass("alert-success");

                        $("#form-covid").addClass("alert-danger");
                   
                    }

                });

                $('#TCagree').change(function () {
                    console.log("texbox changed");

                    if ($(this).is(":checked")) {
                        $("#form-privacy").removeClass("alert-danger");
                        $("#form-privacy").removeClass("alert-warning");
                        $("#form-privacy").addClass("alert-success");
             
                    } else {
                        $("#form-privacy").removeClass("alert-success");

                        $("#form-privacy").addClass("alert-danger");
                    
                    }

                });

            });
            });

    </script>



</body>
</html>
