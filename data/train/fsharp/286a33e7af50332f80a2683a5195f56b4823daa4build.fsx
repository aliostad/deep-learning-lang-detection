// include Fake libs
#r "./packages/FAKE/tools/FakeLib.dll"

open Fake

// Directories
let htmlSourceDir = "./Blog/html/"
let htmlTargetDir = "./build/html/"
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
    |> Log "AppBuild-Output: "
)

Target "CopyHTMLs" (fun _ ->
    CopyDir htmlTargetDir htmlSourceDir (fun _ -> true)
)

Target "CopyWebConfig" (fun _ ->
    CopyFile buildDir "./Blog/web.config"
)

Target "Deploy" (fun _ ->
    !! (buildDir + "/**/*.*")
    -- "*.zip"
    |> Zip buildDir (deployDir + "ApplicationName." + version + ".zip")
)

// Build order
"Clean"
  ==> "CopyHTMLs"
  ==> "CopyWebConfig"
  ==> "Build"
  ==> "Deploy"

// start build
RunTargetOrDefault "Build"
