namespace FSharpMVC2.Core

open System
open System.IO
open System.Web
open System.Web.Routing
open System.Reflection
open Newtonsoft.Json
open Microsoft.FSharp.Reflection
open Strangelights.PicoMvc

type Global() =
    inherit System.Web.HttpApplication() 

    static member RegisterRoutes(routes:RouteCollection) =
        let routingTables = RoutingTable.LoadFromCurrentAssemblies()
        let routingTables = routingTables.AddStaticHandler(("get","/"), (fun () -> Result "hello"))
        let actions =
            { TreatModuleParameterActions = []
              TreatHandlerParameterActions = [ ParamaterActions.defaultParameterAction; ParamaterActions.contextParameterAction; NewtonsoftJson.defaultJsonRecordParameterAction ]
              TreatResultActions = [ Spark.defaultSparkResultAction; Phalanger.defaultPhalangerResultAction; NewtonsoftJson.defaultJsonResultAction ] }
        routes.Add(new Route("{*url}", new PicoMvcRouteHandler("url", routingTables, actions)))

    member x.Start() =
        log4net.Config.XmlConfigurator.Configure()
        Global.RegisterRoutes(RouteTable.Routes)
