#r @"tools/FAKE.Core/tools/FakeLib.dll"

open Fake
open System

let authors = ["Sdl Community"]

//project details
let projectName = "Sdl Studio Community Toolkit"
let projectDescription="The SDL Studio Community Toolkit is a collection of helper functions. It simplifies and demonstrates common developer tasks building SDL Studio plugins."
let projectSummary = projectDescription

//directories
let buildDir = "./build"
let packagingRoot = "./packaging"
let packagingDir = packagingRoot @@ "studiotoolkit"

let releaseNotes = 
    ReadFile "ReleaseNotes.md"
    |> ReleaseNotesHelper.parseReleaseNotes

let buildMode = getBuildParamOrDefault "buildMode" "Release"

MSBuildDefaults <-{
    MSBuildDefaults with 
        ToolsVersion = Some "14.0"
        Verbosity = Some MSBuildVerbosity.Minimal
        
}

Target "Clean"(fun _ ->
    CleanDirs[buildDir;packagingRoot;packagingDir]
)

open Fake.AssemblyInfoFile

Target "AssemblyInfo" (fun _ ->
    CreateCSharpAssemblyInfo "./SolutionInfo.cs"
      [ Attribute.Product projectName
        Attribute.Version releaseNotes.AssemblyVersion
        Attribute.FileVersion releaseNotes.AssemblyVersion
        Attribute.ComVisible false ]
)

let setParams defaults = {
    defaults with
        ToolsVersion = Some("14.0")
        Targets = ["Build"]
        Properties =
            [
                "Configuration", buildMode
                "OutputPath" , "./../build"
            ]
        
    }

Target "BuildApp" (fun _ ->
    build setParams "./SDL Studio Community Toolkit.sln"
        |> DoNothing
)
//Publishing is not working from build script because of an issue in FAKE with 
//latest nuget versions - https://github.com/fsharp/FAKE/issues/1241
Target "CreateCorePackage" (fun _ ->
    let portableDir = packagingDir @@ "lib/net45/"
    CleanDirs [portableDir]

    CopyFile portableDir (buildDir @@ "Sdl.Community.Toolkit.Core.dll")
    CopyFile portableDir (buildDir @@ "Sdl.Community.Toolkit.Core.XML")
    CopyFile portableDir (buildDir @@ "Sdl.Community.Toolkit.Core.pdb")
    CopyFiles packagingDir ["LICENSE"; "README.md"; "ReleaseNotes.md"]

    NuGet (fun p -> 
        {p with
            Authors = authors
            Project = "Sdl.Community.Toolkit.Core"
            Description = projectDescription
            OutputPath = packagingRoot
            Summary = projectSummary
            WorkingDir = packagingDir
            Version = releaseNotes.AssemblyVersion
            ReleaseNotes = toLines releaseNotes.Notes
            AccessKey = getBuildParamOrDefault "nugetkey" ""
            Publish = hasBuildParam "nugetkey" }) "Sdl.Community.Toolkit.Core.nuspec"
)

Target "CreateFileTypePackage" (fun _ ->
    let portableDir = packagingDir @@ "lib/net45/"
    CleanDirs [portableDir]

    CopyFile portableDir (buildDir @@ "Sdl.Community.Toolkit.FileType.dll")
    CopyFile portableDir (buildDir @@ "Sdl.Community.Toolkit.FileType.XML")
    CopyFile portableDir (buildDir @@ "Sdl.Community.Toolkit.FileType.pdb")
    CopyFiles packagingDir ["LICENSE"; "README.md"; "ReleaseNotes.md"]

    NuGet (fun p -> 
        {p with
            Authors = authors
            Project = "Sdl.Community.Toolkit.FileType"
            Description = projectDescription
            OutputPath = packagingRoot
            Summary = projectSummary
            WorkingDir = packagingDir
            Version = releaseNotes.AssemblyVersion
            ReleaseNotes = toLines releaseNotes.Notes
            AccessKey = getBuildParamOrDefault "nugetkey" ""
            Publish = hasBuildParam "nugetkey" }) "Sdl.Community.Toolkit.FileType.nuspec"
)

Target "CreateProjectAutomationPackage" (fun _ ->
    let portableDir = packagingDir @@ "lib/net45/"
    CleanDirs [portableDir]

    CopyFile portableDir (buildDir @@ "Sdl.Community.Toolkit.ProjectAutomation.dll")
    CopyFile portableDir (buildDir @@ "Sdl.Community.Toolkit.ProjectAutomation.XML")
    CopyFile portableDir (buildDir @@ "Sdl.Community.Toolkit.ProjectAutomation.pdb")
    CopyFiles packagingDir ["LICENSE"; "README.md"; "ReleaseNotes.md"]

    NuGet (fun p -> 
        {p with
            Authors = authors
            Project = "Sdl.Community.Toolkit.ProjectAutomation"
            Description = projectDescription
            OutputPath = packagingRoot
            Summary = projectSummary
            WorkingDir = packagingDir
            Version = releaseNotes.AssemblyVersion
            ReleaseNotes = toLines releaseNotes.Notes
            AccessKey = getBuildParamOrDefault "nugetkey" ""
            Publish = hasBuildParam "nugetkey" }) "Sdl.Community.Toolkit.ProjectAutomation.nuspec"
)

Target "CreateIntegrationPackage" (fun _ ->
    let portableDir = packagingDir @@ "lib/net45/"
    CleanDirs [portableDir]

    CopyFile portableDir (buildDir @@ "Sdl.Community.Toolkit.Integration.dll")
    CopyFile portableDir (buildDir @@ "Sdl.Community.Toolkit.Integration.XML")
    CopyFile portableDir (buildDir @@ "Sdl.Community.Toolkit.Integration.pdb")
    CopyFiles packagingDir ["LICENSE"; "README.md"; "ReleaseNotes.md"]

    NuGet (fun p -> 
        {p with
            Authors = authors
            Project = "Sdl.Community.Toolkit.Integration"
            Description = projectDescription
            OutputPath = packagingRoot
            Summary = projectSummary
            WorkingDir = packagingDir
            Version = releaseNotes.AssemblyVersion
            ReleaseNotes = toLines releaseNotes.Notes
            AccessKey = getBuildParamOrDefault "nugetkey" ""
            Publish = hasBuildParam "nugetkey" }) "Sdl.Community.Toolkit.Integration.nuspec"
)


Target "CreatePackages" DoNothing

Target "BuildAndCreatePackages" DoNothing

"CreateCorePackage"
    ==> "CreateFileTypePackage"
    ==> "CreateProjectAutomationPackage"
    ==> "CreateIntegrationPackage"
    ==>"CreatePackages"

"Clean"
   ==> "AssemblyInfo"
   ==> "BuildApp"

RunTargetOrDefault "BuildApp"
