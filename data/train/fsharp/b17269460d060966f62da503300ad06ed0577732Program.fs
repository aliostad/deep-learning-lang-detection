open System
open Akka.Actor
open Akka.FSharp
    
type Message = 
    | Increment
    | Decrement
    | GetState

let counter (mailbox: Actor<_>) =
    let rec processMessage currentState =
        actor {
            let! message = mailbox.Receive()
            return! match message with
                    | Increment -> processMessage (currentState + 1)
                    | Decrement -> processMessage (currentState - 1)
                    | GetState ->
                        mailbox.Sender() <! currentState

                        processMessage currentState
        }
    processMessage 0

[<EntryPoint>]
let main argv = 
    use system = ActorSystem.Create("my-system")
    let counter = spawn system "counter" counter

    counter <! Increment
    counter <! Increment
    counter <! Increment
    counter <! Increment

    counter <! Decrement
    counter <! Decrement

    async {
        let! currentCount = counter <? GetState

        printfn "The current count is %i" currentCount
    } |> Async.RunSynchronously

    Console.ReadKey() |> ignore
    0