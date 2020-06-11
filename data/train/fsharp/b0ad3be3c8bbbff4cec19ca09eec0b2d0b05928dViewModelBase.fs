namespace ViewModels

open System
open System.Windows.Input
open System.ComponentModel

type ViewModelBase() =
    let propertyChangedEvent = new DelegateEvent<PropertyChangedEventHandler>()

    interface INotifyPropertyChanged with
        [<CLIEvent>]
        member this.PropertyChanged = propertyChangedEvent.Publish

    member this.OnPropertyChanged propertyName = 
        propertyChangedEvent.Trigger([| this; new PropertyChangedEventArgs(propertyName) |])
 
type RelayCommand (canExecute:(obj -> bool), action:(obj -> unit)) =
    let event = new DelegateEvent<EventHandler>()

    interface ICommand with
        [<CLIEvent>]
        member this.CanExecuteChanged = event.Publish
        member this.CanExecute arg = canExecute(arg)
        member this.Execute arg = action(arg)

