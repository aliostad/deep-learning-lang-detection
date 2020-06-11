(*** hide ***)
#if INTERACTIVE
#r "Microsoft.Office.Interop.Excel"
#r "System.Runtime.InteropServices"
#r "Microsoft.Office.Core"
#r "../../packages/FSharp.Formatting.2.10.3/lib/net40/FSharp.MetadataFormat.dll"
#else
module public ComLastCell
#endif

open System
open System.IO
open Microsoft.Office.Interop.Excel
open System.Runtime.InteropServices
open Microsoft.Office.Core
open FSharp.MetadataFormat

(** 
    Type provides one place to manage the application settings for the Excel instance that hosts the workbooks.
*)
type public ExcelHandler (handle : ApplicationClass) = 
    member this.Handle = handle
    member this.BooksCollection = handle.Workbooks

    member this.Close() =
        if(not(obj.ReferenceEquals(this.BooksCollection, null)) && Marshal.IsComObject(this.BooksCollection)) then Marshal.ReleaseComObject(this.BooksCollection) |> ignore
        this.Handle.Quit()
        if(not(obj.ReferenceEquals(this.Handle, null)) && Marshal.IsComObject(this.Handle))  then Marshal.ReleaseComObject(this.Handle) |> ignore
    
    member this.Flush()= 
        for wb in this.BooksCollection do if(not(obj.ReferenceEquals(wb, null)) && Marshal.IsComObject(wb)) then Marshal.ReleaseComObject(wb) |> ignore

    member this.Secure() =
        this.Handle.AutomationSecurity <- Microsoft.Office.Core.MsoAutomationSecurity.msoAutomationSecurityForceDisable

    member this.Perform() = 
        this.Handle.Calculation <- Microsoft.Office.Interop.Excel.XlCalculation.xlCalculationManual
        this.Handle.ScreenUpdating <- false
        this.Handle.DisplayAlerts <- false
    
(** 
    Basic holder for the results.
*)
type public LastCell = 
    {
        mutable LastRow : int
        mutable LastCol : int
    }
    member this.ToString = "LastRow:" + this.LastRow.ToString() + ";LastCol:" + this.LastCol.ToString()

(** 
    Basic holder for the results.
*)
type public SheetLimits = 
    {
        mutable MaxRow : int
        mutable MaxCol : int
    }
    member this.ToString = "MaxRow:" + this.MaxRow.ToString() + ";MaxCol:" + this.MaxCol.ToString()

  
let p1 (c, _, _) = c
let p2 (_, c, _) = c

let SyncArray (s1:string[]) (s2:string[]) (s3:string[]) = 
    let count = s1 |> Array.length
    Array.init count (fun i -> s1.[i] + " " + s2.[i] + " " + s3.[i])

let tupleToString(t: SheetLimits * LastCell) = 
     (fst t).ToString + "," + (snd t).ToString

let lastElement (data : int option) = 
    match data with
        | Some var1 -> var1
        | None -> -1        // some error value to indicate an error occurred when trying to find the last[Row|Col]

(** 
    Finds the last row in a worksheet by starting at the first cell and doing a find with 
    the direction reversed.
*)
let FindWorksheetLastRow (sheet : Worksheet) =
    let cellsColl = sheet.Cells 
    //printfn "%s has %i cells" sheet.Name cellsColl.Count
    let firstCell = cellsColl.[1,1] :?> Range
    let mutable lastCell = cellsColl.[1,1] :?> Range
    let mutable lastRow = -1
    try
        try
            lastCell <- cellsColl.Find("*", firstCell, Microsoft.Office.Interop.Excel.XlFindLookIn.xlFormulas, Microsoft.Office.Interop.Excel.XlLookAt.xlPart, Microsoft.Office.Interop.Excel.XlSearchOrder.xlByRows, Microsoft.Office.Interop.Excel.XlSearchDirection.xlPrevious, Type.Missing, Type.Missing, Type.Missing)
            if(not(obj.ReferenceEquals(lastCell, null))) then lastRow <- lastCell.Row
        with
            | _ as ex -> printfn "%s has thrown an error: %s" sheet.Name ex.Message
    finally
        if(not(obj.ReferenceEquals(cellsColl, null)) && Marshal.IsComObject(cellsColl)) then printfn "Remaining RCW references to cellsColl %i " (Marshal.ReleaseComObject(cellsColl))
        if(not(obj.ReferenceEquals(firstCell, null)) && Marshal.IsComObject(firstCell)) then printfn "Remaining RCW references to firstCell %i " (Marshal.ReleaseComObject(firstCell))
        if(not(obj.ReferenceEquals(lastCell, null)) && Marshal.IsComObject(lastCell)) then printfn "Remaining RCW references to lastCell %i " (Marshal.ReleaseComObject(lastCell)) 
    lastRow

(** 
    Finds the last column in a worksheet by starting at the first cell and doing a find with 
    the direction reversed.
*)    
let FindWorksheetLastCol (sheet : Worksheet) =
    let cellsColl = sheet.Cells 
    let firstCell = cellsColl.[1,1] :?> Range
    let mutable lastCell = cellsColl.[1,1] :?> Range
    let mutable lastCol = -1
    try
        try
            lastCell <- cellsColl.Find("*", firstCell, Microsoft.Office.Interop.Excel.XlFindLookIn.xlFormulas, Microsoft.Office.Interop.Excel.XlLookAt.xlPart, Microsoft.Office.Interop.Excel.XlSearchOrder.xlByColumns, Microsoft.Office.Interop.Excel.XlSearchDirection.xlPrevious, Type.Missing, Type.Missing, Type.Missing)
            if(not(obj.ReferenceEquals(lastCol, null))) then lastCol <- lastCell.Column
        with
            | _ as ex -> printfn "%s has thrown an error: %s" sheet.Name ex.Message
    finally
        if(not(obj.ReferenceEquals(cellsColl, null)) && Marshal.IsComObject(cellsColl)) then printfn "Remaining RCW references to cellsColl %i " (Marshal.ReleaseComObject(cellsColl))
        if(not(obj.ReferenceEquals(firstCell, null)) && Marshal.IsComObject(firstCell)) then printfn "Remaining RCW references to firstCell %i " (Marshal.ReleaseComObject(firstCell))
        if(not(obj.ReferenceEquals(lastCell, null)) && Marshal.IsComObject(lastCell)) then printfn "Remaining RCW references to lastCell %i " (Marshal.ReleaseComObject(lastCell)) 
    lastCol

