module ExcelHOF

//
// Source: Kit Eason,
//         http://fssnip.net/aV
//         "Higher-Order Functions for Excel"
//
// Office interop may need http://www.microsoft.com/en-us/download/details.aspx?id=3508,
// check C:\Windows\assembly for already installed interop assemblies.
//
// Source adjusted to get it run in my environment.
// @fbmnds


open System
open Microsoft.Office.Interop.Excel
open Deedle
open Log

let releaseComObject x = 
    match x with
    | Some x -> System.Runtime.InteropServices.Marshal.ReleaseComObject x
    | _ -> 0


//type CellType = | None | String of string | Float of float | Integer of int
//
///// Enforce "Garbage in, None out" policy
///// Autoconvert Excel cell contents,
///// should also handle Date, Time
//let cellContent (range : Range) =
//    match range.Value2 with
//    | :? string as _string -> Some _string //sprintf "string: %s" _string
//    | :? float as _float -> Some _float  //sprintf "double: %f" _double
//    | :? int as _int -> Some _int
//    | _ -> None

///  Deal with strings
let cellString (range : Range) =
    match range.Value2 with
    | :? string as _string-> string _string
    | _ ->failwith "Type error while reading strings."

/// Deal with floats
let cellDouble (range : Range) =
    match range.Value2 with
    | :? double as _double -> double _double
    | _ -> failwith "Type error while reading double/float numbers."
let cellFloat = cellDouble


/// Returns the specified worksheet range as a sequence of indvidual cell ranges.
let toSeq (range : Range) =
    seq {
        for r in 1 .. range.Rows.Count do
            for c in 1 .. range.Columns.Count do
                let cell = range.Item(r, c) :?> Range
                yield cell
    }

/// Returns the specified worksheet range as a sequence of indvidual cell ranges, together with a 0-based
/// row-index and column-index for each cell.
let toSeqrc (range : Range) =
    seq {
            for r in 1 .. range.Rows.Count do
                for c in 1 .. range.Columns.Count do
                    let cell = range.Item(r, c) :?> Range
                    yield r, c, cell
    }

/// Takes a sequence of individual cell-ranges and returns an Excel range representation of the cells
/// (using Excel 'union' representation - eg. "R1C1, R2C1, R5C4").
let toRangeAsString (workSheet : Worksheet) (rangeSeq : seq<Range>) =
    let csvSeq sequence =
        let result =
            sequence
            |> Seq.fold (fun acc x -> acc + x + ",") ""
        result.Remove(result.Length-1)
    let rangeName =
        rangeSeq
        |> Seq.map (fun cell -> cell.Address())
        |> csvSeq
    //workSheet.Range(rangeName)
    rangeName

let toRange (workSheet : Worksheet) (rangeSeq : seq<Range>) =
    let rangeName =
        rangeSeq
        |> Seq.map (fun cell -> cell.Address().ToString())
    //workSheet.Range(rangeName)
    workSheet.Range( (Seq.head rangeName), (Seq.last rangeName))


