namespace cvbuilder.web

open System
open System.Web
open System.Net
open System.Web.Http
open System.Net.Http
open System.Configuration
open System.Threading
open HttpClient
open Newtonsoft.Json
open System.Security.Claims
open System.IdentityModel.Services
open System.IdentityModel.Tokens
open Thinktecture.IdentityModel.Authorization.WebApi

[<RoutePrefix("api/logout")>]
type LogoutController() =
    inherit ApiController()

    [<Authorize>]
    member x.Post() =
        x.Request.CreateResponse(HttpStatusCode.OK);
