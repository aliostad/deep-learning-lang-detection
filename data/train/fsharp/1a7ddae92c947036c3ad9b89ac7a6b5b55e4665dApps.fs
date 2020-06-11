module SuaveHost.Apps

open Suave
open Suave.Files
open Suave.Filters
open Suave.Operators
open Suave.Successful
open Suave.Writers
open System

open FootballDemo
open FootballDemo.LeagueTable
open FootballDemo.TeamStats
open Enigma
open SudokuSolver

/// Routes for the Football app.
let footballApp =
    GET >=> choose [
        pathScan "/api/leaguetable/%d" (enum<FootballMonth> >> getLeague >> toJsonAsync)
        pathScan "/api/team/%s" (Uri.UnescapeDataString >> loadStatsForTeam >> toJsonAsync) ]

/// Routes for the Enigma app.
let enigmaApp =
    choose [
        POST >=> choose [
            path "/api/enigma/translate" >=> Helpers.mapJson Api.performTranslation
            path "/api/enigma/configure" >=> Helpers.mapJson Api.configureEnigma
        ]
        GET >=> choose [
            pathScan "/api/enigma/reflector/%d" (Api.getReflectorResponse >> optionallyWith OK)
            pathScan "/api/enigma/rotor/%d" (Api.getRotorResponse >> optionallyWith Helpers.toJson)
        ]
    ]

/// Routes for the Sudoku app.
let sudokuApp =
    POST >=> path "/api/sudoku/solve" >=> Helpers.mapJson Api.solve

/// Routes for non-application specific features.
let basicApp staticFileRoot =
    GET >=> choose [
        path "/throwAnException" >=> (fun _ -> failwith "Oh no! You've done something STUPID!"; async.Return None)
        path "/" >=> browseFile staticFileRoot "index.html"
        browse staticFileRoot ]

/// Routes through to 404.html
let pageNotFound staticFileRoot = browseFile staticFileRoot "404.html" >=> setStatus HttpCode.HTTP_404