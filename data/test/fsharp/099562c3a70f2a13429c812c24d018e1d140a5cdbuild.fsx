#r @"FakeLib.dll"

open Fake

// Properties
let buildDir = "./build/"

// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir]
)

Target "Build" (fun _ ->
   !! "src/**/*.csproj"
     |> MSBuildRelease buildDir "Build"
     |> Log "Build-Output: "
)

Target "RunTests" (fun _ ->
    !! (buildDir + "/**Tests.dll")
      |> NUnit (fun p ->
          {p with
             DisableShadowCopy = true;
             OutputFile = null })
)

Target "Default" (fun _ ->
    trace "beep!"
)

// Dependencies
"Clean"
  ==> "Build"
  ==> "RunTests"
  ==> "Default"

// start build
RunTargetOrDefault "Default"
