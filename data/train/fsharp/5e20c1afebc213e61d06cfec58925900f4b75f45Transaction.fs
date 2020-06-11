namespace Balgor.Data

open System
open System.Drawing

open Balgor.Common
open Balgor.Data.Broker

open Prelude
open Fxcm.Data

open LogWindow

module Transaction =

    let private transactionsObservable =
        match Broker.getTransactionsObservable() with
        | Left err -> failwith <| err.ToString()
        | Right obs ->
            // subscribe updater function
            //obs |> Observable.add (fun (orders : FxcmOrder list) ->
            // return observable
            obs

    let mutable private transactions = List.Empty

    // update trades subscription
    transactionsObservable |> Observable.add (fun newTransactions ->
        transactions <- newTransactions)

    /// Returns a snapshot of transactions
    let getTransactions() =
        transactions

    /// Create Fxcm Open trades log window
    let createFxcmTransactionsLogWindow () =
        let font = new Font("Monospace", 12.0f, FontStyle.Bold, GraphicsUnit.Point, 0uy)
        let txtColor = Color.Ivory
        let transactionsColor = Color.YellowGreen
        let backColor = Color.Black
        let transactionUpdatesWindow = LogWindow.createLogWindow "Fxcm Transactions" 900 500 800 300 (Some backColor) None (Some font)
        // helper fn to add text with specific color
        let addTxt (txt : string, color) =
            transactionUpdatesWindow.BufferWriteLine(txt, color)
        // helper transactions printer
        let printTransactions (headerMsg : string) (color : Color) (transacList : Transaction list) =
            if not transacList.IsEmpty then
                addTxt (headerMsg, txtColor)
                transacList |> List.iteri (fun idx trans -> addTxt (sprintf "%d | %s" (idx + 1) (trans.ToShortString()), color))

        // subscribe to stream
        transactionsObservable |> Observable.add (fun (transactionsList : Transaction list) ->
        // Init log window
        transactionUpdatesWindow.SuspendLayout()
        transactionUpdatesWindow.BufferClear()
        match transactionsList with
        | tr when tr.IsEmpty ->
            addTxt("No transactions", transactionsColor)
        | trs ->
            printTransactions "Transactions:" transactionsColor trs
        // Show logWindow buffer content
        transactionUpdatesWindow.BufferShow()
        transactionUpdatesWindow.ResumeLayout())
