namespace Balgor.Data.Offer

open System

open Balgor.Common
open Balgor.Statistics.Smoothing
open Balgor.Data.Offer
open Balgor.Data.Broker

open Prelude.Data

module BarFeed =

    let private offersMapObservable = Offer.offersMapObservable

    let createBarFeedObservable instrument (interval : Interval) : IObservable<PriceDataTuple> =
        let ohlcSpan = interval.TimeSpan
        let calcOHLCBar (collectTime : DateTimeUtc) (collOffers : Offer list) =
            let extractBid o = o.Bid
            let extractAsk o = o.Ask
            // Collected offers is a List i.e. newest/close values are List.Head, oldest/open values are List.Last
            //let dt = List.head collOffers |> (fun o -> o.Time)
            let bo = List.last collOffers |> extractBid
            let bh = List.maxBy extractBid collOffers |> extractBid
            let bl = List.minBy extractBid collOffers |> extractBid
            let bc = List.head collOffers |> extractBid
            let oo = List.last collOffers |> extractAsk
            let oh = List.maxBy extractAsk collOffers |> extractAsk
            let ol = List.minBy extractAsk collOffers |> extractAsk
            let oc = List.head collOffers |> extractAsk
            // volume is 'active time' weighted average of all collected volumes
            let vol =
                match collOffers.Length with
                | 1 -> collOffers.Head.Volume
                | _ ->
                    let offerTimesArr = collectTime :: List.map (fun (o : Offer) -> o.Time) collOffers |> Array.ofList
                    let offerVolArr = List.map (fun o -> float o.Volume) collOffers |> Array.ofList
                    let barTicks = float ohlcSpan.Ticks
                    let volWeights = [|
                        for i = 0 to offerTimesArr.Length - 2 do
                            let activeTime = offerTimesArr.[i] - offerTimesArr.[i + 1]
                            yield float activeTime.Ticks/barTicks |]
                    int (dotProduct volWeights offerVolArr)
            (collectTime, bo, bh, bl, bc, oo, oh, ol, oc, vol)

        // the new observable
        let barFeedSource = new ObservableSource<PriceDataTuple>()
        let barFeedObservable = barFeedSource.AsObservable
        // list of collected offers for the current OHLC bar
        let mutable collectedOffers = List.empty
        let mutable collectStart : DateTimeUtc option = None
        // filter offersObservable for instrument
        let instrumentOffersObservable = offersMapObservable |> Observable.filter (fun (offerId : string, newOffersMap) ->
             let newOffer : Offer = Map.find offerId newOffersMap
             // new offer is for the instrument and it is not disabled/view only but Tradable
             newOffer.Instrument = instrument && newOffer.SubscriptionStatus = "T")
        // add the collector routine
        instrumentOffersObservable |> Observable.add (fun (offerId : string, newOffersMap) ->
            let newOffer : Offer = Map.find offerId newOffersMap
            let time = newOffer.Time

            match collectStart with
            | None ->
                // collection not started yet
                collectedOffers <- [ newOffer ]
                collectStart <- Some time

            | Some startTime when time - startTime < ohlcSpan ->
                // partially collected OHLC bar
                collectedOffers <- newOffer :: collectedOffers

            | Some startTime ->
                // OHLC bar time elapsed - emit bar and clear collected data
                let barCollectTime = startTime + ohlcSpan
                let bar = calcOHLCBar barCollectTime collectedOffers
                barFeedSource.Next bar
                collectStart <- Some barCollectTime
                collectedOffers <- [ newOffer ]
        )
        // subscribe the given instrument to offer updates at the broker
        let subscribed = Broker.offerSubscribe instrument.InstrumentSymbol
        // return created observable
        barFeedObservable

