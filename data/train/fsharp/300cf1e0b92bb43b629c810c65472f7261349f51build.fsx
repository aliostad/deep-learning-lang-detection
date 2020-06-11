//include Fake lib
#r @"tools/FAKE/tools/FakeLib.dll"
open Fake
open Fake.FscHelper
open Fake.NUnitCommon
open Fake.NUnitSequential

let buildDir = "./build"

Target "Clean" (fun _ ->
    CleanDir buildDir
)

// Default target
Target "Default" (fun _ ->
    let references = [
        "tools/NLog/lib/net45/NLog.dll";
    ]

    ["runner.fs"]
    |> Fsc (fun parameters ->
        {parameters with 
            References = references;
            OtherParams=["--optimize+"; "--debug:full"; "--checked+"; "--standalone"];
            Platform=X64
        }
    )
    Copy buildDir (references @ ["runner.exe"; "runner.exe.mdb"])
)

Target "Test" (fun _ ->
    let references = [
        "lib.dll";
        "tools/FsCheck/lib/net40-Client/FsCheck.dll";
        "tools/NUnit/lib/nunit.framework.dll";
        "tools/FsUnit/Lib/Net40/FsUnit.NUnit.dll";
    ]
    Copy buildDir references

    ["tests.fs"]
    |> Fsc (fun parameters ->
        {parameters with
            References = references;
            OtherParams=["--optimize+"; "--debug:full"];
            FscTarget=Library;
            Platform=X64;
            Output="tests.dll";
        }
    )
    Copy buildDir (references @ ["tests.dll"])

    [buildDir + "/tests.dll"]
        |> NUnit (fun parameters ->
            {parameters with ErrorLevel = FailOnFirstError}
        )
)


Target "MakeDeps" (fun _ ->
    !! "src/app/**/*.csproj"
        |> MSBuildRelease buildDir "Build"
        |> Log "AppBuild-Output: "
)

// Dependencies

"Clean"
    ==> "MakeDeps"
    ==> "Default"

"Clean"
    ==>"Default"
    ==> "Test"

// start build
RunTargetOrDefault "Default"
