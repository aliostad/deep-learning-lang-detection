// include Fake lib
#r @"tools/FAKE/tools/FakeLib.dll"
open System
open System.IO
open Fake
open TeamCityHelper

// Properties
let buildDir = "./build/"
let webBuildDir = buildDir + "_PublishedWebsites/FileNewProject/"
let toolsDir = "./tools/"
let nuspecFile = "./FileNewProjectIIS.nuspec"
let packageDir = "./package/"
let webPackageDir = packageDir + "Web/"

let version =
    match buildServer with
    | TeamCity -> buildVersion
    | _ -> "0.0.1-dev"

// Targets
Target "Clean" (fun _ ->
    CleanDir buildDir
    CleanDir packageDir
)

Target "Build" (fun _ ->
    !! "src/*.sln"
        |> MSBuild buildDir "Build" ["Configuration", "Release"; "VisualStudioVersion", "11.0"]
        |> Log "AppBuild-Output: "
)

Target "Package" (fun _ ->
    CreateDir webPackageDir

    CopyFile webPackageDir nuspecFile
    CopyDir webPackageDir webBuildDir allFiles
)

Target "CreateNuGetPackage" (fun _ ->
    // Copy all the package files into a package folder

    NuGet (fun p -> 
        {p with
            Authors = ["ryanrousseau"]
            Project = "FileNewProjectIIS"
            Description = "FileNewProjectIIS"
            OutputPath = packageDir
            Summary = "FileNewProjectIIS"
            WorkingDir = webPackageDir
            Version = version
            Publish = false })
        "FileNewProjectIIS.nuspec"

    PublishArtifact (packageDir + "FileNewProjectIIS." + version + ".nupkg")
)

// Dependencies
"Clean"
    ==> "Build"
    ==> "Package"
    ==> "CreateNuGetPackage"

// Start build
RunTargetOrDefault "CreateNuGetPackage"