// include Fake libs
#r "./packages/FAKE/tools/FakeLib.dll"

open Fake
open FileSystem

// Directories
let buildDir  = "./build/"
let deployDir = "./deploy/"


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
    MSBuildRelease buildDir "Build" appReferences
    |> Log "AppBuild-Output: ";
    !! "packages/gtk-sharp3/build/net40/*.dll.config"
    |> CopyFiles buildDir ;
    !! "src/resources/*.png"
    |> CopyFiles buildDir
    CopyFile buildDir "launch.sh"
    CopyFile buildDir "script.sh"
)

Target "Deploy" (fun _ ->
    !! (buildDir + "/**/*.*")
    -- "*.zip"
    |> Zip buildDir (deployDir + "ApplicationName." + version + ".zip")
)

// Build order
"Clean"
  ==> "Build"
  ==> "Deploy"

// start build
RunTargetOrDefault "Build"
