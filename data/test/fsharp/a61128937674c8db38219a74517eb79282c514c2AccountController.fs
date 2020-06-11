namespace FSharpCMS_MVC5.Controllers

open System
open System.Collections.Generic
open System.Linq
open System.Web
open Microsoft.Owin
open Microsoft.Owin.Extensions
open System.Web.Mvc
open System.Web.Mvc.Ajax
open System.Web.Security
open System.Security.Claims
open Microsoft.AspNet.Identity
open Microsoft.AspNet.Identity.EntityFramework
open Microsoft.Owin.Security
open Microsoft.Owin.Host.SystemWeb
open FSharpCMS_MVC5.Models

type ManageMessageId =
    | ChangePasswordSuccess = 0
    | SetPasswordSuccess = 1
    | RemoveLoginSuccess = 2
    | Error = 3

[<Authorize>]
type AccountController() =
    inherit System.Web.Mvc.Controller()

    let mutable _userManager = 
        new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())) 

    member x.UserManager with get() = _userManager
                         and private set(v) = _userManager <- v

    member x.AccountController(userManager : UserManager<ApplicationUser>) =
        x.UserManager <- userManager

    member x.AccountController() =
        x.AccountController(x.UserManager)

    member private x.AuthenticationManager =
        System.Web.HttpContextBaseExtensions.GetOwinContext(base.HttpContext).Authentication

    member x.SignInAsync(user : ApplicationUser, isPersistent: bool) =
        async {
            x.AuthenticationManager.SignOut(DefaultAuthenticationTypes.ExternalCookie)
            let! identity = Async.AwaitTask(x.UserManager.CreateIdentityAsync(user, DefaultAuthenticationTypes.ApplicationCookie))
            x.AuthenticationManager.SignIn(
                new AuthenticationProperties(IsPersistent = isPersistent),
                identity
            )
        }

    member x.RedirectToAction(action :string, route :string) =
        base.RedirectToAction(action, route)

    member x.RedirectToAction(action :string, routeValues :Routing.RouteValueDictionary) =
        base.RedirectToAction(action, routeValues)

    member private x.RedirectToLocal(returnUrl) =
        if base.Url.IsLocalUrl(returnUrl) then
            base.Redirect(returnUrl) :> ActionResult
        else
            base.RedirectToAction("Index", "Home") :> ActionResult

    member private x.HasPassword() =
        let userid = x.User.Identity.GetUserId()
        let user = x.UserManager.FindById(userid)

    
    member private x.AddErrors(errors :Microsoft.AspNet.Identity.IdentityResult) =
        errors |> List.map(fun e -> x.ModelState.AddModelError("", e)) // TODO: this needs fixins
    
    [<AllowAnonymous>]
    member x.Login(returnUrl) =
        x.ViewData.Add("ReturnUrl", returnUrl)
        //x.ViewBag?ReturnUrl <- returnUrl
        x.View()

    [<HttpPost>]
    [<AllowAnonymous>]
    [<ValidateAntiForgeryToken>]
    member x.Login(model : LoginViewModel, returnUrl : string) =
        let task (x : AccountController) =
            async {
                let! user = 
                    Async.AwaitTask(
                        x.UserManager.FindAsync(
                            model.UserName,
                            model.Password))
                try
                    do! x.SignInAsync(user, model.RememberMe)
                    return x.RedirectToLocal(returnUrl)
                with
                    | ex -> x.ModelState.AddModelError("", "Invalid username or password") 
                            return x.RedirectToLocal(returnUrl) // TODO: watch this line closely, may not do what it should
            }
        if x.ModelState.IsValid then Async.StartAsTask(task x) |> ignore
        base.View(model) 

    [<AllowAnonymous>]
    member x.Register() = x.View()

    [<HttpPost>]
    [<AllowAnonymous>]
    [<ValidateAntiForgeryToken>]
    member x.Register(model : RegisterViewModel) =
        let sucess = base.RedirectToAction("Index", "Home")
        let failure = x.RedirectToLocal("Register")
        let error result = x.AddErrors(result)
        let task (x :AccountController) =
            async {
                let user = new ApplicationUser(UserName = model.UserName)
                let! result = Async.AwaitTask(x.UserManager.CreateAsync(user, model.Password))
                if result.Succeeded then
                    do! x.SignInAsync(user, false) 
                    return x.RedirectToAction("Index", "Home") :> ActionResult // TODO: work on this bit, too
                else
                    x.AddErrors(result)
                    return x.RedirectToLocal("Register")
            } 
        if x.ModelState.IsValid then Async.StartAsTask(task x) |> ignore
        base.View(model)

    [<HttpPost>]
    [<ValidateAntiForgeryToken>]
    member x.Disassociate(loginProvider : string, providerKey : string) = async {
            let mutable message = ManageMessageId.Error
            let! result =
                Async.AwaitTask(
                    x.UserManager.RemoveLoginAsync(
                        x.User.Identity.GetUserId(),
                        new UserLoginInfo(loginProvider, providerKey)
                     )
                )
            if result.Succeeded then
                message <- ManageMessageId.RemoveLoginSuccess
            else
                message <- ManageMessageId.Error
            let routeValues = new Routing.RouteValueDictionary()
            routeValues.Add("Message", message)
            return x.RedirectToAction("Manage", routeValues)
    } 

    [<HttpPost>]
    [<ValidateAntiForgeryToken>]
    member x.Manage(?message) =
        let msgString = match message with
                        | Some ManageMessageId.ChangePasswordSuccess -> "Your password has been changed."
                        | Some ManageMessageId.SetPasswordSuccess    -> "Your password has been set."
                        | Some ManageMessageId.RemoveLoginSuccess    -> "The external login was removed."
                        | Some ManageMessageId.Error                 -> "An error has occurred."
                        | Some _                                     -> ""
                        | None                                       -> ""
        let hasPassword = x.HasPassword()
        let returnUrl = x.Url.Action("Manage")
        x.ViewData.Add("StatusMessage", msgString)
        x.ViewData.Add("HasLocalPassword", hasPassword)
        x.ViewData.Add("ReturnUrl", returnUrl)
        // dynamic set operator support not 100%, using ViewData instead
        //x.ViewBag?StatusMessage <- msgString
        //x.ViewBag?HasLocalPassword <- HasPassword();
        //x.ViewBag?ReturnUrl <- x.Url.Action("Manage")
        x.View()

        
    [<HttpPost>]
    [<ValidateAntiForgeryToken>]
    member x.Manage(model :ManageUserViewModel) =
        let hasPassword = x.HasPassword()

        