namespace AyinExcelAddIn.Backoffice

open System
open System.Collections.Generic
open System.Diagnostics
open System.Drawing
open System.Linq
open System.Windows
open ExcelDna.Integration
open ExcelDna.XlUtils
open ExcelDna.XlWorksheetRefreshUtil
open FSharpx
open FSharpx.Functional
open NetOffice.ExcelApi
open NetOffice.ExcelApi.Enums
open MathNet.Numerics.Statistics
open Microsoft.FSharp.Reflection

open AyinExcelAddIn
open AyinExcelAddIn.Utils
open AyinExcelAddIn.Backoffice
open AyinExcelAddIn.Business
open AyinExcelAddIn.Business.Utils
open AyinExcelAddIn.Gui

[<AutoOpen>]
module QuoteFunctions =

  // Custom coparator that ensures when comparing brokers, 
    // IDC will always be the first
    let private idcFirstBrCmpr ((br1 : Broker.T), _) ((br2 : Broker.T), _) = 
        match (br1.name, br2.name) with
        | ("IDC", _) -> -1
        | (_, "IDC") -> 1
        | _ -> compare br1.name br2.name
    
    // Custom coparator that ensures when comparing brokers, 
    // IDC will always be the last
    let private idcLastBrCmpr (br1 : Broker.T) (br2 : Broker.T) = 
        match (br1.name, br2.name) with
        | ("IDC", _) -> 1
        | (_, "IDC") -> -1
        | _ -> compare br1.name br2.name
    
    //
    //
    //
    let private monthEnds (sd : DateTime) (ed : DateTime) = 
        Seq.initInfinite (fun i -> monthEnd <| ed.AddMonths(-i))
        |> Seq.takeWhile (fun d -> d >= sd)
        |> Seq.toList
        |> List.rev
    
    ///    
    let idcBroker = either (Broker.getBrokerByName "IDC") failwith id
    
    ///
    ///
    ///
    let monthlyBondQuote (id, broker, date) = 
        let bond = 
            match getDealBond id with
            | BondInfo b -> 
                match b.security with
                | None -> failwith "#N/A Invalid bond"
                | _ -> b
            | DealInfo _ -> failwith "#N/A Invalid bond"
            | NoInfo -> failwith "#N/A Invalid bond"
        
        let sd = monthStart date
        let ed = monthEnd date
        let br = either (Broker.getBrokerByName broker) failwith Operators.id
        Quote.mostRecentQuote bond.security.Value br sd ed
    
    ///
    ///
    ///
    let aggrBondQuote (id, date) = 
        let bond = 
            match getDealBond id with
            | BondInfo b -> 
                match b.security with
                | None -> failwith "#N/A Invalid bond"
                | _ -> b
            | DealInfo _ -> failwith "#N/A Invalid bond"
            | NoInfo -> failwith "#N/A Invalid bond"
        
        let sd = monthStart date
        let ed = monthEnd date
        
        // Calculates the aggregate quote value for a given period
        let calcAggrQuote (qs : Quote.T list) = 
            let qs' = 
                match qs.Length % 2 with
                | 0 -> qs |> List.filter (fun q -> q.broker.name <> "IDC")
                | _ -> qs
            match qs' with
            | [] -> None
            | _ -> 
                qs'
                |> List.map (fun q -> float q.price)
                |> Statistics.Median
                |> Some
        
        let aggrQuote = 
            Quote.quotes sd ed bond.security.Value
            // Dedup the quotes for each bond by broker
            |> Seq.distinctBy (fun q -> (q.broker, q.date.Year, q.date.Month))
            |> Seq.toList
            |> calcAggrQuote
        
        aggrQuote


    ///    
    let renderQuote (sht : Worksheet) (cell : Range) (q : Quote.T) = 
        sht.Names.Add("quote_" + q.id.ToString(), cell) |> ignore
        cell.Value <- q.price
    
    //
    //
    //
    let private monthlyQuotesByBroker keepEmptyMonths bond sd ed = 
        // Get the quotes for the bond and period
        let quotes = 
            Quote.quotes sd ed bond
            // Dedup the quotes for each bond by broker
            |> Seq.distinctBy (fun q -> (q.broker, q.date.Year, q.date.Month))
            |> Seq.toList
        
        let months = 
            match (keepEmptyMonths, quotes) with
            | (true, _) | (_, []) -> monthEnds sd ed
            | _ -> 
                let ds = quotes |> List.map (fun q -> q.date)
                monthEnds (List.min ds) (List.max ds)
        
        let nullQuotes = months |> List.map (fun m -> (m, None))
        
        // Given a sequence of quotes with (possibly) missing quotes for certain months,
        // add quotes with None values for the missing months.
        let normalizeQuotes qs = 
            Seq.append qs nullQuotes
            |> Seq.distinctBy (fun (d, _) -> (d.Year, d.Month))
            |> Seq.sort
            |> Seq.toList
        
        let quotesByBroker = 
            quotes
            |> Seq.groupBy (fun q -> q.broker)
            // Add a list of quotes for IDC, since we always want one in there
            |> flip Seq.append [ (idcBroker, Seq.empty<Quote.T>) ]
            |> Seq.map (fun (br, qs) -> 
                   (br, 
                    qs
                    |> Seq.map (fun q -> (q.date, Some q))
                    |> normalizeQuotes))
            |> Seq.distinctBy fst
            |> Seq.toList
            |> List.sortWith idcFirstBrCmpr
        
        (months, quotesByBroker)
    
    //
    //
    //
    let private renderLine (sht : Worksheet) ri ci (bond : Security.T) 
        (quotes : Broker.T * (DateTime * Quote.T option) list) = 
        let cells = sht.Cells
        let broker = fst quotes
        cells.[ri, ci].Value2 <- broker.name
        snd quotes |> List.iteri (fun i (_, q) -> 
                          match q with
                          | Some x -> renderQuote sht cells.[ri, ci + i + 1] x
                          | _ -> cells.[ri, ci + i + 1].Value <- null)
    
    //
    //
    //
    let private renderBondInfo (sht : Worksheet) ri (bond : Security.T) = 
        let cells = sht.Cells
        cells.[ri, 1].Value2 <- bond.symbol
        cells.[ri, 2].Value2 <- bond.cusip.GetOrElse(bond.isin.GetOrElse(""))
    
    //
    //
    //
    let private renderAggrLine (sht : Worksheet) ri ci nMonths nBrokers = 
        let cells = sht.Cells
        cells.[ri, ci].Value2 <- "MEDIAN"
        for i in [ ci + 1..nMonths + ci ] do
            // Range with IDC
            let rangeIDC = sht.Range(cells.[ri - nBrokers, i], cells.[ri - 1, i])
            
            let noQuotes = 
                lazy (rangeIDC.Cells.Value :?> obj [,]
                      |> Seq.cast<obj>
                      |> Seq.filter (fun x -> x <> null)
                      |> Seq.isEmpty)

            match (rangeIDC.Cells.Value, noQuotes) with
            | (null, _) -> cells.[ri, i].Value <- null
            | (_, Lazy x) when (x = true) -> cells.[ri, i].Value <- null
            | _ -> 
                let addrIDC = rangeIDC.AddressLocal
                // Range without IDC
                let range = sht.Range(cells.[ri - nBrokers + 1, i], cells.[ri - 1, i])
                let addr = range.AddressLocal
                let formula = 
                    "=IF(COUNTA(" + addrIDC + ") = 0" + ", \"\", " + "IF(ISEVEN(COUNTA(" + addrIDC + ")), MEDIAN(" + addr 
                    + "), MEDIAN(" + addrIDC + ")))"
                cells.[ri, i].Formula <- formula
        
        // Format the aggregate row
        let aggrRow = sht.Range(cells.[ri, 1], cells.[ri, ci + nMonths])
        let bondBorder = aggrRow.Borders.[XlBordersIndex.xlEdgeTop]
        aggrRow.NumberFormat <- "#.00000"
        aggrRow.Font.Bold <- true
        aggrRow.Font.Color <- 0x000000
        bondBorder.LineStyle <- XlLineStyle.xlContinuous
        bondBorder.Weight <- 3
  
    //
    //
    //
    let private renderBond (sheet : Worksheet) 
                           (rowi : int) 
                           (displayBondInfo : bool) 
                           (displayColumnHdrs : bool) 
                           (bond : Security.T) ((months, quotes) : DateTime list * (Broker.T * (DateTime * Quote.T option) list) list) = 
        
        let ci = if displayBondInfo then 3 else 1
        let dataRowi = if displayColumnHdrs then rowi + 1 else rowi
        let cells = sheet.Cells
        let nMonths = months.Length
        let nBrokers = quotes.Length
        
        // Print the header row (the month-end dates)
        if displayColumnHdrs then 
            months |> List.iteri (fun i d -> cells.[rowi, ci + i + 1].Value <- d)
            let hdrRange = sheet.Range(cells.[rowi, ci + 1], cells.[rowi, ci + 1 + months.Length])
            hdrRange.Font.Bold <- true
            hdrRange.NumberFormat <- " mm/yyyy "
            (hdrRange.Borders.[XlBordersIndex.xlEdgeBottom]).LineStyle <- XlLineStyle.xlContinuous
        
        // Render each (bond, broker) pair
        quotes |> List.iteri (fun i qs -> 
                      if displayBondInfo then renderBondInfo sheet (dataRowi + i) bond
                      renderLine sheet (dataRowi + i) ci bond qs)
        
        // Render the aggreage row
        if displayBondInfo then renderBondInfo sheet (dataRowi + nBrokers) bond
        renderAggrLine sheet (dataRowi + nBrokers) ci nMonths nBrokers

        // Set the fromatting for the quote cells
        let cells = sheet.Cells
        let quoteRange = sheet.Range(cells.[dataRowi, ci + 1], cells.[dataRowi + nBrokers - 1, ci + nMonths])
        quoteRange.NumberFormat <- "#.00000"
        quoteRange.Font.Color <- 0x7D491F

        // Return the number of lines rendered, so that 
        // we know where to start rendering the next bond.
        nBrokers + 2

    //
    //
    //
    let public ytdQuoteReport (app : Application) (sht : Worksheet) asof = 
        let stopWatch = Stopwatch.StartNew()
        let ed = monthEnd (asof)
        let sd = (monthStart ed).AddMonths(-11)
        let months = monthEnds sd ed
         
        // Get the bonds that have positions currently in the portfolio(s)
        let bonds = 
            Position.getPositions ed
            |> Seq.map (fun p -> p.security)
            |> Seq.filter (fun s -> (s.sectype = Security.ABS) || (s.sectype = Security.CONVERTIBLE))
            |> Seq.distinct
            |> Seq.sortBy (fun b -> b.symbol)
            |> Seq.toList
         
        // Display the quote report
        let cells = sht.Cells
         
        // Print the header row (the month-end dates)
        months |> List.iteri (fun i d -> cells.[1, 4 + i].Value <- d)
         
        // Format the top row, make it bold, and freeze it
        let topRow = cells.[1, 1].EntireRow
        topRow.Font.Bold <- true
        topRow.NumberFormat <- " MM/yyyy "
        app.ActiveWindow.SplitRow <- 1
        app.ActiveWindow.SplitColumn <- 3
        app.ActiveWindow.FreezePanes <- true
         
        // Display all the bond quotes
        let lastRow = 
            List.fold (fun r b -> 
                let (ms, qs) = monthlyQuotesByBroker true b sd ed
                r + renderBond sht r true false b (ms, qs)) 2 bonds
         
        // Make sure everything fits
        sht.Columns.AutoFit() |> ignore
        sht.Rows.AutoFit() |> ignore
         
        // Add column border for the row headers
        let columnBorder = sht.Range(cells.[2, 3], cells.[lastRow, 2]).Borders.[XlBordersIndex.xlEdgeRight]
        columnBorder.LineStyle <- XlLineStyle.xlContinuous
        stopWatch.Stop()
        app.StatusBar <- sprintf "Report took %.2f seconds to generate" stopWatch.Elapsed.TotalSeconds


    //
    //
    //
    let public YtdQuoteReport () =
        let today = DateTime.Now
        let app = new Application(null, ExcelDnaUtil.Application)
        let sht = app.Sheets.AddOrReplace("YTD Quote Report")
        registerShtRefresher sht.Name (fun () -> ytdQuoteReport app sht today)
        
        ytdQuoteReport app sht today

    //
    //
    //
    let private renderAggrCell (sht: Worksheet) ri nBrokers =
        let cells = sht.Cells
    
        // Range with IDC
        let rangeIDC = sht.Range(cells.[ri, 3], cells.[ri, 2 + nBrokers])
        let noQuotes = lazy (rangeIDC.Cells.Value :?> obj[,] |> Seq.cast<obj> |> Seq.filter (fun x -> x <> null) |> Seq.isEmpty)
        let aggrCell = cells.[ri, 3 + nBrokers]

        match (rangeIDC.Cells.Value, noQuotes) with
        | (null, _) -> aggrCell.Value <- null 
        | (_, Lazy x) when (x = true) -> aggrCell.Value <- null
        | _    -> 
            let addrIDC = rangeIDC.AddressLocal
            // Range without IDC
            let range = sht.Range(cells.[ri, 3], cells.[ri, 1 + nBrokers])
            let addr = range.AddressLocal
                
            let formula = "=IF(COUNTA(" + addrIDC + ") = 0"
                            + ", \"\", " 
                            + "IF(ISEVEN(COUNTA(" + addrIDC + ")), MEDIAN(" + addr + "), MEDIAN(" + addrIDC + ")))"
            aggrCell.Formula <- formula

    ///
    ///
    ///
    let private monthlyQuoteReport (app: Application) (sht: Worksheet) asof =
        let ed = monthEnd(asof)
        let sd = monthStart ed

        // Get the bonds that have positions currently in the portfolio(s)
        let bonds =
            Position.getPositions ed
            |> Seq.map (fun p -> p.security)
            |> Seq.filter (fun s -> (s.sectype = Security.ABS) || (s.sectype = Security.CONVERTIBLE))
            |> Seq.distinct
            |> Seq.sortBy (fun b -> Security.secid b)
            |> Seq.toList

        // Set of distinct brokers from all the quotes
        let brokers = new HashSet<Broker.T>()

        // Quotes for all the bonds
        let allQuotes =
            bonds
            |> List.map (fun b -> (b, Quote.quotes sd ed b))
            |> List.map (fun (b, qs) -> 
                                    // Create a broker -> quote map
                                    let qsMap = qs 
                                                |> List.map (fun q -> brokers.Add(q.broker) |> ignore
                                                                      (q.broker, q)) 
                                                |> Map.ofList
                                    (b, qsMap)
                        )
        
        // Quoting brokers
        let quotingBrokers = 
            bonds
            |> List.map (fun b -> let qbs = Broker.quotingBrokers b |> Set.ofList
                                  brokers.UnionWith(qbs) |> ignore
                                  (b, qbs))
            |> Map.ofList



        let sortedBrokers = brokers |> Seq.toList |> List.sortWith idcLastBrCmpr
        let nBrokers = brokers.Count

        // Render the header row
        let cells = sht.Cells
        cells.[1, 1].Value <- "Symbol"
        cells.[1, 2].Value <- "Security ID"
        cells.[1, 3 + nBrokers].Value <- "Median"

        sortedBrokers |> List.iteri (fun i br -> cells.[1, 3 + i].Value <- br.name)
        // Change the alignment for the broker names to vertical
        sht.Range(cells.[1, 3], cells.[1, 2 + nBrokers]).Orientation <- XlOrientation.xlUpward

        // Render the quotes
        allQuotes
        |> List.iteri (fun i (b, qm) -> 
                                    if (i % 2 <> 0) then
                                        sht.Range(cells.[2 + i, 1], cells.[2 + i, 3 + nBrokers]).Interior.Color <- 0xBFBFBF
                                    
                                    let qbs = quotingBrokers.[b]
                                    cells.[2 + i, 1].Value <- b.symbol
                                    cells.[2 + i, 2].Value <- Security.secid b
                                    sortedBrokers
                                    |> List.iteri (fun j br -> match qm.TryFind(br) with
                                                               | Some q -> renderQuote sht cells.[2 + i, 3 + j] q
                                                                           if q.challanged then 
                                                                               cells.[2 + i, 3 + j].Interior.Color <- 0x00C0FF
                                                               | None   -> cells.[2 + i, 3 + j].Value <- null
                                                                           if (qbs.Contains br) then
                                                                               cells.[2 + i, 3 + j].Interior.Color <- 0x0000C0
                                                                                     
                                                  )
                                    renderAggrCell sht (2 + i) nBrokers
                      )

        // Format the sheet
        let quoteRange = sht.Range(cells.[2, 3], cells.[1 + bonds.Length, 2 + nBrokers])
        quoteRange.NumberFormat <- "#.00000"
        quoteRange.Font.Color <- 0x7D491F

        sht.Range(cells.[2, 3 + nBrokers], cells.[1 + bonds.Length, 3 + nBrokers]).NumberFormat <- "#.00000"

        // Add the borders
        let hdrBorder = sht.Range(cells.[1, 1], cells.[1, 3 + nBrokers]).Borders.[XlBordersIndex.xlEdgeBottom]
        hdrBorder.LineStyle <- XlLineStyle.xlContinuous
        hdrBorder.Weight <- 3

        let secBorder = sht.Range(cells.[1, 2], cells.[1 + bonds.Length, 2]).Borders.[XlBordersIndex.xlEdgeRight]
        secBorder.LineStyle <- XlLineStyle.xlContinuous
        secBorder.Weight <- 3

        let aggrBorder = sht.Range(cells.[1, 3 + nBrokers], cells.[1 + bonds.Length, 3 + nBrokers]).Borders.[XlBordersIndex.xlEdgeLeft]
        aggrBorder.LineStyle <- XlLineStyle.xlContinuous
        aggrBorder.Weight <- 3

        // Make sure everything fits
        sht.Columns.AutoFit() |> ignore
        sht.Rows.AutoFit() |> ignore

        // Freeze panes
        app.ActiveWindow.SplitRow <- 1
        app.ActiveWindow.SplitColumn <- 2
        app.ActiveWindow.FreezePanes <- true


    ///
    ///
    ///
    let public MonthlyQuoteReport () =
        match SimpleInputBox "Monthly Quote Report" "Enter Report Date" None with
        | Cancel | Ok "" -> ()
        | Ok str -> try
                        let d = DateTime.Parse(str)
                        let app = new Application(null, ExcelDnaUtil.Application)
                        let sht = app.Sheets.AddOrReplace(d.ToString("yyyyMM") + " Monthly Quote Report")
                        registerShtRefresher sht.Name (fun () -> monthlyQuoteReport app sht d)
        
                        monthlyQuoteReport app sht d
                    with 
                        | :? FormatException -> ErrorBox "Invalid date"
     //
     //
     //
    let private bondQuotesReport (app: Application) (sht: Worksheet) (s: Security.T) = 
            let sd = new DateTime(1900, 1, 1)
            let ed = DateTime.Now
            let (months, quotes) = monthlyQuotesByBroker false s sd ed
            let cells = sht.Cells

            renderBond sht 25 false true s (months, quotes) |> ignore
            // Make sure everything fits
            sht.Columns.AutoFit() |> ignore
            sht.Rows.AutoFit() |> ignore
            // Freeze pane
            app.ActiveWindow.SplitRow <- 25
            app.ActiveWindow.SplitColumn <- 1
            app.ActiveWindow.FreezePanes <- true
                                        
            // Add the chart
            let charts = sht.ChartObjects() :?> ChartObjects
            let left = (cells.[1, 1]).Width :?> float
            let top = (cells.[1, 1]).Height :?> float
            let chart = (charts.Add(left, top, 850., 320.)).Chart
            let dataRange = sht.Range(cells.[25, 1], cells.[25 + quotes.Length + 1, 1 + months.Length])
            chart.HasTitle <- true
            chart.ChartTitle.Text <- s.symbol
            chart.ChartType <- XlChartType.xlLine
            chart.DisplayBlanksAs <- XlDisplayBlanksAs.xlInterpolated
            chart.SetSourceData(dataRange)
                                        
            let xAxis = chart.Axes(XlAxisType.xlCategory, XlAxisGroup.xlPrimary) :?> Axis
            let yAxis = chart.Axes(XlAxisType.xlValue, XlAxisGroup.xlPrimary) :?> Axis
            xAxis.BaseUnit <- XlTimeUnit.xlMonths
            xAxis.MajorUnitScale <- XlTimeUnit.xlYears
            xAxis.MinorUnitScale <- XlTimeUnit.xlYears

            yAxis.TickLabels.NumberFormatLinked <- false
            yAxis.TickLabels.NumberFormat <- "#.00"


    ///
    ///
    ///
    let public BondQuoteReport () =
        match SimpleInputBox "Bond" "Bond symbol or CUSIP" (Some(bondTickersCol)) with
        | Cancel | Ok "" -> ()
        | Ok bid -> match getDealBond bid with
                    | BondInfo b -> match b.security with
                                    | Some s -> match Quote.quotes (new DateTime(1900, 1, 1)) DateTime.Now s with
                                                | [] -> ErrorBox <| "No quotes for bond: " + b.symbol
                                                | _  -> 
                                                        let app = new Application(null, ExcelDnaUtil.Application)
                                                        let sht = app.Sheets.AddOrReplace(s.symbol + " Quotes")
                                                        registerShtRefresher sht.Name (fun () -> bondQuotesReport app sht s)
        
                                                        bondQuotesReport app sht s

                                    | _ -> ErrorBox <| "No quotes for bond: " + b.symbol

                    | _ -> ErrorBox <| "Invalid bond identifier: " + bid

    ///
    ///
    ///
    type QuoteForm(?quote: Quote.T) as this =
        inherit Forms.Form(Text = "Quote",
                           FormBorderStyle = Forms.FormBorderStyle.FixedSingle,
                           Height = 277,
                           Width = 330,
                           BackColor = Color.White)

        // Security field
        static let securityLabel = new Forms.Label(Text = "Security", Top = 27, Left = 10, Height = 23, Width = 140)
        let securityBox = new Forms.TextBox(Top = 27, Left = 150, Height = 23, Width = 160)
        
        // Date field
        static let dateLabel = new Forms.Label(Text = "Date", Top = 55, Left = 10, Height = 23, Width = 140)
        let dateBox = new Forms.TextBox(Top = 55, Left = 150, Height = 23, Width = 160)

        // Broker field
        static let brokerLabel = new Forms.Label(Text = "Broker", Top = 83, Left = 10, Height = 23, Width = 140)
        let brokerBox = new Forms.ComboBox(Top = 83, Left = 150, Height = 23, Width = 160)

        // Price field
        static let priceLabel = new Forms.Label(Text = "Price", Top = 111, Left = 10, Height = 23, Width = 140)
        let priceBox = new Forms.TextBox(Top = 111, Left = 150, Height = 23, Width = 160)

        // Currency field
        static let currencyLabel = new Forms.Label(Text = "Currency", Top = 139, Left = 10, Height = 23, Width = 140)
        let currencyBox = new Forms.ComboBox(Top = 139, Left = 150, Height = 23, Width = 160)

        // Challanged field
        static let challangedLabel = new Forms.Label(Text = "Challanged?", Top = 167, Left = 10, Height = 23, Width = 140)
        let challangedBox = new Forms.CheckBox(Top = 167, Left = 150)

        let okButton = new Forms.Button(Text = "Ok", Top = 208, Left = 240, Width = 65, BackColor = Color.LightGray)
        let cancelButton = new Forms.Button(Text = "Cancel", Top = 208, Left = 135, Width = 65, BackColor = Color.LightGray)
        let deleteButton = new Forms.Button(Text = "Delete", Top = 208, Left = 30, Width = 65, BackColor = Color.LightGray)
        
        // Auto-complete list for the security symbols
        let symbolCompCol = new Forms.AutoCompleteStringCollection()
        do 
            Security.allSecurities
            |> List.filter (fun s -> (s.sectype = Security.ABS) || (s.sectype = Security.CONVERTIBLE))
            |> List.map (fun s -> symbolCompCol.Add(s.symbol))
            |> ignore

            securityBox.AutoCompleteMode <- Forms.AutoCompleteMode.Suggest
            securityBox.AutoCompleteSource <- Forms.AutoCompleteSource.CustomSource
            securityBox.AutoCompleteCustomSource <- symbolCompCol

            // Populate the broker combo box
            brokerBox.DataSource <- Broker.allBrokers.ToList() 
            brokerBox.DisplayMember <- "name"
            brokerBox.ValueMember <- "id"

            // Populate the currency combo box
            currencyBox.DataSource <- FSharpType.GetUnionCases(typeof<Currency>)
            currencyBox.DisplayMember <- "Name"
            currencyBox.ValueMember <- null

            okButton.Click.Add(fun _ -> 
                                    match quote with
                                    | Some _ -> this.UpdateQuote()
                                    | None -> this.SaveQuote()

                                    this.Hide()
                               )

            cancelButton.Click.Add(fun _ -> this.Hide())

            deleteButton.Click.Add(fun _ -> 
                                        this.DeleteQuote()
                                        this.Hide()
                                  )

            // Create the form window
            this.Controls.Add(securityLabel)
            this.Controls.Add(securityBox)
            this.Controls.Add(dateLabel)
            this.Controls.Add(dateBox)
            this.Controls.Add(brokerLabel)
            this.Controls.Add(brokerBox)
            this.Controls.Add(priceLabel)
            this.Controls.Add(priceBox)
            this.Controls.Add(currencyLabel)
            this.Controls.Add(currencyBox)
            this.Controls.Add(challangedLabel)
            this.Controls.Add(challangedBox)
            this.Controls.Add(okButton)
            this.Controls.Add(cancelButton)
            this.Controls.Add(deleteButton)

            this.AcceptButton <- okButton

            this.Load.Add(fun _ ->             
                                match quote with
                                | None -> securityBox.Text <- ""
                                          brokerBox.SelectedIndex <- 0
                                          currencyBox.Text <- Currency.USD.ToString()
                                          challangedBox.Checked <- false
                                          deleteButton.Enabled <- false

                                | Some q -> securityBox.Text <- q.security.symbol
                                            brokerBox.SelectedValue <- q.broker.id
                                            currencyBox.Text <- q.currency.ToString()
                                            priceBox.Text <- string q.price
                                            dateBox.Text <- q.date.ToString("MM/dd/yyyy")
                                            challangedBox.Checked <- q.challanged
                                            deleteButton.Enabled <- true
                         )

            this.ShowDialog() |> ignore

        member private this.SaveQuote() =
            let db = Db.nyabsDbCon.GetDataContext()
            let security = either (Security.getSecurity securityBox.Text) failwith id
            let quotes = db.Backoffice.Quotes
            let q = quotes.Create()
            q.SecurityId <- security.id
            q.BrokerId <- unbox brokerBox.SelectedValue
            q.Quote <- decimal priceBox.Text
            q.Date <- DateTime.Parse(dateBox.Text)
            q.Currency <- currencyBox.Text
            q.Challanged <- challangedBox.Checked
 
            db.SubmitUpdates()

        member private this.UpdateQuote() =
            let db = Db.nyabsDbCon.GetDataContext()

            let q = query {
                for x in db.Backoffice.Quotes do
                where (x.Id = quote.Value.id)
                headOrDefault
            }

            match q with
            | null -> ErrorBox "Couldn't find quote"
            | _ ->  
                let security = either (Security.getSecurity securityBox.Text) failwith id
                q.SecurityId <- security.id
                q.BrokerId <- unbox brokerBox.SelectedValue
                q.Quote <- decimal priceBox.Text
                q.Date <- DateTime.Parse(dateBox.Text)
                q.Currency <- currencyBox.Text
                q.Challanged <- challangedBox.Checked

                db.SubmitUpdates() 

        member private this.DeleteQuote() =
            let db = Db.nyabsDbCon.GetDataContext()

            let q = query {
                for x in db.Backoffice.Quotes do
                where (x.Id = quote.Value.id)
                headOrDefault
            }

            match q with
            | null -> ErrorBox "Couldn't find quote"
            | _ ->  
                q.Delete()
                db.SubmitUpdates()

    ///
    ///
    ///
    let public enterQuote () = new QuoteForm()

    ///
    ///
    ///
    let public modifyQuote qid = new QuoteForm(Quote.getQuoteById qid)
