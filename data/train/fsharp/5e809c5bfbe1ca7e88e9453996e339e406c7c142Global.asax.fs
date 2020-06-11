namespace FSharpWebAPIExample

open System
open System.Net.Http
open System.Web
open System.Web.Http
open System.Web.Routing

type HttpRoute = {
    controller : string
    id : RouteParameter }

type Global() =
    inherit System.Web.HttpApplication() 

    static member RegisterWebApi(config: HttpConfiguration) =
        // Configure routing
        config.MapHttpAttributeRoutes()

        // Configure serialization
        config.Formatters.Remove(config.Formatters.XmlFormatter) |> ignore

        // Additional Web API settings

    member x.Application_Start() =
        GlobalConfiguration.Configure(Action<_> Global.RegisterWebApi)
