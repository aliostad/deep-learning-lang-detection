open Drunkcod.Data.ServiceBroker
open System
open System.Collections.Generic

let digits n = 
    let rec loop acc = function 0 -> acc | n -> loop (acc + 1) (n / 10)
    loop 1 (n / 10)

type QueueStats = { Name : string; Count : int }

type DisplayAgentMessage = 
    | Refresh
    | Update of QueueStats

[<EntryPoint>]
let main argv = 
    let displayAgent = MailboxProcessor.Start(fun inbox ->
        let queueStats = Dictionary()
        let displayStats() =
            let theQueues = 
                queueStats.Values
                |> Seq.toArray
                |> Array.sortBy (fun x -> x.Name)
    
            Console.Clear()
            if theQueues.Length <> 0 then
                let width = theQueues |> Seq.map (fun x -> x.Name.Length) |> Seq.max
                let maxDigits = digits(theQueues |> Seq.map (fun x -> x.Count) |> Seq.max)
                let rowFormat = String.Format("{{0,-{0}}}│ {{1,{1}}}", width, maxDigits)
                theQueues |> Seq.iter (fun x -> 
                    Console.WriteLine(rowFormat, x.Name, x.Count)
                )
                Console.WriteLine("{0}┘", String('─', width))
            else Console.Write("Waiting for data -")
            Console.WriteLine(" " + DateTime.Now.ToString())

        let rec loop() = async {
            let! msg = inbox.Receive()
            match msg with
            | Refresh -> displayStats()
            | Update(x) -> queueStats.[x.Name] <- x
            return! loop()
        }
        loop()
    )

    let monitorAgent = MailboxProcessor.Start(fun inbox ->
        let broker = SqlServerServiceBroker("Server=.;Integrated Security=SSPI;Initial Catalog=WorkWork");
        let rec loop() = async { 
            let! msg = inbox.Receive() 
            msg |> ignore
            broker.GetQueues()
            |> Seq.iter (fun q -> displayAgent.Post(Update({ Name = q.Name; Count = q.Peek() |> Seq.length })))
            return! loop()
        }
        loop()
    )

    use timer = new Timers.Timer(300.)
    timer.Elapsed.Add(fun _ -> 
        monitorAgent.Post(Refresh)
        displayAgent.Post(Refresh)
    )
    timer.AutoReset <- true
    displayAgent.Post(Refresh)
    timer.Enabled <- true

    Console.ReadKey()
    0 
