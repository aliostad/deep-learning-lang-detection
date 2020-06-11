module BulkCopyToNpgsql

open Npgsql
open System.Text
open System.IO
open System.Threading

let bulkCopyStdInTo (connection : string) table stream = 
    use conn = new NpgsqlConnection(connection)
    conn.Open()
    let commandString = sprintf "COPY %s FROM STDIN" table
    use command = new NpgsqlCommand(commandString, conn)
    let copyIn = new NpgsqlCopyIn(command, conn, stream)
    try 
        try
            copyIn.Start()        
        finally
            copyIn.End()
    with ex -> 
        try 
            copyIn.Cancel("Undo copy")
        with :? NpgsqlException as ex2 -> 
            match ex2.ToString().Contains("Undo copy") with
            | false -> failwithf "Failed to cancel copy: %A upon failure: %A" ex2 ex
            | true -> reraise()
