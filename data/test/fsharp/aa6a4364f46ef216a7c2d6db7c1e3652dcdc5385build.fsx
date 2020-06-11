// --------------------------------------------------------------------------------------
// FAKE build script
// --------------------------------------------------------------------------------------

#I @"packages/build/FAKE/tools"
#r "FakeLib.dll"
open Fake

// --------------------------------------------------------------------------------------
// Clean build results

Target "Clean" (fun _ ->
    !! "*/bin/release/"
    |> CleanDirs
)

// --------------------------------------------------------------------------------------
// Build all projects

Target "Build" (fun _ ->
    !! ("SPUG.Newsletter.sln")
    |> MSBuildRelease "" "Rebuild"
    |> ignore
)

// --------------------------------------------------------------------------------------
// Copies binaries from default VS location to expected bin folder

Target "CopyBinaries" (fun _ ->
    !! "src/**/*.??proj"
    |>  Seq.map (fun f -> ((System.IO.Path.GetDirectoryName f) @@ "bin/Release", "bin" ))
    |>  Seq.iter (fun (fromDir, toDir) -> CopyDir toDir fromDir (fun _ -> true))
)

// --------------------------------------------------------------------------------------
// Targets dependencies

Target "All"        DoNothing   // Build

"Clean"
  ==> "Build"
  ==> "CopyBinaries"
  ==> "All"

RunTargetOrDefault "All"
