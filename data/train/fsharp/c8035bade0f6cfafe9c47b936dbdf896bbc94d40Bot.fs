namespace Rotix

open System
open System.Collections.Generic
open System.Collections.ObjectModel
open System.Reflection
open Mono.Reflection
open ChatExchangeDotNet

type Bot() =
    let mutable initd = false
    let mutable dispose = false
    let mutable chatClient : Client = null
    let mutable chatRooms = HashSet<Room * string>()
    let mutable chatHandlers = HashSet<ChatEventHandler>()
    let connector = EventRouter()

    let initChatClient (configs : Config[]) =
        let mutable success = false
        let mutable error : Exception = null
        configs
        |> Array.iter (fun config ->
            if not success then
                try
                    chatClient <- new Client(config.Email, config.Password)
                    success <- true
                with
                | _  as e -> error <- e
        )
        if not success then
            let rootMsg = "The specified configuration"
            match configs.Length with
            | 0 -> failwith "Da hell are ya passin me no configz m8?!" // Should never happen... he says.
            | 1 -> failwith <| rootMsg + " has failed. " + error.ToString()
            | _ -> failwith <| rootMsg + "s have all failed."

    let parseHandlers (handlers : ChatEventHandler[]) =
        let roomUrls = new HashSet<string * bool>()
        handlers
        |> Seq.iter (fun handler ->
            handler.SubscribedRoomUrls
            |> Seq.iter (fun url ->
                let loadUsersAsync =
                    handlers
                    |> Seq.filter (fun h ->
                        h.SubscribedRoomUrls
                        |> Seq.exists (fun u -> u = url)
                    )
                    |> Seq.exists (fun h ->
                        h.AccessesUserCollections()
                    )
                    |> not
                let room =
                    let joinRoom =
                        roomUrls
                        |> Seq.exists (fun x ->
                            chatRooms
                            |> Seq.exists (fun y ->
                                snd y = url && (snd x = true || snd x = loadUsersAsync)
                            )
                        )
                        |> not
                    if joinRoom then
                        let r = chatClient.JoinRoom(url, loadUsersAsync)
                        chatRooms.Add(r, url) |> ignore
                        roomUrls.Add(url, loadUsersAsync) |> ignore
                        r
                    else
                        fst (chatRooms |> Seq.find (fun kv -> snd kv = url))
                handler.SubscribedEvents
                |> Seq.iter (fun ev ->
                    connector.ConnectHandler room ev handler
                )
                chatHandlers.Add(handler) |> ignore
            )
        )

    member this.Start (handlers : ChatEventHandler[]) =
        if initd then
            failwith "This bot has already been started!"
        let defaultConfigs =
            [|
                ConfigFile("") :> Config
                ConfigEnvVar() :> Config
            |]
            |> Array.filter (fun i ->
                i.IsValid()
            )
        if defaultConfigs.Length = 0 then
            failwith "All default configurations have returned invalid data."
        initChatClient defaultConfigs
        parseHandlers handlers
        initd <- true

    member this.Start (config : Config, handlers : ChatEventHandler[]) =
        if initd then
            failwith "This bot has already been started!"
        if config.IsValid() |> not then
            failwith "Invalid configuration."
        initChatClient [| config |]
        parseHandlers handlers
        initd <- true

    member this.Start (configs : HashSet<Config>, handlers : ChatEventHandler[]) =
        if initd then
            failwith "This bot has already been started!"
        let validConfigs =
            configs
            |> Seq.filter (fun i ->
                i.IsValid()
            )
            |> Array.ofSeq
        if validConfigs.Length = 0 then
            failwith "The specified configurations have all returned invalid data."
        initChatClient validConfigs
        parseHandlers handlers
        initd <- true

    member this.Stop() =
        if not initd then
            failwith "This bot cannot be stopped, it hasn't been started!"
        chatRooms
        |> Seq.iter (fun (room, url) ->
            room.Leave()
            room.Dispose()
        )
        chatHandlers.Clear()
        chatRooms.Clear()
        chatClient.Dispose()
        initd <- false

    member this.Rooms
        with get() =
            List<Room>(
                chatRooms
                |> Seq.map(fun kv -> fst kv)
            )

    member this.EventHandlers
        with get() : HashSet<ChatEventHandler> = chatHandlers

    interface IDisposable with
        member this.Dispose() =
            if not dispose then
                dispose <- true
                chatClient.Dispose()
                GC.SuppressFinalize(this)