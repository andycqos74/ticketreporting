Public Class login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            LBError.Visible = False
        End If

    End Sub

    Protected Sub BSignin_Click(sender As Object, e As EventArgs) Handles BSignin.Click

        LBError.Visible = False

        If FormsAuthentication.Authenticate(inputuser.Text, inputPassword.Text) Then

            FormsAuthentication.RedirectFromLoginPage(inputuser.Text, True)

        Else

            LBError.Text = "INVALID LOGIN"
            LBError.Visible = True

        End If



    End Sub
End Class