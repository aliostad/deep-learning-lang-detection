#I @"packages/FAKE/tools/"
#r "FakeLib.dll"

open Fake

// ------------------------ //
// Configuration            //
// ------------------------ //
let output      = @"./build-output/" 
let api         = output + "api/"
let apitests    = output + "api-tests/"
let all         = [api;apitests;]
let buildArgs   = ["PlatformTarget","x86"]

// ------------------------ //
// Targets                  //
// ------------------------ //
Target "Clean" (fun _ ->
    CleanDirs all
)

Target "Build Api" (fun _ ->
    let projects = !! @"src/FSharp.GitHubApi/FSharp.GitHubApi.fsproj"
    MSBuild api "Build" buildArgs projects |> Log "Build Api Log: "
)

Target "Build Api Tests" (fun _ ->
    let projects = !! @"src/FSharp.GitHubApi.Tests/FSharp.GitHubApi.Tests.fsproj"
    MSBuild apitests "Build" buildArgs projects |> Log "Build Api Tests Log: "
)

Description "Runs the first-pass on the unit test suite (testing authentication, create/delete) which is required for second-pass tests."
Target "Run FirstPass Tests" (fun _ ->
    NUnit (fun p ->
            { p with
                IncludeCategory = "FirstPass"
                ToolPath = "./packages/NUnit.Runners/tools"
                ToolName = "nunit-console-x86.exe"
                //WorkingDir = apitests
                DisableShadowCopy = true
                OutputFile = "FirstPass.Results.xml"
                TimeOut = System.TimeSpan.MaxValue }) (!! (apitests + "FSharp.GitHubApi.Tests.dll"))
)

Description "Runs the second-pass on the unit test suite."
Target "Run SecondPass Tests" (fun _ ->
    NUnit (fun p ->
            { p with
                IncludeCategory = "SecondPass"
                ToolPath = "./packages/NUnit.Runners/tools"
                ToolName = "nunit-console-x86.exe"
                //WorkingDir = apitests
                DisableShadowCopy = true
                OutputFile = "SecondPass.Results.xml"
                TimeOut = System.TimeSpan.MaxValue }) (!! (apitests + "FSharp.GitHubApi.Tests.dll"))
)

Target "Developer" (fun _ ->
    trace "Run local developer build!"
)

// ------------------------ //
// Target Dependencies      //
// ------------------------ //
"Developer" <== ["Clean"; "Build Api"; "Build Api Tests"; "Run FirstPass Tests"; "Run SecondPass Tests"]

// ------------------------ //
// Run Build:               //
// Default - Developer      //
// ------------------------ //
RunParameterTargetOrDefault "target" "Developer"
