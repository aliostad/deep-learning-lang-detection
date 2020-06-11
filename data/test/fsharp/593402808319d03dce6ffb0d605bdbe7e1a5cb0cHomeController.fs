namespace ActionableWebApi

open System
open System.Net
open System.Net.Http
open System.Net.Http.Formatting
//open Microsoft.AspNet.WebApi.Client
open System.Web.Http


type HomeRendition () =
    [<DefaultValue>] val mutable Message : string
    [<DefaultValue>] val mutable Time : string

type HomeController() =
    inherit ApiController()
    member this.Get() =
        this.Request.CreateResponse(
            HttpStatusCode.OK,
            HomeRendition(
                Message = "Hello from F#",
                Time = DateTimeOffset.Now.ToString("o")))
