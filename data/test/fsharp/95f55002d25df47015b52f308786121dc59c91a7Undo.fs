namespace SafetyProgram.UI.Commands

open System.Windows.Input
open SafetyProgram.UI.Models
open SafetyProgram.Core.Services
open System
open SafetyProgram.Base
open SafetyProgram.Base.Helpers
open FSharpx.Option

type Undo(model : GuiKernelData) as this =

    let canExecuteChanged = Event<_,_>()

    let triggerCanExecuteChanged () = canExecuteChanged.Trigger(this, new EventArgs())

    let attachToCommandController x = maybe {
        let! y = x
        let z = y.CommandController.CanRedoChanged.Subscribe(fun _ ->
            triggerCanExecuteChanged())
        return z
    }

    let mutable commandControllerHandler = attachToCommandController model.Content

    let contentHandler = model.ContentChanged.Subscribe(fun _ ->
        maybe {
            let! x = commandControllerHandler
            x.Dispose()

            return ()
        } |> ignore

        commandControllerHandler <- attachToCommandController model.Content
        
        triggerCanExecuteChanged())

    interface ICommand with

        // Undo may only be executed if there is content open AND there are commands to undo.
        member this.CanExecute(_) = 
            match model.Content with
            | Some x -> x.CommandController.CanUndo()
            | None -> false

        // Perform an undo operation.
        member this.Execute(_) = 
            maybe {
                let! x = model.Content
                x.CommandController.Undo()
                return ()
            } |> ignore

        [<CLIEvent>]
        member this.CanExecuteChanged = canExecuteChanged.Publish

    interface IDisposable with
        member this.Dispose() =
            contentHandler.Dispose()
            maybe {
                let! x = commandControllerHandler
                x.Dispose()
                return ()
            } |> ignore