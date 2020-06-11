namespace FSharpWebSite.ViewModels.Account

open System
open Entities
open Newtonsoft.Json
open System.ComponentModel.DataAnnotations

[<CLIMutable>]
type RegisterViewModel = { 
    [<Required>]
    [<EmailAddress(ErrorMessage = "Enter correct email address")>]
    Email : string

    [<Required>]
    [<Display(Name = "Login")>]
    Login : string

    [<Required>]
    [<Display(Name = "Password")>]
    [<DataType(DataType.Password)>]
    Password : string

    [<Display(Name = "Confirm password")>]
    [<DataType(DataType.Password)>]
    [<System.ComponentModel.DataAnnotations.Compare("Password", ErrorMessage = "The password and confirmation password do not match.")>]
    ConfirmPassword : string
}

[<CLIMutable>]
type ManageViewModel = { 
    Email : string
    Login : string
    Role : User.Role
}
   
[<CLIMutable>]
type LoginViewModel = { 
    [<Display(Name = "Login")>]
    [<Required>]
    Login : string

    [<Display(Name = "Password")>]
    [<Required>]
    [<DataType(DataType.Password)>]
    Password : string
}
   
[<CLIMutable>]
type ChangeRoleViewModel = { 
    [<Display(Name = "Login")>]
    [<Required>]
    Login : string

    [<Display(Name = "Role")>]
    [<Required>]
    Role : User.Role
}

[<CLIMutable>]
type ChangePasswordViewModel = { 
    [<Required>]
    [<Display(Name = "Enter old password")>]
    [<DataType(DataType.Password)>]
    OldPassword : string
    [<Required>]
    [<Display(Name = "Enter new password")>]
    [<DataType(DataType.Password)>]
    Password : string

    [<Display(Name = "Confirm new password")>]
    [<DataType(DataType.Password)>]
    [<System.ComponentModel.DataAnnotations.Compare("Password", ErrorMessage = "The password and confirmation password do not match.")>]
    ConfirmPassword : string
}