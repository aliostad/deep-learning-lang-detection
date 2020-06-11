namespace Balgor.Data.Broker

open System
open System.Data

open Balgor.Common
open Balgor.Common.Helpers
open Balgor.Data

open Prelude
open Prelude.Data
open Prelude.Util
open Prelude.TypeExtensions

open Fxcm
open Fxcm.Data

//[<RequireQualifiedAccess>]
type private BrokerMessage =
    | Login of AsyncReplyChannel<Either<FxcmError, unit> >
    | Logout of AsyncReplyChannel<unit> // just to make it synchronous - prevents SIGABRT in Fxcm C++ DLL on early app exit
    | GetAccount of AsyncReplyChannel< Either<FxcmError, Account> >
    | GetOrders of AsyncReplyChannel< Either<FxcmError, Order list> >
    | DeleteOrder of String * AsyncReplyChannel< Either<FxcmError, unit> >
    | DeleteAllOrders of AsyncReplyChannel< Either<FxcmError, string> >
    | CloseAllOpenTrades of AsyncReplyChannel< Either<FxcmError, unit> >
    | CheckFxcmPermissionsOnInstrument of CurrencyInstrument
    | CreateEntryOrder of CurrencyInstrument * int * float * ContractSide * AsyncReplyChannel<Either<FxcmError, unit> >
    | CreateMarketOrder of CurrencyInstrument * int * float * ContractSide * AsyncReplyChannel<Either<FxcmError, unit> >
    | GetOffer of CurrencyInstrument * AsyncReplyChannel<Either<FxcmError, Offer> >
    | GetOffersMap of AsyncReplyChannel< Either<FxcmError, Map<string, Offer> >>
    | GetOffersObservable of AsyncReplyChannel< Either<FxcmError, IObservable<string * Map<string, Offer>> > >
    | GetOrdersObservable of AsyncReplyChannel< Either<FxcmError, IObservable<Order list>> >
    | GetOpenTradesObservable of AsyncReplyChannel< Either<FxcmError, IObservable<Trade list>> >
    | GetTransactionsObservable of AsyncReplyChannel< Either<FxcmError, IObservable<Transaction list>> >
    | GetPrices of String * String * String * DateTimeUtc * DateTimeUtc * AsyncReplyChannel< Either<FxcmError, PriceDataTuple list> >
    | GetOpenTrades of AsyncReplyChannel<Either<FxcmError, Trade list> >
    // HistoricClosedTrades cannot be converted to Trade type because BuySell info is wrong (a number)
    | GetHistoricClosedTrades of AsyncReplyChannel<Either<FxcmError, FxcmTrade list> >
    | Subscribe of String * AsyncReplyChannel< Either<FxcmError, unit> >
    | Unsubscribe of String * AsyncReplyChannel< Either<FxcmError, unit> >
    | SubscribeAll of String array * AsyncReplyChannel< Either<FxcmError, unit> >
    | UnsubscribeAll of String array * AsyncReplyChannel< Either<FxcmError, unit> >


