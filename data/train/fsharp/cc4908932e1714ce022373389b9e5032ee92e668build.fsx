// include Fake lib
#r @"tools/FAKE/tools/FakeLib.dll"
open System
open System.IO
open Fake
open TeamCityHelper

// Properties
let buildDir = "./build/"
let toolsDir = "./tools/"

let packageDir = "./package"
let apiPackageDir = packageDir + "/AgileZenApi"
let apiDll = "./build/AgileZenApi.dll"
let nuspecFile = "./AgileZenApi.nuspec"

let version =
  match buildServer with
  | TeamCity -> buildVersion
  | _ -> "0.0.2-alpha"

// Targets
Target "Clean" (fun _ ->
    CleanDir buildDir
    CleanDir packageDir
)

Target "Build" (fun _ ->
    !! "./src/AgileZenApi/*.sln"
      |> MSBuild buildDir "Build" ["Configuration", "Release"; "VisualStudioVersion", "11.0"]
      |> Log "AppBuild-Output: "
)

Target "Package" (fun _ ->
    CreateDir (apiPackageDir + "/lib/net45/")
    CopyFile (apiPackageDir + "/lib/net45/") apiDll
    CopyFile apiPackageDir nuspecFile
)

Target "CreateNuGetPackage" (fun _ ->
    NuGet (fun p -> 
      {p with
        Project = "AgileZenApi"
        Description = "C# Agile Zen API Wrapper"
        OutputPath = packageDir
        Summary = "C# Agile Zen API Wrapper"
        WorkingDir = apiPackageDir
        Version = version
        Dependencies = (getDependencies "./src/AgileZenApi/packages.config") 
        Publish = false })
       "AgileZenApi.nuspec"

    PublishArtifact (packageDir + "AgileZenApi." + version + ".nupkg")
)

Target "PublishNuGetPackage" (fun _ ->
    NuGet (fun p -> 
      {p with
        Project = "AgileZenApi"
        Description = "C# AgileZen API Wrapper"
        OutputPath = packageDir
        Summary = "C# AgileZen API Wrapper"
        WorkingDir = apiPackageDir
        Version = version
        PublishUrl = "http://nuget.praeses.com/PraesesNuGetFeed/api/v2/package/"
        Publish = true })
       "AgileZenApi.nuspec"

    PublishArtifact (packageDir + "Praeses.Core.PWaffle." + version + ".nupkg")
)

// Dependencies
"Clean"
  ==> "Build"
  ==> "Package"
  ==> "CreateNuGetPackage"

"Package"
  ==> "PublishNuGetPackage"

// start build
RunTargetOrDefault "CreateNuGetPackage"