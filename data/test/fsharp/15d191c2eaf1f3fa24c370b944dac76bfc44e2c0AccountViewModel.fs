namespace FSharpCMS_MVC5.Models

open System.ComponentModel.DataAnnotations

type public ExternalLoginConfirmationViewModel() =
    [<Required>]
    [<Display(Name = "User name")>]
    member val UserName = "" with get, set

type ManageUserViewModel() =
    [<Required>]
    [<DataType(DataType.Password)>]
    [<Display(Name = "Current Password")>]
    member val OldPassword = "" with get, set
    
    [<Required>]
    [<StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)>]
    [<DataType(DataType.Password)>]
    [<Display(Name = "New Password")>]
    member val NewPassword = "" with get, set

    [<DataType(DataType.Password)>]
    [<Display(Name = "Confirm New Password")>]
    [<Compare("NewPassword", ErrorMessage = "The new password and confirmation password do not match.")>]
    member val ConfirmPassword = "" with get, set

type LoginViewModel() =
    [<Required>]
    [<Display(Name = "User name")>]
    member val UserName = "" with get, set

    [<Required>]
    [<DataType(DataType.Password)>]
    [<Display(Name = "Password")>]
    member val Password = "" with get, set

    [<Display(Name = "Remember me?")>]
    member val RememberMe = false with get, set

type RegisterViewModel() =
    [<Required>]
    [<Display(Name = "User name")>]
    member val UserName = "" with get, set

    [<Required>]
    [<StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)>]
    [<DataType(DataType.Password)>]
    [<Display(Name = "Password")>]
    member val Password = "" with get, set

    [<DataType(DataType.Password)>]
    [<Display(Name = "Confirm password")>]
    [<Compare("Password", ErrorMessage = "The password and confirmation password do not match.")>]
    member val ConfirmPassword = "" with get, set