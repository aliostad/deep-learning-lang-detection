#r "packages/FAKE/tools/FakeLib.dll"
#I @"packages/SourceLink.Fake/tools"

#load "SourceLink.fsx"
#load "SourceLink.Tfs.fsx"


open System
open System.IO
open Fake
open SourceLink

let projectName = "Mozu.Api"
//NOTE! you need to increment this if you want the version published to change.
let version = "1.23.1.5"
let bin = "bin"

Target "Clean" (fun _ -> !! "**/bin/" ++ "**/obj/" |> CleanDirs)

Target "BuildSln" (fun _ ->
    let getBuildParams p =
            {Fake.MSBuildHelper.MSBuildDefaults with
                Targets = ["Rebuild"]
                Properties = [("Configuration", "Release");] }

    build getBuildParams "Mozu.Api.sln"
)

Target "Test" (fun _ ->
    
    let parameters = 
        { NUnitDefaults with 
            Framework = "net-45" 
            ToolPath = @"packages\Nunit.runners\tools" }

    !! "**/*.Tests.dll"
    -- ".\packages\*"
    |> NUnit (fun p -> p)
)

Target "NuGet" (fun _ ->
    
    ensureDirectory bin

    NuGet (fun p ->
    { p with
        Version = version
        OutputPath = bin
        WorkingDir = ".\Mozu.Api"
        ToolPath = "nuget.exe"
    }) "Mozu.Api\Mozu.Api.nuspec"
)

Target "Publish" (fun _ ->
        
    let setParams (p : NuGetParams) =               
        {p with
            PublishUrl = getBuildParam "publishUrl"
            TimeOut = TimeSpan.FromMinutes 5.0
            Project = "Mozu.Api.SDK"
            WorkingDir = ".\Mozu.Api"
            ToolPath = "nuget.exe"
            Version = version
            OutputPath = bin } 

    if not (hasBuildParam "publishUrl") then failwith "the build param PublishUrl mst be present to publish"

    NuGetPublish setParams
)

"Clean"
    ==> "BuildSln"
    ==> "NuGet"

"NuGet" ==> "Publish"

RunTargetOrDefault "NuGet"