module private MockBrokerAgent =


    let mockBrokerAgent =

        // mock Offers i.e. historical 1 minute data
        let defaultInstrument = CurrencyInstrument.EUR_NOK
        let intrvl = Interval.MIN_1
        let intervalSpan = intrvl.TimeSpan
        let dateFrom = DateTimeUtc(2016, 1, 1, 0, 0, 0, TimeSpan.Zero)
        let dateTo = DateTimeUtc(2016, 5, 1, 0, 0, 0, TimeSpan.Zero)
        let timeStart = DateTime.UtcNow

        /// OrderId generator function
        let getOrderId = Helpers.IdGenerator 0

        let offerId = 0 // doesn't matter in Mock
        let mutable offerMap : Map<string, Offer> = Map.empty
        let mutable idx = 0
        let mutable idxMax = 0
        let mutable idxMod = 0 // idx % idxMax overflow counter
        // offer Data
        let mutable bids : float [] = Array.empty
        let mutable asks : float [] = Array.empty
        let mutable vols : int [] = Array.empty

        // Mock position data
        let mutable orders : Order list = List.Empty
        let mutable trades : Trade list = List.Empty
        let mutable transactions : Transaction list = List.Empty
        // Observable trades/closedtrades
        let ordersSource = new ObservableSource<Order list>()
        let tradesSource = new ObservableSource<Trade list>()
        let transactionsSource = new ObservableSource<Transaction list>()
        let ordersObservable = ordersSource.AsObservable
        let tradesObservable = tradesSource.AsObservable
        let transactionsObservable = transactionsSource.AsObservable
        // offer source
        let offerSource = new ObservableSource<string * Map<string, Offer>>()
        // Get an IObservable from the source
        let offerMapObservable = offerSource.AsObservable

        let getOffer (instrument : CurrencyInstrument) (index: int) : Offer =
            let bid = bids.[index]
            let ask = asks.[index]
            let vol = vols.[index]
            let offerIndexSpan =
                if idxMod = 0 then
                    // no counter overflow yet - simpler calc
                    intervalSpan.Ticks * int64 idx
                else 
                    // idx counter went over idxMax - count the overflows as well
                    let idxModSpan = intervalSpan.Ticks * int64 (idxMod * idxMax)
                    intervalSpan.Ticks * int64 idx + idxModSpan
            let time = DateTimeUtc(timeStart.Ticks + offerIndexSpan, TimeSpan.Zero)
            { OfferId = offerId.ToString();
            Bid = bid;
            Ask = ask;
            Time = time;
            Instrument = instrument;
            Volume = vol;
            SubscriptionStatus = "T";
            TradingStatus = "O";
            High = ask + 5E-4;
            Low = bid - 5E-4;
            Digits = 5;
            PipSize = 0.0001;
            BuyInterest = 0.0;
            SellInterest = 0.0 }

        if Helpers.mockRun then

            logfn "Initializing mock offer source with %s historic data {%s to %s}" intrvl.IntervalSymbol (dateUtcToStr dateFrom) (dateUtcToStr dateTo)
            //let dtArr, boArr, bhArr, blArr, bcArr, ooArr, ohArr, olArr, ocArr, volArr =
            let _, _, _, _, bcArr, _, _, _, ocArr, volArr =
                ForexData.getPrices defaultInstrument intrvl.IntervalSymbol dateFrom dateTo
            idxMax <- bcArr.Length
            bids <- bcArr
            asks <- ocArr
            vols <- volArr
            logfn "Mock offer source ready with %d data points" idxMax
            // Set the current Offer index to the next offer index
            let bumpOfferIdx () =
                if idx + 1 = idxMax then
                    idxMod <- idxMod + 1
                    idx <- 0
                else idx <- idx + 1

            // automatically bump the current offer and push it to offer observable
            let offerBumpTask = async {
                let offerIdStr = offerId.ToString()
                let sleepIter = 10
                let mutable counter = 0
                while true do
                    // bump the current offer index
                    bumpOfferIdx ()
                    // get new current offer
                    let newOffer = getOffer defaultInstrument idx
                    // update offerMap
                    offerMap <- offerMap.Add(offerIdStr, newOffer)
                    // push it to offer observable
                    offerSource.Next(offerIdStr, offerMap)
                    if counter = 0 then
                        do! Async.Sleep 1
                    counter <- (counter + 1) % sleepIter
            }
            Async.Start offerBumpTask


        MailboxProcessor.Start(fun inbox ->
            let initState = 0

            let rec loop n =
                async {
                    let! msg = inbox.Receive()

                    match msg with
                    | Login replyChannel ->
                        logfn "MockBrokerAgent Login"
                        replyChannel.Reply <| Right ()
                        return! loop (n + 1)

                    | Logout replyChannel -> 
                        logfn "MockBrokerAgent Logout"
                        replyChannel.Reply ()
                        return! loop (n + 1)

                    | GetAccount replyChannel ->
                        let account = {
                            AccountId = "MockBrokerAccount"
                            AccountKind = "MockAccountKind"
                            AccountName = "MockAccountName"
                            AmountLimit = 999999
                            Balance = 50000.0;
                            BaseUnitSize = 1000;
                            LastMarginCallDate = DateTimeUtc.MinValue;
                            UsedMargin = 0.0 }
                        replyChannel.Reply <| Right account
                        return! loop (n + 1)

                    | GetOrders replyChannel ->
                        replyChannel.Reply <| Right orders
                        return! loop (n + 1)

                    | DeleteOrder (orderID, replyChannel) ->
                        orders <- orders |> List.filter (fun order -> order.OrderId <> orderID)
                        replyChannel.Reply <| Right ()
                        return! loop (n + 1)
                       
                    | DeleteAllOrders replyChannel ->
                        let noOfOrders = orders.Length
                        orders <- List.Empty
                        let msg = sprintf "All %d orders were deleted" noOfOrders
                        replyChannel.Reply <| Right msg
                        return! loop (n + 1)

                    | CloseAllOpenTrades replyChannel ->
                        // convert open trades to transactions
                        let newTransactions = trades |> List.map (fun openTrade ->
                            let closeSide = if openTrade.Side = ContractSide.Buy then ContractSide.Sell else ContractSide.Buy
                            let closeTrade = { openTrade with Side = closeSide }
                            new Transaction(openTrade, closeTrade))
                        transactions <- List.append newTransactions transactions
                        // empty open trades
                        trades <- List.Empty
                        replyChannel.Reply <| Right ()
                        return! loop (n + 1)
                    
                    | CheckFxcmPermissionsOnInstrument instrument ->
                        // do nothing
                        return! loop (n + 1)

                    | CreateEntryOrder (instrument, qty, price, buySell, replyChannel) ->
                        let orderId = getOrderId()
                        let timeFrame = OrderTimeFrame.FOK
                        let state = OrderState.Executing
                        let time = DateTimeUtc.UtcNow
                        let order = { OrderId = orderId;  Side = buySell; TimeFrame = timeFrame; State = state; Quantity = qty; Price = price; Instrument = instrument; Time = time }
                        replyChannel.Reply <| Right ()
                        return! loop (n + 1)

                    | CreateMarketOrder (instrument, qty, price, buySell, replyChannel) ->
                        let orderId = getOrderId()
                        let timeFrame = OrderTimeFrame.FOK
                        let state = OrderState.Executing
                        let time = DateTimeUtc.UtcNow
                        let order = { OrderId = orderId;  Side = buySell; TimeFrame = timeFrame; State = state; Quantity = qty; Price = price; Instrument = instrument; Time = time }
                        replyChannel.Reply <| Right ()
                        return! loop (n + 1)

                    | GetOffer (instrument, replyChannel) ->
                        let offer = getOffer instrument idx
                        replyChannel.Reply <| Right offer
                        return! loop (n + 1)

                    | GetOffersMap replyChannel ->
                        let offersMap = Map.empty
                        replyChannel.Reply <| Right offersMap
                        return! loop (n + 1)

                    | GetOffersObservable replyChannel ->
                        replyChannel.Reply <| Right offerMapObservable
                        return! loop (n + 1)

                    | GetOrdersObservable replyChannel ->
                        replyChannel.Reply <| Right ordersObservable
                        return! loop (n + 1)

                    | GetOpenTradesObservable replyChannel ->
                        replyChannel.Reply <| Right tradesObservable
                        return! loop (n + 1)

                    | GetTransactionsObservable replyChannel ->
                        replyChannel.Reply <| Right transactionsObservable
                        return! loop (n + 1)

                    | GetPrices (c1sym, c2sym, intervalSym, dateFrom, dateTo, replyChannel) ->
                        let instrument =
                            let currSym = c1sym + "/" + c2sym
                            match CurrencyInstrument.ParseCurrencySymbol(currSym) with
                            | None -> failwithf "Cannot parse currency symbol {%s}" currSym
                            | Some instrument -> instrument
                        let interval =
                            match Interval.ParseIntervalSymbol intervalSym with
                            | None -> failwithf "Cannot parse interval symbol {%s}" intervalSym
                            | Some intrvl -> intrvl
                        let dtFrom = dateUtcToDate dateFrom
                        let dtTo = dateUtcToDate dateTo
                        let prices = ForexData.getPrices instrument intervalSym dateFrom dateTo
                        let data = PriceData.OHLCTimeSeries.createFromFxcmData instrument interval prices
                        let tuples : PriceDataTuple list = data.ToPriceDataTuples()
                        replyChannel.Reply <| Right tuples
                        return! loop (n + 1)

                    | GetOpenTrades replyChannel ->
                        replyChannel.Reply <| Right trades
                        return! loop (n + 1)

                    | GetHistoricClosedTrades replyChannel ->
                        replyChannel.Reply <| Right List.Empty
                        return! loop (n + 1)

                    | Subscribe (instrumentSym, replyChannel) ->
                        replyChannel.Reply <| Right ()
                        return! loop (n + 1)

                    | SubscribeAll (instrumentSyms, replyChannel) ->
                        replyChannel.Reply <| Right ()
                        return! loop (n + 1)

                    | Unsubscribe (instrumentSym, replyChannel) ->
                        replyChannel.Reply <| Right ()
                        return! loop (n + 1)

                    | UnsubscribeAll (instrumentSyms, replyChannel) ->
                        replyChannel.Reply <| Right ()
                        return! loop (n + 1)
                }
            loop initState)


