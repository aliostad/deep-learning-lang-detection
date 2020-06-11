module DevRT.ProcessRunner

open System.Diagnostics
open System
open ConsoleOutput

let getProcessStartInfo fileName arguments workingDir =
    let psi = ProcessStartInfo()
    psi.FileName <- fileName
    psi.Arguments <- arguments
    psi.WorkingDirectory <- workingDir
    psi.UseShellExecute <- false
    psi.RedirectStandardOutput <- true
    psi.RedirectStandardError <- true
    psi.CreateNoWindow <- true
    psi.WindowStyle <- ProcessWindowStyle.Hidden
    psi

let run log getProcessStartInfo handleOutput =
    let startInfo: ProcessStartInfo = getProcessStartInfo()
    (startInfo.FileName, startInfo.Arguments) |> log
    use proc = new Process(StartInfo = startInfo)
    proc.ErrorDataReceived.Add(fun d ->
        if d.Data <> null then writelineRed (d.Data))
    proc.OutputDataReceived.Add(fun d ->
        if d.Data <> null then handleOutput (d.Data))
    proc.EnableRaisingEvents <- true
    proc.Start() |> ignore
    proc.BeginOutputReadLine()
    proc.BeginErrorReadLine()
    proc.WaitForExit() |> ignore
