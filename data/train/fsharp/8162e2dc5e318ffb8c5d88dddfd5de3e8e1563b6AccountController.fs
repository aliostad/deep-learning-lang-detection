namespace FSharpWeb1.Controllers


open Microsoft.AspNet.Identity
open Microsoft.Owin.Security
open Microsoft.Owin.Security.Cookies
open Microsoft.AspNet.Identity.EntityFramework
open System
open System.Security.Claims
open System.Net.Http
open System.Web.Http
open System.Web.Http.ModelBinding
open System.Threading.Tasks

open FSharpWeb1
open FSharpWeb1.Models
open FSharpWeb1.Models.ViewModels
open FSharpWeb1.Models.BindingModels



[<AutoOpen>]
module AccountModels =
    type ExternalLoginData = 
        { LoginProvider:string; 
          ProviderKey:string;
          UserName:string }

[<RequireQualifiedAccess>]
module ExternalLoginData =

    let toClaims {LoginProvider = loginProvider; 
                   ProviderKey = providerKey; 
                   UserName = userName} =
        
            Claim(ClaimTypes.NameIdentifier, providerKey, null, loginProvider)::
            match userName with
            | null -> []
            | _ -> [Claim(ClaimTypes.NameIdentifier, userName, null, loginProvider)]

    let fromIdentity (identity : ClaimsIdentity) =
                
        if identity = null
        then None
        else
            let providerKeyClaim = identity.FindFirst(ClaimTypes.NameIdentifier)
            if providerKeyClaim = null then None
            elif String.IsNullOrEmpty(providerKeyClaim.Issuer) then None
            elif String.IsNullOrEmpty(providerKeyClaim.Value) then None
            elif providerKeyClaim.Issuer = ClaimsIdentity.DefaultIssuer then None
            else
            Some { LoginProvider = providerKeyClaim.Issuer;
                   ProviderKey = providerKeyClaim.Value;
                   UserName = identity.FindFirstValue(ClaimTypes.Name) }


[<Authorize; RoutePrefix("api/Account")>]
type AccountController(userManager : UserManager<IdentityUser>,
                       accessTokenFormat : ISecureDataFormat<AuthenticationTicket>) =
    inherit ApiController()

    let localLoginProvider = "Local"

    new() = new AccountController(Startup.UserManagerFactory(), Startup.OAuthOptions.AccessTokenFormat)


    member private x.Authentication = x.Request.GetOwinContext().Authentication

    member private x.GetErrorResult (result : IdentityResult) : IHttpActionResult option =
        match result with
        | null -> Some (x.InternalServerError() :> _ )
        | res when res.Succeeded = false ->
            if res.Errors <> null 
                then result.Errors |> Seq.iter (fun error -> x.ModelState.AddModelError("", error))

            match x.ModelState.IsValid with
            | true -> Some(x.BadRequest() :> _ )
            | false -> Some (x.BadRequest(x.ModelState) :> _ )
        | res -> None
    
    member private x.BadRequest () = base.BadRequest() :> IHttpActionResult
    member private x.BadRequest (message : string) = base.BadRequest message :> IHttpActionResult
    member private x.BadRequest (modelState : ModelStateDictionary) = 
        base.BadRequest(modelState) :> IHttpActionResult

    member private x.Ok () = base.Ok() :> IHttpActionResult
    member private x.Ok content = base.Ok(content) :> IHttpActionResult

    // GET api/Account/UserInfo
    [<HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)>]
    [<Route("UserInfo")>]
    member x.GetUserInfo() =
        let userName = x.User.Identity.GetUserName()
        let externalLogin = 
            match x.User.Identity with
            | :? ClaimsIdentity as iden -> ExternalLoginData.fromIdentity iden
            | _ -> None
        
        match externalLogin with
        | Some (externalLogin) -> 
            { UserName = userName;
              HasRegistered = true;
              LoginProvider = externalLogin.LoginProvider }
        | None ->
            { UserName = userName;
              HasRegistered = false;
              LoginProvider = null}

    // POST api/Account/Logout
    [<Route("Logout")>]
    member x.Logout () =
        x.Authentication.SignOut(CookieAuthenticationDefaults.AuthenticationType)
        x.Ok
    
