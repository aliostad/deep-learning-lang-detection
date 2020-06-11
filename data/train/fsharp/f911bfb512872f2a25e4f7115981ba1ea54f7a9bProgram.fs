open Akka
open Akka.FSharp
open Akka.Actor
open System

type ProcessorMessage = ProcessJob of int * int * int

let processor (mailbox: Actor<_>) =
    let rec loop () = actor {
        let! ProcessJob(x,y,z) = mailbox.Receive ()
        printfn "Processor: received ProcessJox %i %i %i" x y z
        return! loop ()
    }
    loop ()


[<EntryPoint>]
let main argv = 
//    let system = ActorSystem.Create "fsharp-system"
//    let greeter = system.ActorOf<GreetingActor> "greeter"
    let system = System.create "system" <| Configuration.load ()
    let processorRef = spawn system "processor" processor
    processorRef <! ProcessJob (1, 3, 5)

    printfn "Press <RET>"
    Console.ReadLine () |> ignore
    0 // return an integer exit code
