namespace gasby.WebHost

open Owin
open Microsoft.Owin
open System
open System.Net.Http
open System.Web
open System.Web.Http
open System.Web.Http.Dispatcher
open System.Web.Http.Owin
open gasby.Api
open gasby.Api.InfraStructure

[<Sealed>]
type Startup() =

    static member RegisterWebApi(config: HttpConfiguration) =
        Configure config

    member __.Configuration(builder: IAppBuilder) =
        let config = new HttpConfiguration()
        Startup.RegisterWebApi(config)
        builder.UseWebApi(config) |> ignore

