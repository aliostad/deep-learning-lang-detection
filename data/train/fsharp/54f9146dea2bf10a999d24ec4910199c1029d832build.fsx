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
let nuspecFile = "./FileNewProject.nuspec"
let packageDir = "./package/"
let webPackageDir = packageDir + "Web/"
let webPackageContentDir = webPackageDir + "Content/"
let deployScript = "./deploy.ps1";

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
    CreateDir webPackageContentDir

    CopyFile webPackageDir deployScript
    CopyFile webPackageContentDir nuspecFile
    CopyDir webPackageContentDir webBuildDir allFiles
)

Target "CreateNuGetPackage" (fun _ ->
    // Copy all the package files into a package folder

    NuGet (fun p -> 
        {p with
            Authors = ["ryanrousseau"]
            Project = "FileNewProject"
            Description = "FileNewProject"
            OutputPath = packageDir
            Summary = "FileNewProject"
            WorkingDir = webPackageDir
            Version = version
            Publish = false })
        "FileNewProject.nuspec"

    PublishArtifact (packageDir + "FileNewProject." + version + ".nupkg")
)

// Dependencies
"Clean"
    ==> "Build"
    ==> "Package"
    ==> "CreateNuGetPackage"

// Start build
RunTargetOrDefault "CreateNuGetPackage"