namespace SafetyProgram.UI.Commands

open System.Windows.Input
open SafetyProgram.UI.Models
open SafetyProgram.Core.Services
open SafetyProgram.Base
open SafetyProgram.Base.Helpers
open System
open FSharpx.Option

type Redo(model : GuiKernelData) as this =
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

        // May only redo if content is open AND a redo can be performed.
        member this.CanExecute(_) = 
            match model.Content with
            | Some x -> x.CommandController.CanRedo()
            | None -> false

        member this.Execute(_) =
            maybe {
                let! x = model.Content
                x.CommandController.Redo()
                return ()
            } |> ignore

        [<CLIEvent>]
        member this.CanExecuteChanged = canExecuteChanged.Publish

    interface IDisposable with
        member this.Dispose() =
            contentHandler.Dispose()
            maybe {
                let! x = commandControllerHandler
                return x.Dispose()
            } |> ignore