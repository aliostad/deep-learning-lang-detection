open System
open System.Diagnostics
open System.IO
open System.Threading

// helper for parsing Ints
let (|Int|_|) value =
  match Int32.TryParse value with
  | true ,i -> Some i
  | false,_ -> None

do (* PROGRAM *)
  // path to worker executable
  let worker = Path.Combine (__SOURCE_DIRECTORY__
                             ,"valuz.worker/valuz.worker")
  // path to server code
  let serverDir  = Path.Combine (__SOURCE_DIRECTORY__,"valuz.server")
  let source     = Path.Combine (serverDir,"valuz.source.py")
  let reduce     = Path.Combine (serverDir,"valuz.reduce.py")

  // program configuration
  let workerCount = match fsi.CommandLineArgs with
                    | [| _; Int(i) |]  -> i
                    | _                -> 1

  // launch up to N workers
  for i in 1 .. workerCount do 
    Process.Start (sprintf "%s" worker) |> ignore

  // launch distributor
  Process.Start ("/usr/local/bin/python3",source) |> ignore
  // launch aggregator
  let reduce = sprintf "%s %i" reduce workerCount
  Process.Start ("/usr/local/bin/python3",reduce) |> ignore
