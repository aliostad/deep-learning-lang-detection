module GameData

open Movement
open Notifications
open ExplorerState
open State
open Explorer

type Command<'t> = 
     | Turn of Cardinal.Direction
     | Move
     | Drink
     | External of 't

let act difficultyLevel (eventHandler:GameEvent->unit) command explorer =
    match command with
    | Turn direction -> if (explorer |> getExplorerState) = Alive then explorer |> turnAction eventHandler direction else explorer
    | Move           -> if (explorer |> getExplorerState) = Alive then explorer |> moveAction eventHandler else explorer
    | _              -> explorer

