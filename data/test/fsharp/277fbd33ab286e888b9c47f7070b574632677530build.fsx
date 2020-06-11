// include Fake libs
#r "./packages/FAKE/tools/FakeLib.dll"

open Fake

// Directories
let buildDir  = "./build/"
let testDir  = "./test/"

// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir]
)

Target "Build" (fun _ ->
    !! "/**/*.fsproj"
    |> MSBuildDebug buildDir "Build" 
    |> Log "AppBuild-Output: "
)

Target "Test" (fun _ ->
    !! "/**/build/<%= namespace %>.dll"
    |> NUnit (fun p ->
        {p with
            ToolPath = "./packages/NUnit.Runners/tools"
            ToolName = "nunit-console.exe"
            DisableShadowCopy = true;
            ShowLabels = false;
        })
)

// Build order
"Clean"
  ==> "Build"
  ==> "Test"

// start build
RunTargetOrDefault "Test"
