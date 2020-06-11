module Application

    open System
    open Akka
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

    let run () =
        let clientFactory = createClientFactory()
        let system = System.create "system" <| Configuration.load ()
        let sftp = spawn system "sftp" <| sftpActor clientFactory

        let remoteUrl = Url "/"
        let result : SftpFileInfo list = (sftp <? ListDirectory remoteUrl |> Async.RunSynchronously)
        printfn ""
        match result with
        | [] -> printfn "The remote directory is empty"
        | xs -> xs |> Seq.iter (fun x -> 
            printfn "%s: %s" (x.IsDirectory |> function | true -> "Directory" | false -> "File") x.Name)

    [<EntryPoint>]
    let main argv = 

        printInstuctions ()
        waitForInput "Press any key to start the actor system and validate the implementation."

        run ()

        waitForInput ""
        0

