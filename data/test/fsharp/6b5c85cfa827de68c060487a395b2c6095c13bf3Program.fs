namespace TypedRouting

open System
open System.Threading.Tasks

open Microsoft.Owin
open Microsoft.Owin.Hosting

open Owin

module FSharpOwin =
    let mapAsyncHandler (handler : IOwinContext -> (unit -> Async<unit>) -> Async<unit>) (context : IOwinContext) (next : unit -> Task) : Task =
        let asyncNext () =
            Async.AwaitIAsyncResult(next())
            |> Async.Ignore
        let taskHandler =
            handler context asyncNext
            |> Async.StartAsTask
        taskHandler :> Task

    let buildHandler handler =
        let taskHandler : IOwinContext -> (unit -> Task) -> Task =  mapAsyncHandler handler
        Func<IOwinContext, Func<Task>, Task>(fun context next ->
            taskHandler context (fun () -> next.Invoke()))

    let useHandler (handler : IOwinContext -> (unit -> Async<unit>) -> Async<unit>) (app : IAppBuilder) =
        let taskHandler : IOwinContext -> (unit -> Task) -> Task =  mapAsyncHandler handler
        let taskFuncHandler = Func<IOwinContext, Func<Task>, Task>(fun context next ->
            taskHandler context (fun () -> next.Invoke()))
        AppBuilderUseExtensions.Use(app, taskFuncHandler)

type Startup () =
    member x.Configuration app =
        app
        |> FSharpOwin.useHandler (TypedRouting.DocumentApi.buildOwinHandler())
        |> ignore

module Program =
    [<EntryPoint>]
    let Main(args) = 
        use app = WebApp.Start<Startup>("http://localhost:5000/")
        System.Console.Read() |> ignore
        0
