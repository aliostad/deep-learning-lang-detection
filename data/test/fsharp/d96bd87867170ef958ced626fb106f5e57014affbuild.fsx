#r @"packages/build/FAKE/tools/FakeLib.dll"
open Fake
open Fake.Git
open System
open System.IO

let solutionFile  = "MLStudy.sln"

Target "CopyBinaries" (fun _ ->
    !! "src/**/*.??proj"
    |>  Seq.map (fun f -> ((System.IO.Path.GetDirectoryName f) @@ "bin/Release", "bin" @@ (System.IO.Path.GetFileNameWithoutExtension f)))
    |>  Seq.iter (fun (fromDir, toDir) -> CopyDir toDir fromDir (fun _ -> true))
)

Target "Clean" (fun _ ->
    CleanDirs ["bin"; "temp"]
)

Target "Build" (fun _ ->
    !! solutionFile
    |> MSBuildReleaseExt "" [ "Platform", "Any CPU" ] "Rebuild"
    |> ignore
)

Target "All" DoNothing

"Clean"
  ==> "Build"
  ==> "CopyBinaries"
  ==> "All"

RunTargetOrDefault "All"
