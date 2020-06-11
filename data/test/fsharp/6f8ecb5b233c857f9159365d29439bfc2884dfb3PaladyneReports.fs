namespace AyinExcelAddIn.RibbonFunctions

open System
open ExcelDna.Integration
open ExcelDna.XlUtils
open ExcelDna.XlWorksheetRefreshUtil
open FSharpx
open NetOffice.ExcelApi
open NetOffice.ExcelApi.Enums

open AyinExcelAddIn
open AyinExcelAddIn.Utils
open AyinExcelAddIn.Backoffice
open AyinExcelAddIn.Gui

[<AutoOpen>]
module PaladyneReports = 

    /// 
    let private tradeHdrs = 
        ["Trade Type"; "Fund"; "Broker"; "Currency"; "Trade Date"; "Settlement Date"; "Price"; "Orig Face"; 
         "Factor"; "Quantity"; "Accrued"; "Market Value"; "Commission and Fees"; "Total"]

    /// 
    let formatOptDecimal d =
        match d with
        | None -> box null
        | Some x -> box x 

    /// 
    let renderTrades (app: Application) (sht: Worksheet) (ts: Trade.T list) (displaySecurityInfo: bool) = 
            let cells = sht.Cells
            let numTrades = ts.Length
            let (hdrs, nColumns, cOffset) =
                if displaySecurityInfo then
                    ("Security" :: "CUSIP/ISIN" :: "Security Type" :: tradeHdrs, tradeHdrs.Length + 3, 3)
                else 
                    (tradeHdrs, tradeHdrs.Length, 0)
            
            // Render the header row
            hdrs |> List.iteri (fun i h -> cells.[1, i + 1].Value <- h)
            let hdrRange = sht.Range(cells.[1, 1], cells.[1, nColumns])
            let hdrBorder = hdrRange.Borders.[XlBordersIndex.xlEdgeBottom]
            hdrRange.Font.Bold <- true
            hdrRange.HorizontalAlignment <- XlHAlign.xlHAlignCenter
            hdrBorder.Weight <- 3
            hdrBorder.LineStyle <- XlLineStyle.xlContinuous

            // Render the trades
            ts
            |> List.iteri (fun i t -> cells.[2 + i, 1].Value <- t.security.symbol
                                      cells.[2 + i, 2].Value <- t.security.cusip.GetOrElse(t.security.isin.GetOrElse(""))
                                      cells.[2 + i, 3].Value <- t.security.sectype.ToString()
                                      cells.[2 + i, 1 + cOffset].Value <- t.tradeType.ToString()
                                      cells.[2 + i, 2 + cOffset].Value <- t.fund
                                      cells.[2 + i, 3 + cOffset].Value <- t.broker.GetOrElse("")
                                      cells.[2 + i, 4 + cOffset].Value <- t.currency.ToString()
                                      cells.[2 + i, 5 + cOffset].Value <- t.tradeDate
                                      cells.[2 + i, 6 + cOffset].Value <- t.settleDate
                                      cells.[2 + i, 7 + cOffset].Value <- t.price
                                      cells.[2 + i, 8 + cOffset].Value <- (t.quantity / t.factor)
                                      cells.[2 + i, 9 + cOffset].Value <- t.factor 
                                      cells.[2 + i, 10 + cOffset].Value <- t.quantity
                                      cells.[2 + i, 11 + cOffset].Value <- t.accrued
                                      cells.[2 + i, 12 + cOffset].Value <- t.notional
                                      cells.[2 + i, 13 + cOffset].Value <- t.commission  
                                      cells.[2 + i, 14 + cOffset].Value <- t.totalAmnt
                                     )

            let dataRange = sht.Range(cells.[2, 1], cells.[numTrades + 1, nColumns])
            dataRange.Font.Color <- 0x7D491F

            // Format the columns
            sht.Range(cells.[2, 5 + cOffset], cells.[numTrades + 1, 5 + cOffset]).NumberFormat <- "MM/dd/yyyy"
            sht.Range(cells.[2, 6 + cOffset], cells.[numTrades + 1, 6 + cOffset]).NumberFormat <- "MM/dd/yyyy"
            sht.Range(cells.[2, 7 + cOffset], cells.[numTrades + 1, 7 + cOffset]).NumberFormat <- "#,##0.00000"
            sht.Range(cells.[2, 8 + cOffset], cells.[numTrades + 1, 8 + cOffset]).NumberFormat <- "#,##0"
            sht.Range(cells.[2, 9 + cOffset], cells.[numTrades + 1, 9 + cOffset]).NumberFormat <- "#,##0.0000"
            sht.Range(cells.[2, 10 + cOffset], cells.[numTrades + 1, 10 + cOffset]).NumberFormat <- "#,##0.0000"
            sht.Range(cells.[2, 11 + cOffset], cells.[numTrades + 1, 11 + cOffset]).NumberFormat <- "#,##0.0000"
            sht.Range(cells.[2, 12 + cOffset], cells.[numTrades + 1, 12 + cOffset]).NumberFormat <- "#,##0.00"
            sht.Range(cells.[2, 13 + cOffset], cells.[numTrades + 1, 13 + cOffset]).NumberFormat <- "#,##0.0000"
            sht.Range(cells.[2, 14 + cOffset], cells.[numTrades + 1, 14 + cOffset]).NumberFormat <- "#,##0.00_);(#,##0.00);"

            // Make sure everything fits
            sht.Columns.AutoFit() |> ignore
            sht.Rows.AutoFit() |> ignore
            // Freeze pane
            app.ActiveWindow.SplitRow <- 1
            app.ActiveWindow.FreezePanes <- true

    /// 
    let public SecurityTrades () = 
        match SimpleInputBox "Security Trades" "Security symbol or CUSIP" None with
        | Cancel | Ok "" -> ()
        | Ok s -> match Trade.getSecurityTrades s with
                  | [] -> ErrorBox <| "No trades for: " + s
                  | (t1 :: _) as ts  -> 
                    let app = new Application(null, ExcelDnaUtil.Application)
                    let sht = app.Sheets.AddOrReplace(t1.security.symbol + " Trades")
                    registerShtRefresher sht.Name (fun () -> renderTrades app sht ts false)

                    renderTrades app sht ts false

    /// 
    let public BlotterReport () = 
        match DateRangeInputBox "Trade Blotter" with
        | Cancel -> ()
        | Ok (sd, ed) -> match Trade.getTradesByDate sd ed with
                         | [] -> ErrorBox <| "No trades"
                         | ts  -> 
                         let app = new Application(null, ExcelDnaUtil.Application)
                         let sht = app.Sheets.AddWithIncrement("Trade Blotter")
                         registerShtRefresher sht.Name (fun () -> renderTrades app sht ts true)

                         renderTrades app sht ts true

    /// 
    let private positionHdrs = 
        ["Security"; "CUSIP/ISIN"; "Security Type"; "Fund"; "Currency"; "Collateral"; 
         "Orig Face"; "Position"; "Unit Cost"; "Last Price"; "Market Value"; "Coupon"]

    /// 
    let private positionReport (app: Application) (sht: Worksheet) (d: DateTime) (positions: Position.T list option) =
        let ps = positions.GetOrElse(Position.getPositions d)

        let cells = sht.Cells
        let numPos = ps.Length

        // Render the header row
        positionHdrs |> List.iteri (fun i h -> cells.[1, i + 1].Value <- h)
        let hdrRange = sht.Range(cells.[1, 1], cells.[1, positionHdrs.Length])
        let hdrBorder = hdrRange.Borders.[XlBordersIndex.xlEdgeBottom]
        hdrRange.Font.Bold <- true
        hdrRange.HorizontalAlignment <- XlHAlign.xlHAlignCenter
        hdrBorder.Weight <- 3
        hdrBorder.LineStyle <- XlLineStyle.xlContinuous

        // Render the positions
        ps
        |> List.filter (fun p -> p.security.sectype <> Security.CURRENCY)
        |> List.sortBy (fun p -> (p.collateral, p.security.symbol))
        |> List.iteri (fun i p -> cells.[2 + i, 1].Value <- p.security.symbol
                                  cells.[2 + i, 2].Value <- p.security.cusip.GetOrElse(p.security.isin.GetOrElse(""))
                                  cells.[2 + i, 3].Value <- p.security.sectype.ToString()
                                  cells.[2 + i, 4].Value <- p.fund
                                  cells.[2 + i, 5].Value <- p.currency.ToString()
                                  cells.[2 + i, 6].Value <- p.collateral.GetOrElse("")
                                  cells.[2 + i, 7].Value <- p.origFace
                                  cells.[2 + i, 8].Value <- p.quantity
                                  cells.[2 + i, 9].Value <- p.unitCost
                                  cells.[2 + i, 10].Value <- p.lastPrice
                                  cells.[2 + i, 11].Value <- p.marketVal
                                  cells.[2 + i, 12].Value <- p.rate
                       )

        let dataRange = sht.Range(cells.[2, 1], cells.[numPos + 1, positionHdrs.Length])
        dataRange.Font.Color <- 0x7D491F

        // Format the columns 
        sht.Range(cells.[2, 7], cells.[numPos + 1, 7]).NumberFormat <- "#,##0"
        sht.Range(cells.[2, 8], cells.[numPos + 1, 8]).NumberFormat <- "#,##0.00_);(#,##0.00);"
        sht.Range(cells.[2, 9], cells.[numPos + 1, 9]).NumberFormat <- "#,##0.0000"
        sht.Range(cells.[2, 10], cells.[numPos + 1, 10]).NumberFormat <- "#,##0.0000"
        sht.Range(cells.[2, 11], cells.[numPos + 1, 11]).NumberFormat <- "#,##0.00_);(#,##0.00);"
        sht.Range(cells.[2, 12], cells.[numPos + 1, 12]).NumberFormat <- "#,##0.00"

        // Make sure everything fits
        sht.Columns.AutoFit() |> ignore
        sht.Rows.AutoFit() |> ignore
        // Freeze pane
        app.ActiveWindow.SplitRow <- 1
        app.ActiveWindow.FreezePanes <- true

    let public PositionReport d =
        match Position.getPositions d with
        | [] -> ErrorBox <| "No position info for: " + d.ToString("MM/dd/yyyy")
        | ps -> 
            let app = new Application(null, ExcelDnaUtil.Application)
            let sht = app.Sheets.AddOrReplace((d.ToString("yyyyMMdd") + " Positions"))
            registerShtRefresher sht.Name (fun () -> positionReport app sht d None)

            positionReport app sht d (Some ps)


