module FuncInterop
open System.Collections.Generic
open System.Linq
open System.Diagnostics
open System

let GetLargeProcesses() =
    Process.GetProcesses().Where(new Func<Process,bool>(fun proc -> proc.WorkingSet64 > (8L * 1024L * 1024L))).ToList()

/// <summary>Get row index within a collection</summary>
let GetRowIndex (datasource: IEnumerable<'t>) (functionToFind: 't -> bool) : int =
    let paramcheck = datasource <> null
    match paramcheck with
    | true -> Seq.findIndex functionToFind datasource
    | _ -> -1
