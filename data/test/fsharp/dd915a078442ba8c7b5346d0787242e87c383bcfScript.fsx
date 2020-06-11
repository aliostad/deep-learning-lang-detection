#r "./packages/FAKE/tools/FakeLib.dll"

open System
open System.IO
open Fake

Environment.CurrentDirectory <- __SOURCE_DIRECTORY__

Fake.ProcessHelper.ExecProcessAndReturnMessages (fun info ->
    info.FileName <- "node"
    info.Arguments <- "--version")
    (System.TimeSpan.FromMinutes 1.)

let npmPath =
    Fake.EnvironmentHelper.environVar "PATH"
    |> splitStr ";"
    |> List.tryFind (fun s ->
            s |> endsWith "nodejs\\")
    |> (fun so ->
        match so with
        | Some s -> s + "npm.cmd"
        | None -> "npm.cmd")

let workDir = Path.Combine(Environment.CurrentDirectory, "client")

Fake.ProcessHelper.ExecProcessAndReturnMessages (fun info ->
    info.FileName <- npmPath
    info.WorkingDirectory <- workDir
    info.UseShellExecute <- false
    info.Arguments <- "-v")
    (System.TimeSpan.FromMinutes 1.)