/// Takes a function and an Excel range, and returns the results of applying the function to each individual cell.
let map (f : Range -> 'T) (range : Range) =
    range
    |> toSeq
    |> Seq.map f

/// Takes a function and an Excel range, and returns the results of applying the function to each individual cell,
/// providing 0-based row-index and column-index for each cell as arguments to the function.
let maprc (f : int -> int -> Range -> 'T) (range : Range) =
    range
    |> toSeqrc
    |> Seq.map (fun item -> match item with
                            | (r, c, cell) -> f r c cell)

/// Takes a function and an Excel range, and applies the function to each individual cell.
let iter (f : Range -> unit) (range : Range) =
    range
    |> toSeq
    |> Seq.iter (fun cell -> f cell)

/// Takes a function and an Excel range, and applies the function to each individual cell,
/// providing 0-based row-index and column-index for each cell as arguments to the function.
let iterrc (f : int -> int -> Range -> unit) (range : Range) =
    range
    |> toSeqrc
    |> Seq.iter (fun item -> match item with
                                | (r, c, cell) -> f r c cell)

/// Takes a function and an Excel range, and returns a sequence of individual cell ranges where the result
/// of applying the function to the cell is true.
let filter (f : Range -> bool) (range : Range) =
    range
    |> toSeq
    |> Seq.filter (fun cell -> f cell)

 
let getExcel() = 
    let mutable excel = None
    try 
        excel <- Some (ApplicationClass(Visible = false)) 
    with 
        | _ -> Log.error "Failed to start Excel application."
    excel


let getWorkbooks (excel: ApplicationClass) =
    let mutable workbooks = None
    try 
        workbooks <- Some excel.Workbooks
    with
        | _ -> Log.error "Failed to access Excel Workbooks."
    workbooks


let getWorkbook (workbooks: Workbooks) fname =
    let mutable workbook = None
    try
        workbook <- Some(workbooks.Open(fname))
    with
        | _ -> Log.error (sprintf "Failed to open Workbook %s." fname)  
    workbook


let getWorkbook2 (workbooks: Workbooks) path fname =
    let fqn = path+"\\"+fname
    getWorkbook workbooks fqn


let getSheetByName (sheets: Sheets) (name: string) = 
    sheets.[name] :?> Worksheet
    
     
let getSheetByIndex (sheets: Sheets) (idx: int) =
    sheets.[idx] :?> Worksheet


let getFrameWithStringHeader (sheet: Worksheet) 
                       (ul: int*int) 
                       (lr: int*int) = 
    let (ulrow, ulcol) = ul
    let (lrrow,lrcol) = lr
    let data = seq { 
        for col in [ulcol..lrcol] do
            let label = cellString (sheet.Cells.[ulrow,col] :?> Range)
            for row in [ulrow+1..lrrow] do
                yield (row-1, label, cellFloat (sheet.Cells.[row,col] :?> Range))
    } 
    let mutable frame = None
    try
        frame <- Some (Frame.ofValues data)
    with
        | _ -> Log.error (sprintf "Failed to read Frame at [%A,%A] [%A,%A]" 
            ulrow ulcol lrrow lrcol)
    frame

// http://stackoverflow.com/questions/22708/how-do-i-find-the-excel-column-name-that-corresponds-to-a-given-integer
//public static string Column(int column)
//{
//    column--;
//    if (column >= 0 && column < 26)
//        return ((char)('A' + column)).ToString();
//    else if (column > 25)
//        return Column(column / 26) + Column(column % 26 + 1);
//    else
//        throw new Exception("Invalid Column #" + (column + 1).ToString());
//}
let rec intToColumn i =
    let mutable x = ""
    let j = i-1
    if (j >= 0 && j < 26) then
        x <- (char (int 'A' + j)).ToString()
    elif (j > 25 && j < 16384) then
        x <- intToColumn (j/26) + intToColumn (j % 26 + 1)
    else 
        failwith (sprintf "Invalid Excel column index %A" i)
    x

/// returns a System.Array of dimension (ulrow x lrcol) with indices counting from [1;1]
let getRangeAsArray (sheet: Worksheet) ulrow ulcol lrrow lrcol : Array option =
    let mutable r = None
    try 
        let s = (sprintf "%s%s:%s%s" (intToColumn ulcol) 
                                     (sprintf "%d" ulrow)
                                     (intToColumn lrcol) 
                                     (sprintf "%d" lrrow))
        Log.info (sprintf "%s" s)
        r <- Some (sheet.Range s)
    with
        | _ -> Log.error (sprintf "Invalid Excel column indices %d %d %d %d." ulrow ulcol lrrow lrcol)
    match r with 
    | Some r -> Some (r.Value() :?> Array)
    | _ -> None

let getFrameWithHeader (sheet: Worksheet) ulrow ulcol lrrow lrcol : Frame<int,_> option =
    let r = getRangeAsArray sheet ulrow ulcol lrrow lrcol
    let mutable data = None
    match r with
    | Some r -> data <- Some (seq { for col in [ulcol..lrcol] do
                                        let label = (r.GetValue [|ulrow;col|])
                                        for row in [ulrow+1..lrrow] do
                                            yield (row-1, label, r.GetValue [|row;col|]) } )
    | _ -> ignore r
    let mutable frame = None
    try
        match data with
        | Some data -> frame <- Some (Frame.ofValues data)
        | _ -> ignore data
    with
        | _ -> Log.error (sprintf "Failed to read Frame at [%A,%A] [%A,%A]" 
            ulrow ulcol lrrow lrcol)
    frame

/// catch the exception, when the user opts for overwriting an already opened Workbook
let trySave (workbook: Workbook) =
    try 
        workbook.Save()
    with
        | _ -> ignore workbook

/// be explicite: path might be None (pseudo overloading)
type ExcelWorkbook(path: string option, fname: string) =
    /// should be a singleton shared by workbooks?
    let excel = getExcel()
    let fqn = 
        match path with 
        | Some path -> path+"\\"+fname 
        | _ -> System.Environment.CurrentDirectory+fname 
    let workbooks = 
        match excel with 
        | Some excel -> getWorkbooks excel 
        | _ -> None
    let workbook = 
        match workbooks with 
        | Some workbooks -> getWorkbook workbooks fqn
        | _ -> None
    let sheets = 
        match workbook with 
        | Some workbook -> Some workbook.Sheets 
        | _ -> None
    /// would want to manage an array of sheet(s) ?
    let mutable sheet = None

    /// Finally destilled from: 
    /// http://stackoverflow.com/questions/158706/how-to-properly-clean-up-excel-interop-objects
    /// http://stackoverflow.com/questions/19977337/closing-excel-application-with-excel-interop-without-save-message
    /// http://msdn.microsoft.com/en-us/library/h1e33e36.aspx       
    member x.close() =
        match workbook with | Some workbook -> trySave(workbook) | _ -> ignore workbook
        /// may release None:
        releaseComObject sheet |> ignore
        releaseComObject sheets |> ignore
        releaseComObject workbook |> ignore
        match workbooks with | Some workbooks -> workbooks.Close() | _ -> ignore workbooks
        releaseComObject workbooks  |> ignore
        match excel with | Some excel -> excel.Quit() | _ -> ignore excel
        releaseComObject excel |> ignore     

    /// Expert F# 3.0, p. 139
    interface System.IDisposable with
        member x.Dispose() = x.close()

    member x.setSheetByName name =
        match sheets with 
        | Some (sheets) -> sheet <- Some(getSheetByName sheets name)
        | _ -> ignore name

    member x.setSheetByIndex idx = 
        match sheets with 
        | Some (sheets) -> sheet <- Some (getSheetByIndex sheets idx)
        | _ -> ignore idx

    member x.getFrameWithStringHeader (ul: int*int) (lr: int*int) = 
        match sheet with 
        | Some sheet -> getFrameWithStringHeader sheet ul lr
        | _ -> None
        
    member x.getRangeAsArray ulrow ulcol lrrow lrcol : Array option =
        match sheet with 
        | Some sheet -> getRangeAsArray sheet ulrow ulcol lrrow lrcol
        | _ -> None

    member x.getFrameWithHeader ulrow ulcol lrrow lrcol : Frame<int,_> option =
        match sheet with 
        | Some sheet -> getFrameWithHeader sheet ulrow ulcol lrrow lrcol
        | _ -> None