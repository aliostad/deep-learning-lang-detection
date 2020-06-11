module Process

open System.Diagnostics
open System.Text
open Common

type ExitCode = ExitCode of int
type Result = Result of ExitCode * string list

let private encodingWin1251 = Encoding.GetEncoding("windows-1251")

let private startProcess (p:Process) =
    try 
        p.Start() |> ignore
        p.BeginOutputReadLine()
        p.BeginErrorReadLine()
        p.WaitForExit()
        p.ExitCode
    with e ->
        printf "Exception starting process: %A" e
        p.ExitCode

let launchProcess path args = 
    use p = new Process()
    let startInfo = p.StartInfo

    startInfo.FileName <- path
    startInfo.Arguments <- args |> String.concat " "
    startInfo.CreateNoWindow <- true
    startInfo.UseShellExecute <- false
    startInfo.RedirectStandardOutput <- true
    startInfo.RedirectStandardError <- true
    startInfo.WorkingDirectory <- workingDir
    startInfo.StandardOutputEncoding <- encodingWin1251

    let errorLines = new ResizeArray<string>();
    let outputLines = new ResizeArray<string>()

    p.OutputDataReceived.Add(fun e -> 
        if not (isNullOrWhitespace e.Data) then outputLines.Add(e.Data) |> ignore else ())

    p.ErrorDataReceived.Add(fun e ->
        if not (isNullOrWhitespace e.Data) then errorLines.Add(e.Data) |> ignore else ())

    let exitCode = p |> startProcess |> ExitCode

    let output =
        match exitCode with
        | ExitCode 0 -> outputLines
        | ExitCode _ -> errorLines   
        |> List.ofSeq

    Result (exitCode, output)