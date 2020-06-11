// include Fake libs
#r "./packages/FAKE/tools/FakeLib.dll"

open Fake
open System.IO
// Directories
let buildDir  = "./build/"
let deployDir = "./deploy/"
let resourceDir = "./res/"

// Filesets
let appReferences  =
    !! "/**/*.csproj"
      ++ "/**/*.fsproj"

// version info
let version = "0.3"  // or retrieve from CI server

// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir; deployDir]
)

Target "Build" (fun _ ->
    // Because Fake's Copy helpers aren't working
    File.Copy("res/ilaria.css","build/ilaria.css", true)

    // compile all projects below src/app/
    MSBuildDebug buildDir "Build" appReferences
        |> Log "AppBuild-Output: "
)

Target "Deploy" (fun _ ->
    !! (buildDir + "/**/*.*")
        -- "*.zip"
        |> Zip buildDir (deployDir + "Ilaria." + version + ".zip")
)

// Build order
"Clean"
  ==> "Build"
  ==> "Deploy"

// start build
RunTargetOrDefault "Build"
