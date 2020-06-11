namespace Fantastica.Controllers

open System
open System.Collections.Generic
open System.Linq
open System.Web
open System.Web.Mvc
open System.Web.Mvc.Ajax
open System.Net;
open System.Web.Http;
open Fantastica.Models;
open Fantastica.Api.Entities
open Fantastica.Api

[<RoutePrefix("api/room")>]
type RoomController() =
    inherit ApiController()
    
    let users = DataStore.Instance.UserRepository.FindAll()
    let mutable currentUser = 0
    
    [<Route("nextSong")>]
    member x.Post()  =
        currentUser <- (currentUser + 1) % users.Count()
        ""//DataStore.Instance.UserRepository.NextSongId(user,playlist)