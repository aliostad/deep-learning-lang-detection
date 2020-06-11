[<AutoOpen>]
module Utils

open System

let BoolTrue = Nullable<bool>(true)
let BoolFalse = Nullable<bool>(false)
let BoolNone = Nullable<bool>()

[<AutoOpen>]
module Either =

    type Either<'a, 'b> =
        | Left of 'a
        | Right of 'b

    type either<'a, 'b> = Either<'a, 'b> // lower-case alias like option

    let right = function
      | Right x -> x
      | _      -> failwith "right"

    let isLeft = function
      | Left _ -> true
      | _      -> false

    let isRight = function
      | Right _ -> true
      | _      -> false

    let rightSome = function
      | Right x -> Some x
      | _      -> None

    let leftSome = function
      | Left x -> Some x
      | _      -> None

type ICommand = Windows.Input.ICommand
type NotifyCollectionChangedAction = Collections.Specialized.NotifyCollectionChangedAction


let private _event_commands = Event<_, _>().Publish
let wpfCommnad canExecute action =    
    {   new System.Windows.Input.ICommand with
            member this.CanExecute _ = 
                canExecute()
            member this.Execute _ = 
                action()
            member this.add_CanExecuteChanged(handler) = _event_commands.AddHandler(handler)
            member this.remove_CanExecuteChanged(handler) = _event_commands.RemoveHandler(handler) }

let wpfCommnad1 f =
    wpfCommnad (fun() -> true) f

let subscribePropertyChanged x f =
    (x |> box :?> ComponentModel.INotifyPropertyChanged).PropertyChanged.Add f

let subscribePropertyChangedAction x f =
    let f = ComponentModel.PropertyChangedEventHandler(f)
    (x |> box :?> ComponentModel.INotifyPropertyChanged).PropertyChanged.AddHandler f
    f


let subscribePropertyChangeHandler x f =
    (x |> box :?> ComponentModel.INotifyPropertyChanged).PropertyChanged.AddHandler f
    

let removePropertyChangedAction x f =
    (x |> box :?> ComponentModel.INotifyPropertyChanged).PropertyChanged.RemoveHandler f