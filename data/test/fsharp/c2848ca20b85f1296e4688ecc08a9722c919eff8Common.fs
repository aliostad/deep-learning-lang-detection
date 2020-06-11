namespace Balgor.Strategy

open System

open Balgor.Common
open Balgor.Data
open Balgor.Data.Offer
open Balgor.Data.Broker
open Balgor.Statistics

open Prelude

module Common =

    /// ===========================================
    /// POSITION ENTER / EXIT
    /// ===========================================

    /// Minimum value of trade in account currency (USD) i.e. lowest lot size possible
    let unitLotSize:int = 1000

    /// Initial P&L value used in testing
    let initialPL = 10000.0

    /// Returns the commission pay charged based on instrument
    let getCommission (currency : CurrencyInstrument) =
        // https://www.fxcm.com/advantages/spreads-commissions/
        // FXCM charges 0.04/1K (minimum lot size) for most common currency pairs i.e.
        // EUR/USD - GBP/USD - USD/JPY - USD/CHF - AUD/USD - EUR/JPY - GBP/JPY
        // For the rest of the instruments they charge 0.06/1K (minimum lot size)
        let smallCommision = 0.04E-3
        let largeCommision = 0.06E-3
        let smallCommissions = [
            CurrencyInstrument.EUR_USD;
            CurrencyInstrument.GBP_USD;
            CurrencyInstrument.USD_JPY;
            CurrencyInstrument.USD_CHF;
            CurrencyInstrument.AUD_USD;
            CurrencyInstrument.EUR_JPY;
            CurrencyInstrument.GBP_JPY ]
        if List.exists ((=) currency) smallCommissions then smallCommision
        else largeCommision

    /// Assumed risk-free interest rate
    let riskFreeRate = 0.9E-2 // multiply by 100 to get %

    /// Calculates Sharpe Ratio
    /// riskFreeRate is used though it could be removed
    let sharpeRatio (ret:float[,]) =
        let nx = Array2D.length1 ret
        let ny = Array2D.length2 ret
        let excessRet = Array2D.map (fun v -> v - riskFreeRate) ret
        let vals = Array.zeroCreate (nx*ny)
        for i = 0 to nx-1 do
            vals.[i*nx..i*nx + ny-1] <- excessRet.[i,*]
        let n = Array.average vals
        let d = Distributions.stddev vals
        n/d

    /// Calculate Z-scores from timeseries
    /// idx is the current calculating position in timeseries
    /// In backtesting timeseries are loaded at once in full length.
    /// In strategy run idx + lookBack is the current last element in timeseries
    let calcZValue (idx : int) (p : PriceData.OHLCTimeSeries) (lookBack : int) =
        //let np = p.Length
        let bc = p.BidClose.[idx - lookBack + 1..idx]
        let oc = p.OfferClose.[idx - lookBack + 1..idx]
        let mc = bc
        //let mc = Array.map2 (fun b o -> 0.5*(b + o)) bc oc
        let mcH = Array.last mc
        let expAvgH = Smoothing.expMovingAvg mc lookBack |> Array.head
        //let nom = mc @- Smoothing.expMovingAvg mc lookBack |> Array.skipFromEnd (lookBack - 1)
        let nom = mcH - expAvgH
        let denom = Smoothing.movingStdDev mc lookBack |> Array.head
        nom/denom

    /// Returns the volume/quantity of all OPEN (i.e. not exited) trades
    /// Heavily used in loop/mockrun therefore switched to imperative code
    let totalOpenQty position =
        //List.sumBy(fun (tr:Trade) -> if tr.Type = TradeType.LongEnter || tr.Type = TradeType.ShortEnter then tr.Quantity else 0) position
        let mutable sm = 0
        for (tr : Trade) in position do
            if tr.Type = TradeType.LongEnter || tr.Type = TradeType.ShortEnter then sm <- sm + tr.Quantity
        sm

    /// OrderId generator function
    let private getOrderId = Helpers.IdGenerator 0

    /// TradeId generator function
    let private getTradeId = Helpers.IdGenerator 0

    let rec private sublists2 xs =
        match xs with
        | [] -> [[]]
        | x::xs ->
            let sublist = sublists2 xs in
                List.append (List.map (fun xs -> x::xs) sublist) sublist

    let private sublists input =
        let rec loop remaining current = seq {
            match remaining with 
            | [] -> ()
            | hd::tail -> 
                yield  hd::current
                yield! loop tail (hd::current)
                yield! loop tail current
        }
        loop input []

    /// Sends a Create Order request to the broker.
    /// Returns an Order type filled with all available data on the request being sent
    let private putOrder (instrument : CurrencyInstrument) (side : ContractSide) (qty : int) (price : float) (time : DateTimeUtc) =
        let timeFrame = OrderTimeFrame.FOK
        let state = OrderState.Executing
        let orderId = getOrderId()
        let order = { OrderId = orderId;  Side = side; TimeFrame = timeFrame; State = state; Quantity = qty; Price = price; Instrument = instrument; Time = time }
        let brokerOrder =
            if not Helpers.mockRun then
                match Offer.getOffer instrument with
                | None -> ()
                | Some offer ->
                    logfn "CURRENT OFFER: %s" <| offer.ToShortString()
                logfn "CREATING MARKET ORDER %s" <| order.ToString() 
                Broker.createMarketOrder instrument qty price side
            else Right ()
        order

    /// Collects a trade made as a result of a given order
    let private spawnTrade (order : Order) (tradeType : TradeType) =
        //let tr = Exchange.findMatchingTrade idx order tradeType
        let tradeId = getTradeId()
        let instrument = order.Instrument
        //let lotQty = order.Quantity / unitLotSize
        let qty = order.Quantity
        let commission = float qty * getCommission instrument
        let trade = { TradeId = tradeId; OrderId = order.OrderId; Side = order.Side; Type = tradeType;
            Quantity = qty; Price = order.Price; Instrument = order.Instrument; Time = order.Time; Commission = commission }
        trade

    let enterLong (p:PriceData.OHLCTimeSeries) (instrument : CurrencyInstrument) (qty : int) (price : float) (idx : int) (lpos : Trade list) =
        assertTrue (qty > 0)
        assertTrue (qty % 1000 = 0)
        let side = ContractSide.Buy
        let time = p.Time.[idx]
        let order = putOrder instrument side qty price time
        let tradeType = TradeType.LongEnter
        let trade = spawnTrade order tradeType
        trade :: lpos

    let enterShort (p:PriceData.OHLCTimeSeries) (instrument : CurrencyInstrument) (qty : int) (price : float) (idx : int) (spos : Trade list) =
        assertTrue (qty > 0)
        assertTrue (qty % 1000 = 0)
        let side = ContractSide.Sell
        let time = p.Time.[idx]
        let order = putOrder instrument side qty price time
        let tradeType = TradeType.ShortEnter
        let trade = spawnTrade order tradeType
        trade :: spos

    let exitLong (p:PriceData.OHLCTimeSeries) (instrument : CurrencyInstrument) (qty : int) (price : float) (idx : int) (lpos : Trade list) (transactions : Transaction list) =
        assertTrue (qty > 0)
        assertTrue (qty % 1000 = 0)
        let longEnterTrades = List.filter (fun tr -> tr.Type = TradeType.LongEnter) lpos
        match longEnterTrades with
        | [] -> (lpos, transactions)
        | allEnterTrades ->
            // try find a list of enterTrades whose sum quantity = requested qty
            match Seq.tryFind (fun trList -> List.sumBy (fun (tr : Trade) -> tr.Quantity) trList = qty ) <| sublists allEnterTrades with
            | None ->
                failwithf "Could not find a list of trades whose total quantity = requested quantity %d" qty
            | Some enterTrades ->
                // generate a matching exitTrade to all enterTrades
                let side = ContractSide.Sell
                let exitTradeType = TradeType.LongExit
                let time = p.Time.[idx]
                let foldFunc = fun (pos, trans) enterTrade ->
                    let order = putOrder instrument side enterTrade.Quantity price time
                    let exitTrade = spawnTrade order exitTradeType
                    // Remove enterTrade from open positions and create transaction
                    List.except [ enterTrade ] pos, new Transaction(enterTrade, exitTrade) :: trans
                let (lposNew, transNew) = List.fold foldFunc (lpos, transactions) enterTrades
                (lposNew, transNew)

    let exitShort (p:PriceData.OHLCTimeSeries) (instrument : CurrencyInstrument) (qty : int) (price : float) (idx : int) (spos : Trade list) (transactions : Transaction list) =
        assertTrue (qty > 0)
        assertTrue (qty % 1000 = 0)
        let shortEnterTrades = List.filter (fun tr -> tr.Type = TradeType.ShortEnter) spos
        match shortEnterTrades with
        | [] -> (spos, transactions)
        | allEnterTrades ->
            // try find a list of enterTrades whose sum quantity = requested qty
            match Seq.tryFind (fun trList -> List.sumBy (fun (tr : Trade) -> tr.Quantity) trList = qty ) <| sublists allEnterTrades with
            | None ->
                failwithf "Could not find a list of trades whose total quantity = requested quantity %d" qty
            | Some enterTrades ->
                // generate a matching exitTrade to all enterTrades
                let side = ContractSide.Buy
                let exitTradeType = TradeType.ShortExit
                let time = p.Time.[idx]
                let foldFunc = fun (pos, trans) enterTrade ->
                    let order = putOrder instrument side enterTrade.Quantity price time
                    let exitTrade = spawnTrade order exitTradeType
                    // Remove enterTrade from open positions and create transaction
                    List.except [ enterTrade ] pos, new Transaction(enterTrade, exitTrade) :: trans
                let (sposNew, transNew) = List.fold foldFunc (spos, transactions) enterTrades
                (sposNew, transNew)
