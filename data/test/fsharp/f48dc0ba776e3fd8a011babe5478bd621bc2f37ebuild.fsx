#I @"packages/FAKE/tools"
#r @"FakeLib.dll"

open Fake
open Fake.MSBuild
open Fake.AssemblyInfoFile
open Fake.ReleaseNotesHelper

open System
open System.IO

let projectName = "irc-fs"

let projectGuid = "694ab3b0-8929-4f78-ab72-55f29eb48a36"

let summary = "An IRC client library for F#"

let releaseNotes = ReleaseNotesHelper.parseReleaseNotes (File.ReadLines "RELEASE_NOTES.md")

let solutionFile = "irc-fs.sln"

let buildDir = "./bin"
let nugetDir = "./.nuget"

let isAppveyorBuild = environVar "APPVEYOR" <> null
let appveyorBuildVersion = sprintf "%s-a%s" releaseNotes.AssemblyVersion (DateTime.UtcNow.ToString "yyMMddHHmm")

Target "Clean" (fun _ ->
    CleanDirs [buildDir]
)

Target "AppveyorBuildVersion" (fun _ ->
    Shell.Exec("appveyor", sprintf "UpdateBuild -Version \"%s\"" appveyorBuildVersion) |> ignore
)

Target "RestorePackages" (fun _ ->
    !! "./src/**/packages.config"
    |> Seq.iter(
        RestorePackage (fun p -> 
            { p with ToolPath = nugetDir @@ "NuGet.exe" })
       )
)

Target "AssemblyInfo" (fun _ ->
    let filename = "./src" @@ projectName @@ "AssemblyInfo.fs"
    CreateFSharpAssemblyInfo filename
        [ Attribute.Title projectName
          Attribute.Product projectName
          Attribute.Description summary
          Attribute.Version releaseNotes.AssemblyVersion
          Attribute.FileVersion releaseNotes.AssemblyVersion
          Attribute.Guid projectGuid ]
)

Target "CopyLicense" (fun _ ->
    [ "LICENSE.md" ]
    |> CopyTo (buildDir @@ "Release")
)

Target "Build" (fun _ ->
    !! solutionFile
    |> MSBuildRelease "" "Rebuild"
    |> ignore
)

Target "All" DoNothing

"Clean"
    =?> ("AppveyorBuildVersion", isAppveyorBuild)
    ==> "RestorePackages"
    ==> "AssemblyInfo"
    ==> "CopyLicense"
    ==> "Build"
    ==> "All"

let target = getBuildParamOrDefault "target" "All"

RunTargetOrDefault target