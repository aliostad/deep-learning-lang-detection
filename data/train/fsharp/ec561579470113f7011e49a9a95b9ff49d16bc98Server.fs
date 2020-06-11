module Server

open Akka.FSharp
open Messages
open System
open Plotting
open System.Drawing

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
let (<!!) (actor : Actor<_>) msg = actor.Sender() <! ResponseMessage msg
let writeImage token plotter = sprintf "C:/inetpub/wwwroot/%O.bmp" token |> plotter.Bitmap.Save

let turtleHandler (mbx : Actor<_>) = 
  let rec loop plotter = 
    actor { 
      let! msg = mbx.Receive()
      match extractRequest msg with
      | TurtleCommand(token, command) -> 
        let plotter = 
          match command with
          | Move x -> Plotting.move x plotter
          | Turn x -> Plotting.turn x plotter
          | Polygon(x, y) -> Plotting.polygon x y plotter
          | Color(r, g, b) -> { plotter with Color = Color.FromArgb(r |> int, g |> int, b |> int) }
        writeImage token plotter
        mbx <!! TurtleCommandExecuted
        return! loop plotter
      | _ -> unhandled msg
    }
  
  let plotter = 
    { Plotter.Bitmap = new Bitmap(800, 800)
      Position = 400, 400
      Color = Color.White
      Direction = 0. }
  
  loop plotter

let handler (actor : Actor<_>) msg = 
  match extractRequest msg with
  | Register -> 
    let token = Guid.NewGuid()
    turtleHandler
    |> spawn actor (token |> string)
    |> ignore
    actor <!! Registered token
  | Ping token -> actor <!! Pong token
  | TurtleCommand(token, _) | Ping token -> 
    token
    |> string
    |> actor.ActorSelection
    |> fun x -> 
      TimeSpan.FromSeconds 1.
      |> x.ResolveOne
      |> Async.AwaitTask
      |> Async.Catch
      |> Async.RunSynchronously
      |> function 
      | Choice1Of2 handler -> handler.Tell(msg, actor.Sender())
      | Choice2Of2 _ -> actor <!! UnknownToken token

let system = Configuration.parse config |> System.create "server"

let start() = 
  actorOf2 handler
  |> spawn system "server"
  |> ignore

let dispose = system.Dispose >> system.AwaitTermination
