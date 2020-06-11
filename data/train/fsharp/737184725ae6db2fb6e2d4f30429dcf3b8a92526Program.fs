module Application

    open System
    open Akka.Actor
    open Akka.FSharp
    open ClientFactory

    let printInstuctions () =
        printfn "No new commands are implemented in the step 3. In fact you will have to remove previously implemented Connect and Disconnect commands,"
        printfn "so the actor will manage FTP connections internally, connect on demand and reconnect after being 10 seconds idle."
        printfn "Once the actor is property implemented the program should display the following messages:"
        printfn ""
        cprintfn ConsoleColor.Cyan "SSH.NET: Connecting..."
        cprintfn ConsoleColor.Green "SSH.NET: Connected."
        cprintfn ConsoleColor.Cyan "SSH.NET: Listing directory <directory name>..."
        cprintfn ConsoleColor.Green "SSH.NET: Directory <directory name> is listed."
        printfn "    Directory listing results"
        printfn "    pause for about 10 seconds"
        cprintfn ConsoleColor.Cyan "SSH.NET: Disconnecting..."
        cprintfn ConsoleColor.Green "SSH.NET: Disconnected."
        printfn ""

    let strategy () = 
        Strategy.OneForOne((fun ex ->
        match ex with 
        | :? System.IO.FileNotFoundException  -> Directive.Resume
        | :? NotSupportedException | :? NotImplementedException -> Directive.Stop
        | _ -> Directive.Restart), 3, TimeSpan.FromSeconds(10.))

    let run () =
        let clientFactory = createClientFactory()
        let system = System.create "system" <| Configuration.load ()
        let runner = spawnOpt system "runner" <| runnerActor <| [ SpawnOption.SupervisorStrategy(strategy ()) ]
        runner <! Run clientFactory

    [<EntryPoint>]
    let main argv = 

        printInstuctions ()
        waitForInput "Press any key to start the actor system and validate the implementation."

        run ()

        waitForInput ""
        0

