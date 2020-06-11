// include Fake lib
#r "packages/FAKE/tools/FakeLib.dll"
open Fake

RestorePackages()

// Properties
let testDir  = "./out/test/"

// Targets
Target "Clean" (fun _ ->
    CleanDirs [testDir]
)

Target "BuildTest" (fun _ ->
    !! "Exercism.Tests.csproj"
      |> MSBuildDebug testDir "Build"
      |> Log "TestBuild-Output: "
)

Target "Test" (fun _ ->
    !! (testDir + "/Exercism.Tests.dll")
      |> NUnit (fun p ->
          {p with
             DisableShadowCopy = true;
             OutputFile = testDir + "TestResults.xml" })
)

// Dependencies
"BuildTest"
  ==> "Test"

// start build
RunTargetOrDefault "Test"
