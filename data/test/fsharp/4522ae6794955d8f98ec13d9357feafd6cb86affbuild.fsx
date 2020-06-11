#r "packages/FAKE/tools/FakeLib.dll"
open System
open Fake
open Fake.FileSystem
open Fake.ProcessHelper
open System.Diagnostics

let buildDir = "./build"
let slnFile = "./Katana.sln"
let cwd = currentDirectory

Target "StopRunning" (fun _ ->
    killProcess "Predictions.Api")

Target "Clean" (fun _ ->
    CleanDir buildDir)

Target "CopyConfig" (fun _ ->
    "config.prod.json" |> CopyFile (buildDir + "/config.json"))

Target "Compile" (fun _ ->
    !! slnFile |> MSBuildRelease buildDir "Build" |> ignore)

Target "FrontEnd" (fun _ ->
    let grunt = tryFindFileOnPath (if isUnix then "grunt" else "grunt.cmd")
    match grunt with
    | Some g -> Shell.Exec(g, "build") |> ignore
    | None -> ())

Target "Run" (fun _ ->
    let startProcess configProcessStartInfoF =
        use proc = new Process()
        configProcessStartInfoF proc.StartInfo
        if isMono && proc.StartInfo.FileName.ToLowerInvariant().EndsWith(".exe") then
            proc.StartInfo.Arguments <- "--debug \"" + proc.StartInfo.FileName + "\" " + proc.StartInfo.Arguments
            proc.StartInfo.FileName <- monoPath
        proc.Start() |> ignore
    startProcess(fun info ->
        info.UseShellExecute <- true
        info.FileName <- sprintf "%s\\%s\\Predictions.Api.exe" cwd buildDir
        info.WorkingDirectory <- sprintf "%s\\%s" cwd buildDir))

Target "All" DoNothing

"StopRunning"
    ==> "Clean"
    ==> "CopyConfig"
    ==> "Compile"
    ==> "Run"
    ==> "All"

RunTargetOrDefault "All"
