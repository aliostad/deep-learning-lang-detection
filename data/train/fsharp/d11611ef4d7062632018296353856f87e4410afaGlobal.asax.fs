namespace WebApiHelloWorld

open System
open System.Net.Http
open System.Web
open System.Web.Http
open System.Net.Http.Headers
open System.Web.Routing

type HttpRoute = {
    controller : string
    id : RouteParameter }

type Global() =
    inherit System.Web.HttpApplication() 

    static member RegisterWebApi(config: HttpConfiguration) =
        // Configure routing
        config.MapHttpAttributeRoutes()
        config.Routes.MapHttpRoute(
            "DefaultApi", // Route name
            "api/{controller}/{id}", // URL with parameters
            { controller = "{controller}"; id = RouteParameter.Optional } // Parameter defaults
        ) |> ignore
        // Additional Web API settings
        config.Formatters.JsonFormatter.SupportedMediaTypes.Add(new MediaTypeHeaderValue("text/html") );

    member x.Application_Start() =
        GlobalConfiguration.Configure(Action<_> Global.RegisterWebApi)

    member x.Application_PostAuthorizeRequest() =
      System.Web.HttpContext.Current.SetSessionStateBehavior(System.Web.SessionState.SessionStateBehavior.Required)
