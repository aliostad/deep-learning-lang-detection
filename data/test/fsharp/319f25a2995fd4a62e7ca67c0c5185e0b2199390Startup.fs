module Startup

open Common
open Logging
open LogHttpMiddleware
open LogExceptionHandler
open Owin
open System.Web.Http
open System.Web.Http.ExceptionHandling

type Startup() =
  member __.Configuration (appBuilder: IAppBuilder) =
    Logging.initialize()

    appBuilder.Use LogHttpMiddleware |> ignore

    let config =
      new HttpConfiguration()
      |> Logging.configure
      |> Cors.configure
      |> Routes.configure
      |> Serialization.configure

    config.Services.Replace(typedefof<IExceptionHandler>, new LogExceptionHandler())

    appBuilder.UseWebApi(config) |> ignore
