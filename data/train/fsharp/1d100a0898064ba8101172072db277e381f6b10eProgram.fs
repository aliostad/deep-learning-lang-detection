module Main

open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Hosting
open Microsoft.AspNetCore.Http

open Uhura.Web
open Uhura.Web.Routing
open Hopac
open System.Threading.Tasks
let helloWorldHandler groups (ctx : HttpContext) = job {
    do! ctx.Response.WriteAsync("Hello world") |> Job.awaitUnitTask
}

let helloNameHandler groups (ctx : HttpContext) = job {
    let name =  tryGetNamedParam groups "name" |> Option.get
    do! ctx.Response.WriteAsync(sprintf "Hello %s" name) |> Job.awaitUnitTask
}
 
let getUsers  groups (ctx : HttpContext)= job {
    let id = tryGetNamedParam groups "id" |> Option.get
    do! ctx.Response.WriteAsync(sprintf "Hello %s" id) |> Job.awaitUnitTask
}
let inline (>>+) f g x y = g (f x y)

let unitTaskToTask (t : Task<unit>) = t :> Task
let inline jobToTask f  =
    f  >>+ (startAsTask >> unitTaskToTask)

let routes =
    [
        GET "/" (jobToTask helloWorldHandler)
        GET "/what/do" (jobToTask helloWorldHandler)
        GET "/users/(?<id>\d{1,5})/do" (jobToTask getUsers)
        GET "/:name" (jobToTask helloNameHandler)
    ]
[<EntryPoint>]
let main argv =

    WebHostBuilder()
        .UseUrls("http://localhost:8080")
        .UseKestrel()
        .Configure(fun appBuilder -> openHailingFrequencies appBuilder routes)
        .Build()
        .Run()


    0 // return an integer exit code
