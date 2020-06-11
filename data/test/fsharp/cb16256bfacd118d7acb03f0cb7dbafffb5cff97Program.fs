namespace RiddleBot.RestApi

open System
open System.Threading
open RiddleBot.RestApi.Redis.Authentication
open RiddleBot.RestApi.Rest.ScoreWebPart
open RiddleBot.RestApi.Rest.QuestionWebPart
open Suave
open Suave.Authentication
open Suave.Operators
open Suave.Writers

module Program =

    [<EntryPoint>]
    let main argv = 
        printfn "Starting RiddleBot's REST API webservice..."

        let cts = new CancellationTokenSource()
        let cfg = { defaultConfig with cancellationToken = cts.Token }

        let auth f = authenticateBasic authenticateUser f
        let mimeJson = setMimeType "application/json; charset=utf-8"
        
        let restApi = auth (choose [scores; questions]) >=> mimeJson
        let listening, server = startWebServerAsync cfg restApi
        Async.Start(server, cts.Token)

        Console.ReadKey true |> ignore
    
        cts.Cancel()
        0 // Return with exit code success