#r @"packages/FAKE/tools/FakeLib.dll"
#r @"packages/FSharpLint.Fake/tools/FSharpLint.Fake.dll"

open System
open System.Diagnostics
open System.IO
open Fake
open Fake.Testing.XUnit2
open Fake.OpenCoverHelper
open FSharpLint.Fake

let buildDir = "./build/"
let testDir = "./tests/"
let testDlls = !! (testDir + "*.Tests.dll")
let deployDir ="./release/"
let isCIBuild = hasBuildParam "ci"
let openCoverResultsXmlPath = testDir @@ "results.xml"
let packageDir = Directory.GetCurrentDirectory() @@ "packages/"
    
Target "Clean" (fun _ -> CleanDirs [ buildDir; testDir; deployDir ])

Target "Lint" (fun _ ->
    !! "**/*.fsproj"
        |> Seq.iter (FSharpLint id)
)

Target "BuildRunner" (fun _ ->
    !! "Rexcfnghk.MarkSixParser.*/*.fsproj"
        -- "Rexcfnghk.MarkSixParser*.Tests/*.fsproj"
        |> MSBuildRelease buildDir "Build"
        |> Log "Runner built"
)

Target "BuildTests" (fun _ ->
    !! "Rexcfnghk.MarkSixParser*.Tests/*.fsproj"
        |> MSBuildDebug testDir "Build"
        |> Log "Tests built")

Target "OpenCover" (fun _ ->
    let targetArgs = 
        ["Rexcfnghk.MarkSixParser.Tests.dll"; "Rexcfnghk.MarkSixParser.Runner.Tests.dll"]
        |> List.map ((@@) testDir)
        |> String.concat " "
    OpenCover (fun p -> 
        { p with
            ExePath = packageDir @@ "OpenCover/tools/OpenCover.Console.exe"
            TestRunnerExePath = packageDir @@ "xunit.runner.console/tools/xunit.console.exe"
            Filter = "+[Rexcfnghk.MarkSixParser*]Rexcfnghk.* -[Rexcfnghk.MarkSixParser*.Tests]*"
            Output = openCoverResultsXmlPath
            OptionalArguments = if hasBuildParam "travis" then String.Empty else "-register:user" })
        (targetArgs + if not isCIBuild then String.Empty else " -noshadow")
)
        
Target "SendToCoveralls" (fun _ -> 
    let configStartProcessInfoF (info: ProcessStartInfo) =
        info.FileName <- packageDir @@ "coveralls.io/tools/coveralls.net.exe"
        info.Arguments <- sprintf "--opencover %s" openCoverResultsXmlPath

    let result = ExecProcess configStartProcessInfoF (TimeSpan.FromMinutes 1.)
    
    if result <> 0 then
        failwith "Cannot send code coverage results to Coveralls"
)

Target "RunReportGenerator" (fun _ -> 
    let configStartProcessInfoF (info: ProcessStartInfo) =
        info.FileName <- packageDir @@ "ReportGenerator/tools/ReportGenerator.exe"
        info.Arguments <- sprintf "-reports:%s -targetdir:%sreport" openCoverResultsXmlPath testDir
    
    let result = ExecProcess configStartProcessInfoF (TimeSpan.FromMinutes 1.)
    
    if result <> 0 then
        failwith "Cannot run ReportGenerator"
)

Target "Pack" (fun _ ->
    CreateDir deployDir
    !! (buildDir + "/**/*.*")
        -- "*.zip"
        |> Zip buildDir (deployDir @@ "marksix-parser.zip")
) 

"Clean"
    ==> "Lint"
    ==> "BuildRunner"
    ==> "BuildTests"
    ==> "OpenCover"
    =?> ("SendToCoveralls", isCIBuild)
    ==> "Pack"
        
"OpenCover"
    ==> "RunReportGenerator"
        
RunTargetOrDefault "Pack"
