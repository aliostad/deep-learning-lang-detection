#I __SOURCE_DIRECTORY__
#r "../packages/FAKE/tools/FakeLib.dll"

open System
open System.Diagnostics
open Fake
open Fake.ProcessHelper

Environment.CurrentDirectory <- __SOURCE_DIRECTORY__

Target "Export CSV" (fun _ ->
    trace "Start exporting"

    let instances = 
        (getBuildParam "inst").Split(',')
        

    instances
    |> Array.iter (fun instance ->
        let exec() =
            ExecProcess
                (fun (info: ProcessStartInfo) ->
                    info.FileName <- "../libs/sqlite3.exe"
                    info.Arguments <- 
                        "../data/20160622/" + instance + "-logs.db.bak"
                        + " \".mode csv\"" 
                        + " \".output data/"+ instance + "-logs.csv\""
                        + " \"SELECT"
                            + " id,"
                            + " DATETIME(timestamp / 10000000 - 62135596800, 'unixepoch') AS date," 
                            + " level,"
                            + " source,"
                            + " text,"
                            + " exception,"
                            + " '" + instance + "' "
                        + " FROM logs"
                        + " WHERE date NOT NULL"
                        + " ORDER BY date ASC;\"")
                (TimeSpan.FromMinutes 5.0)

        match exec() with
        | 0 -> trace ("Sucess export for " + instance)
        | _ -> failwith ("Failed export for " + instance))
)

Run "Export CSV"