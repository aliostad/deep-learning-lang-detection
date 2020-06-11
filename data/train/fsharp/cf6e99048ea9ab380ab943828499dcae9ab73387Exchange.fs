namespace Balgor.Data

open System

open Balgor.Common
open Balgor.Data
open Balgor.Data.Broker

open Fxcm.Data

open Prelude

type private ExchangeBase =
    abstract GetExchangePosition : CurrencyInstrument -> Transaction list -> Trade list -> Trade list -> Transaction list * Trade list * Trade list 

    /// Finds an Open or Closed trade matching the given order values
    (*member x.findMatchingTrade (index : int) (order : Order) (tradeType : TradeType) =
        let instrument = order.Instrument
        let trades =
            match tradeType with
            | TradeType.LongEnter ->
                let longFxcmTrades = Trade.getLongTrades()
                longFxcmTrades |> List.map (Trade.ConvertFromFxcmTrade instrument)
            | TradeType.ShortEnter ->
                let shortFxcmTrades = Trade.getShortTrades()
                shortFxcmTrades |> List.map (Trade.ConvertFromFxcmTrade instrument)
            | _ -> failwithf "TradeType.%s not supported yet" <| tradeType.ToString()
        let orderId = order.OrderId
        match List.tryFind (fun tr -> tr.OrderId = orderId) trades with
        | Some trade ->
            Some trade
        | None ->
            None

    /// Finds an Open or Closed trade matching the given order values
    member x.findMatchingTransaction (index : int) (openTrade : Trade) =
        let transactions = Transaction.getTransactions()
        let instrument = openTrade.Instrument
        let openTradeId = openTrade.TradeId
        let openTradeType = openTrade.Type
        let openTradeOrderId = openTrade.OrderId
        let openQty = openTrade.Quantity
        (*let trades =
            match openTradeType with
            | TradeType.LongEnter ->
                let longFxcmTrades = Trade.getLongTrades()
                longFxcmTrades |> List.map (Trade.ConvertFromFxcmTrade instrument index)
            | TradeType.ShortEnter ->
                let shortFxcmTrades = Trade.getShortTrades()
                shortFxcmTrades |> List.map (Trade.ConvertFromFxcmTrade instrument index)
            | _ -> failwithf "TradeType.%s is not an Enter/Open trade" <| openTradeType.ToString()*)
        
        match List.tryFind (fun (trans : FxcmTransaction) -> trans.OpenOrderID = openTradeOrderId) transactions with
        | Some trans ->
            let tradeId = trans.TradeID
            let openOrderId = trans.OpenOrderID
            let closeOrderId = trans.CloseOrderID
            let closeSide = ContractSide.FromString trans.BuySell
            let closeTradeType = 
                match openTradeType with
                | TradeType.LongEnter -> TradeType.LongExit
                | TradeType.ShortEnter -> TradeType.ShortExit
                | _ -> failwithf "TradeType.%s is not an Enter/Open trade" <| openTradeType.ToString()
            let closeQty = trans.Amount
            assertTrueMsg(openQty = closeQty, sprintf "Transaction Open quantity %d <> Close quantity %d" openQty closeQty)
            let closePrice = trans.CloseRate
            let instrument = openTrade.Instrument
            let closeTime = trans.CloseTime |> Helpers.dateToDateUtc
            let closeIndex = index
            let closeTrade = { TradeId = tradeId; OrderId = openOrderId; Side = closeSide; Type = closeTradeType;
                Quantity = closeQty; Price = closePrice; Instrument = instrument; Time = closeTime }
            Some closeTrade

        | None ->
            None

    /// Finds Canceled/Executed/whatever ordres
    member x.findMatchingOrder (order : Order) (state : OrderState) =
        ()*)

module Exchange =
    /// Noop MockExchange
    let private MockExchange = { new ExchangeBase with

        member x.GetExchangePosition (instrument : CurrencyInstrument) (oldTransactions : Transaction list) (oldLongTrades : Trade list) (oldShortTrades : Trade list) =
            (oldTransactions, oldLongTrades, oldShortTrades)
    }

    /// FxcmExchange
    let private FxcmExchange = { new ExchangeBase with

        member x.GetExchangePosition (instrument : CurrencyInstrument) (oldTransactions : Transaction list) (oldLongTrades : Trade list) (oldShortTrades : Trade list) =
            let transactions = Transaction.getTransactions()
            let longTrades = Trade.getLongTrades()
            let shortTrades = Trade.getShortTrades()

            let executingOrders = Order.getExecutingOrders()
            let executedOrders = Order.getExecutedOrders()
            let canceledOrders = Order.getCanceledOrders()
            let rejectedOrders = Order.getRejectedOrders()

            (transactions, longTrades, shortTrades)
    }

    let private exchange = 
        if Helpers.mockRun then MockExchange
        else FxcmExchange

    let getExchangePosition (instrument : CurrencyInstrument) (oldTransactions : Transaction list) (oldLongTrades : Trade list) (oldShortTrades : Trade list) =
        exchange.GetExchangePosition instrument oldTransactions oldLongTrades oldShortTrades
