module Startup
open ControllerActivator
open Owin
open Microsoft.Owin
open System
open System.IO
open System.Threading.Tasks
open System.Web.Http
open System.Web.Http.Dispatcher

type RouteDefaults = {id : RouteParameter; version : RouteParameter}

type Startup (controllerActivator : ControllerActivator) =

    let ca = controllerActivator :> IHttpControllerActivator

    member this.Configuration(app : IAppBuilder) =
        let config = new HttpConfiguration()
        config.MapHttpAttributeRoutes()
        config.Routes.MapHttpRoute(
            "DefaultApi",
            "api/v1/{controller}/{id}",
            {id = RouteParameter.Optional; version = RouteParameter.Optional}) |> ignore
        config.Services.Replace(typeof<IHttpControllerActivator>, ca)
        app.UseWebApi(config) |> ignore
        ()