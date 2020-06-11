namespace FsWeb.Models

open System
open System.ComponentModel.DataAnnotations
open System.ComponentModel

[<CLIMutable>]
type LoginViewModel = {
    [<Required; Display(Name = "Username")>]
    UserName : string

    [<Required; DataType(DataType.Password)>]
    Password : string

    [<Display(Name = "Remember me?")>]
    RememberMe : bool
}


[<CLIMutable>]
type RegisterViewModel = {
    [<Required; Display(Name = "Username")>]
    UserName : string

    [<Required; DataType(DataType.EmailAddress)>]
    Email : string

    [<Required; DataType(DataType.Password)>]
    Password : string

    [<Required; DataType(DataType.Password); Display(Name = "Confirm password")>]
    [<Compare("Password", ErrorMessage = "The password and confirmation password do not match.")>]
    ConfirmPassword : string
}


[<CLIMutable>]
type ManageUserViewModel = {
    [<Required; DataType(DataType.Password); Display(Name = "Current password")>]
    OldPassword : string

    [<Required; DataType(DataType.Password); Display(Name = "New password")>]
    NewPassword : string

    [<Required; DataType(DataType.Password); Display(Name = "Confirm new password")>]
    [<Compare("NewPassword", ErrorMessage = "The new password and confirmation password do not match.")>]
    ConfirmPassword : string

    [<Required; DataType(DataType.EmailAddress)>]
    Email : string
}