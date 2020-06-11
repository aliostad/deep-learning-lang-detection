module StuffExchange.EventStore.Store

open System.Net

open Microsoft.FSharp.Reflection

open EventStore.ClientAPI
open EventStore.ClientAPI.SystemData
open Newtonsoft.Json

open StuffExchange.EventStore.AsyncExtensions

let userCredentials = new UserCredentials("admin", "changeit")

let connect() =
    let ipaddress = IPAddress.Parse("192.168.56.10")
    let endpoint = new IPEndPoint(ipaddress, 1113)
    let esSettings = 
        let s = 
            ConnectionSettings.Create()
                .UseConsoleLogger()
                .SetDefaultUserCredentials(userCredentials)
                .Build()
        s

    let connection = EventStoreConnection.Create(esSettings, endpoint, null)
    connection.AsyncConnect() |> Async.RunSynchronously
    connection

let settings = 
    let settings = new JsonSerializerSettings()
    settings.TypeNameHandling <- TypeNameHandling.Auto
    settings

let serialize (event:'a)= 
    let serializedEvent = JsonConvert.SerializeObject(event, settings)
    let data = System.Text.Encoding.UTF8.GetBytes(serializedEvent)
    let case,_ = FSharpValue.GetUnionFields(event, typeof<'a>)
    EventData(System.Guid.NewGuid(), case.Name, true, data, null)

let deserialize<'a> (event: ResolvedEvent) =
    let serializedString = System.Text.Encoding.UTF8.GetString(event.Event.Data)
    let domainEvent = JsonConvert.DeserializeObject<'a>(serializedString, settings)
    domainEvent

let readStream streamId =
    use store = connect()
    let slice = store.AsyncReadStreamEventsForward streamId false |> Async.RunSynchronously
    let events : List<'a> = 
        slice.Events
        |> Seq.map deserialize<'a>
        |> Seq.cast 
        |> Seq.toList
    events 

let appendToStream streamId event =
    // TODO: Catch exceptions thrown by AsyncAppendToStream
    use store = connect()
    let events = [|event|]
    
    events 
    |> Array.map serialize
    |> store.AsyncAppendToStream streamId ExpectedVersion.Any
    |> Async.RunSynchronously
    |> ignore

    event


let subscribeToStream streamId eventHandler =
    let store = connect()

    let eventHandlerHelper (event: ResolvedEvent) =
        event 
        |> deserialize<'a>
        |> eventHandler

    let eventHandlerAction =
        System.Action<EventStoreSubscription, ResolvedEvent>(fun sub event ->
            eventHandlerHelper event)

    store.SubscribeToStreamAsync(streamId, true, eventHandlerAction, userCredentials = userCredentials)
    |> Async.AwaitTask
    |> Async.RunSynchronously
    |> ignore
