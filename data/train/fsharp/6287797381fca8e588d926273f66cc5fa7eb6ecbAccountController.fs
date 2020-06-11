namespace FSharpWebApi.Controllers

open System
open System.Collections.Generic
open System.Net.Http
open System.Security.Claims
open System.Security.Cryptography
open System.Threading.Tasks
open System.Web
open System.Web.Http
open System.Web.Http.ModelBinding
open Microsoft.AspNet.Identity
open Microsoft.AspNet.Identity.EntityFramework
open Microsoft.AspNet.Identity.Owin
open Microsoft.Owin.Security
open Microsoft.Owin.Security.Cookies
open Microsoft.Owin.Security.OAuth

open FSharpWebApi.Infrastructure
open FSharpWebApi.Models
open FSharpWebApi.Providers
open FSharpWebApi.Results

open Common.Helpers

type private RouteValues =
  { Provider : string
    ResponseType : string
    ClientId : string
    RedirectUri : string
    State : string }

[<AllowNullLiteral>]
type private ExternalLoginData() =
  let mutable _loginProvider = Unchecked.defaultof<string>
  let mutable _providerKey = Unchecked.defaultof<string>
  let mutable _userName = Unchecked.defaultof<string>

  member this.LoginProvider
    with get() = _loginProvider
    and set(value) = _loginProvider <- value 
  
  member this.ProviderKey
    with get() = _providerKey
    and set(value) = _providerKey <- value

  member this.UserName
    with get() = _userName
    and set(value) = _userName <- value

  member this.GetClaims() =   
    let claims = new List<Claim>()    
    claims.Add(new Claim(ClaimTypes.NameIdentifier, this.ProviderKey, null, this.LoginProvider))
  
    if this.UserName <> null then
      claims.Add(new Claim(ClaimTypes.Name, this.UserName, null, this.LoginProvider))

    claims
 
  static member FromIdentity(identity:ClaimsIdentity) =
    match identity with
    | null -> null
    | _ -> 
      let providerKeyClaim = identity.FindFirst(ClaimTypes.NameIdentifier)
      match providerKeyClaim, String.IsNullOrEmpty(providerKeyClaim.Issuer), String.IsNullOrEmpty(providerKeyClaim.Value) with
      | null, true, true -> null      
      | _ -> match providerKeyClaim.Issuer with
             | ClaimsIdentity.DefaultIssuer -> null
             | _ -> new ExternalLoginData(LoginProvider = providerKeyClaim.Issuer, ProviderKey = providerKeyClaim.Value, UserName = identity.FindFirstValue(ClaimTypes.Name))

type private RandomOAuthStateGenerator() =
  static member private _random = 
    new RNGCryptoServiceProvider()

  static member Generate(strengthInBits:int) =
    let bitsPerByte = 8

    if (strengthInBits % bitsPerByte <> 0) then
      raise(new ArgumentException("strengthInBits must be evenly divisible by 8.", "strengthInBits"))

    let strengthInBytes = strengthInBits / bitsPerByte
    let data : byte [] = Array.zeroCreate strengthInBytes
    RandomOAuthStateGenerator._random.GetBytes(data);
    HttpServerUtility.UrlTokenEncode(data)

