// include Fake lib
#r @"packages/FAKE/tools/FakeLib.dll"
open Fake


// Properties
let buildDir = "./build"
let releaseDir = "./release"
let debugVSDir = "./Helbreath.HGServerConsole/Debug"
let releaseVSDir = "./Helbreath.HGServerConsole/Release"

// Targets
Target "Clean" (fun _ ->
trace "--- Cleaning build and test dirs --- "
CleanDirs [buildDir; releaseDir; debugVSDir; releaseVSDir]
)

Target "CopyToDebugFolder" (fun _ ->
trace "Copying from build to debug"
!! ("./build/" + "*.*")
      |> Copy "./Debug"
)

Target "BuildApp" (fun _ ->
trace "--- Building app --- "
!! "Helbreath.HGServerConsole/*.vcxproj"
 |> MSBuild "" "Build" ["Configuration", "Debug"; "PlatformToolset", "v140"; "Platform", "x86"; "OutDir", "../build"]
 |> Log "AppBuild-Output: "
)

Target "BuildInReleaseApp" (fun _ ->
trace "--- Building app --- "
!! "Helbreath.HGServerConsole/*.vcxproj"
 |> MSBuild "" "Build" ["Configuration", "Release"; "PlatformToolset", "v140"; "Platform", "x86"; "OutDir", "../release"]
 |> Log "AppBuild-Output: "
)


Target "Default" (fun _ ->
trace "--- Starting... --- "
)

// start build
"Clean" ==> "BuildApp" ==> "CopyToDebugFolder" ==> "BuildInReleaseApp" ==> "Default"

RunTargetOrDefault "Default"