module private FxcmAgent =


    let private fxcmManager = new Fxcm.FxcmManager()

    let fxcmAgent =

        let fxcmOfferMapConverter (fxcmOfferMap : Map<string, FxcmOffer>) =
            // filter out FxcmOffers on unrecognized CurrencyInstruments
            let offers = fxcmOfferMap |> Map.toSeq |> Seq.map (snd >> Offer.ConvertFromFxcmOffer) |> Seq.filter Either.isRight |> Seq.map Either.rightValue
            Seq.zip (Seq.map (fun (o : Offer) -> o.OfferId) offers) offers |> Map.ofSeq

        MailboxProcessor.Start(fun inbox ->
            let initState = 0

            let rec loop n =
                async {
                    let! msg = inbox.Receive()

                    match msg with
                    | Login replyChannel ->
                        if fxcmManager.Connected then replyChannel.Reply <| Right ()
                        else
                            let fxcmsettings = Option.getOrFailwith Config.readConfig "Error reading Fxcm login config file"
                            let loginParams = new LoginParams(fxcmsettings)
                            let sampleParams = new SampleParams(fxcmsettings)
                            let login = loginParams.Login
                            let password = loginParams.Password
                            let url = loginParams.Url
                            let connection = loginParams.Connection
                            logfn "Fxcm Login attempt { ID = %s, password = %s, url = %s, connection = %s }" login password url connection
                            //replyChannel.Reply <| fxcmManager.Login(loginParams, sampleParams)
                            let reply = fxcmManager.Login(loginParams, sampleParams) |> Either.bind (fun _ ->
                                match fxcmManager.Session with
                                | Left _ -> Left FxcmError.SessionIsNull
                                | Right session ->
                                    logfn "\nFxcm account { %s }\n" <| fxcmManager.AccountInfo(false)
                                    Right ())
                            replyChannel.Reply reply
                        return! loop (n + 1)

                    | Logout replyChannel -> 
                        if not <| fxcmManager.Connected then
                            replyChannel.Reply ()
                        else
                            logfn "\nFxcm Logout"
                            replyChannel.Reply <| fxcmManager.Logout()
                        return! loop (n + 1)

                    | GetAccount replyChannel ->
                        let response = fxcmManager.GetAccount()
                        let reply = response |> Either.bind (Account.ConvertFromFxcmAccount >> Right)
                        replyChannel.Reply reply
                        return! loop (n + 1)

                    | GetOrders replyChannel ->
                        let response = fxcmManager.GetOrders()
                        let reply = response |> Either.bind (Right << List.map Order.ConvertFromFxcmOrder)
                        replyChannel.Reply reply
                        return! loop (n + 1)

                    | DeleteOrder (orderID, replyChannel) ->
                        // hopefully DeleteEntryOrder will delete any (market&entry) order types as advertised
                        replyChannel.Reply <| fxcmManager.DeleteEntryOrder orderID
                        return! loop (n + 1)
                       
                    | DeleteAllOrders replyChannel ->
                        replyChannel.Reply <| fxcmManager.DeleteAllOrders ()
                        return! loop (n + 1)

                    | CloseAllOpenTrades replyChannel ->
                        replyChannel.Reply <| fxcmManager.CloseAllOpenTrades ()
                        return! loop (n + 1)
                    
                    | CheckFxcmPermissionsOnInstrument instrument ->
                        if fxcmManager.Connected then
                            let instrumentSym = instrument.InstrumentSymbol
                            fxcmManager.CheckPermissions instrumentSym |> ignore
                        return! loop (n + 1)

                    | CreateEntryOrder (instrument, lotQty, rate, buySell, replyChannel) ->
                        replyChannel.Reply <|
                            fxcmManager.CreateEntryOrder(instrument.InstrumentSymbol, lotQty, rate, buySell.ToString())
                        return! loop (n + 1)

                    | CreateMarketOrder (instrument, lotQty, rate, buySell, replyChannel) ->
                        replyChannel.Reply <|
                            fxcmManager.CreateMarketOrder(instrument.InstrumentSymbol, lotQty, rate, buySell.ToString())
                        return! loop (n + 1)

                    | GetOffer (instrument, replyChannel) ->
                        let instrSym = instrument.InstrumentSymbol
                        let response = fxcmManager.GetOffer instrSym
                        let converter fxcmOffer =
                            match Offer.ConvertFromFxcmOffer fxcmOffer with
                            | Left msg -> Left <| FxcmError.Other msg
                            | Right offer -> Right offer
                        let reply = response |> Either.bind converter
                        replyChannel.Reply reply
                        return! loop (n + 1)

                    | GetOffersMap replyChannel ->
                        let response = fxcmManager.GetOffersMap()
                        let reply = response |> Either.bind (Right << fxcmOfferMapConverter)
                        replyChannel.Reply reply
                        return! loop (n + 1)

                    | GetOffersObservable replyChannel ->
                        let response = fxcmManager.GetOffersObservable()
                        let observableConverter fxcmObs =
                            Observable.map (fun (id, fxcmOfferMap) -> id, fxcmOfferMapConverter fxcmOfferMap) fxcmObs
                        let reply = response |> Either.bind (Right << observableConverter)
                        replyChannel.Reply reply
                        return! loop (n + 1)

                    | GetOrdersObservable replyChannel ->
                        let response = fxcmManager.GetOrdersObservable()
                        let reply = response |> Either.bind (Right << Observable.map (List.map Order.ConvertFromFxcmOrder))
                        replyChannel.Reply reply
                        return! loop (n + 1)

                    | GetOpenTradesObservable replyChannel ->
                        let response = fxcmManager.GetOpenTradesObservable()
                        let reply = response |> Either.bind (Right << Observable.map (List.map Trade.ConvertFromFxcmTrade))
                        replyChannel.Reply reply
                        return! loop (n + 1)

                    | GetTransactionsObservable replyChannel ->
                        let response = fxcmManager.GetTransactionsObservable()
                        let reply = response |> Either.bind (Right << Observable.map (List.map Transaction.ConvertFromFxcmTransaction))
                        replyChannel.Reply reply
                        return! loop (n + 1)

                    | GetPrices (c1sym, c2sym, intervalSym, dateFrom, dateTo, replyChannel) ->
                        // convert DateTime values to DateTimeUtc
                        let dtFrom = dateUtcToDate dateFrom
                        let dtTo = dateUtcToDate dateTo
                        let fxcmResponse = fxcmManager.GetHistoryPrices (c1sym, c2sym, intervalSym, dtFrom, dtTo)
                        let replyValue = fxcmResponse |> Either.bind Right
                        replyChannel.Reply replyValue
                        return! loop (n + 1)

                    | GetOpenTrades replyChannel ->
                        let response = fxcmManager.GetOpenTrades()
                        let reply = response |> Either.bind (Right << List.map Trade.ConvertFromFxcmTrade)
                        replyChannel.Reply reply
                        return! loop (n + 1)

                    | GetHistoricClosedTrades replyChannel ->
                        let response = fxcmManager.GetHistoricClosedTrades()
                        replyChannel.Reply response
                        return! loop (n + 1)

                    | Subscribe (instrumentSym, replyChannel) ->
                        replyChannel.Reply <| fxcmManager.OfferSubscribe instrumentSym
                        return! loop (n + 1)

                    | SubscribeAll (instrumentSyms, replyChannel) ->
                        replyChannel.Reply <| fxcmManager.OfferSubscribeAll instrumentSyms
                        return! loop (n + 1)

                    | Unsubscribe (instrumentSym, replyChannel) ->
                        replyChannel.Reply <| fxcmManager.OfferUnsubscribe instrumentSym
                        return! loop (n + 1)

                    | UnsubscribeAll (instrumentSyms, replyChannel) ->
                        replyChannel.Reply <| fxcmManager.OfferUnsubscribeAll instrumentSyms
                        return! loop (n + 1)
                }
            loop initState)

