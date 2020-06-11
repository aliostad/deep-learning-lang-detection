// --------------------------------------------------------------------------------------
// FAKE build script
// --------------------------------------------------------------------------------------
#r "packages/build/FAKE/tools/FakeLib.dll"

open Fake
open Fake.Git
open Fake.AssemblyInfoFile
open Fake.ReleaseNotesHelper
open System
open System.IO
open Fake.Testing.Expecto

let fantomasCLIDir =
    @"paket-files/local/github.com/dungpa/fantomas/src/Fantomas.Cmd/bin/Release"
let fantomasCLIReleaseDir = @"release/fantomas-cli"

let platformTool tool winTool =
    let tool =
        if isUnix then tool
        else winTool
    tool
    |> ProcessHelper.tryFindFileOnPath
    |> function 
    | Some t -> t
    | _ -> failwithf "%s not found" tool

let npmTool = platformTool "npm" "npm.cmd"

Target "CopyFantomasCLI" 
    (fun _ -> 
    copyRecursive (DirectoryInfo fantomasCLIDir) 
        (DirectoryInfo fantomasCLIReleaseDir) false 
    |> printfn "Copied FantomasCLI Files: \n%A")
RunTargetOrDefault "CopyFantomasCLI"
