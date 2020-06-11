open FSharp.Core

open System
open System.Management
open System.Diagnostics

let isInList (opts: string[]) (p: Process) =
  try
    Array.exists (fun opt -> p.ProcessName = opt) opts
    || Array.exists (fun opt -> p.MainModule.FileName = opt) opts
  with e -> false

let killProcess (p: Process) =
  try
    Console.WriteLine (sprintf "✋  nope 🚫  :: %s" p.ProcessName)
    p.Kill()
  with e -> ()

let maybeKill (opts: string[]) (p: Process) =
  match (isInList opts p) with
  | true -> killProcess p
  | false -> ()

let maybeKillExisting opts =
  Process.GetProcesses()
  |> Seq.filter (fun p ->
    try
      not p.HasExited
    with e -> false)
  |> Seq.iter (maybeKill opts)

let setupHandler opts =
  let processStartEvent = new ManagementEventWatcher(@"\\.\root\CIMV2", "SELECT * FROM Win32_ProcessStartTrace")
  let rec monitoring() =
    let evt = processStartEvent.WaitForNextEvent()
    maybeKillExisting opts
    monitoring()
  async { monitoring() } |> Async.Start

[<EntryPoint>]
let main argv =
  maybeKillExisting argv
  setupHandler argv
  Console.ReadLine() |> ignore
  0

