namespace Projector

open System
open System.Net.Http
open System.Web
open System.Web.Http
open System.Web.Routing
open Projector.Data

type HttpRoute = {
    controller : string
    id : RouteParameter }

type Global() =
    inherit System.Web.HttpApplication() 

    static member RegisterWebApi(config: HttpConfiguration) =
        config.MapHttpAttributeRoutes()
        config.Routes.MapHttpRoute(
            "DefaultApi",
            "api/{controller}/{id}",
            { controller = "{controller}"; id = RouteParameter.Optional }
        ) |> ignore

        config.Formatters.JsonFormatter.SerializerSettings.ContractResolver <- Newtonsoft.Json.Serialization.CamelCasePropertyNamesContractResolver()

    member x.Application_Start() =
        GlobalConfiguration.Configure(Action<_> Global.RegisterWebApi)
        DataConfiguration.ConfigureMappings()
