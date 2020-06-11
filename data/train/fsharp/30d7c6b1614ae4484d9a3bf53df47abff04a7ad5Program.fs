module MAG.Server.Suave

open MAG
open MAG.Server
open MAG.Server.UI
open Chiron
open Suave
open Suave.Http
open Suave.Http.Applicatives
open Suave.Http.Successful
open Suave.Types
open Suave.Web
open Suave.Utils
open Suave.Sockets
open Suave.Http.Files
open System

let OKasync r : WebPart =
    fun (x : HttpContext) ->
        async {
            let! result = r
            return! OK result x
        }

let processAsync f : WebPart =
    fun (x : HttpContext) ->
        async {
            let! result = f (System.Text.Encoding.UTF8.GetString x.request.rawForm)
            return! OK result x
        }

let inline jsonify x =
    x |> Json.serialize |> Json.format

let api =
    choose [
        GET >>=
            choose [
                pathScan "/api/game/%s" <| fun gid -> OKasync (async { let! r = UI.getGame gid in return sprintf "%A" r })
                pathScan "/api/player/%s/%s" <| fun (name, gid) -> OKasync (async { let! v = (UI.getPlayerView (PlayerName name) gid) in return jsonify v } )
            ]
        POST >>=
            choose [
                path "/api/game" >>= processAsync postStartGame
                pathScan "/api/player/%s/%s/initiative" <| fun (name, gid) -> processAsync (postPlayInitiative gid name)
                pathScan "/api/player/%s/%s/attack" <| fun (name, gid) -> processAsync (postPlayAttack gid name)
                pathScan "/api/player/%s/%s/counter" <| fun (name, gid) -> processAsync (postCounter gid name)
                pathScan "/api/player/%s/%s/stance" <| fun (name, gid) -> processAsync (postMoveToStance gid name)
            ]
    ]

let ui =
    GET >>=
        choose [
            path "/" >>= OK (UI.gameCreate (MAG.Decks.Decks |> Map.toList |> List.map fst))
            pathScan "/play/%s/%s" <| fun (name, gid) -> OK (UI.playerViewHtml name gid)
            browseHome
        ]

let app =
    choose [
        api
        ui
        RequestErrors.NOT_FOUND "Not found"
    ]

let cts = new System.Threading.CancellationTokenSource()
let config = { defaultConfig with
                bindings = [HttpBinding.mk' HTTP "127.0.0.1" 8888]}

let listening, server = startWebServerAsync config app
Async.Start(server, cts.Token)

listening |> Async.RunSynchronously |> printfn "start stats: %A"

System.Console.ReadLine() |> ignore

cts.Cancel()