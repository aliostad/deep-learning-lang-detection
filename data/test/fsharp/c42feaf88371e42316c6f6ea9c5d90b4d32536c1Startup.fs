module Startup

  open Owin
  open Microsoft.Owin
  open System.Web.Http

  type HomeController() =
    inherit ApiController()
    member x.Get() =
      "Hello"

  type ItemController() =
    inherit ApiController()
    member x.Get() =
      async {
        return ["Item1", "Item2"]
      } |> Async.StartAsTask

  type Config = {
    id : RouteParameter
  }

  type Startup() =
    member x.Configuration (app:IAppBuilder) =
      let config =
        let config = new HttpConfiguration()
        config.Routes.MapHttpRoute("DefaultApi", "api/{controller}/{id}", { id = RouteParameter.Optional }) |> ignore
        config

      app.UseWebApi config |> ignore

  [<assembly:OwinStartup(typeof<Startup>)>]
  do ()