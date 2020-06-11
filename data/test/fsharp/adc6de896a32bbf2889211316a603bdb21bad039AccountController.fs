namespace FSharpWeb1.Controllers

open System
open System.Collections.Generic
open System.Globalization
open System.Linq
open System.Security.Claims
open System.Threading.Tasks
open System.Web
open System.Web.Mvc
open Microsoft.AspNet.Identity
open Microsoft.AspNet.Identity.Owin
open Microsoft.Owin.Security

open FSharpWeb1.Infrastructure
open FSharpWeb1.Infrastructure.Helpers
open FSharpWeb1.Models

[<Authorize>]
type AccountController(userManager:ApplicationUserManager, signInManager:ApplicationSignInManager) =
  inherit Controller()

  let mutable _signInManager : ApplicationSignInManager = signInManager
  let mutable _userManager : ApplicationUserManager = userManager

  member this.AuthenticationManager with get() = this.HttpContext.GetOwinContext().Authentication

  member this.SignInManager
    with get () = 
      match _signInManager with
      | null -> this.HttpContext.GetOwinContext().Get<ApplicationSignInManager>()
      | _ -> _signInManager
    and set (value) = _signInManager <- value

  member this.UserManager
    with get () = 
      match _userManager with
      | null -> this.HttpContext.GetOwinContext().GetUserManager<ApplicationUserManager>()
      | _ -> _userManager
    and set (value) = _userManager <- value

  new() = new AccountController(null, null)

  member private this.RedirectToLocal(returnUrl:string) = 
    match this.Url.IsLocalUrl(returnUrl) with
    | true -> this.Redirect(returnUrl) :> ActionResult
    | false -> this.RedirectToAction("Index", "Home") :> ActionResult

  member private this.AddErrors(result:IdentityResult) =
    result.Errors
    |> Seq.map (fun error -> this.ModelState.AddModelError("", error))
    |> ignore

  //
  // GET: /Account/Login
  [<AllowAnonymous>]
  member this.Login(returnUrl : string) =
    this.ViewData?ReturnUrl <- returnUrl
    this.View()

  //
  // POST: /Account/Login
  [<HttpPost>]
  [<AllowAnonymous>]
  [<ValidateAntiForgeryToken>]
  member this.Login(model:LoginViewModel, returnUrl:string) =
    match this.ModelState.IsValid with
    | false -> this.View(model) :> ActionResult
    | true -> 
        // This doesn't count login failures towards account lockout
        // To enable password failures to trigger account lockout, change to shouldLockout: true
        let result = await(fun () -> this.SignInManager.PasswordSignInAsync(model.Email, model.Password, model.RememberMe, shouldLockout = false))
        match result with
        | SignInStatus.Success -> this.RedirectToLocal(returnUrl)
        | SignInStatus.LockedOut -> this.View("Lockout") :> ActionResult
        | SignInStatus.RequiresVerification -> 
            this.RedirectToAction("SendCode", { RouteValues.ReturnUrl = returnUrl; RememberMe = model.RememberMe }) :> ActionResult
        | SignInStatus.Failure | _  -> 
          this.ModelState.AddModelError("", "Invalid login attempt.")
          this.View(model) :> ActionResult
 
  //
  // GET: /Account/VerifyCode
  [<AllowAnonymous>]
  member this.VerifyCode(provider:string, returnUrl:string, rememberMe:bool) =
    // Require that the user has already logged in via username/password or external login
    let hasBeenVerified = await(fun () -> this.SignInManager.HasBeenVerifiedAsync())

    match hasBeenVerified with
    | true -> this.View({ VerifyCodeViewModel.Provider = provider; ReturnUrl = returnUrl; RememberMe = rememberMe })
    | false -> this.View("Error")
    
  //
  // POST: /Account/VerifyCode
  [<HttpPost>]
  [<AllowAnonymous>]
  [<ValidateAntiForgeryToken>]
  member this.VerifyCode(model:VerifyCodeViewModel) =
    match this.ModelState.IsValid with
    | false -> this.View(model) :> ActionResult
    | true ->
        // The following code protects for brute force attacks against the two factor codes. 
        // If a user enters incorrect codes for a specified amount of time then the user account 
        // will be locked out for a specified amount of time. 
        // You can configure the account lockout settings in IdentityConfig
        let twoFactorSignIn = await(fun () -> this.SignInManager.TwoFactorSignInAsync(model.Provider, model.Code, isPersistent =  model.RememberMe, rememberBrowser = model.RememberBrowser))

        match twoFactorSignIn with
        | SignInStatus.Success -> this.RedirectToLocal(model.ReturnUrl)
        | SignInStatus.LockedOut -> this.View("Lockout") :> ActionResult
        | SignInStatus.Failure | _ -> 
          this.ModelState.AddModelError("", "Invalid code.")
          this.View(model) :> ActionResult

  //
  // GET: /Account/Register
  [<AllowAnonymous>]
  member this.Register() =
      this.View()

  //
  // POST: /Account/Register
  [<HttpPost>]
  [<AllowAnonymous>]
  [<ValidateAntiForgeryToken>]
  member this.Register(model:RegisterViewModel) =
    match this.ModelState.IsValid  with
    | true -> 
      let user = ApplicationUser(UserName = model.Email, Email = model.Email)
      let um = await(fun () -> this.UserManager.CreateAsync(user, model.Password))
      
      match um.Succeeded with 
      | true -> 
          awaitPlainTask(fun () -> this.SignInManager.SignInAsync(user, isPersistent = false, rememberBrowser = false))        
          // For more information on how to enable account confirmation and password reset please visit http://go.microsoft.com/fwlink/?LinkID=320771
          // Send an email with this link
          // string code = await UserManager.GenerateEmailConfirmationTokenAsync(user.Id);
          // var callbackUrl = Url.Action("ConfirmEmail", "Account", new { userId = user.Id, code = code }, protocol: Request.Url.Scheme);
          // await UserManager.SendEmailAsync(user.Id, "Confirm your account", "Please confirm your account by clicking <a href=\"" + callbackUrl + "\">here</a>");
          this.RedirectToAction("Index", "Home") :> ActionResult
      | false -> 
          this.AddErrors(um)
          // If we got this far, something failed, redisplay form
          this.View(model) :> ActionResult
    | false ->
        // If we got this far, something failed, redisplay form
        this.View(model) :> ActionResult

  //
  // GET: /Account/ConfirmEmail
  [<AllowAnonymous>]
  member this.ConfirmEmail(userId:string, code:string) =
    match userId, code with
    | null, null -> this.View("Error")
    | _ ->
      let result = await(fun () -> this.UserManager.ConfirmEmailAsync(userId, code))
      let view = match result.Succeeded with
                  | true -> "ConfirmEmail"
                  | false -> "Error"

      this.View(view)

  //
  // GET: /Account/ForgotPassword
  [<AllowAnonymous>]
  member this.ForgotPassword() =
    this.View()

  //
  // POST: /Account/ForgotPassword
  [<HttpPost>]
  [<AllowAnonymous>]
  [<ValidateAntiForgeryToken>]
  member this.ForgotPassword(model:ForgotPasswordViewModel) =
    match this.ModelState.IsValid with
    | true ->
        let user = await(fun () -> this.UserManager.FindByNameAsync(model.Email))
        let isEmailConfirmed = await(fun () -> this.UserManager.IsEmailConfirmedAsync(user.Id))

        match user, isEmailConfirmed with
        | null, false -> this.View("ForgotPasswordConfirmation")
        // If we got this far, something failed, redisplay form
        | _ -> this.View(model) 
    // If we got this far, something failed, redisplay form
    | false -> this.View(model) 

    // For more information on how to enable account confirmation and password reset please visit http://go.microsoft.com/fwlink/?LinkID=320771
    // Send an email with this link
    // string code = await UserManager.GeneratePasswordResetTokenAsync(user.Id);
    // var callbackUrl = Url.Action("ResetPassword", "Account", new { userId = user.Id, code = code }, protocol: Request.Url.Scheme);		
    // await UserManager.SendEmailAsync(user.Id, "Reset Password", "Please reset your password by clicking <a href=\"" + callbackUrl + "\">here</a>");
    // return RedirectToAction("ForgotPasswordConfirmation", "Account");

  //
  // GET: /Account/ForgotPasswordConfirmation
  [<AllowAnonymous>]
  member this.ForgotPasswordConfirmation() =
    this.View()

  //
  // GET: /Account/ResetPassword
  [<AllowAnonymous>]
  member this.ResetPassword(code:string) =
    match code with
    | null -> this.View("Error")
    | _ -> this.View()
  
  //
  // POST: /Account/ResetPassword
  [<HttpPost>]
  [<AllowAnonymous>]
  [<ValidateAntiForgeryToken>]
  member this.ResetPassword(model:ResetPasswordViewModel) =
    match this.ModelState.IsValid with
    | false -> this.View(model) :> ActionResult
    | true ->
      let user = await(fun () -> this.UserManager.FindByNameAsync(model.Email))
      match user with
      // Don't reveal that the user does not exist
      | null -> this.RedirectToAction("ResetPasswordConfirmation", "Account") :> ActionResult
      | _ ->
        let result = await(fun () -> this.UserManager.ResetPasswordAsync(user.Id, model.Code, model.Password))
        this.AddErrors(result)
        match result.Succeeded with
        | true -> this.RedirectToAction("ResetPasswordConfirmation", "Account") :> ActionResult
        | false -> this.View() :> ActionResult

  //
  // GET: /Account/ResetPasswordConfirmation
  [<AllowAnonymous>]
  member this.ResetPasswordConfirmation() =
      this.View()

  //
  // POST: /Account/ExternalLogin
  [<HttpPost>]
  [<AllowAnonymous>]
  [<ValidateAntiForgeryToken>]
  member this.ExternalLogin(provider:string, returnUrl:string) =
    // Request a redirect to the external login provider
    ChallengeResult(this, provider, this.Url.Action("ExternalLoginCallback", "Account", { ReturnUrl.ReturnUrl = returnUrl }))
   
  //
  // GET: /Account/SendCode
  [<AllowAnonymous>]
  member this.SendCode(returnUrl:string, rememberMe:bool) =
    let userId = await(fun () -> this.SignInManager.GetVerifiedUserIdAsync())

    match userId with
    | null -> this.View("Error")
    | _ -> 
      let userFactors = await(fun () -> this.UserManager.GetValidTwoFactorProvidersAsync(userId))
      let factorOptions = 
        userFactors
        |> Seq.map (fun purpose -> SelectListItem(Text = purpose, Value = purpose))
        |> Seq.toArray :> ICollection<System.Web.Mvc.SelectListItem>                 
      
      this.View({ SendCodeViewModel.Providers = factorOptions; ReturnUrl = returnUrl; RememberMe = rememberMe})
      
  //
  // POST: /Account/SendCode
  [<HttpPost>]
  [<AllowAnonymous>]
  [<ValidateAntiForgeryToken>]
  member this.SendCode(model:SendCodeViewModel) =
      match this.ModelState.IsValid with
      | false -> this.View() :> ActionResult
      | true -> 
        // Generate the token and send it
        let sendTwoFactorCode = await(fun () -> this.SignInManager.SendTwoFactorCodeAsync(model.SelectedProvider))
        
        match sendTwoFactorCode with
        | false -> this.View("Error") :> ActionResult
        | true -> 
            this.RedirectToAction("VerifyCode", { RedirectValues.Provider = model.SelectedProvider; ReturnUrl = model.ReturnUrl; RememberMe = model.RememberMe }) :> ActionResult
            
  //
  // GET: /Account/ExternalLoginCallback
  [<AllowAnonymous>]
  member this.ExternalLoginCallback(returnUrl:string) =
    let loginInfo = await(fun () -> this.AuthenticationManager.GetExternalLoginInfoAsync())

    match loginInfo with
    | null -> this.RedirectToAction("Login") :> ActionResult
    | _ ->
      // Sign in the user with this external login provider if the user already has a login
      let externalSignIn = await(fun () -> this.SignInManager.ExternalSignInAsync(loginInfo, isPersistent = false))

      match externalSignIn with
      | SignInStatus.Success -> this.RedirectToLocal(returnUrl)
      | SignInStatus.LockedOut -> this.View("Lockout") :> ActionResult
      | SignInStatus.RequiresVerification -> this.RedirectToAction("SendCode", { RouteValues.ReturnUrl = returnUrl; RememberMe = false }) :> ActionResult
      | SignInStatus.Failure | _ -> 
        // If the user does not have an account, then prompt the user to create an account
        this.ViewData?ReturnUrl <- returnUrl
        this.ViewData?LoginProvider <- loginInfo.Login.LoginProvider
        this.View("ExternalLoginConfirmation", { ExternalLoginConfirmationViewModel.Email = loginInfo.Email }) :> ActionResult

  //
  // POST: /Account/ExternalLoginConfirmation
  [<HttpPost>]
  [<AllowAnonymous>]
  [<ValidateAntiForgeryToken>]
  member this.ExternalLoginConfirmation(model:ExternalLoginConfirmationViewModel, returnUrl:string) =
    
    // TODO: This function needs work and I will be seriously suprised if
    // it even works the way it's currently coded. I got so confused on this
    // function due to it's C# counterpart. This one has stumped me due
    // to the various ways it returns
    
    match this.User.Identity.IsAuthenticated with
    | true -> this.RedirectToAction("Index", "Manage") :> ActionResult
    | false ->
        match this.ModelState.IsValid with
        | false -> 
          this.ViewData?ReturnUrl <- returnUrl
          this.View(model) :> ActionResult
          // Get the information about the user from the external login provider
        | true -> 
            let info = await(fun () -> this.AuthenticationManager.GetExternalLoginInfoAsync())

            match info with
            | null -> this.View("ExternalLoginFailure") :> ActionResult
            | _ -> 
              let user = ApplicationUser(UserName = model.Email, Email = model.Email)
              let um = await(fun () -> this.UserManager.CreateAsync(user))
              let redirectToLocal : string =
                match um.Succeeded with
                | true ->
                    let addLogin = await(fun () -> this.UserManager.AddLoginAsync(user.Id, info.Login))                
                    match addLogin.Succeeded with
                    | true -> 
                      awaitPlainTask(fun () -> this.SignInManager.SignInAsync(user, isPersistent = false, rememberBrowser = false))
                      returnUrl
                    | false -> String.Empty
                | false -> String.Empty                    
              
              match redirectToLocal with
              | "" ->
                this.AddErrors(um)
                this.ViewData?ReturnUrl <- returnUrl
                this.View(model) :> ActionResult
              | _ -> this.RedirectToLocal(returnUrl)
              
  //
  // POST: /Account/LogOff
  [<HttpPost>]
  [<ValidateAntiForgeryToken>]
  member this.LogOff() =
    this.AuthenticationManager.SignOut()
    this.RedirectToAction("Index", "Home")

  //
  // GET: /Account/ExternalLoginFailure
  [<AllowAnonymous>]
  member this.ExternalLoginFailure() =
    this.View()

  override this.Dispose(disposing) =
    if disposing then
      match _userManager with
      | null -> ()
      | _ -> 
        _userManager.Dispose()
        _userManager <- null

      match _signInManager with
      | null -> ()
      | _ ->
          _signInManager.Dispose()
          _signInManager <- null

    base.Dispose(disposing)