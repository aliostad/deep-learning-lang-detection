#r "packages/FAKE/tools/FakeLib.dll"

open Fake
open Fake.MSpecHelper

let buildMode = "Release"
let directoryToPackage = "src/DynamicConfiguration/bin/" @@ buildMode
let packagingRoot = "./packaging/"
let packagingDir = packagingRoot @@ "DynamicConfiguration"

let setBuildParams defaults =
        { defaults with
            Verbosity = Some(Quiet)
            Targets = ["Build"]
            Properties =
                [
                    "Optimize", "True"
                    "DebugSymbols", "True"
                    "Configuration", buildMode
                ]

         }

let authors = ["Tim Butterfield"]
let projectName = "DynamicConfiguration"
let projectDescription = "A .net library to make it simpler to access configuration settings from {app/web}.config files"
let projectSummary = projectDescription

let releaseNotes = 
    ReadFile "ReleaseNotes.md"
    |> ReleaseNotesHelper.parseReleaseNotes

let setPackagingParams defaults =
    {defaults with
            Authors = authors
            Project = projectName
            Description = projectDescription
            OutputPath = packagingRoot
            Summary = projectSummary
            WorkingDir = packagingDir
            Version = releaseNotes.AssemblyVersion
            ReleaseNotes = toLines releaseNotes.Notes
            AccessKey = getBuildParamOrDefault "nugetkey" ""
            Publish = hasBuildParam "nugetkey" 
            }

Target "Clean" (fun _ -> 
    DeleteDir "src/DynamicConfiguration/bin/debug"
    DeleteDir "src/DynamicConfiguration/bin/release"
    DeleteDir "src/DynamicConfiguration.Tests/bin/debug"
    DeleteDir "src/DynamicConfiguration.Tests/bin/release"
)

Target "Build" (fun _ ->
    build setBuildParams "src/DynamicConfiguration.sln"
)

let testDir = ".src/DynamicConfiguration.Tests/bin/release"
let testOutput = "./src/testResults"

Target "RunTests" (fun _ -> 
    !! (testDir @@ "src/DynamicConfiguration.Tests.dll")
    |> MSpec (fun parameters -> {parameters with HtmlOutputDir = testOutput} )
)

Target "CreateNugetPackage" (fun _ ->

    printf "Creating a nuget package"
    let net45Dir = packagingDir @@ "lib/net45/" 

    directoryInfo net45Dir 
    |> ensureDirExists
    
    CopyFile net45Dir (directoryToPackage @@ "DynamicConfiguration.dll")
    CopyFile net45Dir (directoryToPackage @@ "DynamicConfiguration.pdb")
    //need to copy readme, etc... 
    //CopyFiles directoryToPackage []
)


"Build"   
    ==> "CreateNugetPackage"

"Clean" 
    ==> "Build"

"Build"
    ==> "RunTests"

RunTargetOrDefault "Build"