//    // GET api/Account/ManageInfo?returnUrl=%2F&generateState=true
//    [<Route("ManageInfo")>]
//    member x.GetManageInfo (returnUrl: string, generateState: bool) =
//        async {
//            let! user = userManager.FindByIdAsync(x.User.Identity.GetUserId())
//                        |> Async.AwaitTask
//            if user = null
//            then return None
//            else
//                let logins = 
//                    seq {
//                        for linkedAccount in user.Logins 
//                            do yield { UserLoginInfoViewModel.LoginProvider = linkedAccount.LoginProvider; 
//                                       ProviderKey = linkedAccount.ProviderKey }
//                        if user.PasswordHash <> null 
//                            then yield { UserLoginInfoViewModel.LoginProvider = localLoginProvider; 
//                                         ProviderKey = user.UserName }
//                   }
//                return Some 
//                    { LocalLoginProvider = localLoginProvider;
//                      UserName = user.UserName;
//                      Logins = logins;
//                      ExternalLoginProviders = x.GetExternalLogins(returnUrl, generateState)}
//        } |> Async.StartAsTask
    
    // POST api/Account/ChangePassword
    [<Route("ChangePassword")>]
    member x.ChangePassword (model : ChangePasswordBindingModel) =
        async { 
            if not x.ModelState.IsValid 
            then return x.BadRequest(x.ModelState)
            else
                let! result = userManager.ChangePasswordAsync(x.User.Identity.GetUserId(), 
                                                              model.OldPassword, 
                                                              model.NewPassword)
                              |> Async.AwaitTask

                match x.GetErrorResult(result) with
                | None -> return x.Ok() 
                | Some(errorResult) -> return errorResult 
           } |> Async.StartAsTask 
                
    // POST api/Account/SetPassword
    [<Route("SetPassword")>]
    member x.SetPassword (model : SetPasswordBindingModel) =
        async {
            if not x.ModelState.IsValid
            then return x.BadRequest(x.ModelState)
            else
                let! result = userManager.AddPasswordAsync(x.User.Identity.GetUserId(), 
                                                           model.NewPassword)
                              |> Async.AwaitTask
                match x.GetErrorResult(result) with
                | None -> return x.Ok() 
                | Some(errorResult) -> return errorResult 
           } |> Async.StartAsTask 


    member x.AddExternalLogin (model : AddExternalLoginBindingModel) =
        async {
            if not x.ModelState.IsValid
            then return x.BadRequest(x.ModelState)
            else
                x.Authentication.SignOut(DefaultAuthenticationTypes.ExternalCookie)
                let ticket = accessTokenFormat.Unprotect(model.ExternalAccessToken)
                if ticket = null || ticket.Identity = null ||
                    (ticket.Properties <> null 
                    && ticket.Properties.ExpiresUtc.HasValue
                    && ticket.Properties.ExpiresUtc.Value < DateTimeOffset.UtcNow)
                then return x.BadRequest("External login failure.")
                else 
                    match ExternalLoginData.fromIdentity(ticket.Identity) with
                    | None -> return x.BadRequest("The external login is already associated with an account.")
                    | Some externalData ->
                        let userLoginInfo = UserLoginInfo(externalData.LoginProvider, externalData.ProviderKey)
                        let! result = userManager.AddLoginAsync(x.User.Identity.GetUserId(), userLoginInfo)
                                      |> Async.AwaitTask
                        match x.GetErrorResult(result) with
                        | None -> return x.Ok()
                        | Some errorResult -> return errorResult

                

        } |> Async.StartAsTask 

