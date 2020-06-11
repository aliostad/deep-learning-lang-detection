namespace FSharpWebSite.Controllers

open System
open System.Web.Mvc
open FSharpWebSite.ViewModels.Account
open Domain
open Entities
open FSharpWebSite.Mappers
open System.Security.Claims
open System.Collections.Generic
open Microsoft.Owin.Security
open Microsoft.AspNet.Identity
open Microsoft.Owin.Host.SystemWeb
open Microsoft.AspNet.Identity.Owin
open System.Web.Http.Owin
open System.Web

type AccountController() =
    inherit Controller()

    member this.Index () =    
        this.View()

    [<HttpGet>]
    member this.Login() = 
        this.View()

    [<HttpGet>]
    member this.Register() = 
        this.View()

    [<HttpGet>]
    member this.ChangePassword() = 
        this.View()
        
    [<HttpGet>]    
    member this.Manage() = 
        let id = base.User.Identity.GetUserId()
        match UserManager.GetUserById (Guid.ParseExact(id, "N")) with
        |Some user ->
            let viewModel = { Email = user.Email; Login= user.Login; Role = user.Role} : ManageViewModel
            base.View viewModel
        |None -> base.View "Error"

    [<HttpPost>]
    member this.Login (viewModel : LoginViewModel) : ActionResult = 
        match this.ModelState.IsValid with
            |false -> upcast base.View viewModel 
            |true ->  match UserManager.Login viewModel.Login viewModel.Password with                    
                        |Choice1Of2(id, role) ->   
                            let claims = List<Claim>()
                            claims.Add(Claim(ClaimTypes.Name, viewModel.Login, ClaimValueTypes.String))                         
                            claims.Add(Claim(ClaimTypes.NameIdentifier, id))
                            claims.Add(Claim(ClaimTypes.Role, role.ToString()))
                            claims.Add(Claim("http://schemas.microsoft.com/accesscontrolservice/2010/07/claims/identityprovider", "OWIN Provider", ClaimValueTypes.String));                          
                            (AuthenticationProperties(IsPersistent = true), ClaimsIdentity(claims, DefaultAuthenticationTypes.ApplicationCookie))
                            |> HttpContext.Current.GetOwinContext().Authentication.SignIn                            
                            upcast base.Redirect "~/"
                        |Choice2Of2 e ->  
                            List.iter( fun (errorLine : string) -> this.ModelState.AddModelError("", errorLine)) e   
                            upcast base.View viewModel 

    [<HttpPost>]
    member this.Register (viewModel : RegisterViewModel) : ActionResult = 
        match this.ModelState.IsValid with
            |false -> upcast base.View viewModel 
            |true -> 
                    let id = UserManager.getUserIdByLogin viewModel.Login
                    if(id.IsNone) then
                        let result = viewModel
                                    |> UserMapper.registerVMToUserDTO
                                    |> UserManager.RegisterUser 
                        match result with
                        |Choice1Of2 _  -> upcast base.Redirect("~/")
                        |Choice2Of2 e ->    
                            List.iter( fun (errorLine : string) -> this.ModelState.AddModelError("", errorLine)) e   
                            upcast base.View viewModel
                    else 
                        this.ModelState.AddModelError("", "User already exists") 
                        upcast base.View viewModel

    [<HttpPost>]
    [<ValidateAntiForgeryToken>]
    member this.LogOff() =
        HttpContext.Current.GetOwinContext().Authentication.SignOut();       
        base.Redirect "~/"

    [<HttpPost>]
    member this.ChangeRole(viewModel : ChangeRoleViewModel) : ActionResult= 
        match UserManager.ChangeRole viewModel.Login viewModel.Role with
        |Choice1Of2 _ -> 
            if(this.TempData.ContainsKey("SuccessMessage")) then
                this.TempData.["SuccessMessage"] <- ["Role has been changed succefully"]
            else this.TempData.Add("SuccessMessage", ["Role has been changed succefully"])  
            upcast base.RedirectToAction("Manage")              
        |Choice2Of2 message -> 
            if(this.TempData.ContainsKey("FailureMessage")) then
                this.TempData.["FailureMessage"] <- message                
            else this.TempData.Add("FailureMessage", message)
            upcast base.RedirectToAction("Manage")              

    [<HttpPost>]
    member this.ChangePassword(viewModel : ChangePasswordViewModel) : ActionResult= 
        let id = Guid.ParseExact(base.User.Identity.GetUserId(), "N")
        match UserManager.ChangePassword id viewModel.OldPassword viewModel.Password with
        |Choice1Of2 _ -> 
            if(this.TempData.ContainsKey("SuccessMessage")) then
                this.TempData.["SuccessMessage"] <- ["Password has been changed succefully"]
            else this.TempData.Add("SuccessMessage", ["Password has been changed succefully"])  
            upcast base.RedirectToAction("Manage")                                          
        |Choice2Of2 message -> 
            List.iter (fun (m : string) -> this.ModelState.AddModelError("", m)) message
            upcast base.View viewModel
                
