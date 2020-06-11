// --------------------------------------------------------------------------------------
// FAKE build script
// --------------------------------------------------------------------------------------

#r @"packages/FAKE/tools/FakeLib.dll"
#r @"packages/FAKE.Persimmon/lib/net451/FAKE.Persimmon.dll"
open Fake

let solutionFile  = "Persimmon.Demo.sln"

let testAssemblies = "./**/bin/Release/*Demo*.dll"

// Copies binaries from default VS location to exepcted bin folder
// But keeps a subdirectory structure for each project in the
// src folder to support multiple project outputs
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
    |> MSBuildRelease "" "Rebuild"
    |> ignore
)

Target "RunTests" (fun _ ->
    !! testAssemblies
    |> Persimmon id
)

"Clean"
  ==> "Build"
  ==> "CopyBinaries"
  ==> "RunTests"

RunTargetOrDefault "RunTests"

