namespace Balgor.Data

open System
open System.Drawing

open Balgor.Common
open Balgor.Data.Broker

open Prelude
open Fxcm.Data

open LogWindow

module Trade =

    let private openTradesObservable =
        match Broker.getOpenTradesObservable() with
        | Left err -> failwith <| err.ToString()
        | Right obs ->
            // subscribe updater function
            //obs |> Observable.add (fun (orders : FxcmOrder list) ->
            // return observable
            obs

    let mutable private shortTrades = List.empty
    let mutable private longTrades = List.empty

    // update trades subscription
    openTradesObservable |> Observable.add (fun (trades : Trade list) ->
        let sbTrades = trades |> List.partition (fun t -> t.Side = ContractSide.Sell)
        shortTrades <- fst sbTrades
        longTrades <- snd sbTrades)

    let getLongTrades() =
        longTrades

    let getShortTrades() =
        shortTrades

    /// Create Fxcm Open trades log window
    let createFxcmOpenTradesLogWindow () =
        let font = new Font("Monospace", 12.0f, FontStyle.Bold, GraphicsUnit.Point, 0uy)
        let txtColor = Color.Ivory
        let tradeColor = Color.DeepSkyBlue
        let backColor = Color.Black
        let tradeUpdatesWindow = LogWindow.createLogWindow "Fxcm Trades" 40 500 800 300 (Some backColor) None (Some font)
        // helper fn to add text with specific color
        let addTxt (txt : string, color) =
            tradeUpdatesWindow.BufferWriteLine(txt, color)
        // subscribe to stream
        openTradesObservable |> Observable.add (fun (trades : Trade list) ->
            // Init log window
            tradeUpdatesWindow.SuspendLayout()
            tradeUpdatesWindow.BufferClear()
            match trades with
            | tr when tr.IsEmpty ->
                addTxt("No Open trades", tradeColor)
            | trs ->
                addTxt("Open trades", txtColor)
                trades |> List.iteri (fun idx trade -> addTxt (sprintf "%d | %s" (idx + 1) (trade.ToShortString()), tradeColor))
            // Swap RTF text from dummy RichTextBox
            tradeUpdatesWindow.BufferShow()
            tradeUpdatesWindow.ResumeLayout() )

