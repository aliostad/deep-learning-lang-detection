namespace AutoRespect.IdentityServer.Api.Controllers

open AutoRespect.IdentityServer.Api.Models.Requests
open AutoRespect.IdentityServer.Api.DataAccess

open System
open System.Collections.Generic
open System.Linq
open System.Threading.Tasks
open Microsoft.AspNetCore.Mvc

[<Route("api/v1/[controller]")>]
type AccessTokenController () =
    inherit Controller()

    [<HttpPost>]
    member this.Post(request: AccessTokenRequest) =
        match request.grant_type with
        | "password" -> 
            let user = UserDao.findByLogin request.username
            user.ToString()
        | _ -> "Specified grant_type not supported"