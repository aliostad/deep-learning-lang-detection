namespace RunMany

[<AutoOpen>]
module Utilities = 
    open System.Threading.Tasks

    let inline tap f a = f a; a
    type Agent<'a> = MailboxProcessor<'a>

module Option = 
    let inline def v o = defaultArg o v

module Process = 
    open System
    open System.Diagnostics
    open System.Threading.Tasks
    open System.Management
    open FSharp.Collections.ParallelSeq

    let fix (proc: Process option) = 
        match proc with
        | None -> None
        | Some p when p.HasExited -> None
        | _ -> proc

    let exec command = 
        let comspec = Environment.GetEnvironmentVariable("COMSPEC")
        let arguments = command |> sprintf "/c %s"
        let info = ProcessStartInfo(comspec, arguments, UseShellExecute = false)
        Process.Start(info) |> Some |> fix

    let wait (proc: Process option) = 
        match proc |> fix with
        | None -> Task.CompletedTask
        | Some p -> Task.Factory.StartNew((fun () -> p.WaitForExit()), TaskCreationOptions.LongRunning)

    let children (proc: Process option) = 
        match proc |> fix with
        | None -> Seq.empty
        | Some p -> 
            let query = p.Id |> sprintf "select * from Win32_Process where ParentProcessID = %d"
            use searcher = new ManagementObjectSearcher(query)
            let collection = searcher.Get() |> Seq.cast<ManagementObject>
            collection |> Seq.map (fun o -> o.["ProcessId"] |> Convert.ToInt32 |> Process.GetProcessById)

    let rec kill (proc: Process option) = 
        proc |> fix |> Option.iter (fun p -> 
            p |> Some |> children |> PSeq.iter (Some >> kill)
            p.Kill()
            p.WaitForExit()
        )
