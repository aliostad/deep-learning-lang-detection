// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Yaaf.Shell
open System
open System.IO
open System.Diagnostics
open Yaaf.Shell.StreamModule
open Yaaf.Shell.Event

/// Will be thrown if the process doesn't end with exitcode 0.
/// The Data contained is a tuple of exitCode, commandLine, output, errorOutput.
exception ToolProcessFailed of int * string * string * string

type OutputType = 
    | StandardOutput
    | StandardError

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
                    
    let mutable throwOnExitCode = true
    let mutable lastExitCode = None
    let convertStream = toInterface 1024
    
    let mutable input = None
    let mutable output, outputCopy = None, Unchecked.defaultof<_>
    let mutable error, errorCopy = None, Unchecked.defaultof<_>
    
    do 
        toolProcess.EnableRaisingEvents <- false
        for entry in Environment.GetEnvironmentVariables() |> Seq.cast<System.Collections.DictionaryEntry> do
            toolProcess.StartInfo.EnvironmentVariables.[entry.Key :?> string] <- entry.Value :?> string
    member x.Dispose disposing = 
        if (disposing) then
            toolProcess.Dispose()
    override x.Finalize() = 
        x.Dispose(false)
    interface System.IDisposable with
        member x.Dispose() = 
            x.Dispose(true)
            System.GC.SuppressFinalize(x)
    member x.ExitCode 
        with get() = 
            match lastExitCode with
            | None -> failwith "run the process first!"
            | Some s -> s
    member x.ThrowOnExitCode 
        with get() = throwOnExitCode
        and set v = throwOnExitCode <- v
    member x.Kill() = 
        toolProcess.Kill()

    member x.StandardInput 
        with get() = 
            match input with
            | None -> failwith "Start the process first!"
            | Some s -> s
    member x.StandardOutput 
        with get() =
            match output with
            | None -> failwith "Start the process first!"
            | Some s -> s
    member x.StandardError 
        with get() =             
            match error with
            | None -> failwith "Start the process first!"
            | Some s -> s
    member x.RunAsyncRedirect(input, output, error) = 
        let closeFun = ref (fun () -> ())
        let appendF waitFinish f =
            let old = !closeFun
            closeFun :=
                (fun () -> 
                    f 10000 waitFinish
                    old())
        x.RunAsyncCallback((fun () ->
                    (* sic! *)
                    input |> redirect 1024 x.StandardInput |> appendF false
                    x.StandardError |> redirect 1024 error |> appendF true
                    x.StandardOutput |> redirect 1024 output |> appendF true
                ), (fun () ->
                    let c = !closeFun
                    c()
                ))
    member x.RunAsyncRedirectStream(input, output, error) = 
        x.RunAsyncRedirect(input |> convertStream, output |> convertStream, error |> convertStream)
    member x.RunAsyncCallback(afterStarting, afterFinish) = 
        async {
            let commandLine = 
                sprintf "%s> \"%s\" %s" workingDir processFile arguments
            let isStarted = ref false
            let start() =
                if not <| !isStarted then
                    toolProcess.EnableRaisingEvents <- true
                    if not <| toolProcess.Start() then
                        failwith "could not start process"
                    isStarted := true
                    input <- toolProcess.StandardInput.BaseStream |> convertStream |> Some
                    let o, oC = toolProcess.StandardOutput.BaseStream |> convertStream |> duplicate
                    output <- Some o
                    outputCopy <- oC
                    let e, eC = toolProcess.StandardError.BaseStream |> convertStream |> duplicate
                    error <- Some e
                    errorCopy <- eC
                    afterStarting()
                    
            // Wait for the process to finish
            let! exitEvent = 
                toolProcess.Exited 
                    // qualified because of an fsi bug
                    |> Yaaf.Shell.Event.guard start
                    |> Async.AwaitEvent
            // Waiting for the process to exit (buffers)
            toolProcess.WaitForExit()
            let exitCode = toolProcess.ExitCode
            lastExitCode <- Some exitCode
            // Should run only 1 time
            afterFinish()

            toolProcess.Close()
            toolProcess.Dispose()

            let getFailData ()= 
                let outputReader = new StreamReader(outputCopy |> fromInterface)
                let errorReader = new StreamReader(errorCopy |> fromInterface)
                outputReader.ReadToEnd(),
                errorReader.ReadToEnd()
            // Check if we already recognised an error
            (*for e in [!errorExn;!outputExn] do
                if (e <> null) then
                    // Add all infos we have
                    let output, error = getFailData()
                    e.Data.["Output"] <- output
                    e.Data.["Error"] <- error
                    e.Data.["ExitCode"] <- exitCode
                    e.Data.["Cmd"] <- commandLine
                    raise e*)

            // Check exitcode
            if throwOnExitCode && exitCode <> 0 then 
                let output, error = getFailData()
                raise (ToolProcessFailed (exitCode, commandLine, output, error))

            return exitCode
        }
