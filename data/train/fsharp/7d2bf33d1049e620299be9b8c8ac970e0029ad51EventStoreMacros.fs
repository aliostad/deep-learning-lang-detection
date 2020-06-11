namespace Macros
open Microsoft.FSharp.Core
module EventStore =
    module AgentHelper = 
        type Agent<'T> = MailboxProcessor<'T>  
        let post (agent:Agent<'T>) message = agent.Post message  
        let postAsyncReply (agent:Agent<'T>) messageConstr = agent.PostAndAsyncReply(messageConstr)
    open AgentHelper
    
    type StreamId = StreamId of int
    
    type StreamVersion = StreamVersion of int
    type SaveResult = | Saved | VersionConflict
    
    type Messages<'T> = 
        | GetVersion of StreamId * AsyncReplyChannel<StreamVersion>
        | GetEvents of StreamId * AsyncReplyChannel<'T list option>
        | SaveEvents of StreamId * StreamVersion * 'T list * AsyncReplyChannel<SaveResult>
        | AddSubscriber of string * (StreamId * 'T list -> unit)
        | RemoveSubscriber of string
   
    type internal EventStoreState<'TEvent,'THandler> =  
        {
            EventHandler: 'THandler
            GetVersion: 'THandler -> StreamId -> (StreamVersion *'THandler)
            GetEvents: 'THandler -> StreamId -> ('TEvent list option * 'THandler) 
            SaveEvents: 'THandler -> StreamId -> StreamVersion -> 'TEvent list -> (SaveResult * 'THandler)
            Subscribers: Map<string, (StreamId * 'TEvent list -> unit)>
        }

    let eventStoreAgent<'T, 'TEventHandler> (eventHandler:'TEventHandler) getVersion getEvents saveEvents (inbox:Agent<Messages<'T>>) = 
        let initState = 
            {
                EventHandler = eventHandler
                Subscribers = Map.empty
                GetEvents = getEvents
                GetVersion = getVersion
                SaveEvents = saveEvents
            }
        let rec loop state = 
            async {
                let! msg = inbox.Receive()
                match msg with
                | GetVersion (id,replyChannel) ->
                    let (version,newHandler) = state.GetVersion state.EventHandler id
                    replyChannel.Reply(version)
                    return! loop {state with EventHandler = newHandler}
                | GetEvents (id, replyChannel) ->
                    let (events, newHandler) = state.GetEvents state.EventHandler id
                    replyChannel.Reply(events)
                    return! loop {state with EventHandler = newHandler}
                | SaveEvents (id, expectedVersion, events, replyChannel) ->
                    let (result, newHandler) = state.SaveEvents state.EventHandler id expectedVersion events
                    if result = Saved then state.Subscribers |> Map.iter (fun _ sub -> sub(id, events)) else ()
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
    
    let createEventStoreAgent<'TEvent, 'TEventHandler> eventHandler getVersion getEvents saveEvents = 
        Agent.Start(eventStoreAgent<'TEvent, 'TEventHandler> eventHandler getVersion getEvents saveEvents)
    
    type EventStore<'TEvent, 'TError> = 
        {
            GetEvents: StreamId -> Choice<StreamVersion*'TEvent list, 'TError>
            GetVersion: StreamId -> StreamVersion
            SaveEvents: StreamId -> StreamVersion -> 'TEvent list -> Choice<'TEvent list, 'TError>
            AddSubscriber: string -> (StreamId * 'TEvent list -> unit) -> unit
            RemoveSubscriber: string -> unit
        }
    
    let createEventStore<'TEvent, 'TError> (versionError:'TError) agent =
        let getEvents streamId : Choice<StreamVersion*'TEvent list, 'TError> = 
            let result = (fun r -> GetEvents (streamId, r)) |> postAsyncReply agent |> Async.RunSynchronously
            match result with
            | Some events -> (StreamVersion (events |> List.length), events) |> Choice1Of2
            | None -> (StreamVersion 0, []) |> Choice1Of2
    
        let saveEvents streamId expectedVersion events : Choice<'TEvent list, 'TError> = 
            let result = (fun r -> SaveEvents(streamId, expectedVersion, events, r)) |> postAsyncReply agent |> Async.RunSynchronously
            match result with
            | Saved -> events |> Choice1Of2
            | VersionConflict -> versionError |> Choice2Of2
    
        let addSubscriber subId subscriber = 
            (subId,subscriber) |> AddSubscriber |> post agent
    
        let removeSubscriber subId = 
            subId |> RemoveSubscriber |> post agent
        let getVersion streamId : StreamVersion = 
            let result = (fun r -> GetVersion(streamId,r)) |> postAsyncReply agent |> Async.RunSynchronously
            result

        { GetEvents = getEvents; SaveEvents = saveEvents; AddSubscriber = addSubscriber; RemoveSubscriber = removeSubscriber; GetVersion = getVersion}
    
    
    let createInMemoryEventStore<'TEvent, 'TError> (versionError:'TError) =
        let initState : Map<StreamId, 'TEvent list> = Map.empty
    
        let saveEventsInMap map id expectedVersion events = 
            match map |> Map.tryFind id with
            | None -> 
                (Saved, map |> Map.add id events)
            | Some existingEvents ->
                let currentVersion = existingEvents |> List.length |> StreamVersion
                match currentVersion = expectedVersion with
                | true -> 
                    (Saved, map |> Map.add id (existingEvents@events))
                | false -> 
                    (VersionConflict, map)
    
        let getEventsInMap map id = Map.tryFind id map, map
        let getVersion map id = Map.tryFind id map |> Option.map List.length |> Option.getOrDefault 0 |> StreamVersion, map
        let agent = createEventStoreAgent initState getVersion getEventsInMap saveEventsInMap
        createEventStore<'TEvent, 'TError> versionError agent
