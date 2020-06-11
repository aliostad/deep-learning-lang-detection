namespace LogAlyzer

open System
open System.IO
open System.Collections.Generic
open System.Data
open System.Data.SqlClient
open System.Text.RegularExpressions
open System.Diagnostics

module Program =
    [<EntryPoint>]
    let Main(args) =
        try 
            let [|logPath; siteName|] = args
            let time = Stopwatch.StartNew()

            let bulkWriteToServer (reader:IDataReader) =
                use db = new SqlConnection("Server=.;Database=IisLogs;Integrated Security=SSPI")
                use bulkCopy = new SqlBulkCopy(db)
                bulkCopy.BulkCopyTimeout <- 0
                bulkCopy.EnableStreaming <- true
                bulkCopy.DestinationTableName <- String.Format("[{0}]", siteName)
                ["sequence-number"; "date"; "time"; "s-ip"; "c-ip"; "cs-method"; "cs(User-Agent)"; "cs-uri-stem"; "cs-uri-query"; "sc-status"; "time-taken"]
                |> Seq.iter (fun x -> bulkCopy.ColumnMappings.Add(SqlBulkCopyColumnMapping(x, x)) |> ignore)
                db.Open()
                bulkCopy.WriteToServer(reader)

            let processFile withReader (input:string) =
                let wantedRecord = 
                    let exts = String.Join("|", [|"ico"; "css"; "jpg"; "gif"; "swf"; "js"; "axd"; "png"; "xml"; "txt"; "pdf"; "htm"; "html"; "dll"; "rdf"; "bmp"|])
                    let r = Regex("\.(" + exts + ")$", RegexOptions.Compiled)
                    fun (x:IDataRecord) -> not(r.IsMatch(x.["cs-uri-stem"].ToString()))

                use reader = new IisLogReader(input, wantedRecord)

                let mutable s = 0
                do reader.AddCustomField("sequence-number", fun _ -> 
                    s <- s + 1
                    box s)

                reader.ReadHeaders() |> ignore
                withReader reader

            let theWork = (fun (x:string) -> async {
                Console.WriteLine("Processing {0}", x)
                processFile bulkWriteToServer x
                Console.WriteLine("Done processing {0}", x)
            })

            Directory.GetFiles(logPath, "*.log", SearchOption.AllDirectories)
            |> Seq.map theWork
            |> Async.Parallel
            |> Async.RunSynchronously
            |> ignore

            Console.WriteLine("Transfer done in: {0}", time.Elapsed)
        with
        | :? MatchFailureException -> Console.WriteLine("usage is:LogAlyzer <logPath> <siteName>")

        0