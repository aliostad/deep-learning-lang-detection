module Process

#r "../../packages/FAKE/tools/FakeLib.dll"
#r "../../packages/FSharp.Data/lib/net40/FSharp.Data.dll"

#load "./logo.fsx"

open Fake
open System
open System.IO

let run command args =
    tracef "%sProcess starting -> %s\r\n" Logo.text command
    let p = new System.Diagnostics.Process()
    p.StartInfo.FileName <- command
    p.StartInfo.Arguments <- args
    p.StartInfo.WorkingDirectory = (sprintf "%s/../../" __SOURCE_DIRECTORY__) |> ignore
    p.StartInfo.RedirectStandardOutput <- true
    p.StartInfo.RedirectStandardError <- true
    p.StartInfo.UseShellExecute <- false
    p.StartInfo.CreateNoWindow <- true
    p.EnableRaisingEvents <- true
    p.ErrorDataReceived.Add <| fun (arg) ->
        tracef "%sERROR -> %s\r\n" Logo.text arg.Data
    p.OutputDataReceived.Add <| fun (arg) ->
        tracef "%s%s\r\n" Logo.text arg.Data
    p.Start() |> ignore
    p.BeginErrorReadLine()
    p.BeginOutputReadLine()
    p.WaitForExit();

