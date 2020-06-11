#r @"packages/FAKE/tools/FakeLib.dll"

open Fake

let buildRoot = "./build/"

let buildDir = "./build/prod/"
let testDir = "./build/test/"

Target "Clean" (fun _ ->
    CleanDirs [buildDir; testDir]
)

Target "BuildTest" (fun _ ->
    !! "test/**/*.fsproj"
        |> MSBuildDebug testDir "Build"
        |> Log "TestBuild-Output: "
)

Target "Test" (fun _ ->
    !! (testDir + "/*.Test.dll")
        |> NUnit (fun p->
            {p with
                DisableShadowCopy = true;
                OutputFile = testDir @@ "TestResults.xml"})
)

"Clean"
    ==> "BuildTest"
    ==> "Test"

RunTargetOrDefault "Clean"