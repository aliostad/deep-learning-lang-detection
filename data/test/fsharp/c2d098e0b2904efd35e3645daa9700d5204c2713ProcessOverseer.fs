namespace ProcessOverseer

open System
open System.Diagnostics

type ProcessOverseer(exitCodes, proc: Process, exe, args) =
    do if isNull proc then nullArg "process"
    let exitCodes = Set.ofSeq exitCodes
    let mutable proc = proc
    [<VolatileField>]
    let mutable isRunning = false

    member this.Process = proc
    member this.ExitCodes = exitCodes
    member this.Run() =
        if isRunning then invalidOp "Overseer is already running"
        if isNull proc then ObjectDisposedException("ProcessOverseer") |> raise

        isRunning <- true
        try
            while isRunning do
                proc.EnableRaisingEvents <- true
        
                proc.WaitForExit()

                if Set.contains proc.ExitCode exitCodes then
                    isRunning <- false
                else
                    Trace.WriteLine(sprintf "exited with code %d" proc.ExitCode)

                    let startInfo = ProcessStartInfo(exe, args)
                    startInfo.UseShellExecute <- false

                    proc.Dispose()

                    proc <- Process.Start(startInfo)

                    Trace.WriteLine(sprintf "started new instance of %s" exe)
        finally
            isRunning <- false

    member this.Dispose() =
        if isRunning then invalidOp "Can't dispose in running state"

        proc.Dispose()
        proc <- null

    static member Start(exitCodes, exe, args) =
        let startInfo = ProcessStartInfo(exe, args, UseShellExecute = false)
        let proc = Process.Start(startInfo)
        new ProcessOverseer(exitCodes, proc, exe, args)

    interface IDisposable with
        member this.Dispose() = this.Dispose()
