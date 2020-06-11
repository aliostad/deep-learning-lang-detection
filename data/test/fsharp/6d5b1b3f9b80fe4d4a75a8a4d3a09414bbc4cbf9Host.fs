module BricksHost

open Bricks

type EventHandler = interface end

type EventHandler<'e> = 'e -> Transaction

type ProgramHost = 
    abstract member dispatch : ('e -> Transaction) -> 'e -> unit

type ProgramHost<'v>() =
    let mutable _activeHandlers: IMap<obj, obj -> Transaction> = IMap.Empty
    let mutable _program: 'v program option = None

    interface ProgramHost with

        member this.dispatch handler event = 
            let transaction = handler event
            // run the transaction and the program
            transaction ()
            _program.Value.run() |> ignore

    member this.run program =
        _program <- Some program
        program.run()
