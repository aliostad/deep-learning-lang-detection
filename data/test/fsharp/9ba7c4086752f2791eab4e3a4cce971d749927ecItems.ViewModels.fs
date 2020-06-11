namespace BasketTracker.Mobile.Core.Items

open BasketTracker.Mobile.Core
open BasketTracker.Mobile.Core.Models
open BasketTracker.Mobile.Core.Storage
open Xamarin.Forms
open System
open System.Linq
open System.Collections
open System.Collections.ObjectModel
open System.ComponentModel

type ItemListViewModel(basketId, basketDate: DateTime, api:ItemsApi) =
    inherit ListPageViewModel()

    let mutable list = 
        new ObservableCollection<ItemCellViewModel>()
    
    member self.List
        with get() = list
        and set value =
            base.OnPropertyChanging("List")
            list <- value
            base.OnPropertyChanged("List")

    member self.Date
        with get() = basketDate

    member self.BasketId
        with get() = basketId

    override self.Refresh() = 
        let cells = 
            api.List basketId
            |> List.map(fun i -> new ItemCellViewModel(self, api, i))

        self.List <- new ObservableCollection<ItemCellViewModel>(cells)


and ItemCellViewModel(parent: ItemListViewModel, api:ItemsApi, item: Item) =
    inherit ViewModelBase()

    let mutable name = item.Name
    let mutable amount = item.Amount
    
    member self.Id
        with get() = item.Id

    member self.Name
        with get() = name
        and set value =
            base.OnPropertyChanging "Name"
            name <- value
            base.OnPropertyChanged "Name"
            
    member self.Amount
        with get() = amount
        and set value =
            base.OnPropertyChanging "Amount"
            amount <- value
            base.OnPropertyChanged "Amount"
            
    member self.RemoveCommand
        with get() =
            new Command(fun () ->
                api.Remove item.Id
                parent.List.Remove self
                |> ignore)

type AddItemViewModel(parent: ItemListViewModel, api: ItemsApi)=
    inherit PageViewModel(Title = "Add a new item")

    let mutable name = ""
    let mutable amount = 0.0m

    member self.Name
        with get() = name
        and set value =
            base.OnPropertyChanging "Name"
            name <- value
            base.OnPropertyChanged "Name"
            
    member self.Amount
        with get() = amount
        and set value =
            base.OnPropertyChanging "Amount"
            amount <- value
            base.OnPropertyChanged "Amount"

    member self.AddCommand
        with get() =
            new Command(fun () ->
                let item = api.Add parent.BasketId self.Name self.Amount
                parent.Refresh())

type UpdateItemViewModel(parent: ItemCellViewModel, api: ItemsApi) =
    inherit PageViewModel(Title = "Update item")
    
    let mutable name = parent.Name
    let mutable amount = parent.Amount

    member self.Name
        with get() = name
        and set value =
            base.OnPropertyChanging "Name"
            name <- value
            base.OnPropertyChanged "Name"
            
    member self.Amount
        with get() = amount
        and set value =
            base.OnPropertyChanging "Amount"
            amount <- value
            base.OnPropertyChanged "Amount"

    member self.UpdateCommand
        with get() =
            new Command(fun () -> 
                api.Update parent.Id self.Name self.Amount
                parent.Name <- self.Name
                parent.Amount <- self.Amount)