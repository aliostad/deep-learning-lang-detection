namespace FSharpWeb1.Models

open System
open System.Collections.Generic
open System.ComponentModel.DataAnnotations
open System.Security.Claims
open Microsoft.AspNet.Identity


            
module ViewModels =
    [<CLIMutable>]         
    type ExternalLoginViewModel = 
        { Name:string; 
          Url: string; 
          State:string }
    
    [<CLIMutable>]
    type UserInfoViewModel =
        { UserName : string;
          HasRegistered : bool;
          LoginProvider : string}

    [<CLIMutable>]
    type UserLoginInfoViewModel =
        { LoginProvider : string;
          ProviderKey : string }

    [<CLIMutable>]
    type ManageInfoViewModel =
        { LocalLoginProvider : string;
          UserName : string;
          Logins : seq<UserLoginInfoViewModel>;
          ExternalLoginProviders : seq<ExternalLoginViewModel>}   


module BindingModels =
    type AddExternalLoginBindingModel = 
        { [<Required>]
          [<Display(Name = "External Access Token")>]
          ExternalAccessToken : string }

    type ChangePasswordBindingModel = 
        { [<Required>]
          [<DataType(DataType.Password)>]
          [<Display(Name = "Current password")>]
          OldPassword: string;
        
          [<Required>]
          [<StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)>]
          [<DataType(DataType.Password)>]
          [<Display(Name = "New password")>]
          NewPassword : string;

          [<DataType(DataType.Password)>]
          [<Display(Name = "Confirm new password")>]
          [<Compare("NewPassword", ErrorMessage = "The new password and confirmation password do not match.")>]        
          ConfirmPassword : string; }

    type RegisterBindingModel =
        { [<Required>]
          [<Display(Name = "User name")>]
          UserName : string;

          [<Required>]
          [<StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)>]
          [<DataType(DataType.Password)>]
          [<Display(Name = "Password")>]
          Password : string;

          [<DataType(DataType.Password)>]
          [<Display(Name = "Confirm password")>]
          [<Compare("Password", ErrorMessage = "The password and confirmation password do not match.")>]
          ConfirmPassword : string; }

    type RegisterExternalBindingModel =
        { [<Required>]
          [<Display(Name = "User name")>]
          UserName : string; }

    type RemoveLoginBindingModel = 
        { [<Required>]
          [<Display(Name = "Login provider")>]
          LoginProvider : string; }

    type SetPasswordBindingModel =
        { [<Required>]
          [<StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)>]
          [<DataType(DataType.Password)>]
          [<Display(Name = "New password")>]
          NewPassword : string;
          
          [<DataType(DataType.Password)>]
          [<Display(Name = "Confirm new password")>]
          [<Compare("NewPassword", ErrorMessage = "The new password and confirmation password do not match.")>]
          ConfirmPassword : string; }
    