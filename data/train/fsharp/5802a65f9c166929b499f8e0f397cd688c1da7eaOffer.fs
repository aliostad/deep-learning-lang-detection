namespace Balgor.Data.Offer

open System
open System.Drawing

open Balgor.Common
open Balgor.Common.Helpers
open Balgor.Data
open Balgor.Data.Broker

open Prelude
open Prelude.ModuleExtensions

open Fxcm.Data

open LogWindow

module Offer =

    let offersMapObservable =
        match Broker.getOffersObservable() with
        | Left err -> failwith <| err.ToString()
        | Right obs ->
            // subscribe updater function
            obs 

    let mutable private offersMap : Map<string, Offer> = Map.empty

    let getOffer instrument =
        let offers = offersMap |> Map.toList |> List.map snd
        List.tryFind (fun (o:Offer) -> o.Instrument = instrument) offers


    /// Create Fxcm offers log window
    let createFxcmOffersLogWindow () =
        let font = new Font("Monospace", 12.0f, FontStyle.Regular, GraphicsUnit.Point, 0uy)
        let offerUpdatesWindow = LogWindow.createLogWindow "Fxcm Offers" 100 100 1100 100 (Some Color.Black) None (Some font)
        let oldColor = Color.LightBlue
        let newUpColor = Color.Green
        let newDownColor = Color.Red
        // helper fn to add text with specific color
        let addTxt (txt : string) (c : Color) =
            offerUpdatesWindow.BufferWrite(txt, c)
        // convert map to Seq
        let offerMapToSeq (offerMap : Map<string, Offer>) =
            // sort by currency
            offerMap |> Map.toSeq |> Seq.map snd |> Seq.sortBy (fun o -> o.Instrument)

        match Broker.getOffersMap() with
        | Left err -> ()
        | Right fxcmOfferMap ->
            // save previous offers map
            let mutable oldOffers = offerMapToSeq fxcmOfferMap
            // create offers subscription
            offersMapObservable |> Observable.add (fun (offerId : string, newOffersMap) ->
                let newOffers = newOffersMap |> Map.toSeq |> Seq.map snd |> Seq.sortBy (fun o -> o.Instrument)
                let subscribedNewOffers = newOffers |> Seq.filter (fun o -> o.SubscriptionStatus = "T")
                if not <| Seq.isEmpty subscribedNewOffers then
                    // Init log window
                    offerUpdatesWindow.SuspendLayout()
                    offerUpdatesWindow.BufferClear()
                    // print newly added offers with different color
                    let printFxcmOffer (o : Offer) (n : Offer) =
                        let spreadN = abs(n.Bid - n.Ask) / n.PipSize
                        let dtimeStr = n.Time.ToString("HH:mm:ss")
                        if o = n then
                            let lineTxt =
                                sprintf "%s %s Bid %.5f Ask %.5f Spread %.1f Vol %d Hi %.5f Lo %.5f RollB %.2f RollS %.2f %s\n"
                                    n.Instrument.InstrumentSymbol dtimeStr n.Bid n.Ask spreadN n.Volume n.High n.Low n.BuyInterest n.SellInterest n.TradingStatus
                            addTxt lineTxt oldColor
                        else
                            let calcColor oldVal newVal =
                                match compare newVal oldVal with
                                | 0 -> oldColor
                                | res when res > 0 -> newUpColor
                                | _ -> newDownColor
                            let spreadO = abs(o.Bid - o.Ask) / n.PipSize
                            addTxt n.Instrument.InstrumentSymbol oldColor
                            addTxt (sprintf " %s" dtimeStr) newUpColor
                            addTxt (sprintf " Bid %.5f" n.Bid) <| calcColor o.Bid n.Bid
                            addTxt (sprintf " Ask %.5f" n.Ask) <| calcColor o.Ask n.Ask
                            addTxt (sprintf " Spread %.1f" spreadN) <| calcColor spreadO spreadN
                            addTxt (sprintf " Vol %d" n.Volume) <| calcColor o.Volume n.Volume
                            addTxt (sprintf " Hi %.5f" n.High) <| calcColor o.High n.High
                            addTxt (sprintf " Lo %.5f" n.Low) <| calcColor o.Low n.Low
                            addTxt (sprintf " RollB %.2f" n.BuyInterest) <| calcColor o.BuyInterest n.BuyInterest
                            addTxt (sprintf " RollS %.2f" n.SellInterest) <| calcColor o.SellInterest n.SellInterest
                            addTxt (sprintf " %s\n" n.TradingStatus) oldColor
                    Seq.iter2 printFxcmOffer oldOffers subscribedNewOffers
                    // Swap RTF text from dummy RichTextBox buffer
                    offerUpdatesWindow.BufferShow()
                    offerUpdatesWindow.ResumeLayout()
                    // update previous offers
                    oldOffers <- subscribedNewOffers
                    // update current offers
                    subscribedNewOffers |> Seq.iter (fun o -> offersMap <- offersMap.Add(o.OfferId, o)) )

    if not Helpers.mockRun then
        createFxcmOffersLogWindow ()
