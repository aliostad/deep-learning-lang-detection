open System
open Owin
open Microsoft.AspNet.SignalR
open Microsoft.Owin.StaticFiles
open Microsoft.Owin.Hosting
open ImpromptuInterface.FSharp

type Move() =
    inherit Hub()
    member this.Action(x: int, y: int) : unit =
        this.Clients.Others?shapemoved(x, y);

type ValueController() =
    inherit System.Web.Http.ApiController()
    member this.GetValues() =
        [| 1; 2; 3 |]

type Startup() =
    member x.Configuration(app: Owin.IAppBuilder) =
        let signalrConfig = new HubConfiguration()
        let webApiConfig = new System.Web.Http.HttpConfiguration();
        System.Web.Http.HttpRouteCollectionExtensions.MapHttpRoute(webApiConfig.Routes, "default", "{controller}") |> ignore

        app.UseStaticFiles("Web")
           .UseWebApi(webApiConfig)
           .MapSignalR(signalrConfig)
        |> ignore

[<EntryPoint>]
let main argv =
    let url = "http://localhost:5000/"
    use disposable = WebApp.Start<Startup>(url)
    Console.WriteLine("Server running on " + url)
    Console.WriteLine("Press Enter to stop.")
    Console.ReadLine() |> ignore
    0