module TodoList

open System
open System.Collections.ObjectModel
open System.Reactive.Linq
open System.Windows
open FsXaml
open FSharp.Qualia
open FSharp.Qualia.WPF
open Types

type Model() = 
    let items = new ObservableCollection<TodoItemModel>()
    let collChanged = items.CollectionChanged |> Observable.filter Utils.isAddOrRemove
    
    let totalCount = 
        collChanged
        |> Observable.map (fun _ -> items.Count)
        |> toProperty 0
    
    let doneCount = 
        collChanged
        |> Observable.choose Utils.toAddOrRemove
        |> Observable.map (fun _ -> 
               items
               |> Seq.filter (fun i -> i.Done.Value)
               |> Seq.length)
        //                    |> Observable.scan (fun prev change -> prev) 0
        |> toProperty 0
    
    member x.Items = items
    member x.TotalCount = totalCount
    member x.DoneCount = doneCount
    member val NewItemText = ReactiveProperty ""
    member val FilteringType = ReactiveProperty All
    member val SelectedItem : ReactiveProperty<TodoItemModel option> = ReactiveProperty None


type TodoListWindow = XAML< "TodoList.xaml" >
type TodoListView(mw : TodoListWindow, m) = 
    inherit DerivedCollectionSourceView<TodoListEvents, Window, Model>(mw, m)

    let filter (m:Model) (x:TodoItem.View) =
        match m.FilteringType.Value with
        | All -> true
        | Completed -> x.Model.Done.Value
        | Active -> not x.Model.Done.Value
    let listDragHandler = DragDrop.DragSourceHandler()
    let deleteDropHandler = DragDrop.DropTargetHandler()
    do
        mw.list |> DragDrop.setDragHandler listDragHandler
                |> DragDrop.setDefaultDropHandler
                |> ignore
        mw.deleteZone |> DragDrop.setDropHandler deleteDropHandler |> ignore
        listDragHandler.Events |> Observable.map (fun x ->
            match x with
            | DragDrop.StartDrag _ -> Visibility.Visible
            | _ -> Visibility.Collapsed)
            |> Observable.add (fun v -> mw.deleteZone.Visibility <- v)
        ()

    member val ItemsCollectionView:ComponentModel.ICollectionView = null with get,set

    override this.EventStreams = 
        [ // (un)check all
          mw.buttonCheckAll.Click --> CheckAll
          mw.buttonUncheckAll.Click --> UncheckAll
          // filtering
          mw.radioFilterAll.Checked --> FilteringChanged All
          mw.radioFilterActive.Checked --> FilteringChanged Active
          mw.radioFilterCompleted.Checked --> FilteringChanged Completed
          // on Enter keypress, create an item
          mw.tbNewItem.KeyDown
          |> Observable.filter (fun e -> e.Key = System.Windows.Input.Key.Enter)
          |> Observable.mapTo Add
          // new item's text
          Observable.Throttle(mw.tbNewItem.TextChanged, TimeSpan.FromMilliseconds 100.0)
          |> DispatcherObservable.ObserveOnDispatcher
          |> Observable.map (fun _ -> NewItemTextChanged mw.tbNewItem.Text)
          mw.list.SelectionChanged |> Observable.map (fun _ ->
            SelectionChanged (if mw.list.SelectedItem <> null then (Some (mw.list.SelectedItem :?> TodoItem.View).Model) else None))
          
          deleteDropHandler.Events |> Observable.choose(fun x ->
              match x with
              | DragDrop.Drop i when (i.Data :? TodoItem.View) -> Some (i.Data :?> TodoItem.View)
              | _ -> None)
          |> Observable.map (fun x -> Delete x.Model)    ]

    
    override this.SetBindings(m : Model) = 
        // items list
        this.ItemsCollectionView <- m.Items |> this.linkCollection mw.list (TodoItem.createView)
        // filtering
        let p = (fun (x:obj) -> x :?> TodoItem.View |> filter m)
        this.ItemsCollectionView.Filter <- Predicate<obj>(p)
        m.FilteringType |> Observable.add (fun f ->
            match f with
            | All -> mw.radioFilterAll.IsChecked <- Nullable true
            | _ -> ()
            this.ItemsCollectionView.Refresh())
        // counts
        Observable.merge m.DoneCount m.TotalCount 
        |> Observable.add (fun _ -> mw.labelSummary.Content <- sprintf "%i / %i" m.DoneCount.Value m.TotalCount.Value)
        // new item's text tb
        m.NewItemText |> Observable.add (fun x -> mw.tbNewItem.Text <- x)

        m.SelectedItem |> Observable.add (fun x ->
            mw.labeSelected.Content <- match x with
                                       | None -> "None"
                                       | Some x -> x.Text.Value)