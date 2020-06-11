namespace global

open System 
open System.Windows
open System.Windows.Controls
open System.Windows.Data
open System.Windows.Threading
open System.Drawing
open System.ComponentModel;
open System.Net
open System.Windows.Documents
open UIElements
open System.Windows.Controls.Primitives

type MainEvents = 
    | BergerTabell
    | AddToList
    | SelectionChanged of SelectionChangedEventArgs
    | TextChanged of RoutedEventArgs
    | RemovePlayer of Input.MouseEventArgs
    | SortByCheckBox
    | AllPlayersInList

type ManagePlayers =
    | AddPlayer
    | DeletePlayer
    | ShowAllPlayers

type MainView(window: StartWindow) = 

    interface IView<MainEvents, MainModel> with
        member this.Events = 
            [
                window.AddToList.Click |> Observable.map (fun _ -> AddToList)
                window.NavnBox.SelectionChanged |> Observable.map(fun arg -> SelectionChanged arg)
                window.NavnBox.MouseMove |> Observable.map(fun arg -> RemovePlayer arg ) 
                window.Navn.LostFocus |> Observable.map (fun arg -> TextChanged arg )
                window.Rating.LostFocus |> Observable.map (fun arg -> TextChanged arg )
                window.SortButton.Click |> Observable.map (fun _ -> SortByCheckBox)
                window.AllButton.Click  |> Observable.map (fun _ -> AllPlayersInList )
                  
            ] 
            |> List.reduce Observable.merge 

        member this.SetBindings model = 
            window.DataContext <- model

//            let dataTemplate: DataTemplate = window.TryFindResource("PlayerDataTemplate") :?> DataTemplate
//            let t1 = dataTemplate.Template
            //#B Typical call to set up data binding in WPF. Other bindings are similar.
                        
            window.SelectedPlayer.SetBinding(TextBlock.TextProperty, "SelectedPlayer") |> ignore
            window.Navn.SetBinding(TextBox.TextProperty, "Navn") |> ignore
            window.Rating.SetBinding(TextBox.TextProperty, "Rating") |> ignore
            window.NavnBox.SetBinding(ListBox.ItemsSourceProperty , Binding(path = "NavneListe") ) |> ignore
            //window.SortButton.SetBinding(ListBox.ItemsSourceProperty , Binding(path = "SortByChecked") ) |> ignore

            let inpc: INotifyPropertyChanged = unbox model
            let model: MainModel = unbox model 
            inpc.PropertyChanged.Add <| fun args ->
                match args.PropertyName with                                      
                | "SelectedPlayer" ->
                    window.SelectedPlayer.Text <- String.Format("Navn: {0}, Rating: {1}", model.SelectedPlayer.Navn, 
                        if model.SelectedPlayer.Rating.IsSome then model.SelectedPlayer.Rating.Value else 0)
                |_ -> ()


type ManagePlayerView(window: MainWindow) = 

    interface IView<ManagePlayers, ManagePlayersModel> with
        member this.Events = 
            [
                  
            ] 
            |> List.reduce Observable.merge 

        member this.SetBindings model = 
            window.DataContext <- model



            let inpc: INotifyPropertyChanged = unbox model
            let model: ManagePlayersModel = unbox model 
            inpc.PropertyChanged.Add <| fun args ->
                match args.PropertyName with                                      
                | "SelectedPlayer" -> ()
                |_ -> ()
