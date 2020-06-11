open System
open System.Windows
open System.Windows.Markup
open System.Windows.Input

let ReadXaml filename =
    IO.File.ReadLines filename
        |> String.concat "\n"
        |> XamlReader.Parse
        :?> Window

type RelayCommand (execute, canExecute) =
    let e = Event<_, _>()
    interface ICommand with
        member this.CanExecute arg = canExecute arg
        member this.Execute arg = execute arg
        member this.add_CanExecuteChanged handler =
            e.Publish.AddHandler handler
        member this.remove_CanExecuteChanged handler =
            e.Publish.RemoveHandler handler

type Model = { Message: string }

type ViewModel() =
    member this.Model = { Message = "Hello MVVM!" }
    member this.ClickCommand =
        let clickAction _ =
            MessageBox.Show this.Model.Message 
            |> ignore
        new RelayCommand(clickAction, fun _ -> true)

let View =
    let w = ReadXaml "View.xaml"
    w.DataContext <- new ViewModel()
    w

[<EntryPoint;STAThread>]
let main argv = (new Application()).Run View
