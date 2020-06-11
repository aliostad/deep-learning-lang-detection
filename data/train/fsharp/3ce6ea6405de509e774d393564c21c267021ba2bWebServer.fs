module Cats.QueryHandler.WebServer

open Cats.QueryHandler
open Cats.QueryHandler.AppSettings

open Suave
open Suave.Http
open Suave.Http.Applicatives
open Suave.Types
open Suave.Web
open Suave.Extensions.ConfigDefaults
open Suave.Extensions.Guids
open Suave.Extensions.Json

open Logary

open System
open System.IO

let swaggerSpec = Files.browseFileHome <| Path.Combine("static", "api-docs.json")

let index = Successful.OK "Hello from CATS Query Handler"

let webApp =
  choose [
    GET >>= choose [
        url "/api-docs" >>= swaggerSpec
        urlScanGuid "/cats/%s" (fun id -> AppService.getCat id)
        url "/" >>= index ]

    RequestErrors.NOT_FOUND "404 not found" ] 

[<EntryPoint>]
let main argv = 
    let web_config = makeConfig appSettings.Port (Suave.SuaveAdapter(Logging.logary.GetLogger "suave"))
    printfn "Starting CATS on %d" appSettings.Port

    try
        startWebServer web_config webApp    
    with
    | e -> Logger.fatal (Logging.getCurrentLogger()) (e.ToString())

    Logging.logary.Dispose()
    0

