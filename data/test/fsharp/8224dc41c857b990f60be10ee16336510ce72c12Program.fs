open System

open Uno.Domain
open CommandHandler
open Deck
open Game 
open EventHandler
open Uno.Persistence.InMemory.MemoryStore

[<EntryPoint>]
let main argv =
    printfn "Hello World from F#!"

    let eventHandler = EventHandler ()

    let store = create () |> subscribe eventHandler.Handle

    let handle = Game.create (readStream store) (appendToStream store)
    
    let gameId = GameId 1

    handle (StartGame { GameId = gameId; PlayerCount = 4; FirstCard = Digit(Three, Red)})
    handle (PlayCard { GameId = gameId; Player = 0; Card = Digit(Three, Blue) })
    handle (PlayCard { GameId = gameId; Player = 1; Card = Digit(Eight, Blue) })
    handle (PlayCard { GameId = gameId; Player = 2; Card = Digit(Eight, Yellow) })
    handle (PlayCard { GameId = gameId; Player = 3; Card = Digit(Four, Yellow) })
    handle (PlayCard { GameId = gameId; Player = 0; Card = Digit(Four, Green) })

    System.Console.ReadLine() |> ignore
    
    0
