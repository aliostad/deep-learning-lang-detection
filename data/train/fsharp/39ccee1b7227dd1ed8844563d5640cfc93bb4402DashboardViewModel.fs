namespace BucklingSprings.Aware.ViewModels

open BucklingSprings.Aware
open BucklingSprings.Aware.Core.CommonExtensions.DateTimeOffsetExtensions
open BucklingSprings.Aware.Core.Diagnostics
open BucklingSprings.Aware.Input
open BucklingSprings.Aware.Common.UserConfiguration
open BucklingSprings.Aware.Windows
open BucklingSprings.Aware.Windows.Layout



open System.ComponentModel
open System.Threading
open System.Windows
open System.Windows.Input
open System.Collections.ObjectModel

type NavigatablePageViewModel(nm : string, pg: obj, keepFilters : bool) =
    let propertyChanged = Event<PropertyChangedEventHandler, PropertyChangedEventArgs>()
    let mutable isSelected = false
    [<CLIEvent>]
    member this.PropertyChanged  = propertyChanged.Publish
    member x.KeepFilters = keepFilters
    member x.PageName = nm
    member x.Page = pg
    member val Navigate : ICommand = null with get, set
    member x.IsSelected with get () = isSelected
    member x.IsSelected with set (value) =
                                            isSelected <- value
                                            propertyChanged.Trigger(x, PropertyChangedEventArgs("IsSelected"))


    interface INotifyPropertyChanged with
        member this.add_PropertyChanged(handler) = propertyChanged.Publish.AddHandler(handler)
        member this.remove_PropertyChanged(handler) = propertyChanged.Publish.RemoveHandler(handler)


type DashboardViewModel(configurationService : IConfigurationService, wds : WorkingDataService, navigator : obj -> unit, ms : IMessageService) as vm =
    let propertyChanged = Event<PropertyChangedEventHandler, PropertyChangedEventArgs>()
    let pages = ObservableCollection<NavigatablePageViewModel>()
    let mutable filtersVisible = true
    do
        let pgs = LayoutConfiguration.pages wds ms
        let navigateCommand (p : Navigatable) : ICommand =
            let fn () =
                navigator(p.navigateTo)
            AlwaysExecutableCommand(fn) :> ICommand

        for p in pgs do
            pages.Add(NavigatablePageViewModel(p.name, p.navigateTo, p.keepFilters))
        let navigateTo (pgNav : NavigatablePageViewModel) =
            for p in pages do
                if p = pgNav then
                    filtersVisible <- p.KeepFilters
                    propertyChanged.Trigger(vm, PropertyChangedEventArgs("FilterVisibility"))
                    p.IsSelected <- true
                else
                    p.IsSelected <- false
            navigator pgNav.Page


        for pgNav in pages do
            pgNav.Navigate <- AlwaysExecutableCommand(fun () -> navigateTo pgNav)

        let defaultPg = Seq.head pages
        defaultPg.Navigate.Execute null
        


    [<CLIEvent>]
    member this.PropertyChanged  = propertyChanged.Publish
    member x.Pages = pages
    member x.ConfigurationService = configurationService
    member x.DateRangeStartDate = wds.WorkingData.minimumDate.StartOfDay
    member x.DateRangeEndDate = System.DateTimeOffset.Now.StartOfDay
    member x.FilterVisibility = if filtersVisible then Visibility.Visible else Visibility.Collapsed
    interface INotifyPropertyChanged with
        member this.add_PropertyChanged(handler) = propertyChanged.Publish.AddHandler(handler)
        member this.remove_PropertyChanged(handler) = propertyChanged.Publish.RemoveHandler(handler)

