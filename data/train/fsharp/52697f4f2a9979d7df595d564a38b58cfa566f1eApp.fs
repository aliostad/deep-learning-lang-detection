module MainApp

open System
open System.Windows
open System.Windows.Controls
open System.Linq
open System.Collections.ObjectModel
open System.Collections.Generic
open System.Windows
open System.Windows.Data
open System.Windows.Input
open System.Windows.Media
open System.Windows.Documents
open System.Diagnostics
open System.Windows
open FSharpx
open Model

type MainWindow = XAML<"MainWindow.xaml">

let loadWindow() =
    let window = MainWindow()
    let items = ObservableCollection<Model.Advertisment>(Storage.getLatest 1000)
    let itemsView = ListCollectionView(items)

    let includedOrigins = HashSet<string>()
    let includedBedrooms = HashSet<int option>()
    
    let invoke f =
        window.Root.Dispatcher.BeginInvoke(new Action(f)) |> ignore

    let refreshFilters() =
        window.lbFilterByOrigin.ItemsSource <- (items |> Seq.collect (fun t -> t.Origins) |> Set.ofSeq).AsEnumerable()
        window.lbFilterByBedrooms.ItemsSource <- (items |> Seq.map (fun t -> t.Bedrooms) |> Set.ofSeq).AsEnumerable()

    let refreshItems() =
        items.Clear()
        includedBedrooms.Clear()
        includedOrigins.Clear()
        for ad in Storage.getLatest 1000 do
            items.Add ad
        refreshFilters()

    let updateItems() =
        window.bdWait.Visibility <- Visibility.Visible
        window.lblMessage.Text <- "Downloading subscriptions..."
        Getter.progressCallback <- Some (fun i j k -> invoke (fun () -> window.lblProgress.Text <- sprintf "%i in progress, %i in queue, %i completed" j i k))
        async { Storage.refreshSubscriptions()
                invoke (fun () ->
                            refreshItems()
                            window.bdWait.Visibility <- Visibility.Collapsed)
                return () } |> Async.Start

    refreshFilters()

    let resetFilter() =
        let check (ad: Model.Advertisment) =
            if includedOrigins.Count > 0 && (includedOrigins.Intersect ad.Origins).Count() = 0
            then false
            else if includedBedrooms.Count > 0 && includedBedrooms.Contains ad.Bedrooms = false
            then false
            else true
        itemsView.Filter <- new Predicate<obj>(fun o -> o :?> Model.Advertisment |> check)

    let openUrl url =
        Process.Start(url.ToString()) |> ignore

    let markAsRead (ad: Advertisment) =
        ad.IsNew <- false
        window.lbItems.SelectedItem <- ad

    let openDetails (ad: Advertisment) =
        openUrl ad.Url
        markAsRead ad

    let openAddress (ad: Advertisment) = 
        openUrl ad.AddressUrl
        markAsRead ad

    let asHandler f = 
        new RoutedEventHandler(fun s e -> (e.OriginalSource :?> CheckBox).DataContext |> (fun t -> ignore(f t); invoke resetFilter))
        
    window.lbItems.ItemsSource <- itemsView
    window.lbSubscriptions.ItemsSource <- Storage.getSubscriptions()
    window.btnRefresh.Click.Add(fun e -> updateItems())
    window.lbFilterByOrigin.AddHandler(CheckBox.CheckedEvent, asHandler (fun o -> o :?> string |> includedOrigins.Add))
    window.lbFilterByOrigin.AddHandler(CheckBox.UncheckedEvent, asHandler (fun o -> o :?> string |> includedOrigins.Remove))
    window.lbFilterByBedrooms.AddHandler(CheckBox.CheckedEvent, asHandler (fun o -> o :?> int option |> includedBedrooms.Add))
    window.lbFilterByBedrooms.AddHandler(CheckBox.UncheckedEvent, asHandler (fun o -> o :?> int option |> includedBedrooms.Remove))
    window.Root.CommandBindings.Add(new CommandBinding(NavigationCommands.GoToPage, new ExecutedRoutedEventHandler(fun s e -> e.Parameter :?> Advertisment |> openDetails))) |> ignore
    window.Root.CommandBindings.Add(new CommandBinding(NavigationCommands.NavigateJournal, new ExecutedRoutedEventHandler(fun s e -> e.Parameter :?> Advertisment |> openAddress))) |> ignore
    window.Root.CommandBindings.Add(new CommandBinding(NavigationCommands.Zoom, new ExecutedRoutedEventHandler(fun s e -> (e.Parameter :?> Subscription).QueryUrl |> openUrl))) |> ignore
    window.Root

[<STAThread>]
(new Application()).Run(loadWindow()) |> ignore