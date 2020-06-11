namespace OwinREST

open Owin
open System.Web.Http
open System.Net
open System.Net.Http
open Microsoft.Owin.Hosting

type __ = { id : RouteParameter }

type HelloController () =
    inherit ApiController () 
    member x.Get() =
        let res = x.Request.CreateResponse(HttpStatusCode.OK, "world")
        //res.Content.Headers.ContentLength <- System.Nullable 5L
        res

module Program =

    [<EntryPoint>]
    let main argv = 
        let config = new HttpConfiguration()
        config.Routes.MapHttpRoute("DefaultApi", "api/{controller}/{id}", { id = RouteParameter.Optional } ) |> ignore
        let options = new StartOptions("http://localhost:9000")
        use app = 
            WebApp.Start(options, fun ab -> 
                ab.UseWebApi(config) |> ignore
                ())

        System.Console.ReadLine() |> ignore
        0 // return an integer exit code

