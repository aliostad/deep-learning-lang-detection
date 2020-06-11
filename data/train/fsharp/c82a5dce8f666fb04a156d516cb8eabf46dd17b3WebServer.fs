module Cats.CommandHandler.WebServer

open Cats.CommandHandler
open Cats.CommandHandler.Domain
open Cats.CommandHandler.AppSettings

open Suave
open Suave.Http
open Suave.Http.Applicatives
open Suave.Types
open Suave.Web
open Suave.Extensions.ConfigDefaults
open Suave.Extensions.Guids
open Suave.Extensions.Json
open Logary //must be opened after Suave

open System
open System.IO

let swaggerSpec = Files.browseFileHome <| Path.Combine("static", "api-docs.json")

let index = Successful.OK "Hello from CATS Command Handler"

let webApp
    (commandToWebPart : Guid -> Command -> WebPart)
    (getAggregate: Guid -> Async<Cat option * int>)
    (saveEventToNewStream : Guid -> Event -> Async<unit>) =
  choose [
    GET >>= choose [
        url "/api-docs" >>= swaggerSpec
        url "/" >>= index
        (* This method is just a utility for debugging etc, the query handler provides a proper read model *)
        urlScanGuid "/cats/%s" (fun id -> AppService.DiagnosticQueries.getCat getAggregate id)]
        
    POST >>= choose [
        url "/cats/create" >>= tryMapJson (AppService.createCat saveEventToNewStream) ]
    PUT >>= choose [ 
        urlScanGuid "/cats/%s/title" (fun id -> tryMapJson <| AppService.setTitle commandToWebPart id) ]

    RequestErrors.NOT_FOUND "404 not found" ] 

[<EntryPoint>]
let main argv = 
    let web_config = makeConfig appSettings.Port (Suave.SuaveAdapter(Logging.logary.GetLogger "suave"))
    printfn "Starting CATS on %d" appSettings.Port

    try     
        let postCommand, getAggregate, saveEventToNewStream = AppService.getAppServices()
        let commandToWebPart = AppService.createCommandToWebPartMapper postCommand
        startWebServer web_config (webApp commandToWebPart getAggregate saveEventToNewStream)        
    with
    | e -> Logger.fatal (Logging.getCurrentLogger()) (e.ToString())

    Logging.logary.Dispose()
    0

