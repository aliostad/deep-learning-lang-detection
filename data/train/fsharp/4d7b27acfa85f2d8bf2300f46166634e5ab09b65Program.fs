open BulkCopyToNpgsql
open JsonToNpgsql
open ParseCommandLine
open ReadFromStandardIn
open System
open System.IO

let usage = """
Usage: PostgresPusher [/i <ImportMethod>] [/s <server>] [/p <port>] [/u <userId>]
                      [/pw <password>] [/db <database>]
                      [/tbl <table>] [/col <column_for_value>]
/i <ImportMethod> - Default: Insert | BulkCopy
/c <server> - Default: 127.0.0.1 The IP of the PostgreSQL server
/d <port>   - Default: 5432
/u <userId> - Default: postgres
/pw <password>
/db <database>
/tbl <table>
/col <column_for_value>
            """

let handleInvalidArgs (message : string) = 
    Console.WriteLine message
    Console.WriteLine usage
    match Environment.UserInteractive with
    | true -> 
        Console.WriteLine "Press any key to exit..."
        Console.ReadKey() |> ignore
    | false ->
        0 |> ignore

let handleValidArgs options = 
    let connString = 
        sprintf "Server=%s;Port=%d;User Id=%s;Password=%s;Database=%s" options.server options.port options.userId 
            options.pwd options.db
    
    let target : dbTarget = 
        { table = options.table
          column = options.column }
    
    let raw = Console.OpenStandardInput()
    match options.importMethod with
    | ImportMethod.BulkCopy -> raw |> bulkCopyStdInTo connString options.table
    | ImportMethod.Insert -> 
        let input = 
            let buffer = new BufferedStream(raw)
            new StreamReader(buffer)
        input
        |> readIt
        |> pushTo connString target

[<EntryPoint>]
let main argv = 
    let args = parseArgs <| Array.toList argv <| Args defaults
    match args with
    | ParseError message -> 
        handleInvalidArgs message
        1
    | Args options -> 
        handleValidArgs options
        0
