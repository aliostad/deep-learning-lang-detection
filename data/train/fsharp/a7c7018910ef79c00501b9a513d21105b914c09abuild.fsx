// include Fake libs
#r "./packages/FAKE/tools/FakeLib.dll"

open Fake

// Directories
let buildDir  = "./build/"
let deployDir = "./deploy/"
let cssDir = "./SuaveDeskClock/css/"
let jsDir = "./SuaveDeskClock/js/"
let cssTargetDir = "./build/css/"
let jsTargetDir = "./build/js/"


// Filesets
let appReferences  =
    !! "/**/*.csproj"
      ++ "/**/*.fsproj"

// version info
let version = "0.1"  // or retrieve from CI server

// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir; deployDir]
)

Target "Build" (fun _ ->
    // compile all projects below src/app/
    MSBuildDebug buildDir "Build" appReferences
        |> Log "AppBuild-Output: "
)

Target "Deploy" (fun _ ->
    !! (buildDir + "/**/*.*")
        -- "*.zip"
        |> Zip buildDir (deployDir + "ApplicationName." + version + ".zip")
)

Target "Assets" (fun _ ->
    CopyDir cssTargetDir cssDir allFiles
    CopyDir jsTargetDir jsDir allFiles
)

Target "OnlyAssets" (fun _ ->
    CopyDir cssTargetDir cssDir allFiles
    CopyDir jsTargetDir jsDir allFiles
)

// Build order
"Clean"
  ==> "Assets"
  ==> "Build"
  ==> "Deploy"

// start build
RunTargetOrDefault "Build"
