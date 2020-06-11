namespace FsWeb.Controllers

open System
open System.Threading.Tasks
open System.Web
open System.Web.Mvc
open System.Web.Routing
open Microsoft.AspNet.Identity
open Microsoft.AspNet.Identity.EntityFramework
open Microsoft.AspNet.Identity.Owin
open Microsoft.Owin.Security
open FsWeb.Models

type private AppUserManager = UserManager<ApplicationUser>
type private AppUserStore   = UserStore<ApplicationUser>

[<Authorize>]
type AccountController() =
    inherit Controller()
    let userManager = new AppUserManager(new AppUserStore(new MyDbContext()))

    new (manager:AppUserManager) as this = new AccountController() then
        this.UserManager <- manager

    member val UserManager = userManager with get, set

    member this.AuthenticationManager =
        this.HttpContext.GetOwinContext().Authentication

    // GET : /Account/Register
    [<AllowAnonymous>]
    member this.Register() = this.View()

    // POST : /Account/Register
    [<HttpPost>]
    [<AllowAnonymous>]
    [<ValidateAntiForgeryToken>]
    member this.Register(model:RegisterViewModel) : ActionResult =
        if this.ModelState.IsValid then
            let user = ApplicationUser(UserName = model.UserName, Email = model.Email)
            let result = this.UserManager.Create(user, model.Password)

            if result.Succeeded then
                this.SignIn(user, false)
                upcast this.RedirectToAction("Index", "Home")
            else
                this.AddErrors(result)
                upcast this.View(model)
        else
            upcast this.View(model)

    // GET : /Account/Login
    [<AllowAnonymous>]
    member this.Login(returnUrl:string) =
        this.ViewData.["ReturnUrl"] <- returnUrl
        this.View()

    // POST : /Account/Login
    [<HttpPost>]
    [<AllowAnonymous>]
    [<ValidateAntiForgeryToken>]
    member this.Login(model:LoginViewModel, returnUrl) : ActionResult =
        if this.ModelState.IsValid then
            match this.UserManager.Find(model.UserName, model.Password) with
            | null ->
                this.ModelState.AddModelError("", "Invalid UserName or Password.")
                upcast this.View(model)
            | user ->
                this.SignIn(user, model.RememberMe)
                this.RedirectToLocal(returnUrl)
        else
            upcast this.View(model)

    // GET : /Account/Manage
    member this.Manage() =
        let userId = this.User.Identity.GetUserId()
        this.ViewData.["Email"] <- this.UserManager.GetEmail(userId)
        this.View()

    // POST : /Account/Manage
    [<HttpPost>]
    [<ValidateAntiForgeryToken>]
    member this.Manage(model:ManageUserViewModel) : ActionResult =
        if this.ModelState.IsValid then
            let userId = this.User.Identity.GetUserId()
            let result1 = this.UserManager.ChangePassword(
                            userId, model.OldPassword, model.NewPassword)
            let result2 = this.UserManager.SetEmail(userId, model.Email)

            if result1.Succeeded && result2.Succeeded then
                upcast this.RedirectToAction("Index", "Home")
            else
                this.AddErrors(result1)
                this.AddErrors(result2)
                upcast this.View(model)
        else
            upcast this.View(model)

    // POST : /Account/LogOut
    [<HttpPost>]
    [<ValidateAntiForgeryToken>]
    member this.LogOut() =
        this.AuthenticationManager.SignOut()
        this.RedirectToAction("Index", "Home")

    member private this.SignIn(user:ApplicationUser, isPersistent) =
        this.AuthenticationManager.SignOut(DefaultAuthenticationTypes.ExternalCookie)
        let identity = this.UserManager.CreateIdentity(user,
                            DefaultAuthenticationTypes.ApplicationCookie)
        let props = AuthenticationProperties(IsPersistent = isPersistent)
        this.AuthenticationManager.SignIn(props, identity)

    member private this.RedirectToLocal(url) : ActionResult =
        if this.Url.IsLocalUrl(url) then
            upcast this.Redirect(url)
        else
            upcast this.RedirectToAction("Index", "Home")

    member private this.AddErrors(result:IdentityResult) =
        result.Errors |> Seq.iter (fun e -> this.ModelState.AddModelError("", e))


    override this.Dispose(disposing) =
        if disposing && (this.UserManager <> null) then
            this.UserManager.Dispose()
            this.UserManager <- null

        base.Dispose(disposing)