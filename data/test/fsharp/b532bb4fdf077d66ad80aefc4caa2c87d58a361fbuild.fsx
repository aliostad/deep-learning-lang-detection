#r @"tools/FAKE.Core/tools/FakeLib.dll"
#load "tools/SourceLink.Fake/tools/SourceLink.fsx"
open Fake 
open System
open SourceLink

let authors = ["Geoffrey Huntley"]

// project name and description
let projectName = "OpenBrowser"
let projectDescription = "OpenBrowser is a super simple library that does one thing and does it well. It  does exactly what the name entails, a cross-platform pattern for launching the default browser on a mobile/tablet device from a portable class library viewmodel. In the future, if demand exists the interface may be extended to add support for browsers other than the default browser."
let projectSummary = projectDescription

// directories
let buildPortableDir = "./src/OpenBrowser/bin"
let buildDroidDir = "./src/OpenBrowser.Droid/bin"
let buildiOSDir = "./src/OpenBrowser.iOS/bin"
let buildUWPDir = "./src/OpenBrowser.UWP/bin"
let buildWP8Dir = "./src/OpenBrowser.WP8/bin"

let testResultsDir = "./testresults"
let packagingRoot = "./packaging/"
let packagingDir = packagingRoot @@ "OpenBrowser"

let releaseNotes = 
    ReadFile "RELEASENOTES.md"
    |> ReleaseNotesHelper.parseReleaseNotes

let buildMode = getBuildParamOrDefault "buildMode" "Release"

MSBuildDefaults <- { 
    MSBuildDefaults with 
        ToolsVersion = Some "14.0"
        Verbosity = Some MSBuildVerbosity.Minimal }

Target "Clean" (fun _ ->
    CleanDirs [buildPortableDir; buildDroidDir; buildiOSDir; buildUWPDir; buildWP8Dir; testResultsDir; packagingRoot; packagingDir]
)

open Fake.AssemblyInfoFile
open Fake.Testing

Target "AssemblyInfo" (fun _ ->
    CreateCSharpAssemblyInfo "./src/SolutionInfo.cs"
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
            ]
    }

let Exec command args =
    let result = Shell.Exec(command, args)
    if result <> 0 then failwithf "%s exited with error %d" command result

Target "BuildApp" (fun _ ->
    build setParams "./src/OpenBrowser.sln"
        |> DoNothing
)

Target "BuildMono" (fun _ ->
    // xbuild does not support msbuild  tools version 14.0 and that is the reason
    // for using the xbuild command directly instead of using msbuild
    Exec "xbuild" "./src/OpenBrowser.sln /t:Build /tv:12.0 /v:m  /p:RestorePackages='False' /p:Configuration='Release' /logger:Fake.MsBuildLogger+ErrorLogger,'../src/OpenBrowser.net/tools/FAKE.Core/tools/FakeLib.dll'"

)

// Target "UnitTests" (fun _ ->
//     !! (sprintf "./src/OpenBrowser.Tests/bin/%s/**/OpenBrowser.Tests*.dll" buildMode)
//     |> xUnit2 (fun p -> 
//             {p with
//                 HtmlOutputPath = Some (testResultsDir @@ "xunit.html") })
// )

Target "SourceLink" (fun _ ->
    [ "./src/OpenBrowser/OpenBrowser.csproj"; "./src/OpenBrowser.Droid/OpenBrowser.Droid.csproj"; "./src/OpenBrowser.iOS/OpenBrowser.iOS.csproj"; "./src/OpenBrowser.UWP/OpenBrowser.UWP.csproj"; "./src/OpenBrowser.WP8/OpenBrowser.WP8.csproj" ]
    |> Seq.iter (fun pf ->
        let proj = VsProj.LoadRelease pf
        let url = "https://raw.githubusercontent.com/ghuntley/OpenBrowser/{0}/%var2%"
        SourceLink.Index proj.Compiles proj.OutputFilePdb __SOURCE_DIRECTORY__ url
    )
)

Target "CreatePackage" (fun _ ->
    let portableDir = packagingDir @@ "lib/Portable-Net45+WinRT45+WP8+WPA81/"
    let droidDir = packagingDir @@ "lib/MonoAndroid10/"
    let iosDir = packagingDir @@ "lib/Xamarin.iOS10/"
    let uwpDir = packagingDir @@ "lib/portable-win81+wpa81/"    
    let wp8Dir = packagingDir @@ "lib/wp8/"    
    CleanDirs [portableDir; droidDir; iosDir; uwpDir; wp8Dir]

    CopyFile portableDir (buildPortableDir @@ "Release/OpenBrowser.dll")
    CopyFile portableDir (buildPortableDir @@ "Release/OpenBrowser.XML")
    CopyFile portableDir (buildPortableDir @@ "Release/OpenBrowser.pdb")

    CopyFile droidDir (buildDroidDir @@ "Release/OpenBrowser.Droid.dll")
    CopyFile droidDir (buildDroidDir @@ "Release/OpenBrowser.Droid.pdb")
    CopyFile droidDir (buildDroidDir @@ "Release/OpenBrowser.Droid.xml")

    CopyFile iosDir (buildiOSDir @@ "iPhone/Release/OpenBrowser.iOS.dll")
    CopyFile iosDir (buildiOSDir @@ "iPhone/Release/OpenBrowser.iOS.xml")

    CopyFile uwpDir (buildUWPDir @@ "Release/OpenBrowser.UWP.dll")
    CopyFile uwpDir (buildUWPDir @@ "Release/OpenBrowser.UWP.pdb")
    CopyFile uwpDir (buildUWPDir @@ "Release/OpenBrowser.UWP.xml")

    CopyFile wp8Dir (buildWP8Dir @@ "Release/OpenBrowser.WP8.dll")
    CopyFile wp8Dir (buildWP8Dir @@ "Release/OpenBrowser.WP8.pdb")
    CopyFile wp8Dir (buildWP8Dir @@ "Release/OpenBrowser.WP8.xml")
        
    CopyFiles packagingDir ["LICENSE.md"; "README.md"; "RELEASENOTES.md"]

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
            AccessKey = getBuildParamOrDefault "nugetkey" ""
            Publish = hasBuildParam "nugetkey" }) "src/OpenBrowser.nuspec"
)

Target "Default" DoNothing

Target "CreatePackages" DoNothing

"Clean"
   ==> "AssemblyInfo"
   ==> "BuildApp"

"Clean"
   ==> "AssemblyInfo"
   ==> "BuildMono"

//"UnitTests"
//   ==> "Default"

"SourceLink"
   ==> "CreatePackages"

"CreatePackage"
   ==> "CreatePackages"

RunTargetOrDefault "Default"