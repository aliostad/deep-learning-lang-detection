namespace Services

open System.Diagnostics
open System

type Dispatcher() =

    let sellRequested = new Event<EventHandler<_>,_>()
    let buyRequested =  new Event<EventHandler<_>,_>()

    let confirmSellRequested = new Event<EventHandler<_>,_>()
    let executeSellRequested = new Event<EventHandler<_>,_>()

    let confirmBuyRequested = new Event<EventHandler<_>,_>()
    let executeBuyRequested = new Event<EventHandler<_>,_>()
    
    [<CLIEvent>]
    member this.SellRequested = sellRequested.Publish
    member this.Sell owner = sellRequested.Trigger(this , owner)

    [<CLIEvent>]
    member this.BuyRequested = buyRequested.Publish
    member this.Buy owner = buyRequested.Trigger(this , owner)

    [<CLIEvent>]
    member this.ConfirmSellRequested = confirmSellRequested.Publish
    member this.ConfirmSell info =     confirmSellRequested.Trigger(this , info)

    [<CLIEvent>]
    member this.ConfirmBuyRequested = confirmBuyRequested.Publish
    member this.ConfirmBuy info =     confirmBuyRequested.Trigger(this , info)

    [<CLIEvent>]
    member this.ExecuteSellRequested = executeSellRequested.Publish
    member this.ExecuteSell info =     executeSellRequested.Trigger(this , info)

    [<CLIEvent>]
    member this.ExecuteBuyRequested = executeBuyRequested.Publish
    member this.ExecuteBuy info =     executeBuyRequested.Trigger(this , info)