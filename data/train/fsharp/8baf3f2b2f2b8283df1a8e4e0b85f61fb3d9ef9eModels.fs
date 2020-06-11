namespace FSharpWeb1.Models

open System
open System.Collections.Generic
open System.ComponentModel.DataAnnotations
open Microsoft.AspNet.Identity
open Microsoft.Owin.Security

[<CLIMutable>]
type ExternalLoginConfirmationViewModel =
  { [<Required>]
    [<Display(Name = "Email")>]
    Email : string }

[<CLIMutable>]
type ExternalLoginListViewModel =
  { ReturnUrl : string }

[<CLIMutable>]
type SendCodeViewModel =
  { [<DefaultValue>]
    SelectedProvider : string
    Providers : ICollection<System.Web.Mvc.SelectListItem>
    ReturnUrl : string
    RememberMe : bool }

[<CLIMutable>]
type VerifyCodeViewModel =
  { [<Required>]
    Provider : string
    [<Required>]
    [<DefaultValue>]
    [<Display(Name = "Code")>]
    Code : string
    ReturnUrl : string
    [<DefaultValue>]
    [<Display(Name = "Remember this browser?")>]
    RememberBrowser : bool
    RememberMe : bool }

[<CLIMutable>]
type ForgotViewModel =
  { [<Required>]
    [<Display(Name = "Email")>]
    Email : string }

[<CLIMutable>]
type LoginViewModel =
  { [<Required>]
    [<Display(Name = "Email")>]
    [<EmailAddress>]
    Email : string
    [<Required>]
    [<DataType(DataType.Password)>]
    [<Display(Name = "Password")>]
    Password : string
    [<Display(Name = "Remember me?")>]
    RememberMe : bool }

[<CLIMutable>]
type RegisterViewModel =
  { [<Required>]
    [<EmailAddress>]
    [<Display(Name = "Email")>]
    Email : string
    [<Required>]
    [<StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)>]
    [<DataType(DataType.Password)>]
    [<Display(Name = "Password")>]
    Password : string
    [<DataType(DataType.Password)>]
    [<Display(Name = "Confirm password")>]
    [<Compare("Password", ErrorMessage = "The password and confirmation password do not match.")>]
    ConfirmPassword : string }

[<CLIMutable>]
type ResetPasswordViewModel =
  { [<Required>]
    [<EmailAddress>]
    [<Display(Name = "Email")>]
    Email : string
    [<Required>]
    [<StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)>]
    [<DataType(DataType.Password)>]
    [<Display(Name = "Password")>]
    Password : string
    [<DataType(DataType.Password)>]
    [<Display(Name = "Confirm password")>]
    [<Compare("Password", ErrorMessage = "The password and confirmation password do not match.")>]
    ConfirmPassword : string
    Code : string }

[<CLIMutable>]
type ForgotPasswordViewModel =
  { [<Required>]
    [<EmailAddress>]
    [<Display(Name = "Email")>]
    Email : string }

[<CLIMutable>]
type IndexViewModel =
  { HasPassword : bool
    Logins : IList<UserLoginInfo>
    PhoneNumber : string
    TwoFactor : bool
    BrowserRemembered : bool }

[<CLIMutable>]
type ManageLoginsViewModel =
  { CurrentLogins : IList<UserLoginInfo>
    OtherLogins : IList<AuthenticationDescription> }

[<CLIMutable>]
type FactorViewModel =
  { Purpose : string }

[<CLIMutable>]
type SetPasswordViewModel =
  { [<Required>]
    [<StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)>]
    [<DataType(DataType.Password)>]
    [<Display(Name = "New password")>]
    NewPassword : string
    [<DataType(DataType.Password)>]
    [<Display(Name = "Confirm new password")>]
    [<Compare("NewPassword", ErrorMessage = "The new password and confirmation password do not match.")>]
    ConfirmPassword : string }

[<CLIMutable>]
type ChangePasswordViewModel =
  { [<Required>]
    [<DataType(DataType.Password)>]
    [<Display(Name = "Current password")>]
    OldPassword : string
    [<Required>]
    [<StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)>]
    [<DataType(DataType.Password)>]
    [<Display(Name = "New password")>]
    NewPassword : string
    [<DataType(DataType.Password)>]
    [<Display(Name = "Confirm new password")>]
    [<Compare("NewPassword", ErrorMessage = "The new password and confirmation password do not match.")>]
    ConfirmPassword : string }

[<CLIMutable>]
type AddPhoneNumberViewModel =
  { [<Required>]
    [<Phone>]
    [<Display(Name = "Phone Number")>]
    Number : string }

[<CLIMutable>]
type VerifyPhoneNumberViewModel =
  { [<DefaultValue>]
    [<Required>]
    [<Display(Name = "Code")>]
    Code : string
    [<Required>]
    [<Phone>]
    [<Display(Name = "Phone Number")>]
    PhoneNumber : string }

[<CLIMutable>]
type ConfigureTwoFactorViewModel =
  { SelectedProvider : string
    Providers : ICollection<System.Web.Mvc.SelectListItem> }