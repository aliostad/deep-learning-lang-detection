namespace Balgor

open System

open Balgor.Common
open Balgor.Common.Helpers
open Balgor.Data
open Balgor.Data.Broker
open Balgor.Statistics
open Balgor.Strategy

open Prelude


module Program =

    let startProgram() =

        // STRATEGY
        //beepSound()
        //Tester.test()
        Runner.run() 

        //(*
        /////////////////////////////////////////////////////////
        let currencyInstrument = CurrencyInstrument.AUD_NZD
        let interval = Interval.DAY_1

        let dateFrom = "02.01.2016" // MM.DD.YYYY
        let dateTo =   "03.01.2016" // MM.DD.YYYY
        /////////////////////////////////////////////////////////
        let curr1, curr2 = currencyInstrument.CurrencySymbols()
        let intervalSym = interval.IntervalSymbol

        match Broker.login () with
        | Left err -> failwith <| err.ToString()
        | Right _ -> ()

        let oSub = Broker.offerSubscribe currencyInstrument.InstrumentSymbol
        if not oSub then failwithf "Broker.offerSubscribe failed"
        //let oUnsub = Broker.offerUnsubscribeAll (CurrencyInstrument.AllCurrencySymbols())
        let off =
            match Broker.getOffer currencyInstrument with
            | Left err -> failwith <| err.ToString()
            | Right offer -> offer
        let myPrice = off.Ask + 4.0*off.PipSize

        Order.createFxcmOrdersLogWindow() |> ignore
        Trade.createFxcmOpenTradesLogWindow() |> ignore
        Transaction.createFxcmTransactionsLogWindow () |> ignore
        (*
        let createdEntryOrderOpt = Broker.createEntryOrder currencyInstrument 1 myPrice ContractSide.Buy
        match createdEntryOrderOpt with
        | Left err -> logfn "Broker.createEntryOrder ERROR: %s" <| err.ToString()
        | Right orders -> logfn "Broker.createEntryOrder success"
        *)
        (*
        let createdMarketOrderOpt = Broker.createMarketOrder currencyInstrument 1 myPrice ContractSide.Buy
        match createdMarketOrderOpt with
        | Left err -> logfn "Broker.createMarketOrder ERROR: %s" <| err.ToString()
        | Right orders -> logfn "Broker.createMarketOrder success"
        *)

        let ordersOpt = Broker.getOrders ()
        match ordersOpt with
        | Left err -> logfn "Broker.getOrders ERROR: %s" <| err.ToString()
        | Right orders ->
            logfn "Broker.getOrders success"
            Broker.printOrders orders

        let openTradesOpt = Broker.getOpenTrades ()
        match openTradesOpt with
        | Left err -> logfn "Broker.getOpenTrades ERROR: %s" <| err.ToString()
        | Right openTrades ->
            logfn "Broker.getOpenTrades success"
            logfn "Open trades:"
            Broker.printTrades openTrades 

        let previouslyClosedTradesOpt = Broker.getHistoricClosedTrades ()
        match previouslyClosedTradesOpt with
        | Left err -> logfn "Broker.getHistoricClosedTrades ERROR: %s" <| err.ToString()
        | Right previouslyClosedTrades ->
            logfn "Broker.getHistoricClosedTrades success"
            logfn "Historic closed trades:"
            Broker.printFxcmTrades previouslyClosedTrades
        
        let closeAllOpenTradesOpt = Broker.closeAllOpenTrades ()
        match closeAllOpenTradesOpt with
        | Left err -> logfn "Broker.closeAllOpenTrades ERROR: %s" <| err.ToString()
        | Right () -> logfn "Broker.closeAllOpenTrades success"

        let deleteAllOrdersOpt = Broker.deleteAllOrders ()
        match deleteAllOrdersOpt with
        | Left err -> logfn "Broker.deleteAllOrders ERROR: %s" <| err.ToString()
        | Right msg -> logfn "Broker.deleteAllOrders success: %s" msg

        Broker.logout ()
        //let prices = Broker.getPrices curr1 curr2 intervalSym (DateTimeUtc.Parse dateFrom) (DateTimeUtc.Parse dateTo)
        let prices = List.empty<Fxcm.PriceDataTuple>
        let p = PriceData.OHLCTimeSeries.createFromFxcmRowSeq(currencyInstrument, interval, prices)
        let np = p.Length
        //*)

        //let ma = Smoothing.expMovingAvg p.BidClose (p.BidClose.Length/40)
        //let resXY4 = Chart2d.createXYchart "expMovingAvg" 200 100 800 600 [|1.0..float ma.Length|] ma 

        //let mastd = Smoothing.movingStdDev p.BidClose (p.BidClose.Length/40)
        //let resXY4 = Chart2d.createXYchart "movingStdDev" 200 100 800 600 [|1.0..float mastd.Length|] mastd

        //let avg = Seq.average p.BidClose
        //let tmp = [| for i in 1..1000 do yield! p.BidClose |]
        //let std = time (fun () -> Distributions.stddev tmp)
        //let normal = Distributions.normal 10.0 1.0 100
        //let autocrr = Distributions.autoCorrelation p.BidClose 200

        //let lag1 = Timeseries.lagDiff 1 p.OfferClose |> Array.skip 1
        //let lag24 = Timeseries.lagDiff 24 p.OfferClose |> Array.skip 24
        // HURST EXPONENT
        //let hrstBad = Distributions.hurstExp p.BidClose
        //let hrstR1 = Unitroot.hurstexp p.BidClose
        //let hrstR2 = Unitroot.hurstexp lag24

        // HALF-LIFE
        //let lg = 1
        //let tsdata = Smoothing.expMovingAvg p.BidOpen (p.BidOpen.Length/40)
        //let tsdata = p.BidClose
        //let laggedY = Timeseries.lag lg tsdata |> Array.skip lg
        //let deltaY = Timeseries.lagDiff lg tsdata |> Array.skip lg
        //let (alpha, beta) = Distributions.linearReg laggedY deltaY
        //let hlife = -log(2.0)/beta

        // UNIT ROOT TESTS
        // If we reject H0 then we presume there is no unit root.
        // If we fail to reject H0 (i.e. p > 0.05) then we presume a unit root exists
        // According to Chen: Test whether we can reject H0 that the Mean Reverting constant is zero and conclude that it's not zero i.e. that it's mean reverting
        // If we fail to reject H0, then we take that H0 is true i.e. data is a random walk and a unit root is present
        //let adfur = Unitroot.adf p.BidClose Unitroot.AdfType.Constant 24
        //let adfur24 = Unitroot.adf lag24 Unitroot.AdfType.Constant 24
        //let ppur = Unitroot.pp lag24 Unitroot.PPType.ZAlpha Unitroot.PPModel.Constant
        // ERS is detrended ADF
        // H0: it's NOT stationary or trend stationary, rejection of H0 means H1: it IS stationary
        //let ersur = Unitroot.ers p.BidClose Unitroot.ERSType.DF_GLS Unitroot.ERSModel.Constant
        //let ersur1 = Unitroot.ers lag1 Unitroot.ERSType.DF_GLS Unitroot.ERSModel.Constant
        //let ersur24 = Unitroot.ers lag24 Unitroot.ERSType.DF_GLS Unitroot.ERSModel.Constant
        // if kpss (H0: it's stationary or trend stationary) is rejected then it means it's not stationary or trend-stationary
        //let kpssur = Unitroot.kpss p.BidClose Unitroot.KPSSType.Mu Unitroot.KPSSLags.Short
        //let kpssur1 = Unitroot.kpss lag1 Unitroot.KPSSType.Tau Unitroot.KPSSLags.Short
        //let kpssur24 = Unitroot.kpss lag24 Unitroot.KPSSType.Tau Unitroot.KPSSLags.Short
        //////////////////////////////////////////////
        (*let n = 61
        let zgen (x:float) (y:float) = 3.0 * Math.Pow((1.0 - x), 2.0) * Math.Exp(-x * x - (y + 1.0) * (y + 1.0)) - 10.0 * (0.2 * x - Math.Pow(x, 3.0)- Math.Pow(y, 5.0)) * Math.Exp(-x * x - y * y) - 1.0/3.0 * Math.Exp(-(x + 1.0) * (x + 1.0) - y * y)
        let xd = [| for i in 0..n-1 -> -3.0 + 6.0*float i/(float (n-1)) |]
        let yd = [| for i in 0..n-1 -> -4.0 + 8.0*float i/(float (n-1)) |]
        let zd = Array2D.init n n (fun i j -> zgen xd.[i] yd.[j])
        let res3 = Chart3d.createXYZchart "alat" 200 100 800 600 xd yd zd*)
        // only works on external console
        readKeyConsoleApp "\nPress any key to exit..."
        ()
