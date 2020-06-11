namespace ManageTrades.ViewModels

open System
open System.Windows.Input
open Core.IntegrationLogic
open Core.Entities
open Integration.Factories
open Services

type BuyViewModel(info:SharesInfo) as this =

    inherit ViewModelBase()

    let dispatcher = getDispatcher()
    let accountId =  getAccountId()

    let mutable buyQty = ""
    let mutable canBuy = false
    let mutable buyValue = 0m

    let confirm = DelegateCommand( (fun _ -> this.ConfirmBuy()) ,
                                    fun _ -> true ) :> ICommand

    member this.Symbol     with get() = info.Shares.Symbol
    member this.Balance    with get() = info.Balance
    member this.StockPrice with get() = info.PricePerShare
    member this.Total      with get() = ((decimal)info.Shares.Quantity * info.PricePerShare)

    member this.BuyQty    
        with get() =      buyQty
        and  set(value) = buyQty <- value
                          let success , validQty = Int32.TryParse buyQty
                          if  success then this.CanBuy <- info.PricePerShare
                                                          *(decimal)validQty  <= this.Balance
                          else this.CanBuy <- false

                          this.UpdateBuyValue()
                          base.NotifyPropertyChanged(<@ this.BuyQty @>)
    member this.BuyValue  
        with get() =      buyValue
        and  set(value) = buyValue <- value
                          base.NotifyPropertyChanged(<@ this.BuyValue @>)
        
    member this.CanBuy   with get() =      canBuy
                         and  set(value) = canBuy <- value
                                           base.NotifyPropertyChanged(<@ this.CanBuy @>)
    member this.Confirm = confirm

    member private this.ConfirmBuy() =
        if this.CanBuy then
            dispatcher.ConfirmBuy { AccountId = accountId
                                    Symbol    = this.Symbol
                                    Quantity  = Int32.Parse this.BuyQty }

    member private this.UpdateBuyValue() =
        let success , validQty = Int32.TryParse buyQty
        if  success 
        then this.BuyValue <- (decimal)validQty * info.PricePerShare
        else this.BuyValue <- 0m