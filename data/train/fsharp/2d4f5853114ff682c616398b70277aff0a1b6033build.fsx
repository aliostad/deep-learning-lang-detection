#r @"packages/FAKE/tools/FakeLib.dll"
open Fake
RestorePackages()
let buildDir = "./build/"
let testDir  = "./test/"

Target "Clean" (fun _ ->
  CleanDirs [buildDir; testDir]
)

Target "BuildApp" (fun _ ->
  !! "InterpreterL/**/*.fsproj"
    |> MSBuildRelease buildDir "Build"
    |> Log "AppBuild-Output: "
)

Target "BuildTest" (fun _ ->
  !! "Tests/**/*.fsproj"
    |> MSBuildDebug testDir "Build"
    |> Log "BuildTest-Output: "
//  !! "src/Tests/**/*.txt"
  Copy testDir !!"Tests/**/*.txt"
)

Target "Test" (fun _ ->
  !! (testDir + "/*.dll")
    |> NUnit (fun p ->
        {p with
           DisableShadowCopy = true;
           OutputFile = testDir + "TestResults.xml" })
)

Target "Default" (fun _ ->
  trace "Default Target."
)

"Clean"
  ==> "BuildApp"
  ==> "BuildTest"
  ==> "Test"
  ==> "Default"

RunTargetOrDefault "Default"
