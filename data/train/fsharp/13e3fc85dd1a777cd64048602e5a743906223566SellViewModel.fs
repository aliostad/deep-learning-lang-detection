namespace ManageTrades.ViewModels

open System
open System.Windows.Input
open Core.IntegrationLogic
open Core.Entities
open Integration.Factories
open Services

type SellViewModel(info:SharesInfo) as this =

    inherit ViewModelBase()

    let dispatcher = getDispatcher()
    let accountId =  getAccountId()

    let mutable sellQty = ""
    let mutable canSell = false
    let mutable sellValue = 0m

    let confirm = DelegateCommand( (fun _ -> this.ConfirmSell()) ,
                                    fun _ -> true ) :> ICommand

    member this.Symbol     with get() = info.Shares.Symbol
    member this.Shares     with get() = info.Shares.Quantity
    member this.StockPrice with get() = info.PricePerShare
    member this.Total      with get() = ((decimal)info.Shares.Quantity * info.PricePerShare)

    member this.SellQty    
        with get() =      sellQty
        and  set(value) = sellQty <- value
                          let success , validQty = Int32.TryParse sellQty
                          if  success then this.CanSell <- validQty >  0 && 
                                                           validQty <= this.Shares
                          else this.CanSell <- false
                          this.UpdateSellValue()
                          base.NotifyPropertyChanged(<@ this.SellQty @>)
    member this.SellValue  
        with get() =     sellValue
        and set(value) = sellValue <- value
                         base.NotifyPropertyChanged(<@ this.SellValue @>)
        
    member this.CanSell   with get() =      canSell
                          and  set(value) = canSell <- value
                                            base.NotifyPropertyChanged(<@ this.CanSell @>)
    member this.Confirm = confirm

    member private this.ConfirmSell() =
        if this.CanSell then
            dispatcher.ConfirmSell { AccountId = accountId
                                     Symbol    = this.Symbol
                                     Quantity  = Int32.Parse this.SellQty }

    member private this.UpdateSellValue() =
        let success , validQty = Int32.TryParse sellQty
        if  success 
        then this.SellValue <- (decimal)validQty * info.PricePerShare
        else this.SellValue <- 0m