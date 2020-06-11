module Process

open System.Diagnostics
open Common.ConsoleUtil
open ci.BuildOutput

let buildHappyPath processStartInfo expectingBuildTime handleOutput =
    use proc = new Process(StartInfo = processStartInfo)
    proc.ErrorDataReceived.Add(fun d ->
        if d.Data <> null then writelineRed d.Data)
    proc.OutputDataReceived.Add(fun d ->
        if d.Data <> null then handleOutput d.Data)
    proc.EnableRaisingEvents <- true
    proc.Start() |> ignore
    proc.BeginOutputReadLine()
    proc.BeginErrorReadLine()
    if proc.WaitForExit(expectingBuildTime) |> not then proc.Kill()
    proc.WaitForExit()

let build psi = Common.Bind.bindResult (buildHappyPath psi 2500) 
