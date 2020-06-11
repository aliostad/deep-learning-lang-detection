open System
open System.IO
open System.Threading
open Trevor

// TODO: Move the rest of this boiler plate stuff out
let handler req res =
    async { return "Hello world" }

let init =
    printfn "Trevor v0.1"

let start =
    TextResponder.startListener handler

let running (server:Listener.T<_>) =
    let prefixes = String.Join(", ", server.Listener.Prefixes)
    printfn "Listening on %s" (prefixes)

let stopping (server:Listener.T<_>) =
    printfn "Stopping server..."
    server.Listener.Stop()

[<EntryPoint>]
let main argv =
    let interrupt = new ManualResetEvent(false)

    // Setup a interrupt handler before we start the server or else it will hang
    let consoleHandler = ConsoleCancelEventHandler(fun _ _ -> exit 0)
    Console.CancelKeyPress.AddHandler consoleHandler

    init
    let server:Listener.T<_> = start
    
    // Swap out handler to now stop the server on an interrupt
    Console.CancelKeyPress.RemoveHandler consoleHandler
    Console.CancelKeyPress.Add (fun args ->
        args.Cancel <- true
        interrupt.Set() |> ignore
        exit 0)

    running server
    
    interrupt.WaitOne() |> ignore
    stopping server
    0
