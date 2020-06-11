namespace Balgor.Data

open System
open System.Drawing

open Balgor.Common
open Balgor.Data.Broker
open Balgor.Data.Offer

open Prelude
open Prelude.Data

open Fxcm.Data

open LogWindow

module Order =

    /// Searches for CurrencyInstrument based on offerId
    (*let private getInstrumentFromOfferId =
        memoize (fun (offerId : string) ->
            match Broker.getOffersMap() with
            | Left err -> failwith "Error getting offers map from broker"
            | Right offerMap ->
                let offers = offerMap |> Map.toSeq |> Seq.map snd
                let offerIdOffer = offers |> Seq.filter (fun o -> o.OfferId = offerId) |> Seq.head
                let instrument = offerIdOffer.Instrument
                instrument)*)

    /// Converts FxcmOrder list to Order list
    let private convertFxcmOrders (fxcmOrders : FxcmOrder list) =
        List.map Order.ConvertFromFxcmOrder fxcmOrders

    (*let private executingOrdersSource = new ObservableSource<Order list>()
    let private executedOrdersSource = new ObservableSource<Order list>()
    let private canceledOrdersSource = new ObservableSource<Order list>()
    let private rejectedOrdersSource = new ObservableSource<Order list>()*)

    let private allOrdersObservable =
        match Broker.getOrdersObservable() with
        | Left err -> failwith <| err.ToString()
        | Right obs ->
            // subscribe updater function
            obs 
            (*obs |> Observable.add (fun (orders : FxcmOrder list) ->
            let executingFxcmOrders = orders |> List.filter (fun o -> o.State = FxcmOrderState.Executing)
            let executedFxcmOrders = orders |> List.filter (fun o -> o.State = FxcmOrderState.Executed)
            let canceledFxcmOrders = orders |> List.filter (fun o -> o.State = FxcmOrderState.Canceled)
            let rejectedFxcmOrders = orders |> List.filter (fun o -> o.State = FxcmOrderState.Rejected)
            executingOrdersSource.Next(convertFxcmOrders executingFxcmOrders)
            executedOrdersSource.Next(convertFxcmOrders executedFxcmOrders)
            canceledOrdersSource.Next(convertFxcmOrders canceledFxcmOrders)
            rejectedOrdersSource.Next(convertFxcmOrders rejectedFxcmOrders))*)
            // return observable

    let mutable private executingOrders = List.empty
    let mutable private executedOrders = List.empty
    let mutable private canceledOrders = List.empty
    let mutable private rejectedOrders = List.empty

    // update orders subscription
    allOrdersObservable |> Observable.add (fun (orders : Order list) ->
        executingOrders <- orders |> List.filter (fun o -> o.State = OrderState.Executing)
        executedOrders <- orders |> List.filter (fun o -> o.State = OrderState.Executed)
        canceledOrders <- orders |> List.filter (fun o -> o.State = OrderState.Canceled)
        rejectedOrders <- orders |> List.filter (fun o -> o.State = OrderState.Rejected))

    let getExecutingOrders() = executingOrders
    let getExecutedOrders() = executedOrders
    let getCanceledOrders() = canceledOrders
    let getRejectedOrders() = rejectedOrders

    (*let executingOrdersObservable = executingOrdersSource.AsObservable
    let executedOrdersObservable = executedOrdersSource.AsObservable
    let canceledOrdersObservable = canceledOrdersSource.AsObservable
    let rejectedOrdersObservable = rejectedOrdersSource.AsObservable*)

    /// Create Fxcm Orders log window
    let createFxcmOrdersLogWindow () =
        let font = new Font("Monospace", 12.0f, FontStyle.Bold, GraphicsUnit.Point, 0uy)
        let txtColor = Color.Ivory
        let executingColor = Color.OrangeRed
        let executedColor = Color.LimeGreen
        let canceledColor = Color.Yellow
        let rejectedColor = Color.DeepPink
        let orderUpdatesWindow = LogWindow.createLogWindow "Fxcm Orders" 50 40 1600 300 (Some Color.Black) None (Some font)
        // helper fn to add text with specific color
        let addTxtLine (txt : string) (color : Color) =
            orderUpdatesWindow.BufferWriteLine(txt, color)

        allOrdersObservable |> Observable.add (fun (orders : Order list) ->
            // Init log window
            orderUpdatesWindow.SuspendLayout()
            orderUpdatesWindow.BufferClear()
            let stateGroupedOrders = List.groupBy (fun (order : Order) -> order.State) orders
            let executingFxcmOrders = orders |> List.filter (fun o -> o.State = OrderState.Executing)
            let executedFxcmOrders = orders |> List.filter (fun o -> o.State = OrderState.Executed)
            let canceledFxcmOrders = orders |> List.filter (fun o -> o.State = OrderState.Canceled)
            let rejectedFxcmOrders = orders |> List.filter (fun o -> o.State = OrderState.Rejected)
            if not executingFxcmOrders.IsEmpty then
                addTxtLine "EXECUTING" txtColor
                executingFxcmOrders |> List.iteri (fun idx order -> let msg = sprintf "%d | %s" (idx + 1) <| order.ToShortString() in addTxtLine msg executingColor)
            if not executedFxcmOrders.IsEmpty then
                addTxtLine "EXECUTED" txtColor
                executedFxcmOrders |> List.iteri (fun idx order -> let msg = sprintf "%d | %s" (idx + 1) <| order.ToShortString() in addTxtLine msg executedColor)
            if not canceledFxcmOrders.IsEmpty then
                addTxtLine "CANCELED" txtColor
                canceledFxcmOrders |> List.iteri (fun idx order -> let msg = sprintf "%d | %s" (idx + 1) <| order.ToShortString() in addTxtLine msg canceledColor)
            if not rejectedFxcmOrders.IsEmpty then
                addTxtLine "REJECTED" txtColor
                rejectedFxcmOrders |> List.iteri (fun idx order -> let msg = sprintf "%d | %s" (idx + 1) <| order.ToShortString() in addTxtLine msg rejectedColor)
            // Swap RTF text from dummy RichTextBox. This avoids RichTextBox flicker
            orderUpdatesWindow.BufferShow()
            orderUpdatesWindow.ResumeLayout() )
