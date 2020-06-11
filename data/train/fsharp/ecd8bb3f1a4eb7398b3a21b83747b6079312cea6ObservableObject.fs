namespace TXTHelper
open System
open System.ComponentModel
open Microsoft.FSharp.Quotations.Patterns
open System.Windows.Input

type ObservableObject() =
    let propertyChanged = Event<_,_>()
    let getPropertyName = function
        | PropertyGet(_, p, _) -> p.Name
        | _ -> invalidOp "Invalid expression argument: expecting property getter"

    interface INotifyPropertyChanged with
        [<CLIEvent>]
        member this.PropertyChanged = propertyChanged.Publish

    member this.NotifyPropertyChanged name =
        propertyChanged.Trigger(this, PropertyChangedEventArgs(name))
    member this.NotifyPropertyChanged expr =
        expr |> getPropertyName |> this.NotifyPropertyChanged

module Helpers=
    let createCommand action canExecute=
        let event1 = Event<_, _>()
        {
            new ICommand with
                member this.CanExecute(obj) = canExecute(obj)
                member this.Execute(obj) = action(obj)
                member this.add_CanExecuteChanged(handler) = event1.Publish.AddHandler(handler)
                member this.remove_CanExecuteChanged(handler) = event1.Publish.AddHandler(handler)
        }
