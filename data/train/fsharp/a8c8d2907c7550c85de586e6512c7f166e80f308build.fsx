#r @"packages/FAKE/tools/FakeLib.dll"
open Fake

let srcBuildDir = "./build-src/"
let testsBuildDir = "./build-tests/"

let copyAllDlls = fun sourceFolder targetFolder ->
    FileSystemHelper.directoryInfo sourceFolder
        |> FileSystemHelper.filesInDirMatching ".dll" 
        |> Array.toList
        |> List.map (fun s -> s.FullName)
        |> FileHelper.CopyFiles targetFolder

Target "clean" (fun _ ->
    CleanDir srcBuildDir
    CleanDir testsBuildDir
)

Target "compile-src" (fun _ -> 
    !! "./LogAnalyzer/*.csproj"
        |> MSBuildRelease srcBuildDir "Build"
        |> Log "compile-src output: "
)

Target "compile-tests" (fun _ -> 
    copyAllDlls srcBuildDir testsBuildDir
    !! "./LogAnalyzer.Tests/*.csproj"
        |> MSBuildRelease testsBuildDir "Build"
        |> Log "compile-tests output: "
)

Target "run-tests" (fun _ ->
    !! (testsBuildDir @@ "*.Tests.dll")
        |> Testing.XUnit2.xUnit2 (fun p ->
                { p with HtmlOutputPath = Some (testsBuildDir @@ "result.html") }
        )
)

Target "complete" (fun _ ->
    log "finished build"
)

"clean"
==> "compile-src"
==> "compile-tests"
==> "run-tests"
==> "complete"

RunTargetOrDefault "complete"