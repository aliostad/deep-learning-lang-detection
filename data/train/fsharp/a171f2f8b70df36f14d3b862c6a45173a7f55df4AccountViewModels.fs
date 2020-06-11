namespace WebApi.Models

open System
open System.Collections.Generic

// Models returned by AccountController actions.

[<CLIMutable>]
type ExternalLoginViewModel =
  { Name : string
    Url : string
    State : string }

[<CLIMutable>]
type UserInfoViewModel = 
  { Email : string
    HasRegistered : bool
    LoginProvider : string }

[<CLIMutable>]
type UserLoginInfoViewModel =
  { LoginProvider : string
    ProviderKey : string }

[<CLIMutable>]
type ManageInfoViewModel =
  { LocalLoginProvider : string
    Email : string
    Logins : IEnumerable<UserLoginInfoViewModel>
    ExternalLoginProviders : IEnumerable<ExternalLoginViewModel> }
