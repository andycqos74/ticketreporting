<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="terrace.aspx.vb" Inherits="admintickets.terrace" %>
<%@ register TagPrefix="UCHeader" tagname="Header" Src="~/UC_header.ascx" %>
<%@ register TagPrefix="UCFooter" tagname="Footer" Src="~/UC_footer.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>TMS Terrace</title>
          <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
      <link href="css/jquery-ui.min.css" rel="stylesheet" />
    <link href="css/bs4_custom.css" rel="stylesheet" />
    <link href="css/all.min.css" rel="stylesheet" />
</head>
<body class="body-terrace">
    <form id="form1" runat="server">
   <UCHeader:Header runat="server" ID="UCHeader" ></UCHeader:Header>
      <asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>
<div id="dvGrid" class="container pt-3 mt-3 background-white" style="min-height: 95vh;">
    <div class="row">
        <div class="col-12">

          <h3 id="fixturetitle" runat="server"></h3>

<asp:UpdatePanel ID="UpdatePanel1" runat="server" >
    
    <ContentTemplate>
        <div class="border p-3">
           <asp:Panel ID="Panel2" runat="server" DefaultButton="BnewSave">  
        <h5 class="mb-3">Add New Ticket</h5>

        <div class="row">
            <div class="col">
          <div class="form-group">
    <label for="NewtxtName">Name</label>
    <input type="text" class="form-control" id="NewtxtName" placeholder="Name" runat="server" />
       
  </div>
                </div>

    <div class="col">
          <div class="form-group">
    <label for="NewtxtEmail">Email Address</label>
    <input type="email" class="form-control" id="NewtxtEmail" placeholder="email@address.com" runat="server" />
  </div>
                </div>
     <div class="col">
          <div class="form-group">
    <label for="NewtxtEmail">Date of Birth</label>
    <input type="text" class="form-control" id="NewtxtDOB" placeholder="dd/mm/yyyy" runat="server" />
  </div>
                </div>
            </div>
               <div class="row">
             <div class="col">
          <div class="form-group">
    <label for="NewtxtPostcode">Address</label>
    <input type="text" class="form-control" id="NewtxtAddress" placeholder="Address" runat="server" />
  </div>
                </div>
        <div class="col">
          <div class="form-group">
    <label for="NewtxtPostcode">Postcode</label>
    <input type="text" class="form-control" id="NewtxtPostcode" placeholder="postcode" runat="server" />
  </div>
                </div>
            </div>

    <div class="row">
        <div class="col">
            <label for="DDnewType">Ticket Type</label>
             <asp:DropDownList ID="DDnewType" runat="server" CssClass="form-control">
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
              <asp:ListItem Text="Carer" Value="12"></asp:ListItem>
              
             <asp:ListItem Text="Complimentary" Value="8"></asp:ListItem>
             <asp:ListItem Text="Executive" Value="11"></asp:ListItem>
         </asp:DropDownList>

        </div>
        <div class="col">
             <label for="DDnewStatus">Ticket Status</label>
                     <asp:DropDownList ID="DDnewStatus" runat="server" CssClass="form-control">
           
             <asp:ListItem Text="Provisional" Value="2"></asp:ListItem>
             <asp:ListItem Text="Sold" Value="3" Selected="True"></asp:ListItem>

         </asp:DropDownList>

        </div>

    </div>
        <div class="row">
            <div class="col text-center">
                <asp:Button ID="BnewSave" runat="server" OnClick="Insert" AutoPostBack="true" Text="Add New Ticket" CssClass="btn btn-success mt-2" OnClientClick="return ValidateNew();" />
            </div>
        </div>
            </asp:Panel>
        </div>    

 <div id="existing" class="border p-3 mt-5">
  

     <asp:Panel ID="Panel1" runat="server" DefaultButton="BSearch">


