namespace TodoWebApi

open System
open System.Net.Http
open System.Web
open System.Web.Http
open System.Web.Routing
open System.Net.Http.Formatting;

type HttpRoute = {
    controller : string
    action : string
    id : RouteParameter }

type Global() =
    inherit System.Web.HttpApplication() 

    static member RegisterWebApi(config: HttpConfiguration) =
        config.MapHttpAttributeRoutes()
        config.Routes.MapHttpRoute(
            "DefaultApi",
            "api/{controller}/{action}/{id}", 
            { controller = "{controller}"; action = "{action}"; id = RouteParameter.Optional }
        ) |> ignore

        config.Formatters.Clear();
        config.Formatters.Add(new JsonMediaTypeFormatter())
        config.Formatters.JsonFormatter.SerializerSettings.ContractResolver <- Newtonsoft.Json.Serialization.DefaultContractResolver()

    member x.Application_Start() =
        GlobalConfiguration.Configure(Action<_> Global.RegisterWebApi)