/// Helper to convert Either < error, value> reply to Option.
/// Special case when type(value) is unit -in that case (Left val) is false, (Right val) is true.
type private BrokerReplyHelper =

    static member extractFromReply (reply : Either<FxcmError, 'a>) =
        match reply with
        | Left err ->
            logfn "%s" <| err.ToString()
            None
        | Right value -> Some value

    static member extractFromReply (reply : Either<FxcmError, unit>) =
        match reply with
        | Left err ->
            logfn "%s" <| err.ToString()
            false
        | _ ->
            true

    static member waitForBrokerSystemChanges (sleepTime) =
        // time in ms to wait for broker systems update
        Helpers.SleepAsync sleepTime

    static member waitForBrokerSystemChanges () =
        let sleepTime = 500
        BrokerReplyHelper.waitForBrokerSystemChanges(sleepTime)

module Broker =

    let private brokerAgent =
        if Helpers.mockRun then MockBrokerAgent.mockBrokerAgent
        else FxcmAgent.fxcmAgent

    let login () =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> Login replyChannel)
        // Fxcm Login calls Offer Unsubscribe etc so give it time
        BrokerReplyHelper.waitForBrokerSystemChanges()
        match reply with
        | Left err ->
            let msg =
                match err with
                | FxcmError.LoginError msg -> msg
                | _ -> ""
            Left <| sprintf "Fxcm login error { %s }" msg
        | Right _ -> Right ()

    let logout () =
        brokerAgent.PostAndReply(fun replyChannel -> Logout replyChannel)

    /// Get account info
    let getAccount () =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> GetAccount replyChannel)
        BrokerReplyHelper.extractFromReply reply

    /// Get all orders
    let getOrders () =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> GetOrders replyChannel)
        //BrokerReplyHelper.extractFromReply reply
        reply

    /// Delete Order with given OrderID
    let deleteOrder (orderId : string) =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> DeleteOrder (orderId, replyChannel))
        BrokerReplyHelper.waitForBrokerSystemChanges()
        BrokerReplyHelper.extractFromReply reply

    /// Delete all Orders
    let deleteAllOrders () =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> DeleteAllOrders replyChannel)
        BrokerReplyHelper.waitForBrokerSystemChanges()
        //BrokerReplyHelper.extractFromReply reply
        reply

    /// Closes all open trades
    let closeAllOpenTrades () =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> CloseAllOpenTrades replyChannel)
        BrokerReplyHelper.waitForBrokerSystemChanges()
        //BrokerReplyHelper.extractFromReply reply
        reply

    let checkFxcmPermissionsOnInstrument (instrument : CurrencyInstrument) =
        let reply = brokerAgent.Post (CheckFxcmPermissionsOnInstrument instrument)
        reply

    let createEntryOrder (instrument:CurrencyInstrument) (lotQty : int) (rate : float) (buySell : ContractSide) =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> CreateEntryOrder (instrument, lotQty, rate, buySell, replyChannel))
        BrokerReplyHelper.waitForBrokerSystemChanges ()
        //BrokerReplyHelper.extractFromReply reply
        reply

    let createMarketOrder (instrument:CurrencyInstrument) (lotQty : int) (rate : float) (buySell : ContractSide) =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> CreateMarketOrder (instrument, lotQty, rate, buySell, replyChannel))
        BrokerReplyHelper.waitForBrokerSystemChanges ()
        //BrokerReplyHelper.extractFromReply reply
        reply

    let getOffer (instrument : CurrencyInstrument) =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> GetOffer (instrument, replyChannel))
        //BrokerReplyHelper.extractFromReply reply
        reply

    let getOffersMap () =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> GetOffersMap replyChannel)
        reply

    let getOffersObservable () =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> GetOffersObservable replyChannel)
        //BrokerReplyHelper.extractFromReply reply
        reply

    let getOrdersObservable () =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> GetOrdersObservable replyChannel)
        //BrokerReplyHelper.extractFromReply reply
        reply

    let getOpenTradesObservable () =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> GetOpenTradesObservable replyChannel)
        //BrokerReplyHelper.extractFromReply reply
        reply

    let getTransactionsObservable () =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> GetTransactionsObservable replyChannel)
        //BrokerReplyHelper.extractFromReply reply
        reply

    let getPricesOption c1sym c2sym intervalSym (dateFrom : DateTimeUtc) (dateTo : DateTimeUtc) =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> GetPrices (c1sym, c2sym, intervalSym, dateFrom, dateTo, replyChannel))
        BrokerReplyHelper.extractFromReply reply

    let getPrices c1sym c2sym intervalSym (dateFrom : DateTimeUtc) (dateTo : DateTimeUtc) =
        match getPricesOption c1sym c2sym intervalSym dateFrom dateTo with
        | None -> List.empty
        | Some data -> data
       
    /// Returns currently open i.e. not closed yet trades
    let getOpenTrades () =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> GetOpenTrades replyChannel)
        //BrokerReplyHelper.extractFromReply reply
        reply

    /// Returns all closed trades
    let getHistoricClosedTrades () =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> GetHistoricClosedTrades replyChannel)
        //BrokerReplyHelper.extractFromReply reply
        reply

    /// Subscribes an instrument to Offer updates
    let offerSubscribe (instrumentSymbol : string) =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> Subscribe (instrumentSymbol, replyChannel))
        BrokerReplyHelper.waitForBrokerSystemChanges()
        BrokerReplyHelper.extractFromReply reply

    /// Unsubscribes an instrument from Offer updates. Saves network traffic
    let offerUnsubscribe (instrumentSymbol : string) =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> Unsubscribe (instrumentSymbol, replyChannel))
        BrokerReplyHelper.waitForBrokerSystemChanges()
        BrokerReplyHelper.extractFromReply reply

    /// Subscribes to Offer updates for all instruments
    let offerSubscribeAll (instruments: string array) =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> SubscribeAll (instruments, replyChannel))
        BrokerReplyHelper.waitForBrokerSystemChanges()
        BrokerReplyHelper.extractFromReply reply
         
    /// Unsubscribes all instruments from Offer updates. Saves network traffic
    let offerUnsubscribeAll (instruments: string array) =
        let reply = brokerAgent.PostAndReply(fun replyChannel -> UnsubscribeAll (instruments, replyChannel))
        BrokerReplyHelper.waitForBrokerSystemChanges()
        BrokerReplyHelper.extractFromReply reply

    /// Update and then print out all offers
    (*let printOffers () =
        let offersMap = brokerAgent.PostAndReply(fun replyChannel -> GetOffersMap replyChannel)
        let offers = [| for KeyValue(_, v) in offersMap do yield v |]
        for o in offers |> Array.sortBy (fun o -> o.Instrument) do
            //logfn "%s" (v.ToString())
            logfn "Id = %3s | %s | %s | Bid  %11f | Ask  %11f" o.OfferId (dateToStr o.Time) o.Instrument o.Bid o.Ask*)

    /// Print all orders
    let printOrders (orders : Order list) =
        if orders.Length = 0 then
            logfn "Found no Orders to print"
        else
            logfn "Printing info on %d orders:" orders.Length
            List.iter (logfn "%s" << fun (o : Order) -> o.ToShortString()) orders
            //List.iter (logfn "%s" << fun (o : Order) -> o.ToString()) orders

    /// Print trades
    let printTrades (trades : Trade list) =
        if trades.Length = 0 then
            logfn "No trades to print"
        else
            logfn "Printing info on %d trades:" trades.Length
            List.iter (logfn "%s" << fun (o : Trade) -> o.ToShortString()) trades
            //List.iter (logfn "%s" << fun (o : Trade) -> o.ToString()) trades

    /// Print Fxcm trades
    let printFxcmTrades (trades : FxcmTrade list) =
        if trades.Length = 0 then
            logfn "No Fxcm trades to print"
        else
            logfn "Printing info on %d Fxcm trades:" trades.Length
            List.iter (logfn "%s" << fun (o : FxcmTrade) -> o.ToShortString()) trades
            //List.iter (logfn "%s" << fun (o : FxcmTrade) -> o.ToString()) trades
