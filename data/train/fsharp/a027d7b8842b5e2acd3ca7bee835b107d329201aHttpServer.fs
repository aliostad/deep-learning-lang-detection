namespace Averruncus.Services

open Owin
open Microsoft.Owin;
open System
open Unchecked
open Averruncus
open Averruncus.Http

type HttpServer() =
    member this.Configuration(app: IAppBuilder) =
        app.RunServices(
            [
                Http.Service.fmap(<@ fun() -> seq { 0..1 } |> Seq.map(fun x -> Guid.NewGuid()) @>) { 
                    Method = "GET"
                    ContentType = contentType "application/json"
                    Url = "/api/flight"
                }
//                Http.Service.fmap(<@ fun(id: Guid) -> id @>) {
//                    Method = "GET"
//                    ContentType = contentType "application/json"
//                    Url = "/api/flight/{id}"
//                }
//                Http.Service.fmap(<@ fun(id: Guid) -> () @>) { 
//                    Method = "POST"
//                    ContentType = contentType "application/json"
//                    Url = "/api/flight"
//                }
//                Http.Service.fmap(<@ fun(id: Guid) -> () @>) { 
//                    Method = "DELETE"
//                    ContentType = contentType "application/json"
//                    Url = "/api/flight/{id}"
//                }
            ]
        )


