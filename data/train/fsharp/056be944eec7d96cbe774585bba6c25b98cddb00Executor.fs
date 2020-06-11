module IgnoreRemover.Executor

open System.Diagnostics
open System
open System.Text
open IgnoreRemover.Formatter
open System

let executeCommand cmd args=
    let info = ProcessStartInfo()
    info.FileName <- cmd
    info.Arguments <- args
    info.RedirectStandardOutput <- true
    info.UseShellExecute <- false
    info.RedirectStandardError <- true

    let outputHandler (s:DataReceivedEventArgs) = 
        let line = s.Data
        if (String.IsNullOrEmpty >> not) line then
            " -- " + line |> writeInfo

    let errorHandler (s: DataReceivedEventArgs) =
        let line = s.Data
        if (String.IsNullOrEmpty >> not) line then
            " -- " + line |> writeError 

    let ps = new Process()
    ps.StartInfo <- info
    ps.Start() |> ignore
    
    ps.OutputDataReceived.Add(outputHandler)
    ps.BeginOutputReadLine()

    ps.ErrorDataReceived.Add(errorHandler)
    ps.BeginErrorReadLine()
    ps.WaitForExit() |> ignore