namespace SafetyProgram.UI.Commands

open System.Windows.Input
open SafetyProgram.UI.Models
open SafetyProgram.Core.Services
open System

type CopySelected(selection) =

    let canExecuteChanged = Event<_,_>()

    interface ICommand with

        // You can always open a new document
        member this.CanExecute(_) = 
            true

        // Close the old document, open a new one using the IOService
        member this.Execute(_) = 
            ()

        [<CLIEvent>]
        member this.CanExecuteChanged = canExecuteChanged.Publish

    interface IDisposable with
        member this.Dispose() =
            ()