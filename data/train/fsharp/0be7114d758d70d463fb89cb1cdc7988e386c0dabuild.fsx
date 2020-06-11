#I @"packages/FAKE/tools/"

#r "FakeLib.dll"

open Fake
open System.IO
open System.Diagnostics

// Properties
let buildDir = "./build/"

// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir]
)

Target "BuildApp" (fun _ ->
   !! "**/*.fsproj"
     |> MSBuildRelease buildDir "Build"
     |> Log "AppBuild-Output: "
)

Target "Test" (fun _ ->
    !! (buildDir + "/*.exe")
      |> NUnit (fun p ->
          {p with
             DisableShadowCopy = true;
             OutputFile = buildDir + "TestResults.xml" })
)

Target "Default" (fun _ ->
    trace "Building your Dojo project"
)

// Dependencies
"Clean"
  ==> "BuildApp"
  ==> "Test"
  ==> "Default"

// start build
RunTargetOrDefault "Default"