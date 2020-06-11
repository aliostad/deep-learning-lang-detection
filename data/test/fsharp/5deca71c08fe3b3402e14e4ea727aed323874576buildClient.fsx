#I "../packages/FAKE/tools/"

#r @"FakeLib.dll"

open System
open System.IO

open Fake
open Fake.ProcessHelper
open Fake.StringHelper

let combineWith p2 p1 = Path.Combine(p1, p2)

let dir = (new DirectoryInfo(__SOURCE_DIRECTORY__)).Parent.FullName

let workDir = Path.Combine(dir, "client")

Environment.CurrentDirectory <- workDir

let jakePath =
    match isUnix with
    | false -> Path.Combine(workDir, "jake.cmd")
    | true  -> Path.Combine(workDir, "jake.sh")

let runtests = "default"
let build    = "build"

let runClient arg =
    let res =
        ExecProcessAndReturnMessages (fun info ->
            info.FileName <- jakePath
            info.Arguments <- arg
            info.WorkingDirectory <- workDir)
            (TimeSpan.FromMinutes 2.)

    for msg in res.Messages do
        printfn "%s" msg

    if res.ExitCode <> 0 then
        failwith
        <| sprintf "Client code didn't pass:\n %s"
                   (res.Errors |> String.concat "\n")

// Copies the client generatated distribution folder
// to the bin folder
Target "CopyClient" (fun _ ->
    let dist =
        workDir
        |> combineWith "generated"
        |> combineWith "dist"
    let webconfig =
        dir
        |> combineWith "deploy"
        |> combineWith "web.config"
    let app = 
        dir
        |> combineWith "bin"
        |> combineWith "GenUnitApp"
    let client = 
        app
        |> combineWith "client"
    let target =
        client
        |> combineWith "generated"
        |> combineWith "dist"
    
    // add the web.config
    CopyFile app webconfig
    
    // copy/replace the client
    DeleteDir client
    CopyDir target dist (fun _ -> true)

    // delete compressed folder 
    DeleteDir (app |> combineWith "_temporary_compressed_files")

    let docsSource = 
        workDir
        |> combineWith "docs"
    let docsTarget = 
        dir
        |> combineWith "docs"
        |> combineWith "files"
        |> combineWith "client"

    // copy/replace the client docs
    DeleteDir docsTarget
    CopyDir docsTarget docsSource (fun _ -> true)
)

Target "BuildClient" <| fun _ -> runClient build

Target "ClientTests" <| fun _ -> runClient runtests
