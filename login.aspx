<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="login.aspx.vb" Inherits="admintickets.login" %>

<!DOCTYPE html>


<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="/docs/4.0/assets/img/favicons/favicon.ico">

    <title>TMS Login</title>


    <!-- Bootstrap core CSS -->
   <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />

    <link href="css/bs4_custom.css" rel="stylesheet" />
    <link href="css/all.min.css" rel="stylesheet" />

    <!-- Custom styles for this template -->
    <link href="css/signin.css" rel="stylesheet">
  </head>

  <body class="text-center">
      
    <form class="form-signin" runat="server">
<%--        <asp:UpdatePanel ID="UPanel1" runat="server">
            <ContentTemplate>--%>
      <img class="mb-4" src="http://www.qosfc.com/images/95-trans.png" alt="" width="95" height="95">
        <h3>QOS TMS</h3>
      <h1 class="h3 mb-3 font-weight-normal">Please sign in</h1>
      <label for="inputEmail" class="sr-only">Username</label>
        <asp:TextBox ID="inputuser" CssClass="form-control" runat="server"></asp:TextBox>
      
      <label for="inputPassword" class="sr-only">Password</label>
         <asp:TextBox ID="inputPassword" CssClass="form-control" runat="server" TextMode="Password"></asp:TextBox>
    
<%--      <div class="checkbox mb-3">
        <label>
          <input type="checkbox" value="remember-me"> Remember me
        </label>
      </div>--%>
            <asp:Label id="LBError" cssclass="badge badge-warning" runat="server" Text="" visible="false"></asp:Label>
        <asp:Button ID="BSignin" runat="server" Text="Sign in" CssClass="btn btn-lg btn-primary btn-block" />
<%--         </ContentTemplate>
                </asp:UpdatePanel>--%>
    </form>
      
  </body>
</html>
