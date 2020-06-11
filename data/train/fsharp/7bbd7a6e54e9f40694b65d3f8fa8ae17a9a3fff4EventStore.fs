namespace Castos

open System
open System.Net
open System.IO

open EventStore.ClientAPI
open EventStore.ClientAPI.Embedded


[<AutoOpen>]
module EventStore =
    open System.Reflection

    type StreamId = StreamId of string
    type StreamVersion = StreamVersion of int

    type SaveResult =
        | Ok
        | VersionConflict

    type Messages<'T> =
        | GetEvents of StreamId * AsyncReplyChannel<'T list option>
        | SaveEvents of StreamId * StreamVersion * 'T list * AsyncReplyChannel<SaveResult>
        | AddSubscriber of string * (StreamId * 'T list -> unit)
        | RemoveSubscriber of string

    type internal EventStoreState<'TEvent,'THandler> =
        {
            EventHandler: 'THandler
            GetEvents: 'THandler -> StreamId -> ('TEvent list option * 'THandler)
            SaveEvents: 'THandler -> StreamId -> StreamVersion -> 'TEvent list -> (SaveResult * 'THandler)
            Subscribers: Map<string, (StreamId * 'TEvent list -> unit)>
        }

    let post (agent:MailboxProcessor<'T>) message = agent.Post message
    let postAsyncReply (agent:MailboxProcessor<'T>) messageConstr = agent.PostAndAsyncReply(messageConstr)

    let eventStoreAgent<'T, 'TEventHandler> (eventHandler:'TEventHandler) getEvents saveEvents (inbox:MailboxProcessor<Messages<'T>>) =
        let initState =
            {
                EventHandler = eventHandler
                Subscribers = Map.empty
                GetEvents = getEvents
                SaveEvents = saveEvents
            }
        let rec loop state =
            async {
                let! msg = inbox.Receive()
                match msg with
                | GetEvents (id, replyChannel) ->
                    let (events, newHandler) = state.GetEvents state.EventHandler id
                    replyChannel.Reply(events)
                    return! loop {state with EventHandler = newHandler}
                | SaveEvents (id, expectedVersion, events, replyChannel) ->
                    let (result, newHandler) = state.SaveEvents state.EventHandler id expectedVersion events
                    if result = Ok then state.Subscribers |> Map.iter (fun _ sub -> sub(id, events)) else ()
                    replyChannel.Reply(result)
                    return! loop {state with EventHandler = newHandler}
                | AddSubscriber (subId, subFunction) ->
                    let newState = {state with Subscribers = (state.Subscribers |> Map.add subId subFunction)}
                    return! loop newState
                | RemoveSubscriber subId ->
                    let newState = {state with Subscribers = (state.Subscribers |> Map.remove subId )}
                    return! loop newState
            }
        loop initState

    let createEventStoreAgent<'TEvent, 'TEventHandler> eventHandler getEvents saveEvents =
        MailboxProcessor.Start(eventStoreAgent<'TEvent, 'TEventHandler> eventHandler getEvents saveEvents)

    type EventStore<'TEvent, 'TError> =
        {
            GetEvents: StreamId -> Result<StreamVersion*'TEvent list, 'TError>
            SaveEvents: StreamId -> StreamVersion -> 'TEvent list -> Result<'TEvent list, 'TError>
            AddSubscriber: string -> (StreamId * 'TEvent list -> unit) -> unit
            RemoveSubscriber: string -> unit
        }

    let createEventStore<'TEvent, 'TError> (versionError:'TError) agent =
        let getEvents streamId : Result<StreamVersion*'TEvent list, 'TError> =
            let result = (fun r -> GetEvents (streamId, r)) |> postAsyncReply agent |> Async.RunSynchronously
            match result with
            | Some events -> (StreamVersion (events |> List.length), events) |> ok
            | None -> (StreamVersion 0, []) |> ok

        let saveEvents streamId expectedVersion events : Result<'TEvent list, 'TError> =
            let result = (fun r -> SaveEvents(streamId, expectedVersion, events, r)) |> postAsyncReply agent |> Async.RunSynchronously
            match result with
            | Ok -> events |> ok
            | VersionConflict -> versionError |> fail

        let addSubscriber subId subscriber =
            (subId,subscriber) |> AddSubscriber |> post agent

        let removeSubscriber subId =
            subId |> RemoveSubscriber |> post agent

        { GetEvents = getEvents; SaveEvents = saveEvents; AddSubscriber = addSubscriber; RemoveSubscriber = removeSubscriber}


    let createInMemoryEventStore<'TEvent, 'TError> (versionError:'TError) =
        let initState : Map<StreamId, 'TEvent list> = Map.empty

        let saveEventsInMap map id expectedVersion events =
            match map |> Map.tryFind id with
            | None ->
                (Ok, map |> Map.add id events)
            | Some existingEvents ->
                let currentVersion = existingEvents |> List.length |> StreamVersion
                match currentVersion = expectedVersion with
                | true ->
                    (Ok, map |> Map.add id (existingEvents@events))
                | false ->
                    (VersionConflict, map)

        let getEventsInMap map id = Map.tryFind id map, map

        let agent = createEventStoreAgent initState getEventsInMap saveEventsInMap
        createEventStore<'TEvent, 'TError> versionError agent


    let createGetEventStoreEventStore<'TEvent, 'TError> (versionError:'TError) =
        let decontructStreamVersion = function | StreamVersion i -> int64(i)
        let decontructStreamId = function | StreamId s -> s

        let createStore() = async {
            let path = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData)
            let nodeBuilder = EmbeddedVNodeBuilder
                                                .AsSingleNode()
                                                .OnDefaultEndpoints()
                                                .RunOnDisk(Path.Combine(path, "castos", "data"))
            let node = nodeBuilder.Build();
            node.Start()

            use store = EmbeddedEventStoreConnection.Create(node)
            do! store.ConnectAsync()

            return store
        }

        let store = createStore() |> Async.RunSynchronously

        let saveEvents (store:IEventStoreConnection) streamId expectedVersion events =
            let createEventData (event:'TEvent) =
                let eventType = event.GetType().ToString()
                let json = mkjson event
                let metadata = null
                EventData(Guid.NewGuid(), eventType, true, Text.Encoding.UTF8.GetBytes(json), metadata)

            let appendToStream id version eventData = async {
                let! a = store.AppendToStreamAsync(id, version, eventData)
                return a
            }

            let id = decontructStreamId streamId
            let anyVersion = ExpectedVersion.Any
            let eventData = List.map createEventData events
            let version = decontructStreamVersion expectedVersion
            let result =  appendToStream id (int64 anyVersion) (Array.ofList eventData) |> Async.RunSynchronously //TODO: avoid AnyVersion
            (Ok, store)

        let getEvents (store:IEventStoreConnection) streamId = //TODO: Tail recursion
            let rec readStreamEvents (store:IEventStoreConnection) streamId start count =
                let readStreamEventsForward (store:IEventStoreConnection) streamId start count = async{
                    let! a = store.ReadStreamEventsForwardAsync(streamId, start, count, false)
                    return a
                }
                let slice = readStreamEventsForward store streamId start count |> Async.RunSynchronously
                match slice.IsEndOfStream with
                | false -> List.ofArray slice.Events @ readStreamEvents store streamId slice.NextEventNumber count
                | true -> List.ofArray slice.Events

            let id = decontructStreamId streamId
            let events = readStreamEvents store id (int64 0) 200
                         |> List.map (fun ev ->
                                            let json = (Text.Encoding.UTF8.GetString ev.Event.Data)
                                            let evType = Type.GetType(ev.Event.EventType)
                                            unjson json)
            (Some events, store)

        let agent = createEventStoreAgent store getEvents saveEvents
        createEventStore<'TEvent, 'TError> versionError agent
