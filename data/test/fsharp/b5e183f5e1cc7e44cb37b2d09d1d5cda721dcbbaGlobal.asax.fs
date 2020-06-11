namespace Huxley

open System
open System.Net.Http
open System.Web
open System.Web.Http
open System.Web.Routing

open Huxley.Core.StorageManager
open Huxley.Core.Storage

type HttpRoute = {
    id : RouteParameter }

type Global() =
    inherit System.Web.HttpApplication() 

    //IO storage manager
    static let storageManager = new SimpleStorageManager(new MemoryStorage("Metadata"))

    static member RegisterWebApi(config: HttpConfiguration) =
        // Configure routing
        config.MapHttpAttributeRoutes()
        config.Routes.MapHttpRoute(
            "DefaultApi", // Route name
            "api/{controller}/{id}", // URL with parameters
            { id = RouteParameter.Optional } // Parameter defaults
        ) |> ignore

        // Configure serialization
        config.Formatters.XmlFormatter.UseXmlSerializer <- true
        config.Formatters.JsonFormatter.SerializerSettings.ContractResolver <- Newtonsoft.Json.Serialization.CamelCasePropertyNamesContractResolver()

        // Additional Web API settings

    static member StorageManager = storageManager

    member x.Application_Start() =
        GlobalConfiguration.Configure(Action<_> Global.RegisterWebApi)

