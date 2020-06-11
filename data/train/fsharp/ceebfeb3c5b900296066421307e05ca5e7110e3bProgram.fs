// Learn more about F# at http://fsharp.org
// See the 'F# Tutorial' project for more help.

open System
open Impossible
open Impossible.Parse
open System.Linq

[<EntryPoint>]
let main argv = 
//    printfn "%A" argv
    use conn = new System.Data.SqlClient.SqlConnection(DB.ConnectionString)
    conn.Open ()
    // Cross apply
    query {
        for api in
            set [  
                APIList (API.Films (1, None) )
                APIList (API.Films (2, None) )
            ] do
        for version in
            set [
                API.V1P0
                API.V1P1
            ] do
        select (Parse.generateAPI api version conn)
    } |> Seq.concat
    |> Async.Parallel
    |> Async.RunSynchronously
    // |> writeToServer [ Dev; Stage; Prod ]
    |> printfn "%A"
    Console.ReadLine () |> ignore
    0 // return an integer exit code
