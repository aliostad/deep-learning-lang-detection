#r "packages/Fake/tools/FakeLib.dll"
#I "packages/Fake/tools"

open Fake
open Fake.ProcessHelper
open System.Diagnostics

let run (src: string) =
    printfn "before ======> %A" src
    //Shell.Exec "ls" |> printfn "%A" คอมเม้นไว้ทำไม?
    let info = ProcessStartInfo()
    info.FileName <- "fsharpi"
    info.Arguments <- src
    info.RedirectStandardOutput <- true
    info.RedirectStandardError <- true

    use p = new Process()
    p.StartInfo <- info
    p.Start()  |> ignore

    let output = p.StandardOutput.ReadToEnd()
    let error = p.StandardError.ReadToEnd()

    printfn "%A" output
    printfn "%A" error

    p.WaitForExit()

let go change = 
    let fileName  = change.Name
    fileName |> run

Target "watch" (fun _ ->
    use watcher = !! "test*.fsx" |> WatchChanges (fun changes ->
            tracefn  "%A" changes
            go (changes |> Seq.toList |> List.head)
    )
    System.Console.ReadLine() |> ignore
    watcher.Dispose()
)

Target "exec" (fun _ ->
    Shell.Exec("ls") |> printfn "%A"
)

RunTargetOrDefault "watch"
