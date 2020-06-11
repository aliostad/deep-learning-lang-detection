// include Fake lib
#r @"packages/FAKE/tools/FakeLib.dll"
open Fake

// Properties
let buildDir = "./build/"
let testDir  = "./test/"

// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir; testDir]
)

Target "BuildApi" (fun _ ->
   !! "./StockfighterApi/*.fsproj"
     |> MSBuildRelease buildDir "Build"
     |> Log "AppBuild-Output: "
)

Target "BuildDashboardApp" (fun _ ->
   !! "./StockfighterDashboardApp/*.fsproj"
     |> MSBuildRelease buildDir "Build"
     |> Log "AppBuild-Output: "
)

Target "Default" (fun _ ->
    CopyDir (buildDir + "/web/") "./web/" (fun _ -> true)
    trace "Done is done"
)

// Dependencies
"Clean"
  ==> "BuildApi"
  ==> "BuildDashboardApp"
  ==> "Default"

// start build
RunTargetOrDefault "Default"
