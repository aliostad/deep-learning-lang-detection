namespace AyinExcelAddIn

open System
open System.Text.RegularExpressions
open ExcelDna.Integration
open ExcelDna.XlCache
open ExcelDna.XlUtils

open AyinExcelAddIn.Utils
open AyinExcelAddIn.Backoffice.QuoteFunctions
open AyinExcelAddIn.DealGrp

module public Udf =

    ///
    /// BROKERQUOTE
    ///
    [<ExcelFunction(Name = "BROKERQUOTE", 
                    Description = "Returns the month end quote for the bond and broker",
                    IsVolatile = false)>]
    let public brokerquote ([<ExcelArgument(Name="ID", Description = "Bond identifier")>] 
                            id: string,
                            [<ExcelArgument(Name="Broker", Description = "Broker name")>]
                            broker: string,
                            [<ExcelArgument(Name="Date", Description = "Date")>] 
                            date: DateTime) =
        if ExcelDnaUtil.IsInFunctionWizard() then
            box ExcelError.ExcelErrorGettingData
        else 
            (id, broker, date)
            |> asyncRun "brokerquote" (toExcelFuncOpt monthlyBondQuote)
        
    ///
    /// BONDMARK
    ///
    [<ExcelFunction(Name = "BONDMARK", 
                    Description = "Returns aggregate month end quote for the bond",
                    IsVolatile = false)>]
    let public aggrquote ([<ExcelArgument(Name="ID", Description = "Bond identifier")>] 
                          id: string,
                          [<ExcelArgument(Name="Date", Description = "Date")>] 
                          date: obj) =

        if ExcelDnaUtil.IsInFunctionWizard() then
            box ExcelError.ExcelErrorGettingData
        else 
            let d = getDateValue date

            (id, d)
            |> asyncRun "aggrquote" (toExcelFuncOpt aggrBondQuote)

    [<Literal>]
    let private quotePattern = @"([a-z]*)\s*(\d*\.?\d+|teen|sd).*"

    ///
    /// TOQUOTE
    ///
    [<ExcelFunction(Name = "TOQUOTE", 
                    Description = "Returns a quote (number) parsing the quote string",
                    IsVolatile = false)>]
    let public parseQuote ([<ExcelArgument(Name="Quote", Description = "Quote string")>] qstr: string) =
        if qstr.Contains("-")
        then
            qstr.Split([| "-" |], 2, StringSplitOptions.None)
            |> function
               | [| n; frac |] -> float n + (float frac / 32.)
               | _ -> failwith "Unparsable"
        else 
            let m = (Regex quotePattern).Match(qstr)

            if m.Success
            then 
                let gs = [for x in m.Groups -> x.Value]
                let modifier = match gs.[1] with
                               | "" -> 0.
                               | "l" | "lo" | "low" -> 1.
                               | "midlo" | "midlow" | "lomid" | "lowmid" | "ml" | "lm" -> 2.5
                               | "m" | "mi" | "mid" -> 5.
                               | "midhi" | "midhigh" | "himid" | "highmid" | "mh" | "hm" -> 7.5
                               | "h" | "hi" | "high" -> 9.

                let quantifier = match gs.[2] with
                                 | "teen" -> 10.
                                 | "sd" -> 0.
                                 | s -> float s

                quantifier + modifier
            else 
                failwith "Unparsable"
    
    ///
    /// IDP
    ///
    [<ExcelFunction(Name = "IDP", 
                    Description = "IDP (Ayin Data Point) returns the most recent data point for the selected bond or deal.",
                    IsVolatile = false,
                    IsMacroType = true)>]
    let public idp ([<ExcelArgument(Name="ID", Description = "Identifier")>] id: string,
                    [<ExcelArgument(Name="Field", Description = "Data field")>] field: string) =

        if ExcelDnaUtil.IsInFunctionWizard() then
            box ExcelError.ExcelErrorGettingData
        else 
            let (fName, func) = AyinAddIn.IDPFuncMap.[field.Trim()]
            asyncRun fName func id


    ///
    /// IDH
    ///
    [<ExcelFunction(Name = "IDH", 
                    Description = "IDH (Ayin Data History) returns historical data for the selected bond or deal.",
                    IsVolatile = false,
                    IsMacroType = true)>]
    let public idh ([<ExcelArgument(Name="ID", Description = "Identifier")>] id: string,
                    [<ExcelArgument(Name="Field", Description = "Data field")>] field: string,
                    [<ExcelArgument(Name="Start date", Description = "Start date")>] sd: obj,
                    [<ExcelArgument(Name="End date", Description = "End date")>] ed: obj,
                    [<ExcelArgument(Name="Options", Description = "Optional arguments")>] opts: obj) =

        if ExcelDnaUtil.IsInFunctionWizard() then
            array2D [[ box ExcelError.ExcelErrorGettingData ]]
        else 
            let startDate = getDateValue sd
            let endDate = getDateValue ed

            let optArgs = 
                match opts with
                | :? ExcelMissing -> parseOptArgs defaultOpts
                | _               -> parseOptArgs <| defaultOpts + ";" + string opts

            // Get the tag name and the function
            let (fName, func) = AyinAddIn.IDHFuncMap.[field.Trim()]

            (id, startDate, endDate)
            |> asyncRunAndResize (fName + string opts) (toHistoryFunc func optArgs)


