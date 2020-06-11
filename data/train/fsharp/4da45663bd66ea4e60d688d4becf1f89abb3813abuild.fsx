#r "packages/FAKE/tools/FakeLib.dll"

open Fake
open Fake.FileSystemHelper

let buildDir = "./build/"

Target "Clean" (fun _ ->
    CleanDir buildDir
)

Target "CreateDirectorySpec" (fun _ ->
    CreateDir (buildDir + "BMOutput")
    CreateDir (buildDir + "Output")
    CreateDir (buildDir + "StockFont")
    CopyRecursive "Utils" buildDir true |> ignore
    CopyFile buildDir "LICENSE"
)

Target "Test" (fun _ ->
    CopyRecursive "Test/BMOutput/" (buildDir + "BMOutput") true |> ignore
    CopyRecursive "Test/StockFont/" (buildDir + "StockFont") true |> ignore
)

Target "Build" (fun _ ->
    !! "Payday2FontTools/*.fsproj"
    |> MSBuildRelease buildDir "Build"
    |> ignore
)

Target "Default" (fun _ ->
    trace "Deploy"
)

"Clean"
==> "CreateDirectorySpec"
==> "Build"
==> "Default"

RunTargetOrDefault "Default"
