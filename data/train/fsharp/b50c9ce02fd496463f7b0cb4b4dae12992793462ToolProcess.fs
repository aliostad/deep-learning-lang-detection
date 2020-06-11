// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Yaaf.SyncLib

open System.Diagnostics
open Yaaf.AsyncTrace

/// Will be thrown if the process doesn't end with exitcode 0.
/// The Data contained is a tuple of exitCode, commandLine, output, errorOutput.
exception ToolProcessFailed of int * string * string * string

/// A simple wrapper for asyncronus process starting
type ToolProcess(processFile:string, workingDir:string, arguments:string) =
    
    let toolProcess = 
        new Process(
            StartInfo =
                new ProcessStartInfo(
                    FileName = processFile,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    RedirectStandardInput = true,
                    UseShellExecute = false,
                    WorkingDirectory = System.IO.Path.GetFullPath(workingDir),
                    CreateNoWindow = true,
                    Arguments = arguments))

    let addReceiveEvent event f = 
        let c = new System.Collections.Generic.List<_>()
        let customExn = ref null
        event
            |> Event.add (fun (data:DataReceivedEventArgs) ->
                try
                    // When there is data and we have no user exception
                    if data.Data <> null && !customExn = null then
                        match f(data.Data) with                    
                        | Option.Some t -> c.Add(t)
                        | Option.None -> ()
                with exn ->
                    try
                        toolProcess.Kill()
                    with
                        // already finished
                        | :? System.InvalidOperationException -> ()
                        // Access denied -> same as above
                        | :? System.ComponentModel.Win32Exception -> ()
                    customExn := exn
                )
        c, customExn

    do 
        toolProcess.EnableRaisingEvents <- false

    member x.Dispose disposing = 
        if (disposing) then
            toolProcess.Dispose()

    override x.Finalize() = 
        x.Dispose(false)

    interface System.IDisposable with
        member x.Dispose() = 
            x.Dispose(true)
            System.GC.SuppressFinalize(x)

    member x.Kill() = toolProcess.Kill()
    member x.RunAsync() = x.RunWithOutputAsync((fun _ -> None)) |> AsyncTrace.Ignore
            
    member x.StandardInput
        with get() = 
            toolProcess.StandardInput
            


    member x.RunWithOutputAsync(lineReceived) = 
        asyncTrace() {
            let! output, error = x.RunWithErrorOutputAsync(lineReceived, (fun _ -> None))
            return output
        }

    member x.RunWithErrorOutputAsync(lineReceived, errorReceived) = 
        asyncTrace() {
            let errorData, errorExn = addReceiveEvent toolProcess.ErrorDataReceived errorReceived
            let outputData, outputExn = addReceiveEvent toolProcess.OutputDataReceived lineReceived

            let! (t:ITracer) = traceInfo()

            // Collect error stream
            let errorBuilder = ref (new System.Text.StringBuilder())
            toolProcess.ErrorDataReceived 
                |> Event.add (fun data ->
                    if (data.Data <> null) then
                        t.logVerb "Received Error Line %s" data.Data
                        (!errorBuilder).AppendLine(data.Data) |> ignore)
            
            let outputBuilder = ref (new System.Text.StringBuilder())
            toolProcess.OutputDataReceived 
                |> Event.add (fun data ->
                    if (data.Data <> null) then
                        t.logVerb "Received Line %s" data.Data
                        (!outputBuilder).AppendLine(data.Data) |> ignore)
            let commandLine = 
                sprintf "%s> \"%s\" %s" workingDir processFile arguments

            let isStarted = ref false
            let start() =
                if not <| !isStarted then
                    toolProcess.EnableRaisingEvents <- true
                    t.logInfo "Starting Process: %s" commandLine
                    if not <| toolProcess.Start() then
                        failwith "could not start process"

                    toolProcess.BeginErrorReadLine()
                    toolProcess.BeginOutputReadLine()
                    isStarted := true
            
            t.logVerb "Waiting for the process exit event"
            // Wait for the process to finish
            let! exitEvent = 
                toolProcess.Exited 
                    |> Event.guard start
                    |> Async.AwaitEvent
                    |> AsyncTrace.FromAsync
            t.logVerb "Waiting for the process to exit (buffers)"
            toolProcess.WaitForExit()
            
            let exitCode = toolProcess.ExitCode

            // Should run only 1 time
            toolProcess.Close()
            toolProcess.Dispose()

            let getFailData ()= 
                (!outputBuilder).ToString(),
                (!errorBuilder).ToString()

            // Check if we already recognised an error
            for e in [!errorExn;!outputExn] do
                if (e <> null) then
                    // Add all infos we have
                    let output, error = getFailData()
                    e.Data.["Output"] <- output
                    e.Data.["Error"] <- error
                    e.Data.["ExitCode"] <- exitCode
                    e.Data.["Cmd"] <- commandLine
                    t.logWarn "ToolProcess custom fail!\n\tCommand Line (exited with %d): %s\n\tCustomExn: %A\n\tOutput: %s\n\tError: %s" exitCode commandLine e output error
                    raise e

            // Check exitcode
            if exitCode <> 0 then 
                let output, error = getFailData()
                t.logErr "ToolProcess failed!\n\tCommand Line (exited with %d): %s\n\tOutput: %s\n\tError: %s" exitCode commandLine output error
                raise (ToolProcessFailed (exitCode, commandLine, output, error))

            return outputData, errorData
        }
