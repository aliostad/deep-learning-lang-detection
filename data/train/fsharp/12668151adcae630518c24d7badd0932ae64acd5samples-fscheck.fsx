open System
open System.IO

Environment.CurrentDirectory <- __SOURCE_DIRECTORY__

if not (File.Exists "paket.exe") then
    let url = "https://github.com/fsprojects/Paket/releases/download/0.26.3/paket.exe"
    use wc = new Net.WebClient()
    let tmp = Path.GetTempFileName()
    wc.DownloadFile(url, tmp)
    File.Move(tmp, Path.GetFileName url)

#r "paket.exe"

Paket.Dependencies.Install """
    source https://nuget.org/api/v2
    nuget FsCheck.Xunit
    nuget FAKE
    nuget xunit.runners
""";;

#r "packages/FAKE/tools/FakeLib.dll"

open Fake
open Fake.FscHelper

let outputPath = Path.Combine(Environment.CurrentDirectory, "bin")
let outputFile = @"bin\GettingStarted.dll";
let references =
    [ "packages/xunit/lib/net20/xunit.dll";
      "packages/FsCheck/lib/net45/FsCheck.dll";
      "packages/FsCheck.Xunit/lib/net45/FsCheck.Xunit.dll" ]

Target "CreateOutputPath" (fun _ -> 
    CreateDir outputPath)

Target "CleanOutputPath" (fun _ ->
    CleanDir outputPath)

Target "CompileFiles" (fun _ ->
    [ "tests/GettingStarted.fs" ]
    |> Fsc (fun options ->
        { options with
            Output = outputFile
            FscTarget = Library
            References = references }))

Target "CopyAssemblyReferences" (fun _ ->
    CopyFiles
        outputPath
        references)

Target "RunTests" (fun _ ->
    !! outputFile
    |> xUnit (fun options -> options))

"CreateOutputPath"
    ==> "CleanOutputPath"
    ==> "CompileFiles"
    ==> "CopyAssemblyReferences"
    ==> "RunTests"

RunTargetOrDefault "RunTests"
