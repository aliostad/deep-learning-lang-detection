open System
open Drunkcod.Data.ServiceBroker
open SimpleAgents

[<EntryPoint>]
let main argv = 
    let worker = MailboxProcessor.Start(fun inbox ->
        let rec loop() = async {
            let! msg = inbox.Receive() 
            match msg with 
            | Message(x) -> printf "%s\n" x
            
            return! loop()
        }
        loop())

    let broker = SqlServerServiceBroker("Server=.;Integrated Security=SSPI;Initial Catalog=WorkWork");
    let channel = broker.OpenChannel()

    let timeout = TimeSpan.FromMilliseconds(100.)
    let rec loop() = 
        channel.TryReceive((fun x -> worker.Post(x)), timeout) 
        |> ignore
        loop()
    loop()
    0