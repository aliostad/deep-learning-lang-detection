namespace Balgor.Strategy

open System
open System.Drawing
open Microsoft.FSharp.Collections //PSeq
open FSharp.Control // async sequene i.e. asyncSeq monad

open Balgor.Common
open Balgor.Common.Helpers
open Balgor.Statistics
open Balgor.Data
open Balgor.Data.Broker
open Balgor.Data.Offer

open Prelude // assertTrue
open Prelude.Util // time, GetUnionCaseName
open Prelude.ModuleExtensions
open Prelude.TypeExtensions

open StockChart
open Chart2d
open Chart3d
open LogWindow

module Runner =

    open Tester

    let printCollectedBar (dt, bo, bh, bl, bc, oo, oh, ol, oc, vol) (barNo : int option) = 
        let barNoIndicator =
            match barNo with
            | Some n -> n.ToString()
            | None -> ""
        logfn "OHLC bar %s | Time = %s, BO = %.5f, BH = %.5f, BL = %.5f, BC = %.5f, OO = %.5f, OH = %.5f, OL = %.5f, OC = %.5f, Vol = %d"
            barNoIndicator (dateUtcToStr dt) bo bh bl bc oo oh ol oc vol

    /// Runs a strategy function
    let strategyRunner (initialP:PriceData.OHLCTimeSeries) (mockRun : bool) (displayReport:bool) allowedDrawDown abortTime strategyFunc q (lookBack:int) =
        // lookBack < 2 is nonsense i.e. no stdDev, mean to revert to etc
        let preconditions =
            [(lookBack > 2, "lookBack must be > 2"); // usually works (i.e. variance will not be 0.0) with lookBack=2 but that's too small
            (allowedDrawDown > 0.0 && allowedDrawDown < 1.0, "drawdown must be (0.0..1.0)");
            (q > 0.0, "q must be > 0.0")]
        let precondAbort = Seq.tryFind (not << fst) preconditions |> Option.bind (snd >> Some)

        ///////////////////////////////////////////////////////////////////

        let createStockChart (instrument : CurrencyInstrument) (tsData : PriceData.OHLCTimeSeries) =
            StockChart.createStockchart instrument.InstrumentSymbol 200 100 800 600 (Array.map dateUtcToDate tsData.Time) 
                tsData.BidOpen tsData.BidHigh tsData.BidLow tsData.BidClose tsData.Volume

        let updateStockChartData (chart : StockChartForm) (tsData :PriceData.OHLCTimeSeries) =
            chart.UpdateData (Array.map dateUtcToDate tsData.Time, tsData.BidOpen, tsData.BidHigh, tsData.BidLow, tsData.BidClose, tsData.Volume)

        let createPLChart (instrument : CurrencyInstrument) (tsData :PriceData.OHLCTimeSeries) (transactions : Transaction list) =
            let transactionsCorrectOrder = List.rev transactions
            let (_, _, pAndL, _) = calcPAndL tsData transactionsCorrectOrder lookBack q allowedDrawDown displayReport
            let outOfSampleTitle =
                sprintf "RUNNER ClosePL %.2f NoOfOrders %d" pAndL.Last (2*transactions.Length)
            Chart2d.createXYchart outOfSampleTitle 200 100 800 600 [| 1.0..float pAndL.Length |] pAndL

        let updatePLChartData (chart : Chart2dForm) (tsData :PriceData.OHLCTimeSeries) (transactions : Transaction list) =
            let transactionsCorrectOrder = List.rev transactions
            let (_, _, pAndL, _) = calcPAndL tsData transactionsCorrectOrder lookBack q allowedDrawDown displayReport
            let outOfSampleTitle =
                sprintf "RUNNER ClosePL %.2f NoOfOrders %d" pAndL.Last (2*transactions.Length)
            chart.Title <- outOfSampleTitle
            chart.UpdateData ([| 1.0..float pAndL.Length |], pAndL)

        let createOrdersLog () =
            let font = new Font("Monospace", 11.0f, FontStyle.Regular, GraphicsUnit.Point, 0uy)
            LogWindow.createLogWindow "Orders RUNNER" 100 100 600 400 (Some Color.Black) None (Some font)

        let updateOrdersLog (logWindow : LogWindowForm) (longPos : Trade list) (shortPos : Trade list) =
            let longColor = Color.LawnGreen
            let shortColor = Color.Red
            let appender color trade =
                logWindow.BufferWriteLine(trade.ToString(), color)
            logWindow.SuspendLayout()
            logWindow.BufferClear()
            if List.length longPos  = 0 then
                logWindow.BufferWriteLine("NO LONG POSITION", longColor)
            else
                logWindow.BufferWriteLine("LONG POSITIONS:", longColor)
                List.iter (appender longColor) longPos
            if List.length shortPos  = 0 then
                logWindow.BufferWriteLine(Environment.NewLine + "NO SHORT POSITION", shortColor)
            else
                logWindow.BufferWriteLine(Environment.NewLine + "SHORT POSITIONS:", shortColor)
                List.iter (appender shortColor) shortPos
            logWindow.BufferShow()
            logWindow.ResumeLayout(false)

        let createTransactionsLog () =
            let font = new Font("Monospace", 11.0f, FontStyle.Regular, GraphicsUnit.Point, 0uy)
            let logWindowForm = LogWindow.createLogWindow "Transactions RUNNER" 100 100 450 600 (Some Color.Black) None (Some font)
            logWindowForm.ScrollBars <- Windows.Forms.RichTextBoxScrollBars.Vertical
            logWindowForm

        let updateTransactionsLog (logWindow : LogWindowForm) (newTransactions : Transaction list) =
            let reportColor = Color.LightGray
            let profitColor = Color.LawnGreen
            let lossColor = Color.Red
            let orderReport oDate oType oQty oPrice =
                let msg = sprintf "%-4s %d for %.5f at %-16s" (GetUnionCaseName oType |> String.ToUpper) oQty oPrice (dateUtcToStr oDate)
                logWindow.BufferWriteLine(msg, reportColor)

            let transactionReport (tr:Transaction) =
                let openTrade = tr.OpenTrade
                let closeTrade = tr.CloseTrade
                let {Side = os; Quantity = oq; Price = oprice; Time = openDate; Type = _ } = openTrade
                let {Side = cs; Quantity = cq; Price = cprice; Time = closeDate; Type = _ } = closeTrade
                assertTrueMsg (os <> cs, sprintf "Order type mismatch. Both OpenTrade %s and CloseTrade %s are of type %s"
                    (dateUtcToStr openDate) (dateUtcToStr closeDate) (GetUnionCaseName os))
                orderReport openDate os oq oprice
                orderReport closeDate cs cq cprice

            logWindow.SuspendLayout()
            newTransactions |> List.iter ( fun newTransaction ->
                transactionReport newTransaction
                let delta = Tester.transactionPAndL newTransaction
                let (deltaMsg, msgColor) =
                    if delta > 0.0 then ("PROFIT", profitColor)
                    elif delta < 0.0 then ("LOSS", lossColor)
                    else ("NUL", reportColor)
                let msg = sprintf "%s % .2f\n" deltaMsg delta
                logWindow.BufferWriteLine(msg, msgColor) )
            logWindow.BufferShow()
            logWindow.ResumeLayout(false)

        // Run the strategy loop function
        let instrument = initialP.Instrument
        let interval = initialP.Interval

        let zEntry = q
        // in a Mock Run we simulate the initial historic data
        let mutable p = if mockRun then initialP.Empty else initialP

        //let mutable idx = 0
        let mutable transactions = List.Empty
        let mutable longTrades = List.Empty
        let mutable shortTrades = List.Empty
        let mutable abortStrat = precondAbort

        let ohlcObservable = BarFeed.createBarFeedObservable instrument interval

        // collect first lookBack bars if needed
        if p.Length < lookBack then
            logfn "Collecting %d missing (up to lookBack = %d) initial %s bars" (lookBack - p.Length) lookBack interval.IntervalSymbol

            let ohlcInitialLookBackSubscriber = ohlcObservable.Subscribe (fun (ohlcBar : PriceDataTuple) ->
                // CALCULATE
                // Get missing bid/ask prices
                if p.Length < lookBack then
                    logfn "Collecting %d out of %d initial bars" (p.Length + 1) lookBack
                    p <- p.AddData ohlcBar
                    if not mockRun then
                        printCollectedBar ohlcBar None )
            
            while p.Length < lookBack do
                Helpers.SleepAsync 50
            // unsubscribe initial bar collector routine
            ohlcInitialLookBackSubscriber.Dispose()

        let stockChart = createStockChart instrument p
        let plChart = createPLChart instrument p []
        let ordersLog = createOrdersLog ()
        let transactionsLog = createTransactionsLog ()

        if not Helpers.mockRun then
            Order.createFxcmOrdersLogWindow() |> ignore
            Trade.createFxcmOpenTradesLogWindow() |> ignore
            Transaction.createFxcmTransactionsLogWindow () |> ignore

        let nmax = 3000
        logfn "Entering main strategy run loop collecting %s OHLC bars" interval.IntervalSymbol
        logfn "Strategy AbortTime = %s, max. no of bars = %d" (dateUtcToStr abortTime) nmax

        let ohlcSubscriber = ohlcObservable.Subscribe (fun (ohlcBar : PriceDataTuple) ->

            // Add new point
            p <- p.AddData ohlcBar
            let n = p.Length - 1
            let mutable idx = n

            let (nextIdx, transactionsResult, longTradesResult, shortTradesResult, abortResult) =
                strategyFunc p idx transactions longTrades shortTrades abortStrat zEntry lookBack

            // update strategy iter values
            idx <- nextIdx
            abortStrat <- abortResult

            let stratPositionHasChanged = longTrades.Length <> List.length longTradesResult || shortTrades.Length <> List.length shortTradesResult
            let stratTransactionsHasChanged = transactions.Length <> List.length transactionsResult

            // update position infos from exchange data. Input are the strategy result positions (used by MockExchange)
            // Wait for real echange systems to update positions in their systems
            if stratPositionHasChanged || stratTransactionsHasChanged then
                if not Helpers.mockRun then
                    Helpers.SleepAsync 500

            let (transactionsExc, longTradesExc, shortTradesExc) = Exchange.getExchangePosition instrument transactionsResult longTradesResult shortTradesResult
            // Any changes in position after strategy run
            let positionHasChanged = longTrades.Length <> List.length longTradesExc || shortTrades.Length <> List.length shortTradesExc
            let transactionsHasChanged = transactions.Length <> List.length transactionsExc

            // new transactions
            let newTransactions =
                match transactionsHasChanged with
                | false -> List.Empty
                | true -> List.except transactions transactionsExc

            // update exchange position values
            transactions <- transactionsExc
            longTrades <- longTradesExc
            shortTrades <- shortTradesExc

            // Update logs
            if mockRun then
                if transactionsHasChanged then
                    updateTransactionsLog transactionsLog newTransactions
                    updatePLChartData plChart p transactions
                if positionHasChanged then
                    updateOrdersLog ordersLog longTrades shortTrades
                // Progress indicator
                if n % (nmax/20) = 0 then
                    logfn "%.1f%% strategy done" <| float (100*n)/float nmax
                    // mockRun is too fast to update chart on every new bar
                    updateStockChartData stockChart p.[max 0 (p.Length - 2*lookBack)..]
            else
                // Print info about newly collected bar
                printCollectedBar ohlcBar (Some idx)
                // Update chart
                updateStockChartData stockChart p.[max 0 (p.Length - 2*lookBack)..]
                // report new position
                if positionHasChanged then
                    // update positions log window
                    updateOrdersLog ordersLog longTrades shortTrades
                // report new transaction
                if transactionsHasChanged then
                    updateTransactionsLog transactionsLog newTransactions
                    // PandL can only change when transactions changes
                    updatePLChartData plChart p transactions
                // beep on changes in position or transactions
                if transactionsHasChanged then
                    beepSoundChoose SystemSound.Asterisk
                elif positionHasChanged then
                    beepSoundChoose SystemSound.Beep
        )

        // strategy run abort conditions
        while p.Length < nmax && DateTimeUtc.UtcNow < abortTime && abortStrat.IsNone do
            Helpers.SleepAsync 200

        // unsubscribe strategy routine
        ohlcSubscriber.Dispose()

        // report back collected timeseries and calculated values
        let (abort, annualAvgReturn, maxDrawDown, transactionsCorrectOrder, pAndL, totalCommissionPay) =
            strategyFinalizer p transactions longTrades shortTrades abortStrat q lookBack allowedDrawDown displayReport
        p, abort, annualAvgReturn, maxDrawDown, transactionsCorrectOrder, pAndL, totalCommissionPay

    let run () =
        ///////////////////////////////////////////////////////////////////
        let currencyInstrument = CurrencyInstrument.EUR_NOK
        let interval = Interval.HOUR_1
        let abortTime = DateTimeUtc(2017, 12, 1, 10, 0, 0, TimeSpan.FromHours 2.0) 

        let allowedDrawDown = 40.0E-2

        let lookBack = 58
        let qval = 2.16
         
        //let strategyFunc = Meanrevert.meanRevertFunc
        let strategyFunc = Bollinger.bollingerFunc
        ///////////////////////////////////////////////////////////////////
        let loginResult = Broker.login ()
        if loginResult.isLeft then failwithf "%s" loginResult.LeftValue
        /// ===========================================
        /// Collect initial lookBack bars from historic prices if they are available
        /// ===========================================
        let now = DateTimeUtc.UtcNow
        let lookBackSpan =
            let intervalSpan = interval.TimeSpan
            // increase lookBackSpan to account for non-trading hours
            TimeSpan.FromTicks(intervalSpan.Ticks * int64 (2*lookBack))
        let dateFrom = now - lookBackSpan
        let dateTo = now

        let intervalSym = interval.IntervalSymbol

        let priceRowData = ForexData.getPrices currencyInstrument intervalSym dateFrom dateTo
        let pInitial = PriceData.OHLCTimeSeries.createFromFxcmData currencyInstrument interval priceRowData
        /// ===========================================
        /// RUN STRATEGY
        /// ===========================================
        let stratRun = strategyRunner pInitial Helpers.mockRun false allowedDrawDown abortTime strategyFunc
        let p, abort, annualAvgReturn, maxDrawDown, transactions, pAndL, totalCommissionPay = stratRun qval lookBack
        /// ===========================================
        /// SHOW RESULTS
        /// ===========================================
        logfn "///////////////////////////////////////////////"
        logfn "STRATEGY RUNNER - OUT OF SAMPLE TEST REPORT\n"
        reportTransactions p transactions
        report p lookBack qval annualAvgReturn allowedDrawDown maxDrawDown pAndL transactions totalCommissionPay
        // report abort
        match abort with
        | Some abortMsg -> logfn "Strategy was ABORTED. Abort message: %s" abortMsg
        | None -> ()

        (*let oufOfSampleTitle =
            sprintf "RUNNER %.2f %% p.a ClosePL %.2f MaxDrawDown %.2f %% NoOfOrders %d" (100.0*annualAvgReturn) pAndL.Last (100.0*maxDrawDown) (2*transactions.Length)
        ignore <| Chart2d.createXYchart oufOfSampleTitle 200 100 800 600 [| 1.0..float pAndL.Length |] pAndL*)

        ///////////////////////////////////////////////////////////////////
        Broker.logout ()
        //p.SaveAs <| sprintf "TIME_SERIES_%s.csv" (currencyInstrument.CurrencySymbols() |> (fun (a, b) -> a + "_" + b))
