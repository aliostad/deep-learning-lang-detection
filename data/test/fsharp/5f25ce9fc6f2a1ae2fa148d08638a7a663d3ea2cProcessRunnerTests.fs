module ProcessRunnerTests

open NUnit.Framework
open Hopac.Extras
open Hopac
open Hopac.Infixes
open System.Diagnostics

[<Test>]
let ``ProcessExited alt is signalled if process normally exited``() =
    let info = ProcessRunner.createStartInfo @"..\..\..\TestConsole\bin\TestConsole.exe" "1 0"
    info.WindowStyle <- ProcessWindowStyle.Normal
    info.CreateNoWindow <- false
    let p = info |> ProcessRunner.createProcess |> ProcessRunner.startProcess

    Alt.choose [
        p.ProcessExited ^-> function 
            | Ok() -> printfn "Process normally exited" 
            | Fail e -> failwithf "Process exited with error %A" e
        timeOutMillis 5000 ^-> fun () -> failwithf "Process has not exited in 5 seconds"
    ] |> run
    ()

[<Test>]
let ``ProcessExited alt is signalled if process is killed from outside``() =
    let info = ProcessRunner.createStartInfo @"..\..\..\TestConsole\bin\TestConsole.exe" "10 0"
    info.WindowStyle <- ProcessWindowStyle.Normal
    info.CreateNoWindow <- false
    let systemp = ProcessRunner.createProcess info
    let p = ProcessRunner.startProcess systemp

    job { 
        do! timeOutMillis 1000
        printf "Killing the process..."
        systemp.Kill()
        printfn "done."
    } |> start

    Alt.choose [
        p.ProcessExited ^-> function 
            | Ok() -> failwithf "Process normally exited, but an error was expected" 
            | Fail e -> printfn "Process exited with error %A" e
        timeOutMillis 5000 ^-> fun () -> failwithf "Process has not exited in 5 seconds"
    ] |> run

    ()