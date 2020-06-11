namespace BlueHarvest.Controllers

open System
open System.Linq
open System.Threading.Tasks
open System.Web
open System.Web.Mvc
open Microsoft.AspNet.Identity
open Microsoft.AspNet.Identity.Owin
open Microsoft.Owin.Security

open Common.Helpers
open BlueHarvest.Infrastructure
open BlueHarvest.Infrastructure.Helpers
open BlueHarvest.Models

[<Authorize>]
type ManageController(userManager:ApplicationUserManager, signInManager:ApplicationSignInManager) =
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

  new() = new ManageController(null, null)

  //
  // GET: /Manage/Index
  member this.Index(message:Nullable<ManageMessageId>) =
    if message.HasValue then
      this.ViewData?StatusMessage <-
        match message.Value with
          | ManageMessageId.ChangePasswordSuccess -> "Your password has been changed."
          | ManageMessageId.SetPasswordSuccess -> "Your password has been set."
          | ManageMessageId.SetTwoFactorSuccess -> "Your two-factor authentication provider has been set."
          | ManageMessageId.Error -> "An error has occurred."
          | ManageMessageId.AddPhoneSuccess -> "Your phone number was added."
          | ManageMessageId.RemovePhoneSuccess -> "Your phone number was removed."
          | _ -> ""    
    
    let userId = this.User.Identity.GetUserId()
    this.View({ IndexViewModel.HasPassword = this.HasPassword();
                PhoneNumber = await(fun () -> this.UserManager.GetPhoneNumberAsync(userId));
                TwoFactor = await(fun () -> this.UserManager.GetTwoFactorEnabledAsync(userId));
                Logins = await(fun () -> this.UserManager.GetLoginsAsync(userId));
                BrowserRemembered = await(fun () -> this.AuthenticationManager.TwoFactorBrowserRememberedAsync(userId))})

  //
  // POST: /Manage/RemoveLogin
  [<HttpPost>]
  [<ValidateAntiForgeryToken>]
  member this.RemoveLogin(loginProvider:string, providerKey:string) =
    let result = await(fun () -> this.UserManager.RemoveLoginAsync(this.User.Identity.GetUserId(), UserLoginInfo(loginProvider, providerKey)))
    let message = 
      match result.Succeeded with
      | true -> 
          let user = await(fun () -> this.UserManager.FindByIdAsync(this.User.Identity.GetUserId()))
          match user with
          | null -> ManageMessageId.Error
          | _ ->
            awaitPlainTask(fun () -> this.SignInManager.SignInAsync(user, isPersistent = false, rememberBrowser = false))
            ManageMessageId.RemoveLoginSuccess;
      | false -> ManageMessageId.Error
    
    this.RedirectToAction("ManageLogins", { Message = message })

  //
  // GET: /Manage/AddPhoneNumber
  member this.AddPhoneNumber() =
    this.View()

  //
  // POST: /Manage/AddPhoneNumber
  [<HttpPost>]
  [<ValidateAntiForgeryToken>]
  member this.AddPhoneNumber(model:AddPhoneNumberViewModel) =
    match this.ModelState.IsValid with
    | false -> this.View(model) :> ActionResult
    | true ->
        // Generate the token and send it
        let code = await(fun () -> this.UserManager.GenerateChangePhoneNumberTokenAsync(this.User.Identity.GetUserId(), model.Number))
        if this.UserManager.SmsService <> null then
          let message = new IdentityMessage()
          message.Destination <- model.Number
          message.Body <- "Your security code is: " + code
          awaitPlainTask(fun () -> this.UserManager.SmsService.SendAsync(message))

        this.RedirectToAction("VerifyPhoneNumber", { PhoneNumber.PhoneNumber = model.Number }) :> ActionResult

  //
  // POST: /Manage/EnableTwoFactorAuthentication
  [<HttpPost>]
  [<ValidateAntiForgeryToken>]
  member this.EnableTwoFactorAuthentication() =
    await(fun () -> this.UserManager.SetTwoFactorEnabledAsync(this.User.Identity.GetUserId(), true)) |> ignore
    let user = await(fun () -> this.UserManager.FindByIdAsync(this.User.Identity.GetUserId()))
    if user <> null then
      awaitPlainTask(fun () -> this.SignInManager.SignInAsync(user, isPersistent = false, rememberBrowser = false))

    this.RedirectToAction("Index", "Manage")

  //
  // POST: /Manage/DisableTwoFactorAuthentication
  [<HttpPost>]
  [<ValidateAntiForgeryToken>]
  member this.DisableTwoFactorAuthentication() =
    await(fun () -> this.UserManager.SetTwoFactorEnabledAsync(this.User.Identity.GetUserId(), false)) |> ignore
    let user = await(fun () -> this.UserManager.FindByIdAsync(this.User.Identity.GetUserId()))
    if user <> null then
      awaitPlainTask(fun () -> this.SignInManager.SignInAsync(user, isPersistent = false, rememberBrowser = false))

    this.RedirectToAction("Index", "Manage")

  //
  // GET: /Manage/VerifyPhoneNumber
  member this.VerifyPhoneNumber(phoneNumber:string) =
      await(fun () -> this.UserManager.GenerateChangePhoneNumberTokenAsync(this.User.Identity.GetUserId(), phoneNumber)) |> ignore
      // Send an SMS through the SMS provider to verify the phone number
      match String.IsNullOrEmpty(phoneNumber) with
      | true -> this.View("Error")
      | false ->
          this.View({ VerifyPhoneNumberViewModel.PhoneNumber = phoneNumber })

  //
  // POST: /Manage/VerifyPhoneNumber
  [<HttpPost>]
  [<ValidateAntiForgeryToken>]
  member this.VerifyPhoneNumber(model:VerifyPhoneNumberViewModel) =
    match this.ModelState.IsValid with
    | false -> this.View(model) :> ActionResult
    | true ->
        let result = await(fun () -> this.UserManager.ChangePhoneNumberAsync(this.User.Identity.GetUserId(), model.PhoneNumber, model.Code))
        match result.Succeeded with
        | true -> 
            let user = await(fun () -> this.UserManager.FindByIdAsync(this.User.Identity.GetUserId()))
            match user with
            | null ->
              this.ModelState.AddModelError("", "Failed to verify phone")
              this.View(model) :> ActionResult
            | _ ->
              awaitPlainTask(fun () -> this.SignInManager.SignInAsync(user, isPersistent = false, rememberBrowser = false))
              this.RedirectToAction("Index", { Message.Message = ManageMessageId.AddPhoneSuccess }) :> ActionResult
        | false ->
          // If we got this far, something failed, redisplay form
          this.ModelState.AddModelError("", "Failed to verify phone")
          this.View(model) :> ActionResult

  member private this.AddErrors(result:IdentityResult) =
    result.Errors
    |> Seq.map(fun error -> this.ModelState.AddModelError("", error))

  //
  // GET: /Manage/RemovePhoneNumber
  member this.RemovePhoneNumber() =
    let result = await(fun () -> this.UserManager.SetPhoneNumberAsync(this.User.Identity.GetUserId(), null))
    match result.Succeeded with
    | false -> this.RedirectToAction("Index", { Message.Message = ManageMessageId.Error })
    | true ->   
        let user = await(fun () -> this.UserManager.FindByIdAsync(this.User.Identity.GetUserId()))
        if user <> null then
          awaitPlainTask(fun () -> this.SignInManager.SignInAsync(user, isPersistent = false, rememberBrowser = false))

        this.RedirectToAction("Index", { Message.Message = ManageMessageId.RemovePhoneSuccess })

  //
  // GET: /Manage/ChangePassword
  member this.ChangePassword() =
    this.View()

  //
  // POST: /Manage/ChangePassword
  [<HttpPost>]
  [<ValidateAntiForgeryToken>]
  member this.ChangePassword(model:ChangePasswordViewModel) =
    match this.ModelState.IsValid with
    | false -> this.View(model) :> ActionResult
    | true ->
      let result = await(fun () -> this.UserManager.ChangePasswordAsync(this.User.Identity.GetUserId(), model.OldPassword, model.NewPassword))
      match result.Succeeded with
      | false -> 
        this.AddErrors(result) |> ignore
        this.View(model) :> ActionResult
      | true -> 
        let user = await(fun () -> this.UserManager.FindByIdAsync(this.User.Identity.GetUserId()))
        match user with
        | null -> 
          this.AddErrors(result) |> ignore
          this.View(model) :> ActionResult
        | _ ->
          awaitPlainTask(fun () -> this.SignInManager.SignInAsync(user, isPersistent = false, rememberBrowser = false))
          this.RedirectToAction("Index", { Message.Message = ManageMessageId.ChangePasswordSuccess }) :> ActionResult

  //
  // GET: /Manage/SetPassword
  member this.SetPassword() =
    this.View()

  //
  // POST: /Manage/SetPassword
  [<HttpPost>]
  [<ValidateAntiForgeryToken>]
  member this.SetPassword(model:SetPasswordViewModel) =
    match this.ModelState.IsValid with
    | true ->
        let result = await(fun () -> this.UserManager.AddPasswordAsync(this.User.Identity.GetUserId(), model.NewPassword))
        match result.Succeeded with
        | true ->
          let user = await(fun () -> this.UserManager.FindByIdAsync(this.User.Identity.GetUserId()))
          if user <> null then
            awaitPlainTask(fun () -> this.SignInManager.SignInAsync(user, isPersistent = false, rememberBrowser = false))

          this.RedirectToAction("Index", { Message = ManageMessageId.SetPasswordSuccess }) :> ActionResult
        | false -> 
            // If we got this far, something failed, redisplay form 
            this.AddErrors(result) |> ignore
            this.View(model) :> ActionResult
    // If we got this far, something failed, redisplay form
    | false -> this.View(model) :> ActionResult

  //
  // GET: /Manage/ManageLogins
  member this.ManageLogins(message:Nullable<ManageMessageId>) =
    if message.HasValue then
      this.ViewData?StatusMessage <- 
        match message.Value with
        | ManageMessageId.RemoveLoginSuccess -> "The external login was removed."
        | ManageMessageId.Error -> "An error has occurred."
        | _ -> ""
    
    let user = await(fun () -> this.UserManager.FindByIdAsync(this.User.Identity.GetUserId()))
    match user with
    | null -> this.View("Error")
    | _ ->
      let userLogins = await(fun () -> this.UserManager.GetLoginsAsync(this.User.Identity.GetUserId()))
      let otherLogins = 
        (query {
          for auth in this.AuthenticationManager.GetExternalAuthenticationTypes() do
          where (userLogins.All(fun ul -> auth.AuthenticationType <> ul.LoginProvider))
          select auth
        }).ToList()

      this.ViewData?ShowRemoveButton <- 
        if user.PasswordHash <> null || userLogins.Count > 1 then true else false

      this.View({ ManageLoginsViewModel.CurrentLogins = userLogins; OtherLogins = otherLogins })

  //
  // POST: /Manage/LinkLogin
  [<HttpPost>]
  [<ValidateAntiForgeryToken>]
  member this.LinkLogin(provider:string) =
    // Request a redirect to the external login provider to link a login for the current user
    ChallengeResult(this, provider, this.Url.Action("LinkLoginCallback", "Manage"), this.User.Identity.GetUserId())

  //
  // GET: /Manage/LinkLoginCallback
  member this.LinkLoginCallback() =
    let XsrfKey = "XsrfId"
    let loginInfo = await(fun () -> this.AuthenticationManager.GetExternalLoginInfoAsync(XsrfKey, this.User.Identity.GetUserId()))
    
    match loginInfo with
    | null -> this.RedirectToAction("ManageLogins", { Message = ManageMessageId.Error })
    | _ ->
      let result = await(fun () -> this.UserManager.AddLoginAsync(this.User.Identity.GetUserId(), loginInfo.Login))
      match result.Succeeded with
      | true -> this.RedirectToAction("ManageLogins")
      | false -> this.RedirectToAction("ManageLogins", { Message = ManageMessageId.Error })

  member private this.HasPassword() =
    let user = this.UserManager.FindById(this.User.Identity.GetUserId())
    match user with
    | null -> false
    | _ -> 
      match String.IsNullOrEmpty(user.PasswordHash) with
      | false -> true
      | _ -> false

  member private this.HasPhoneNumber() =
    let user = this.UserManager.FindById(this.User.Identity.GetUserId())
    match user with
    | null -> false
    | _ -> 
      match String.IsNullOrEmpty(user.PhoneNumber) with
      | false -> true
      | _ -> false

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