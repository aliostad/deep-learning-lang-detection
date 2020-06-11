module FsAkkaTemplate

open Akka.FSharp

type ProcessorMessage = ProcessJob of int * int * int

let processor (mailbox: Actor<_>) = 
    let rec loop () = actor {
        let! ProcessJob(x,y,z) = mailbox.Receive ()
        printfn "Processor: received ProcessJob %i %i %i" x y z
        return! loop ()
    }
    loop ()

let config = Configuration.parse(@"akka {
  actor {
    serializers {
      wire = ""Akka.Serialization.HyperionSerializer, Akka.Serialization.Hyperion""
    }
    serialization-bindings {
      ""System.Object"" = wire
    }
  }
}")

[<EntryPoint>]
let main argv =

    let system = System.create "mysys" config
    let processorRef = spawn system "processor" processor

    processorRef <! ProcessJob(1, 3, 5)

    Async.Sleep 1000
    |> Async.RunSynchronously

    0
