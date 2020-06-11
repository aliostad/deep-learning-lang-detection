module Server

open Akka.FSharp
open Messages

let config = """
    akka {
      actor {
        provider = "Akka.Remote.RemoteActorRefProvider, Akka.Remote"
        serialization-bindings { "System.Object" = wire }
        }
      remote {
        helios.tcp {
          port = 8001 
          hostname = localhost
        }
      }
    }
    """

let handler (actor : Actor<_>) msg = 
  match msg with
  | Ping -> Pong
  | Pong -> Ping
  |> (<!) (actor.Sender())

let system = Configuration.parse config |> System.create "server"

let start() = 
  actorOf2 handler
  |> spawn system "server"
  |> ignore

let dispose = system.Dispose >> system.AwaitTermination
