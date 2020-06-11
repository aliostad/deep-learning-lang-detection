namespace SafetyProgram.UI.Commands

open System.Windows.Input
open SafetyProgram.UI.Models
open SafetyProgram.Core.Services
open System

type DeleteSelected(document : GuiDocument) as this =

    let canExecuteChanged = Event<_,_>()

    let handler = document.Selection.CollectionChanged.Subscribe(fun _ -> 
        canExecuteChanged.Trigger(this, new EventArgs()))

    interface ICommand with

        // You may only delete if a selection is available.
        member this.CanExecute(_) = document.Content.Count > 0

        // Close the old document, open a new one using the IOService
        member this.Execute(_) = 
            Seq.iter (fun x -> document.Content.Remove(x) |> ignore) document.Selection
            document.Selection.Clear()

        [<CLIEvent>]
        member this.CanExecuteChanged = canExecuteChanged.Publish

    interface IDisposable with
        member this.Dispose() = handler.Dispose()