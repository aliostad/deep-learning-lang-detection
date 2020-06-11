module WebServer
open Suave
open Suave.Sockets
open Suave.Sockets.Control
open Suave.WebSocket
open Suave.Operators
open Suave.Filters
open System
open System.Net
open System.IO
open WebApplication
open Api
open Config


[<EntryPoint>]
let main [| port |] =
    
    let config =
        { defaultConfig with
                bindings = [ HttpBinding.mk HTTP IPAddress.Loopback (uint16 port) ]
                listenTimeout = TimeSpan.FromMilliseconds 3000.
                homeFolder = Some Home
                }

    let webApi = WebApi config
    let webApp = WebApp config
    
    let app =
        request (fun r -> 
                choose[
                    Filters.pathStarts "/api" >=> (webApi ())
                    Filters.GET >=> webApp
                ]
            ) 

    // let app : WebPart =
        
    //     choose [
    //         Filters.GET >=> choose [ 
    //                 Filters.path "/" >=> webApp
    //                 Filters.path "/api/" >=> api]
    //         RequestErrors.NOT_FOUND localHome
    //         ]
    startWebServer config app
    0 // return an integer exit code