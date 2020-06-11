#! packages/FAKE/tools/FAKE.exe
#r "packages/FAKE/tools/FakeLib.dll"

open Fake

let buildDir = "./bin/build/"
let testDir  = "./bin/test/"

let testFiles = !! "tests/*.in"

Target "Clean" (fun _ -> 
    CleanDir "./bin"
)

Target "Copy" (fun _ ->
    CopyFiles testDir testFiles
)

Target "BuildApp" (fun _ ->
    !! "src/app/**/*.fsproj"
        |> MSBuildRelease buildDir "Build"
        |> Log "AppBuild-Output: "
)

Target "BuildTest" (fun _ ->
    !! "src/test/**/*.fsproj"
        |> MSBuildDebug testDir "Build"
        |> Log "BuildTest-Output: "
)

Target "Test" (fun _ ->
    !! (testDir + "/*.dll")
        |> NUnit (fun p ->
            {p with
                DisableShadowCopy = true;
                OutputFile = testDir + "TestResults.xml" })
)

"Clean"
    ==> "Copy"
    ==> "BuildApp"
    ==> "BuildTest"
    ==> "Test"

Run "Test"