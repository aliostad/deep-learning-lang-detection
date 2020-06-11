// include Fake lib
#r @"tools/FAKE/tools/FakeLib.dll"
open System
open System.IO
open Fake
open TeamCityHelper

// Properties
let buildDir = "./build/"
let webBuildDir = buildDir + "_PublishedWebsites/lrtechfestdemo/"
let toolsDir = "./tools/"
let nuspecFile = "./lrtechfestdemo.nuspec"
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
            Project = "lrtechfestdemo"
            Description = "lrtechfestdemo"
            OutputPath = packageDir
            Summary = "lrtechfestdemo"
            WorkingDir = webPackageDir
            Version = version
            Publish = false })
        "lrtechfestdemo.nuspec"

    PublishArtifact (packageDir + "lrtechfestdemo." + version + ".nupkg")
)

// Dependencies
"Clean"
    ==> "Build"
    ==> "Package"
    ==> "CreateNuGetPackage"

// Start build
RunTargetOrDefault "CreateNuGetPackage"