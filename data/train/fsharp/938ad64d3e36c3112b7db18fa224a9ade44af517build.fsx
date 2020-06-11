// include Fake lib
#r @"packages/FAKE/tools/FakeLib.dll"
open Fake
open System

let authors = ["Zengularity"]

let projectName = "prismic"
let projectDescription = "prismic.io Development Kit for .NET"
let projectSummary = "A minimal library, providing binding for any .NET language to the prismic.io REST API."

// directories
let buildDir = "../prismic.extensions/bin"
let packagingRoot = "./packaging/"
let packagingDir = packagingRoot @@ "prismic"

let buildMode = getBuildParamOrDefault "buildMode" "Release"

let releaseNotes = 
    ReadFile "../../ReleaseNotes.md"
    |> ReleaseNotesHelper.parseReleaseNotes

Target "Clean" (fun _ ->
    CleanDirs [buildDir; packagingRoot; packagingDir]
)

open Fake.AssemblyInfoFile

Target "AssemblyInfo" (fun _ ->
    CreateCSharpAssemblyInfo "../SolutionInfo.cs"
      [ Attribute.Product projectName
        Attribute.Version releaseNotes.AssemblyVersion
        Attribute.FileVersion releaseNotes.AssemblyVersion
        Attribute.ComVisible false ]
)


Target "BuildApp" (fun _ ->
    MSBuild null "Build" ["Configuration", buildMode] ["../prismic.sln"]
    |> Log "AppBuild-Output: "
)


Target "CreatePrismicPackage" (fun _ ->
    let libnet40 = "lib/net40/"
    let net40Dir = packagingDir @@ libnet40
    CleanDirs [net40Dir]

    CopyFile net40Dir (buildDir @@ "Release/prismic.dll")
    CopyFile net40Dir (buildDir @@ "Release/prismic.dll.mdb")
    CopyFile net40Dir (buildDir @@ "Release/prismic.extensions.dll")
    CopyFile net40Dir (buildDir @@ "Release/prismic.extensions.dll.mdb")
    CopyFile net40Dir (buildDir @@ "Release/FSharp.Data.dll")
    CopyFiles packagingDir ["../../README.md"; "../../ReleaseNotes.md"]

    NuGet (fun p -> 
        {p with
            Authors = authors
            Project = projectName
            Description = projectDescription                               
            OutputPath = packagingRoot
            Summary = projectSummary
            WorkingDir = packagingDir
            Version = releaseNotes.AssemblyVersion
            ReleaseNotes = toLines releaseNotes.Notes
            Dependencies =
                ["FSharp.Data", "[2.0.7]"]
            References = 
                ["prismic.dll"; "prismic.extensions.dll"]
            Files = [
                    (libnet40@@"prismic.dll", Some(libnet40), None)
                    (libnet40@@"prismic.extensions.dll", Some(libnet40), None)
            ]
            AccessKey = getBuildParamOrDefault "nugetkey" ""
            Publish = hasBuildParam "nugetkey" }) "prismic.nuspec"
)

Target "Default" (fun _ ->
    trace "specify target : Clean, BuildApp, CreatePrismicPackage"
    trace "CreatePrismicPackage can publish package be specifying a nugetkey parameter"
)


Target "CreatePackages" DoNothing

"Clean"
   ==> "AssemblyInfo"
       ==> "BuildApp"


"CreatePrismicPackage"
   ==> "CreatePackages"


RunTargetOrDefault "Default"
