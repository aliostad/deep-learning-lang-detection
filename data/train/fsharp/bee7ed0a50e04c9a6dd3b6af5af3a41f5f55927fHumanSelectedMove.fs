namespace Latrunculi.Model
open System

type HumanMoveSelectedEventArgs(move: Move.T) =
    inherit EventArgs()
    member val Move = move with get

type HumanMoveSelectedEventHandler = delegate of obj * HumanMoveSelectedEventArgs -> unit

module HumanSelectedMove =

    type T() =
        let humanMoveSelectedEvent = new Event<HumanMoveSelectedEventHandler, HumanMoveSelectedEventArgs>()

        [<CLIEvent>]
        member this.HumanMoveSelected = humanMoveSelectedEvent.Publish
        
        member private this.OnHumanMoveSelected(move) =
            humanMoveSelectedEvent.Trigger(this, HumanMoveSelectedEventArgs(move))

        member this.SetMove (move: Move.T) =
            this.OnHumanMoveSelected(move)            

    let create() =
        T()

    let setMove (x: T) move =
        x.SetMove move