<h5 class="mb-3">Search Existing Tickets</h5>

   <div class="form-group row">
       <div class="col-6">
     <asp:TextBox ID="txtSearchTerm" runat="server"  CssClass="form-control" placeholder="Enter Ticket Number, Name, Email or Postcode" />

       </div>
       <div class="col-3">
              <asp:Button ID="BSearch" runat="server" Text="Search" OnClick="SearchData"  AutoPostBack="true" CssClass="btn btn-primary" />

       </div>

       <div class="col-3">
           <div class="row">
               <div class="col-6 text-center clickable"  onclick="document.getElementById('<%= btnSearchall.ClientID %>').click()">

         <asp:Button ID="btnSearchall" runat="server" Text="Search" OnClick="SearchDataAll"  AutoPostBack="true" CssClass="d-none"/>



                   <asp:Label ID="LBTotalrecordcount" runat="server" Text="" CssClass="badge badge-circle badge-secondary p-2"></asp:Label>
                   <p class="font-weight-bold">Total Records</p>
               </div>
                              <div class="col-6 text-center">
                   <asp:Label ID="LBSearchrecordcount" runat="server" Text="" CssClass="badge badge-circle badge-success p-2"></asp:Label>
                   <p class="font-weight-bold">Search Results</p>
               </div>

           </div>
            

           
       </div>


   </div>
       
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" 
            DataKeyNames="SaleID" OnRowEditing="OnRowEditing" OnRowCancelingEdit="OnRowCancelingEdit"  AllowPaging ="false" 
            OnRowUpdating="OnRowUpdating"  EmptyDataText="No records match your search" CssClass="table table-hover table-bordered " Visible="false"
            >
           

            <Columns>
                <asp:TemplateField HeaderText="#" Visible="false">
                    <ItemTemplate>
                        <asp:Label ID="LBSaleID" runat="server" Text='<%# Eval("SaleID") %>'></asp:Label>
                    </ItemTemplate>

                </asp:TemplateField>            
                
                <asp:TemplateField HeaderText="#">
                    <ItemTemplate>
                        <asp:Label ID="LBTicketID" runat="server" Text='<%# Eval("TicketID") %>'></asp:Label>
                    </ItemTemplate>

                </asp:TemplateField>

                <asp:TemplateField HeaderText="Name" >
                    <ItemTemplate>
                        <asp:Label ID="LBName" runat="server" Text='<%# Eval("TicketName") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtName" runat="server" Text='<%# Eval("TicketName") %>' CssClass="form-control"></asp:TextBox>
                      <asp:RequiredFieldValidator runat="server" ID="requiredname"  ValidationGroup="Ticketupdate"
            ErrorMessage="Name Cannot Be Empty" ControlToValidate="txtName" /> 
                    </EditItemTemplate>
                </asp:TemplateField>
                

                   <asp:TemplateField HeaderText="Email" >
                    <ItemTemplate>
                        <asp:Label ID="LBemail" runat="server" Text='<%# Eval("TicketEmail") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtemail" runat="server" Text='<%# Eval("TicketEmail") %>' CssClass="form-control"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>


                    <asp:TemplateField HeaderText="DOB" >
                    <ItemTemplate>
                        <asp:Label ID="LBDOB" runat="server" Text='<%# Eval("TicketDOB") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtDOB" runat="server" Text='<%# Eval("TicketDOB") %>' CssClass="form-control"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>

                                   <asp:TemplateField HeaderText="Address" >
                    <ItemTemplate>
                        <asp:Label ID="LBaddress" runat="server" Text='<%# Eval("Ticketaddress") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtaddress" runat="server" Text='<%# Eval("Ticketaddress") %>' CssClass="form-control"></asp:TextBox>
                  <asp:RequiredFieldValidator runat="server" ID="requiredaddress"  ValidationGroup="Ticketupdate"
            ErrorMessage="Address Cannot Be Empty" ControlToValidate="txtaddress" />
                    </EditItemTemplate>
                </asp:TemplateField>




                    <asp:TemplateField HeaderText="Postcode" >
                    <ItemTemplate>
                        <asp:Label ID="LBpostcode" runat="server" Text='<%# Eval("TicketPostcode") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtpostcode" runat="server" Text='<%# Eval("TicketPostcode") %>'  CssClass="form-control"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>

                 <asp:TemplateField HeaderText="Type" >
                    <ItemTemplate>
                        <asp:Label ID="LBType" runat="server" Text='<%# Eval("SeatTypeName") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                  <asp:DropDownList ID="DDType" runat="server" CssClass="form-control" SelectedValue='<%# Eval("TerraceTypeID") %>'>
               
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
              <asp:ListItem Text="Carer" Value="12"></asp:ListItem>
              
             <asp:ListItem Text="Complimentary" Value="8"></asp:ListItem>
             <asp:ListItem Text="Executive" Value="11"></asp:ListItem>
         </asp:DropDownList>
                           <asp:RequiredFieldValidator ID="requiredDDL" runat="server"  ValidationGroup="Ticketupdate"
                        ControlToValidate="DDType" ErrorMessage="Please select" InitialValue="0"  Display="Dynamic"></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status" >
                    <ItemTemplate>
                        <asp:Label ID="LBStatus" runat="server" Text='<%# Eval("StatusName") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                       <asp:DropDownList ID="DDStatus" runat="server" CssClass="form-control" SelectedValue='<%# Eval("TerraceStatusID") %>'>
            
             <asp:ListItem Text="Provisional" Value="2"></asp:ListItem>
             <asp:ListItem Text="Sold" Value="3"></asp:ListItem>

         </asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField >
                <ItemTemplate>
                    <asp:linkButton ID="EditButton"
                            runat="server"
                            CssClass="btn btn-primary"
                            CommandName="Edit"
                            Text="Edit"
                     
                 
                        />
                </ItemTemplate>
                    <edititemtemplate>
                          <asp:linkButton ID="EditSaveButton"
                            runat="server"
                            CssClass="btn btn-success mb-1"
                            CommandName="Update"
                            Text="Update" 
                                 ValidationGroup="Ticketupdate"
                              />
                        <asp:linkButton ID="EditCancelButton"
                            runat="server"
                            CssClass="btn btn-secondary"
                            CommandName="Cancel"
                            Text="Cancel" />
                       


                        </edititemtemplate>
            </asp:TemplateField>


            </Columns>
        </asp:GridView>
     </asp:Panel>
          </div>

    </ContentTemplate>
