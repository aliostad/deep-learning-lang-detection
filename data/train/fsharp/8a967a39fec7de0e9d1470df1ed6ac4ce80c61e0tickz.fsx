open System
open System.Diagnostics
open System.IO

do (* PROGRAM *)

  let server = Path.Combine (__SOURCE_DIRECTORY__
                            ,"tickz.server/Debug/tickz.server.exe")
  let client = Path.Combine (__SOURCE_DIRECTORY__
                            ,"tickz.client/bin/Debug/tickz.client.exe")

  // launch server
  Process.Start server |> ignore
  // launch three clients, each with a different stock
  [ "AAPL"; "MSFT"; "GOOG" ]
  |> Seq.map  (fun stock -> client,stock)
  |> Seq.iter (Process.Start  >> ignore)
