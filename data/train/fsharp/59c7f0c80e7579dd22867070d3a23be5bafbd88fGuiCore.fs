namespace FSharpSpec.GuiRunner

open System
open System.ComponentModel
open System.Windows.Input

type ViewModelBase () =

  let propertyChanged = new Event<PropertyChangedEventHandler,PropertyChangedEventArgs>()
 
  interface INotifyPropertyChanged with
    [<CLIEvent>]
    member x.PropertyChanged = propertyChanged.Publish
 
  member x.OnPropertyChanged(name)=
    propertyChanged.Trigger (x, new PropertyChangedEventArgs(name))
     

type ActionCommand (action : Action, canExecute : Func<bool>) = 
  let _action = action
  let _canExecute = canExecute

  interface ICommand with
    member x.Execute(_) = _action.Invoke()
    member x.CanExecute(_) = _canExecute.Invoke()
    
    member x.add_CanExecuteChanged(eventHandler) = 
      CommandManager.RequerySuggested.AddHandler eventHandler
    
    member x.remove_CanExecuteChanged(eventHandler) = 
      CommandManager.RequerySuggested.RemoveHandler eventHandler
