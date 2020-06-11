module Program

open Suave
open Suave.Web
open Suave.WebSocket
open Suave.Successful
open Suave.RequestErrors
open Suave.Operators
open Suave.Filters
open Events
open CommandApi
open Projections
open InMemory
open System.Text
open Chessie.ErrorHandling
open JsonFormatter
open QueriesApi
open Suave.Sockets.Control

let eventsStream = new Control.Event<Event list>()

let project event =
  projectReadModel inMemoryActions event
  |> Async.RunSynchronously |> ignore

let projectEvents = List.iter project

let commandApiHandler eventStore (context : HttpContext) = async {
  let payload = Encoding.UTF8.GetString context.request.rawForm
  let! response = handleCommandRequest inMemoryQueries eventStore payload
  match response with
  | Ok ((state, events), _) ->
    do! eventStore.SaveEvents state events
    return! toStateJson state context
  | Bad (err) -> return! toErrorJson err.Head context
}

let commandApi eventStore =
  path "/command"
  >=> POST
  >=> commandApiHandler eventStore

let socketHandler (ws : WebSocket) context = socket {
  while true do
    let! events =
      Control.Async.AwaitEvent(eventsStream.Publish)
      |> Suave.Sockets.SocketOp.ofAsync
    for event in events do
      let eventData = event |> eventJObj |> string |> Encoding.UTF8.GetBytes
      do! ws.send Text eventData true
}

[<EntryPoint>]
let main argv = 
  let app =
    let eventStore = inMemoryEventStore ()
    choose [
      path "/websocket" >=> handShake socketHandler
      commandApi eventStore
      queriesApi inMemoryQueries eventStore
    ]
  let config = {defaultConfig with bindings = [HttpBinding.mkSimple HTTP "127.0.0.1" 8083]}
  startWebServer config app
  0 // return an integer exit code
