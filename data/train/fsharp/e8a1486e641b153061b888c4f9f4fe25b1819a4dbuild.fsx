#r "./packages/FAKE/tools/FakeLib.dll"

open Fake
open Fake.FileHelper
open Fake.NpmHelper

let projectDir = __SOURCE_DIRECTORY__
let outputDir = projectDir </> "bin"
let fsDir = projectDir </> "fs"
let jsDir = projectDir </> "js"

Target "Clean" (fun _ ->
    CleanDir outputDir
)

Target "Restore" (fun _ ->
    // paket restore runs from the cmd script so fake can run
    Npm (fun p -> { p with Command = Install Standard })
)

Target "Build" (fun _ ->
    !! (fsDir </> "**/*.fsproj")
    |> MSBuildHelper.MSBuild
        outputDir
        "Build"
        ["Configuration", "Debug"]
    |> Log "MSBuild: "

    Npm (fun p -> { p with Command = Run "build" })
)

Target "Run" (fun _ ->
    trace "Starting application on localhost..."
    let b, msg = FSIHelper.executeFSI projectDir "server.fsx" []
    msg |> Seq.iter (fun m -> printfn "%A" m.Message)
)

Target "CopyFiles" (fun _ ->
    FileHelper.CopyDir ("content" </> "css") "css" FileHelper.allFiles
    FileHelper.CopyDir ("content" </> "img") "img" FileHelper.allFiles
)

Target "Default" DoNothing

"Clean"
    ==> "Restore"
    ==> "Build"
    ==> "CopyFiles"
    ==> "Default"
    ==> "Run"

RunTargetOrDefault "Default"