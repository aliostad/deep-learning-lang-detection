module FunctionalGame.Main

open System
open System.Threading
open System.Diagnostics
open FunctionalGame.SharedGame
    

type Game = {
    State: Game.State;
    ClientState: ClientGame.State;
    LastTickTime: int64;
    NextTickTime: int64;
    NextRenderTickTime: int64;
    EventQueue: Event list;
}

let Process tickTime (game: Game) =
    let state = game.State |> Game.Tick tickTime
      
    ({ 
        game with 
            State = state; 
            LastTickTime = tickTime; 
            NextTickTime = tickTime + int64 game.State.Rate;
            EventQueue = game.EventQueue @ state.EventQueue;
            NextRenderTickTime = tickTime + int64 game.ClientState.Rate;
    }, true)


let ProcessClient tickTime (game: Game) =
    match tickTime >= game.NextRenderTickTime with
    | false -> (game, true)
    | _ ->
    let state = 
        game.ClientState 
        |> ClientGame.ProcessEvents game.EventQueue 
        |> ClientGame.Tick (float32 (tickTime - game.LastTickTime) / game.State.Rate)
 
    ({ 
        game with
            ClientState = state;
            NextRenderTickTime = game.NextRenderTickTime + int64 game.ClientState.Rate; 
            EventQueue = [];
    }, true)
    

[<EntryPoint>]
let main args =    
    Tools.TimeLoop {
            State = Game.Init ();
            ClientState = ClientGame.Init ();
            LastTickTime = int64 0;
            NextTickTime = int64 0;
            NextRenderTickTime = int64 0;
            EventQueue = list.Empty;
        }
        
        (fun (game, time) ->
            match not (ClientGame.ShouldClose game.ClientState)  with
            | false -> (game, false)
            | _ ->
            let tickTime = time.ElapsedMilliseconds
            
            match tickTime >= game.NextTickTime with
            | false -> ProcessClient tickTime game
            | _ -> Process tickTime game
    )
    0

