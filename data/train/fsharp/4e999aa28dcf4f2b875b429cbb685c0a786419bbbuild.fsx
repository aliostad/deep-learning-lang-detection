// include Fake lib
#r "packages/FAKE/tools/FakeLib.dll"
open Fake
open Fake.Testing.NUnit3

RestorePackages()

// Properties
let buildDir = "./build/"
let testDir  = "./test/"

// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir; testDir]
)

Target "BuildApp" (fun _ ->
   !! "*.sln"
     |> MSBuildRelease "" "Build"
     |> Log "AppBuild-Output: "
)

// Copies binaries from default VS location to expected bin folder
// But keeps a subdirectory structure for each project in the 
// src folder to support multiple project outputs
Target "CopyBinariesToBuild" (fun _ ->
    !! "src/**/*.??proj"
    |>  Seq.map (fun f -> ((System.IO.Path.GetDirectoryName f) @@ "bin/Release", buildDir @@ (System.IO.Path.GetFileNameWithoutExtension f)))
    |>  Seq.iter (fun (fromDir, toDir) -> CopyDir toDir fromDir (fun _ -> true))
)

Target "CopyBinariesToTest" (fun _ ->
    !! "tests/**/*.??proj"
    |>  Seq.map (fun f -> ((System.IO.Path.GetDirectoryName f) @@ "bin/Release", testDir @@ (System.IO.Path.GetFileNameWithoutExtension f)))
    |>  Seq.iter (fun (fromDir, toDir) -> CopyDir toDir fromDir (fun _ -> true))
)

Target "Test" (fun _ ->
    !! (testDir + "/**/*.Tests.dll")
      |> NUnit3 (fun (p:NUnit3Params) ->
          {p with
             ShadowCopy = true})
)

Target "Default" (fun _ ->
    ()
)

// Dependencies
"Clean"
  ==> "BuildApp"
  ==> "CopyBinariesToBuild"
  ==> "CopyBinariesToTest"
  ==> "Test"
  ==> "Default"

// start build
RunTargetOrDefault "Default"