</asp:UpdatePanel>
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
    
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.blockUI/2.70/jquery.blockUI.min.js"></script>
<script type="text/javascript">
    function BlockUI(elementID) {
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_beginRequest(function () {
            $("#" + elementID).block({
                message: '<table align = "center"><tr><td>' +
                    '<img src="images/loadingAnim.gif"/></td></tr></table>',
                css: {},
                overlayCSS: {
                    backgroundColor: '#000000', opacity: 0.6, border: '3px solid #63B2EB'
                }
            });
        });
        prm.add_endRequest(function () {
            $("#" + elementID).unblock();
        });
    }
    $(document).ready(function () {

        BlockUI("existing");
        $.blockUI.defaults.css = {};
   

        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);

        //function EndRequestHandler(sender, args) {
            $("#NewtxtDOB").datepicker({
                changeMonth: true,
                changeYear: true,
                yearRange: "1920:2020",
                dateFormat: "d/m/yy"

            });
        //};
    

        function EndRequestHandler(sender, args) {
            $('input[id*=txtDOB]').datepicker({
                changeMonth: true,
                changeYear: true,
                yearRange: "1920:2020",
                dateFormat: "d/m/yy",


            });
        };

        $("#DDnewType").change(function () {
            var seattype = this.value;

            if (seattype == 0) {
                console.log("no type selected");
                $("#DDnewType").addClass("is-invalid");

                return;
            } else {

                $("#DDnewType").removeClass("is-invalid");

            }

        });


        $('#NewtxtName').on('input', function () {
            var input = $(this);
            var is_name = input.val();
            if (is_name) { input.removeClass("is-invalid"); }
            else { input.addClass("is-invalid"); }
        });



        $('#NewtxtEmail').on('input', function () {
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
                input.removeClass("is-invalid");
            }
        });





    });

    function ValidateNew() {

        var isvalid = true
        var seattype = $("#DDnewType").val();
        if (seattype == 0) {
         
            $("#DDnewType").addClass("is-invalid");

            isvalid = false;
        } else {

            $("#DDnewType").removeClass("is-invalid");

        }
                          
        var isname = $("#NewtxtName").val();
        if (isname) {
            $("#NewtxtName").removeClass("is-invalid");
            }
        else {
            $("#NewtxtName").addClass("is-invalid");
       isvalid = false;
        
        }


        var newemail = $('#NewtxtEmail').val();
        var re = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;

        if (newemail) {


            var is_email = re.test(newemail);
            if (is_email) {
                $('#NewtxtEmail').removeClass("is-invalid");
            }
            else {
                $('#NewtxtEmail').addClass("is-invalid");
                isvalid = false;
            }

        } else {
            $('#NewtxtEmail').removeClass("is-invalid");
        }





        if (isvalid == true) {
            return true;
        } else {
            return false;
        }

    }
                          
</script>
           <UCFooter:Footer runat="server" ID="Footer1" ></UCFooter:Footer>
    
</body>
</html>
