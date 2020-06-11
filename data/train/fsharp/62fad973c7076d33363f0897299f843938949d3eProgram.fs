open CommandHandler
open Game
open EventStore
open EventStore.ClientAPI
open EventStore.ClientAPI.SystemData
open System

[<EntryPoint>]
let main argv = 

    async {
        let settings =
            ConnectionSettings
                .Create()
                .SetDefaultUserCredentials(UserCredentials("admin", "changeit"))         
                .Build()

        let store = EventStore.ClientAPI.EventStoreConnection.Create(settings, Uri "tcp://localhost:1113")
        do! store.ConnectAsync() |> Async.AwaitTask
    
        let read = EventStore.read store
        let append = EventStore.append store
        let handler = CommandHandler.handler read append

        let startCommand = StartGame { Players = 3; FirstCard = Digit(Five, Blue) }
        let! result = handler "game-1" startCommand
        match result with
        | Ok (_) -> printfn "Ok"
        | Failure error -> printfn "%A" error 
    } |> Async.RunSynchronously

    async {
        let settings =
            ConnectionSettings
                .Create()
                .SetDefaultUserCredentials(UserCredentials("admin", "changeit"))         
                .Build()

        let store = EventStore.ClientAPI.EventStoreConnection.Create(settings, Uri "tcp://localhost:1113")
        do! store.ConnectAsync() |> Async.AwaitTask
    
        let read = EventStore.read store
        let append = EventStore.append store
        let game1 = game read append "Game-2"
        let! result = game1.PostAndAsyncReply (fun reply -> StartGame {Players=5; FirstCard=Digit(Five,Red)}, reply.Reply)
        match result with
        | Ok (_) -> printfn "Ok"
        | Failure error -> printfn "%A" error 
    } |> Async.RunSynchronously

    printfn "%A" argv
    0 // return an integer exit code
    // hello
