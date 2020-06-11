module Main


open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Hosting
open Microsoft.AspNetCore.Http
open Uhura.Web
open Uhura.Web.Routing
let helloWorldHandler groups (ctx : HttpContext) =
    ctx.Response.WriteAsync("Hello world from Uhura on Kestrel!") 

let routes =
    [
        GET "/" helloWorldHandler
    ]
[<EntryPoint>]
let main argv =
    WebHostBuilder()
        .UseUrls("http://localhost:8083")
        .UseKestrel()
        .Configure(fun appBuilder -> openHailingFrequencies appBuilder routes)
        .Build()
        .Run()


    0 // return an integer exit code
