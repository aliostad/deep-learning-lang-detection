module Engine.GameLoop
open System

type Delta = float
// Key stuff is a little browser specific. Maybe this should be in Window? Although then gameLoop depends on window...
type KeyCode = float

type KeyboardEvent = {
    key: KeyCode
}

type Event =
| Tick of float
| KeyDown of KeyboardEvent
| KeyUp of KeyboardEvent

type Update<'Game> = 'Game -> Event -> 'Game
type Render<'Game> = 'Game -> unit
type EventHandler<'Game> = Event -> 'Game

let createGameEventHandler update initialGame :EventHandler<'Game> =
    let mutable currentState = initialGame
    (fun event ->
      currentState <- (update currentState event)
      currentState)

let convertToTick delta =
    delta |> Tick

let start requestFrame eventHandler renderer =
    let rec step delta =
        delta
        |> convertToTick
        |> eventHandler
        |> renderer
        |> ignore

        requestFrame step |> ignore

    step(0.)
