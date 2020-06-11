namespace FsWeb.Controllers

open System
open System.Web
open System.Web.Mvc
open System.Linq
open System.Web.Security

open WebMatrix.WebData
open Simple.Account
open Simple.Account.Models
open ErrorCode

type pIsActive = { IsActive: bool } 

[<Authorize>]
[<HandleError>]
[<InitializeSimpleMembership>]
type AccountController() =
    inherit Controller()

    member x.RedirectToLocal returnUrl =
        let isLocalUrl= x.Url.IsLocalUrl returnUrl
        match isLocalUrl with
            | true -> x.Redirect returnUrl :> ActionResult
            | false -> x.RedirectToAction ("Index", "Home") :> ActionResult

    member x.Index () =
        x.View() :> ActionResult

    // GET: /Account/Login
    [<AllowAnonymous>]
    member x.Login (returnUrl: string) =
        x.ViewData.["ReturnUrl"] <- returnUrl       
        x.View() :> ActionResult

    // POST: /Account/Login
    [<System.Web.Mvc.HttpPost>]
    [<AllowAnonymous>]
    [<ValidateAntiForgeryToken>]
    member x.Login (model: LoginModel, returnUrl) =        
        let r =  
            if x.ModelState.IsValid then
                let repo = new AppDbContext()    
                let user = 
                    repo.UserProfiles |> 
                        Seq.tryFind 
                            (fun x -> x.UserName.ToLower() = model.UserName.ToLower() && x.IsActive)
                match user with
                    | Some v -> WebMatrix.WebData.WebSecurity.Login 
                                    (model.UserName, model.Password, model.RememberMe)                                             
                    | None -> false 
            else false                                 
        if (r) then x.RedirectToLocal returnUrl
        else    x.ModelState.AddModelError ("", "The user name or password provided is incorrect, or the user is not active.")
                x.View(model) :> ActionResult
   
    // POST: /Account/LogOff
    [<AcceptVerbs("GET", "POST")>]
    member x.LogOff() =
        WebSecurity.Logout()       
        x.RedirectToAction("Index", "durandal") :> ActionResult

    // GET: /Account/Register
    [<AllowAnonymous>]
    member x.Register() =
        x.View() :> ActionResult

    // POST: /Account/Register
    [<AllowAnonymous>]
    [<ValidateAntiForgeryToken>]
    [<System.Web.Mvc.HttpPost>]
    member x.Register (model: RegisterModel, returnUrl: string) =               
        let r =  
            if x.ModelState.IsValid then
                try
                    WebSecurity.CreateUserAndAccount 
                        (model.UserName, model.Password, { IsActive = true }) |> ignore
                    WebSecurity.Login (model.UserName, model.Password) |> ignore; true 
                with 
                    | :? MembershipCreateUserException as ex -> 
                        x.ModelState.AddModelError ("", ErrorCodeToString ex.StatusCode); false  
            else false                                         
        if (r) then x.RedirectToAction("Index", "durandal") :> ActionResult
        else x.View(model) :> ActionResult

    // GET: /Account/Register

    member x.Manage () =
        x.ViewData.["HasLocalPassword"] <- true 
        x.View() :> ActionResult