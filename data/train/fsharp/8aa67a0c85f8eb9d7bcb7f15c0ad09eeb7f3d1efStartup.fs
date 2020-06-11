namespace WebApiRole

open Owin
open System.Net
open System.Net.Http
open System.Web.Http

type RouteOptions = { id: RouteParameter }

type Startup() =
    member x.Configuration(app: IAppBuilder) =
        // Host Web API
        let config = new HttpConfiguration()
        config.Routes.MapHttpRoute("Default", "{controller}/{id}", { id = RouteParameter.Optional }) |> ignore
        app.UseWebApi(config) |> ignore

        // Host a default handler
        app.UseHandlerAsync(StartupExtensions.OwinHandlerAsync(fun req res ->
            res.
                SetHeader("ContentType", "text/plain").
                WriteAsync("Hello, world!")
        )) |> ignore


type TestController() =
    inherit ApiController()
    member x.Get() =
        "Hello from OWIN!"
    member x.Get(id) =
        sprintf "Hello from OWIN, id %d" id
