namespace AyinExcelAddIn

open System.Drawing
open System.Windows.Forms
open System.Runtime.InteropServices
open ExcelDna
open ExcelDna.Integration
open ExcelDna.Integration.CustomUI
open ExcelDna.XlUtils
open Microsoft.FSharp.Core
open NetOffice

open AyinExcelAddIn
open AyinExcelAddIn.Utils
open AyinExcelAddIn.Gui
open AyinExcelAddIn.Backoffice.BrokerFunctions
open AyinExcelAddIn.Backoffice.QuoteFunctions
open AyinExcelAddIn.RibbonFunctions

/// CustomUI Ribbon class that uses ribbon XML included in the .dna file
[<ComVisible(true)>]
type public AyinRibbon() =
    inherit ExcelRibbon()

    // Execute the given Ribbon function and catch and print any exceptions in a message box.
    let ribbonFuncHelper c rfunc =
        c |> ignore
        handleFuncException rfunc

    member this.Help(c: IRibbonControl) = ribbonFuncHelper c AyinAddIn.help
    member this.MonthlyQuoteReport(c: IRibbonControl) = ribbonFuncHelper c MonthlyQuoteReport
    member this.YtdQuotes(c: IRibbonControl) = ribbonFuncHelper c YtdQuoteReport
    member this.BondQuotes(c: IRibbonControl) = ribbonFuncHelper c BondQuoteReport
    member this.EnterQuote(c: IRibbonControl) = ribbonFuncHelper c (enterQuote >> ignore)
    member this.BrokersDialog(c: IRibbonControl) = ribbonFuncHelper c (brokersDialog >> ignore)
    member this.BondBrokers(c: IRibbonControl) = ribbonFuncHelper c (bondBrokersDialog >> ignore)
    member this.BondTearSheet(c: IRibbonControl) = ribbonFuncHelper c createTearSheet
    member this.SecurityTrades(c: IRibbonControl) = ribbonFuncHelper c SecurityTrades
    member this.BlotterReport(c: IRibbonControl) = ribbonFuncHelper c BlotterReport

    member this.PositionReport(c: IRibbonControl) =
        let p = new Point(Cursor.Position.X, Cursor.Position.Y)
        ribbonFuncHelper c (fun() -> DatePickerInputBox p PositionReport)

    member this.RefreshSheet(c: IRibbonControl) =
        let app = new ExcelApi.Application(null, ExcelDnaUtil.Application)
        let sht = app.ActiveSheet :?> ExcelApi.Worksheet

        match XlWorksheetRefreshUtil.lookup sht with
        | Some f ->
                sht.Cells.Clear() |> ignore
                ribbonFuncHelper () f
        | None -> sht.Calculate |> ignore






