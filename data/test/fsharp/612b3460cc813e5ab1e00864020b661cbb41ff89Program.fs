// Learn more about F# at http://fsharp.org

module Server
open System
open Suave
open Suave.Filters
open Suave.Operators
open Suave.Successful
open Newtonsoft.Json
open Newtonsoft.Json.Serialization
open CommandHandler
open Commands
open Common
open Events
open Storage
open ReadModel
open EventProcessor
open System.Text

type TodoDTO = {
  Name: string 
  Id: string
}

let getBody req =
  req.rawForm |> Encoding.UTF8.GetString

let parseJSON json =
  JsonConvert.DeserializeObject<TodoDTO>(json)    

let createCommand request =
  let {Name=name} = request |> getBody |> parseJSON
  {id = System.Guid.NewGuid(); action = CreateTodo name }

let completeCommand request id =
  {id = System.Guid.Parse(id); action = CompleteTodo}

let changeNameCommand request id = 
  let {Name = name} = request |> getBody |> parseJSON
  {id = System.Guid.Parse(id); action = ChangeNameTodo name}

let deleteCommand request id=
  {id = System.Guid.Parse(id); action = DeleteTodo}

let serialize todo =
  JsonConvert.SerializeObject todo
  |> OK
  >=> Writers.setMimeType "application/json; charset=utf-8"

let serializeTodos todos = 
  JsonConvert.SerializeObject todos
  |> OK
  >=> Writers.setMimeType "application/json; charset=utf-8"

let createLogger =
  printfn "%s"

let createCommandHandler (log: Log) (eventStore: Storage.EventStore) =
  let getEvents id =
    eventStore.Get id

  let saveEvent id event =
    eventStore.Save (id, event)

  commandHandler log getEvents saveEvent

let createEventProcessor (log: Log) (eventStore: Storage.EventStore) (readModel:TodoReadModel) = 
  let getTodo id =
    readModel.Get id
    
  let saveTodo todo =
    readModel.Save todo

  let eventStream = eventStore.SaveEvent :> IObservable<Guid*DomainEvent>
  eventProcessor log eventStream getTodo saveTodo
  
let app =
    let logger = createLogger
    let readModel = TodoReadModel()
    let eventStore = Storage.EventStore()
    let handler = createCommandHandler logger eventStore  
    let eventProcessor = createEventProcessor logger eventStore readModel
    
    choose
      [ GET >=> choose
          [ path "/todos" >=> request( fun req -> readModel.GetAll |>  serializeTodos)]
        POST >=> choose
          [ path "/todos" >=> request(createCommand >> handler >> serialize)  
            pathScan "/todos/%s/completion" (fun (id) ->  request (fun req -> completeCommand req id |> handler  |> serialize))
            pathScan "/todos/%s/name" (fun (id) ->  request (fun req -> changeNameCommand req id |> handler |> serialize))
          ]
        DELETE >=> choose
          [
            pathScan "/todos/%s" (fun (id) ->  request (fun req -> deleteCommand req id |> handler |> serialize))
          ]
      ]

[<EntryPoint>]
let main argv =
  startWebServer defaultConfig app
  0

    

    