[<Authorize>]
[<RoutePrefix("api/Account")>]
type AccountController(userManager:ApplicationUserManager, accessTokenFormat:ISecureDataFormat<AuthenticationTicket>) =
  inherit ApiController()

  let LocalLoginProvider = "Local"
  let mutable _accessTokenFormat = accessTokenFormat
  let mutable _userManager = userManager

  member this.UserManager
    with get() = 
      match _userManager with
      | null -> this.Request.GetOwinContext().GetUserManager<ApplicationUserManager>()
      | _ -> _userManager
    and set(value) = _userManager <- value

  member this.AccessTokenFormat
    with get() = _accessTokenFormat
    and set(value) = _accessTokenFormat <- value
  
  new() = new AccountController()

  member private this.Authentication = 
    this.Request.GetOwinContext().Authentication

  // GET api/Account/UserInfo
  [<HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)>]
  [<Route("UserInfo")>]
  member this.GetUserInfo() =
    let externalLogin = ExternalLoginData.FromIdentity(this.User.Identity :?> ClaimsIdentity)
    let userInfoViewModel = { UserInfoViewModel.Email = this.User.Identity.GetUserName()
                              HasRegistered = (externalLogin = null)
                              LoginProvider = if externalLogin <> null then externalLogin.LoginProvider else null }
  
    userInfoViewModel

  // POST api/Account/Logout
  [<Route("Logout")>]
  member this.Logout() =
    this.Authentication.SignOut(CookieAuthenticationDefaults.AuthenticationType)
    this.Ok()

  // GET api/Account/ManageInfo?returnUrl=%2F&generateState=true
  [<Route("ManageInfo")>]
  member this.GetManageInfo(returnUrl:string, generateState:bool) =
    let user = await(fun () -> this.UserManager.FindByIdAsync(this.User.Identity.GetUserId()))

    match user with
    | null -> None
    | _ ->
      let logins = new List<UserLoginInfoViewModel>()
      
      for linkedAccount in user.Logins do
        logins.Add({ LoginProvider = linkedAccount.LoginProvider; ProviderKey = linkedAccount.ProviderKey })

      if user.PasswordHash <> null then
        logins.Add({ LoginProvider = LocalLoginProvider; ProviderKey = user.UserName})

      Some({ LocalLoginProvider = LocalLoginProvider; 
        Email = user.Email; 
        Logins = logins; 
        ExternalLoginProviders = this.GetExternalLogins(returnUrl, generateState) })

  // POST api/Account/ChangePassword
  [<Route("ChangePassword")>]
  member this.ChangePassword(model:ChangePasswordBindingModel) =
    match this.ModelState.IsValid with
    | false -> this.BadRequest(this.ModelState) :> IHttpActionResult
    | _ ->
        let result = await(fun () -> this.UserManager.ChangePasswordAsync(this.User.Identity.GetUserId(), model.OldPassword, model.NewPassword))

        match result.Succeeded with
        | false -> this.GetErrorResult(result) :> IHttpActionResult
        | _ -> this.Ok() :> IHttpActionResult

  // POST api/Account/SetPassword
  [<Route("SetPassword")>]
  member this.SetPassword(model:SetPasswordBindingModel) =
    match this.ModelState.IsValid with
    | false -> this.BadRequest(this.ModelState) :> IHttpActionResult
    | _ -> 
      let result = await(fun () -> this.UserManager.AddPasswordAsync(this.User.Identity.GetUserId(), model.NewPassword))
      
      match result.Succeeded with
      | false -> this.GetErrorResult(result) :> IHttpActionResult
      | _ -> this.Ok() :> IHttpActionResult

  // POST api/Account/AddExternalLogin
  [<Route("AddExternalLogin")>]
  member this.AddExternalLogin(model:AddExternalLoginBindingModel) =
    match this.ModelState.IsValid with
    | false -> this.BadRequest(this.ModelState) :> IHttpActionResult
    | _ -> 
        this.Authentication.SignOut(DefaultAuthenticationTypes.ExternalCookie)
        let ticket = this.AccessTokenFormat.Unprotect(model.ExternalAccessToken)
      
        let badRequest = 
          this.BadRequest("External login failure.") :> IHttpActionResult

        match ticket with
        | null -> badRequest
        | t when t.Identity = null -> badRequest
        | t when t.Properties <> null &&
                 t.Properties.ExpiresUtc.HasValue &&
                 t.Properties.ExpiresUtc.Value < DateTimeOffset.UtcNow -> badRequest
        | _ ->     
          let externalData = ExternalLoginData.FromIdentity(ticket.Identity)
          
          match externalData with
          | null -> this.BadRequest("The external login is already associated with an account.") :> IHttpActionResult
          | _ ->
              let result = await(fun () -> this.UserManager.AddLoginAsync(this.User.Identity.GetUserId(),
                                              new UserLoginInfo(externalData.LoginProvider, externalData.ProviderKey)))
              match result.Succeeded with
              | false -> this.GetErrorResult(result) :> IHttpActionResult
              | _ -> this.Ok() :> IHttpActionResult
  

  // POST api/Account/RemoveLogin
  [<Route("RemoveLogin")>]
  member this.RemoveLogin(model:RemoveLoginBindingModel) =
    match this.ModelState.IsValid with
    | false -> this.BadRequest(this.ModelState) :> IHttpActionResult
    | _ ->
        let mutable result = Unchecked.defaultof<IdentityResult>

        match model.LoginProvider with
        | l when l = LocalLoginProvider -> result <- await(fun () -> this.UserManager.RemovePasswordAsync(this.User.Identity.GetUserId()))
        | _ -> result <- await(fun () -> this.UserManager.RemoveLoginAsync(this.User.Identity.GetUserId(),
                                            new UserLoginInfo(model.LoginProvider, model.ProviderKey)))
        
        match result.Succeeded with
        | false -> this.GetErrorResult(result) :> IHttpActionResult
        | _ -> this.Ok() :> IHttpActionResult

  // GET api/Account/ExternalLogin
  [<OverrideAuthentication>]
  [<HostAuthentication(DefaultAuthenticationTypes.ExternalCookie)>]
  [<AllowAnonymous>]
  [<Route("ExternalLogin", Name = "ExternalLogin")>]
  member this.GetExternalLogin(provider:string, error:string) =
      match error with
      | null -> 
          if this.User.Identity.IsAuthenticated <> true then 
            new ChallengeResult(provider, this) :> IHttpActionResult
          else
            let externalLogin = ExternalLoginData.FromIdentity(this.User.Identity :?> ClaimsIdentity)
            
            match externalLogin with
            | null -> this.InternalServerError() :> IHttpActionResult
            | el when el.LoginProvider <> provider -> 
                this.Authentication.SignOut(DefaultAuthenticationTypes.ExternalCookie)
                new ChallengeResult(provider, this) :> IHttpActionResult
            | _ ->
                let user = await(fun () -> this.UserManager.FindAsync(new UserLoginInfo(externalLogin.LoginProvider, externalLogin.ProviderKey)))
                let hasRegistered = user <> null
           
                match hasRegistered with
                | true -> 
                    this.Authentication.SignOut(DefaultAuthenticationTypes.ExternalCookie)         
                    let oAuthIdentity = user.GenerateUserIdentityAsync(this.UserManager, OAuthDefaults.AuthenticationType)
                    let cookieIdentity = user.GenerateUserIdentityAsync(this.UserManager, CookieAuthenticationDefaults.AuthenticationType)
                    let properties = ApplicationOAuthProvider.CreateProperties(user.UserName)
                    this.Authentication.SignIn(properties, oAuthIdentity, cookieIdentity)
                | false ->
                    let claims = externalLogin.GetClaims()
                    let identity = new ClaimsIdentity(claims, OAuthDefaults.AuthenticationType)
                    this.Authentication.SignIn(identity)
                this.Ok() :> IHttpActionResult
      | _ -> this.Redirect(this.Url.Content("~/") + "#error=" + Uri.EscapeDataString(error)) :> IHttpActionResult

  // GET api/Account/ExternalLogins?returnUrl=%2F&generateState=true
  [<AllowAnonymous>]
  [<Route("ExternalLogins")>]
  member this.GetExternalLogins(returnUrl:string, generateState:bool) =
    let descriptions = this.Authentication.GetExternalAuthenticationTypes()
    let logins = new List<ExternalLoginViewModel>()
    let mutable state = String.Empty

    match generateState with
    | true -> state <- RandomOAuthStateGenerator.Generate(256)
    | false -> state <- null
   
    for description in descriptions do
      let redirectUri = new Uri(this.Request.RequestUri, returnUrl)
      let login = 
        {
          Name = description.Caption;
          Url = this.Url.Route("ExternalLogin", { Provider = description.AuthenticationType; 
                                                  ResponseType = "token"; 
                                                  ClientId = FSharpWebApi.Startup.PublicClientId; 
                                                  RedirectUri = redirectUri.AbsoluteUri;
                                                  State = state });
          State = state
        }
      
      logins.Add(login)
    
    logins

  // POST api/Account/Register
  [<AllowAnonymous>]
  [<Route("Register")>]
  member this.Register(model:RegisterBindingModel) =
    match this.ModelState.IsValid with
    | false -> this.BadRequest(this.ModelState) :> IHttpActionResult
    | true -> 
        let user = new ApplicationUser(UserName = model.Email, Email = model.Email);   
        let result = await(fun () -> this.UserManager.CreateAsync(user, model.Password))
      
        match result.Succeeded with
        | false -> this.GetErrorResult(result) :> IHttpActionResult
        | true -> this.Ok() :> IHttpActionResult

  // POST api/Account/RegisterExternal
  [<OverrideAuthentication>]
  [<HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)>]
  [<Route("RegisterExternal")>]
  member this.RegisterExternal(model:RegisterExternalBindingModel) =
    match this.ModelState.IsValid with
    | false -> this.BadRequest(this.ModelState) :> IHttpActionResult
    | true ->
        let info = await(fun () -> this.Authentication.GetExternalLoginInfoAsync())
 
        match info with
        | null -> this.InternalServerError() :> IHttpActionResult
        | _ ->
            let user = new ApplicationUser(UserName = model.Email, Email = model.Email)
            let result = await(fun () -> this.UserManager.CreateAsync(user))
            
            match result.Succeeded with
            | false -> this.GetErrorResult(result) :> IHttpActionResult
            | _ ->
                let result = await(fun () -> this.UserManager.AddLoginAsync(user.Id, info.Login))
                
                match result.Succeeded with
                | false -> this.GetErrorResult(result) :> IHttpActionResult
                | _ -> this.Ok() :> IHttpActionResult            

  override this.Dispose(disposing:bool) =
    if (disposing && _userManager <> null) then
      _userManager.Dispose()
      _userManager <- null

    base.Dispose(disposing)

  member private this.GetErrorResult(result:IdentityResult) =
    match result with
    | null -> this.InternalServerError() :> IHttpActionResult
    | _ ->
        match result.Succeeded with
        | true -> null
        | false ->
            if result.Errors <> null then
              result.Errors |> Seq.iter(fun error -> this.ModelState.AddModelError("", error))

            match this.ModelState.IsValid with
            | true -> this.BadRequest() :> IHttpActionResult
            | false -> this.BadRequest(this.ModelState) :> IHttpActionResult