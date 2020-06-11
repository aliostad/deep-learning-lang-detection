namespace FlowerBed

open System
open System.Net.Http
open System.Web
open System.Web.Http
open System.Web.Routing
open Newtonsoft.Json

type HttpRoute = {
    controller : string
    action : RouteParameter
    id : RouteParameter }

type Global() =
    inherit System.Web.HttpApplication() 

    static member RegisterWebApi(config: HttpConfiguration) =
        // Configure routing
        config.MapHttpAttributeRoutes()
        config.Routes.MapHttpRoute(
            "DefaultApi", // Route name
            "api/{controller}/{action}/{id}", // URL with parameters
            { controller = "{controller}"; action = RouteParameter.Optional; id = RouteParameter.Optional } // Parameter defaults
        ) |> ignore

        // Configure serialization
        //config.Formatters.XmlFormatter.UseXmlSerializer <- true
        config.Formatters.JsonFormatter.SerializerSettings.ContractResolver <- Newtonsoft.Json.Serialization.CamelCasePropertyNamesContractResolver()

        // Additional Web API settings

    member x.Application_Start() =
        GlobalConfiguration.Configure(Action<_> Global.RegisterWebApi)
        
