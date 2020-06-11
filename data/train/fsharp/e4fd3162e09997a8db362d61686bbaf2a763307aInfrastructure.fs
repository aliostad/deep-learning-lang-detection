namespace FSharpWeb1.Infrastructure

open System
open System.Security.Claims
open System.Threading.Tasks
open Microsoft.Owin
open Microsoft.Owin.Security
open Microsoft.AspNet.Identity
open Microsoft.AspNet.Identity.EntityFramework
open Microsoft.AspNet.Identity.Owin
open System.Threading.Tasks
open System.Web
open System.Web.Mvc
open Microsoft.AspNet.Identity.Owin
open Microsoft.Owin.Security

// Thanks to http://stackoverflow.com/a/5341186/170217 for this!
module Collections = 
  let inline init s =
    let coll = new ^t()
    Seq.iter (fun (k,v) -> (^t : (member Add : 'a * 'b -> unit) coll, k, v)) s
    coll

module Helpers =
  // Thank you Tomas Petricek!!! http://stackoverflow.com/a/8150139/170217
  let (?<-) (viewData:ViewDataDictionary) (name:string) (value:'T) =
    viewData.Add(name, box value)

  let awaitPlainTask(t) =
    (async { return! Async.AwaitIAsyncResult <| t() |> Async.Ignore } |> Async.StartAsTask).Result

  let await(t) =
    (async { return! Async.AwaitTask <| t() } |> Async.StartAsTask).Result

type EmailService() =
  interface IIdentityMessageService with
    member this.SendAsync (message:IdentityMessage) : Task =
      // Plug in your email service here to send an email.
      Task.FromResult(0) :> Task

type ManageMessageId =
  | AddPhoneSuccess = 1
  | ChangePasswordSuccess = 2
  | SetTwoFactorSuccess = 3
  | SetPasswordSuccess = 4
  | RemoveLoginSuccess = 5
  | RemovePhoneSuccess = 6
  | Error = 7

type ReturnUrl = { ReturnUrl : string }
type RouteValues = 
  { ReturnUrl:string
    RememberMe:bool }
type RedirectValues = 
  { Provider:string
    ReturnUrl:string
    RememberMe:bool }
type Message = { Message : ManageMessageId }
type PhoneNumber = { PhoneNumber:string }

type ChallengeResult(controller:Controller, provider:string, redirectUri:string, userId:string) = 
  inherit HttpUnauthorizedResult()

  member val private Controller = controller with get, set
  member val LoginProvider = provider with get, set
  member val RedirectUri = redirectUri with get, set
  member val UserId = userId with get, set  

  new(controller:Controller, provider:string, redirectUri:string) = 
    ChallengeResult(controller, provider, redirectUri, null)

  override this.ExecuteResult(context:ControllerContext) =
    let properties = AuthenticationProperties(RedirectUri = this.RedirectUri)    

    match this.UserId with
    | null -> ()
    | _ -> properties.Dictionary.["XsrfId"] <- this.UserId
    
    this.Controller.ControllerContext.HttpContext.GetOwinContext().Authentication.Challenge(properties, this.LoginProvider)

type SmsService() =
  interface IIdentityMessageService with
    member this.SendAsync (message:IdentityMessage) : Task = 
      // Plug in your SMS service here to send a text message.
      Task.FromResult(0) :> Task

[<AllowNullLiteral>]
type ApplicationUser() =
  inherit IdentityUser()

  member this.GenerateUserIdentityAsync (manager:UserManager<ApplicationUser>) = 
    // Note the authenticationType must match the one defined in CookieAuthenticationOptions.AuthenticationType
    let userIdentity =  
      async {
        let! result = manager.CreateIdentityAsync(this, DefaultAuthenticationTypes.ApplicationCookie)
                      |> Async.AwaitTask
        return result
      } |> Async.StartAsTask
    // Add custom user claims here
    userIdentity

type ApplicationDbContext() =
  inherit IdentityDbContext<ApplicationUser>("DefaultConnection", throwIfV1Schema = false)
  
  static member Create() =
    new ApplicationDbContext()

[<AllowNullLiteral>]
type ApplicationUserManager(store:IUserStore<ApplicationUser>) =
  inherit UserManager<ApplicationUser>(store)
  
  static member Create(options:IdentityFactoryOptions<ApplicationUserManager>, context:IOwinContext) =  
    let manager = new ApplicationUserManager(new UserStore<ApplicationUser>(context.Get<ApplicationDbContext>()))
    
    // Configure validation logic for usernames
    let userValidator = UserValidator<ApplicationUser> (manager)
    userValidator.AllowOnlyAlphanumericUserNames <- false
    userValidator.RequireUniqueEmail <- true
    
    manager.UserValidator <- userValidator
       
    // Configure validation logic for passwords
    let passwordValidator = PasswordValidator()
    passwordValidator.RequiredLength <- 6
    passwordValidator.RequireNonLetterOrDigit <- true
    passwordValidator.RequireDigit <- true
    passwordValidator.RequireLowercase <- true
    passwordValidator.RequireUppercase <- true

    manager.PasswordValidator <- passwordValidator

    // Configure user lockout defaults
    manager.UserLockoutEnabledByDefault <- true
    manager.DefaultAccountLockoutTimeSpan <- TimeSpan.FromMinutes(5.0)
    manager.MaxFailedAccessAttemptsBeforeLockout <- 5

    // Register two factor authentication providers. This application uses Phone and Emails as a step of receiving a code for verifying the user
    // You can write your own provider and plug it in here.
    let phoneNumberTokenProvider = PhoneNumberTokenProvider<ApplicationUser>()
    phoneNumberTokenProvider.MessageFormat <- "Your security code is {0}"

    manager.RegisterTwoFactorProvider("Phone Code", phoneNumberTokenProvider)

    let emailTokenProvider = EmailTokenProvider<ApplicationUser>()
    emailTokenProvider.Subject <- "Security Code"
    emailTokenProvider.BodyFormat <- "Your security code is {0}"

    manager.RegisterTwoFactorProvider("Email Code", emailTokenProvider)
    manager.EmailService <- EmailService()
    manager.SmsService <- SmsService()

    let dataProtectionProvider = 
      if options.DataProtectionProvider <> null then
        manager.UserTokenProvider <- 
          new DataProtectorTokenProvider<ApplicationUser>(options.DataProtectionProvider.Create("ASP.NET Identity"))

    manager

[<AllowNullLiteral>]
type ApplicationSignInManager(userManager:ApplicationUserManager, authenticationManager:IAuthenticationManager) =
  inherit SignInManager<ApplicationUser, string>(userManager, authenticationManager)
  
  override this.CreateUserIdentityAsync(user:ApplicationUser) =
    user.GenerateUserIdentityAsync(this.UserManager :?> ApplicationUserManager)
    
  static member Create(options:IdentityFactoryOptions<ApplicationSignInManager>, context:IOwinContext) =
    new ApplicationSignInManager(context.GetUserManager<ApplicationUserManager>(), context.Authentication)