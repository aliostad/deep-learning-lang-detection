module Pluralsight.Fsharp.BookingApi.HttpApi.Infastructure

open System.Web.Http

type HttpRouteDefaults = { Controller : string; Id : obj }

let ConfigureRoutes(config : HttpConfiguration) = 
    GlobalConfiguration.Configuration.Routes.MapHttpRoute(
        "DefaultAPI",
        "{controller}/{id}",
        { Controller = "Home"; Id = RouteParameter.Optional }) |> ignore

let ConfigureFormatting (config: HttpConfiguration) = 
    config.Formatters.JsonFormatter.SerializerSettings.ContractResolver <-
        Newtonsoft.Json.Serialization.CamelCasePropertyNamesContractResolver()

let Configure config = 
    ConfigureRoutes config
    ConfigureFormatting config