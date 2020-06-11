namespace WebApiHost

open FootballDemo
open Enigma
open SudokuSolver

open System.Web.Http
open System.Net

[<AutoOpen>]
module Helpers =
    let handleOption = function
        | Some data -> data
        | None -> raise (HttpResponseException HttpStatusCode.NotFound)

type LeagueTableController() = 
    inherit ApiController()
    member __.Get(id) = LeagueTable.getLeague id |> Async.StartAsTask

type TeamController() =
    inherit ApiController()
    member __.Get id = TeamStats.loadStatsForTeam id |> Async.StartAsTask

[<RoutePrefix("api/enigma")>]
type EngimaController() =
    inherit ApiController()
    [<HttpPost>]
    [<Route("translate")>]
    member __.Translate request = Api.performTranslation request
    [<HttpPost>]
    [<Route("configure")>]
    member __.Configure request = Api.configureEnigma request
    [<HttpGet>]
    [<Route("reflector/{id}")>]
    member __.Reflector id = Api.getReflectorResponse id |> handleOption
    [<HttpGet>]
    [<Route("rotor/{id}")>]
    member __.Rotor id = Api.getRotorResponse id |> handleOption

type SudokuController() =
    inherit ApiController()
    [<HttpPost>]
    [<Route("api/sudoku/solve")>]
    member __.Solve request = Api.solve request
