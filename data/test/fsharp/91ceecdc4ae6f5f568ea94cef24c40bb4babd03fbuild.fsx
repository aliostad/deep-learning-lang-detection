#r @"./packages/FAKE/tools/FakeLib.dll"

open Fake.FscHelper
open Fake
open Fake.Testing.NUnit3

//Properties
let sourceDir = "./"
let buildDir = "./build/"
let buildTestDir = buildDir @@ "test"
let testDll = buildTestDir @@ "test.dll"
let testFiles dir = !! (dir @@ "./**/*Test*.fs") |> List.ofSeq
let answerFiles dir = !! (dir @@ "./**/*Answer.fs") |> List.ofSeq
let sourceFiles dir = answerFiles dir @ testFiles dir
let nunitFrameworkDll = "packages/NUnit/lib/net45/nunit.framework.dll"

let testSourceFiles() = sourceFiles buildDir

let compile output files =
    files 
    |> Compile [Out output
                References[nunitFrameworkDll]
                FscParam.Target TargetType.Library]

//Default Target
Target "Clean" (fun _ ->
    CleanDir buildDir
)

Target "CopyTests" (fun _ -> CopyFiles buildTestDir !! (sourceDir @@ "./**/*.fs"))

Target "PrepareTests" (fun _ ->
    testSourceFiles()
    |> ReplaceInFiles [("[<Ignore(\"Remove to run test\")>]", ""); (", Ignore = \"Remove to run test case\"", "")]
)

Target "CompileTests" (fun _->
    testSourceFiles() |> compile testDll
)

Target "Default" (fun _ ->
    trace "Running Excersism suite"
)

Target "Test" (fun _ ->
    Copy buildTestDir [nunitFrameworkDll]
    
    [testDll]
    |> NUnit3 (fun p -> 
        { p with
            ShadowCopy = false })
)

//Dependencies

"Clean"
    ==> "CopyTests"
    ==> "PrepareTests" 
    ==> "CompileTests"  
    ==> "Test"
        
"Test" ==> "Default"

RunTargetOrDefault "Default"