let FindWorksheetLastCell (sheet : Worksheet) = 
    let thisSheet = sheet
    let lastRow = FindWorksheetLastRow thisSheet
    let lastCol = FindWorksheetLastCol thisSheet
    if(not(obj.ReferenceEquals(thisSheet, null)) && Marshal.IsComObject(thisSheet)) then printfn "Remaining RCW references to thisSheet %i " (Marshal.ReleaseComObject(thisSheet))
    {LastRow = lastRow; LastCol = lastCol}

(** 
    Iterates over all the sheets in the workbook looking for the last row and column in each sheet.
    Then chooses the max of all rows and max of all columns.  In other words the workbook lastcell 
    is a combination of the last row and last column and they could be on different sheets in in the workbook.
    I call this the *blended lastcell of the workbook.
*)
let FindWorkbookLastCell (workbook : Workbook) = 
    let sheetsColl = workbook.Sheets    
    let lastCells = seq {for sheet in sheetsColl do yield FindWorksheetLastCell (sheet :?> Worksheet)}
    let maxRow = 
        lastCells
            |> Seq.sortByDescending(fun lr -> lr.LastRow)
            |> Seq.head
    let maxCol = 
        lastCells            
            |> Seq.sortByDescending(fun lc -> lc.LastCol)
            |> Seq.head
    if(not(obj.ReferenceEquals(sheetsColl, null)) && Marshal.IsComObject(sheetsColl)) then printfn "Remaining RCW references to thisSheet %i" (Marshal.ReleaseComObject(sheetsColl))
    {LastRow = maxRow.LastRow; LastCol = maxCol.LastCol}                   

(** 
    Gets the extremes of the workbook: max row and max column.
*)
let FindWorkbookMaxCell (workbook : Workbook) = 
    let sheetsColl = workbook.Sheets
    let firstSheet = sheetsColl.[1] :?> Worksheet
    let rowsColl = firstSheet.Rows
    let colsColl = firstSheet.Columns
    let maxRows = rowsColl.Count
    let maxCols = colsColl.Count
    if(not(obj.ReferenceEquals(colsColl, null)) && Marshal.IsComObject(colsColl)) then printfn "Remaining RCW references to colsColl %i" (Marshal.ReleaseComObject(colsColl))
    if(not(obj.ReferenceEquals(rowsColl, null)) && Marshal.IsComObject(rowsColl)) then printfn "Remaining RCW references to rowsColl %i" (Marshal.ReleaseComObject(rowsColl))
    if(not(obj.ReferenceEquals(firstSheet, null)) && Marshal.IsComObject(firstSheet)) then printfn "Remaining RCW references to firstSheet %i" (Marshal.ReleaseComObject(firstSheet))
    if(not(obj.ReferenceEquals(sheetsColl, null)) && Marshal.IsComObject(sheetsColl)) then printfn "Remaining RCW references to sheetsColl %i" (Marshal.ReleaseComObject(sheetsColl))
    {MaxRow = maxRows; MaxCol = maxCols}

(** 
    Top level function to open and process the workbook.
*)
let public examineFile (handler : ExcelHandler) filename = 
    let workbooks = handler.Handle.Workbooks
    let mutable workbook = null
    let lastCells = {LastRow = -1; LastCol = -1}
    let limits = {MaxRow = -1; MaxCol = -1}
    try
        try
            handler.Secure() |> ignore
            workbook <- workbooks.Open(filename, Microsoft.Office.Interop.Excel.XlUpdateLinks.xlUpdateLinksNever, false, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, false, Type.Missing, Microsoft.Office.Interop.Excel.XlCorruptLoad.xlNormalLoad)
            // TODO: open a dummy workbook to set these settings before opening the actual workbook
            handler.Secure() |> ignore
            handler.Perform() |> ignore 
            let lc =  FindWorkbookLastCell workbook
            let lt = FindWorkbookMaxCell workbook
            lastCells.LastRow <- lc.LastRow
            lastCells.LastCol <- lc.LastCol
            limits.MaxRow <- lt.MaxRow
            limits.MaxCol <- lt.MaxCol
            workbook.Close(false)
        with
            | :? COMException as ex -> printfn "%s threw com exception: %s" filename ex.Message
            | :? ArgumentNullException as ex -> printfn "%s threw argnull exception: %s" filename ex.Message
            | _ as ex -> printfn "%s threw an exception: %s" filename ex.Message
    finally
        if(not(obj.ReferenceEquals(workbook, null)) && Marshal.IsComObject(workbook)) then printfn "Remaining RCW references to workbook: %i " (Marshal.ReleaseComObject(workbook))
        if(not(obj.ReferenceEquals(workbooks, null)) && Marshal.IsComObject(workbooks)) then printfn "Remaining RCW references to workbooks: %i " (Marshal.ReleaseComObject(workbooks))
    (limits, lastCells)        
