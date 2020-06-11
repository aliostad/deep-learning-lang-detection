// include Fake lib
#r @"packages/FAKE/tools/FakeLib.dll"
open Fake
open Fake.FscHelper

//Properties
let buildDir = "./output/"

// Targets
Target "Clean" (fun _ ->
                CleanDir buildDir
                )

Target "demo.exe" (fun _ ->
                   ["source/demo.fs"]
                   |> Fsc (fun p -> {p with
                                     Output=buildDir + "demo.exe"
                                     Debug=true
                                     FscTarget=Exe
                                     References=[]})
                   )

Target "tests.dll" (fun _ ->
                    ["source/tests.fs"]
                    |> Fsc (fun p -> {p with
                                      Output=buildDir + "tests.dll"
                                      Debug=true
                                      FscTarget=Library
                                      References=["output/demo.exe"
                                                  "packages/NUnit.Runners.2.6.4/tools/nunit.framework.dll";
                                                  "packages/FsUnit.1.3.0.1/Lib/Net40/FsUnit.NUnit.dll"
                                                  "packages/FsCheck.1.0.4/lib/net45/FsCheck.dll"
                                                  "packages/FsCheck.Nunit.1.0.4/lib/net45/FsCheck.NUnit.dll"]})
                    )

Target "copyLocal" (fun _ ->
                     Shell.Exec( "bash", "./copyLocal.sh" ) |> ignore
                    )

Target "runTests" (fun _ ->
                   ["output/tests.dll"]
                   |> NUnit (fun p ->
                             {p with
                               DisableShadowCopy=true
                               OutputFile=buildDir + "testResult.xml"})
                   )

//Dependencies
"Clean"
   ==> "demo.exe"
   ==> "tests.dll"
   ==> "copyLocal"
   ==> "runTests"

// start build
//RunTargetOrDefault "tests.dll"
RunTargetOrDefault "runTests"
