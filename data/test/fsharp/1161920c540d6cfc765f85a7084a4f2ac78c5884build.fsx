// --------------------------------------------------------------------------------------
// FAKE build script
// --------------------------------------------------------------------------------------

#I "packages/FAKE/tools"
#r "packages/FAKE/tools/FakeLib.dll"
open System
open System.IO
open Fake
open Fake.Git
open Fake.ProcessHelper
open Fake.ReleaseNotesHelper
open Fake.ZipHelper

#if MONO
#else

#load "src/atom-bindings.fsx"
#load "src/fake.fs"
#load "src/main.fs"

#endif

// Git configuration (used for publishing documentation in gh-pages branch)
// The profile where the project is posted
let gitOwner = "Ionide"
let gitHome  = "https://github.com/" + gitOwner

// The name of the project on GitHub
let gitName = "ionide-fake"

// The url for the raw files hosted
let gitRaw = environVarOrDefault "gitRaw" "https://raw.github.com/Ionide"

let tempReleaseDir = "temp/release"

// Read additional information from the release notes document
let releaseNotesData =
    File.ReadAllLines "RELEASE_NOTES.md"
    |> parseAllReleaseNotes

let release = List.head releaseNotesData


let run cmd args dir =
    if execProcess( fun info ->
        info.FileName <- cmd
        if not( String.IsNullOrWhiteSpace dir) then
            info.WorkingDirectory <- dir
        info.Arguments <- args
    ) System.TimeSpan.MaxValue = false then
        traceError <| sprintf "Error while running '%s' with args: %s" cmd args

//------------------------------------------
// Atom & APM tools for the Commandline
//------------------------------------------

let apmTool =
    #if MONO
        "apm"
    #else
        Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData) </> "atom" </> "bin" </> "apm.cmd"
    #endif

let atomTool =
    #if MONO
        "atom"
    #else
        Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData) </> "atom" </> "bin" </> "atom.cmd"
    #endif

// --------------------------------------------------------------------------------------
// Build the Generator project and run it
// --------------------------------------------------------------------------------------

Target "Clean" (fun _ ->
    CleanDir "temp/release"
    DeleteDir @".fake"
)

// Copy the snippet definition file to the correct path for inclusion in the package
Target "CopySnippets" (fun _ ->
    DeleteDir @"release/snippets"
    CopyDir @"release/snippets" @"src/snippets" (fun _->true)
)

Target "BuildGenerator" (fun () ->
    [ __SOURCE_DIRECTORY__ @@ "src" @@ "Ionide.Fake.fsproj" ]
    |> MSBuildDebug "" "Rebuild"
    |> Log "AppBuild-Output: "
)

Target "RunGenerator" (fun () ->
    (TimeSpan.FromMinutes 5.0)
    |> ProcessHelper.ExecProcess (fun p ->
        p.FileName <- __SOURCE_DIRECTORY__ @@ "src" @@ "bin" @@ "Debug" @@ "Ionide.Fake.exe" )
    |> ignore
)

Target "RunScript" (fun () ->
    #if MONO
        ()
    #else
        Ionide.Paket.Generator.translateModules "../release/lib/fake.js"
    #endif
)

Target "InstallDependencies" (fun _ ->
    run apmTool "install" "release"
)

// This should not be the long term way to test out our packages
// TODO switch this target to install to dev and launch atom in dev mode
Target "TryPackage"( fun _ ->
    killProcess "atom"
    run apmTool "uninstall ionide-fake" ""
    run apmTool "link" "release"
    run atomTool __SOURCE_DIRECTORY__ ""
)

Target "TagDevelopBranch" (fun _ ->
    StageAll ""
    Git.Commit.Commit "" (sprintf "Bump version to %s" release.NugetVersion)
    Branches.pushBranch "" "origin" "develop"

    let tagName = "develop-" + release.NugetVersion
    Branches.tag "" tagName
    Branches.pushTag "" "origin" tagName
)

Target "PushToMaster" (fun _ ->
    CleanDir tempReleaseDir
    Repository.cloneSingleBranch "" (gitHome + "/" + gitName + ".git") "master" tempReleaseDir

    let cleanEverythingFromLastCheckout() =
        let tempGitDir = Path.GetTempPath() </> "gitrelease"
        CleanDir tempGitDir
        CopyRecursive (tempReleaseDir </> ".git") tempGitDir true |> ignore
        CleanDir tempReleaseDir
        CopyRecursive tempGitDir (tempReleaseDir  </> ".git") true |> ignore

    cleanEverythingFromLastCheckout()
    CopyRecursive "release" tempReleaseDir true |> tracefn "%A"
    CopyFiles tempReleaseDir ["README.md"; "RELEASE_NOTES.md"; "LICENSE" ]

    StageAll tempReleaseDir
    Git.Commit.Commit tempReleaseDir (sprintf "Release %s" release.NugetVersion)
    Branches.push tempReleaseDir
)

Target "Release" (fun _ ->
    let args = sprintf "publish %s" release.NugetVersion
    run apmTool args tempReleaseDir
    DeleteDir "temp/release"
)

// --------------------------------------------------------------------------------------
// Run generator by default. Invoke 'build <Target>' to override
// --------------------------------------------------------------------------------------

Target "Default" DoNothing

#if MONO
"Clean"
  ==> "BuildGenerator"
  ==> "RunGenerator"
  ==> "InstallDependencies"
#else
"Clean"
  ==> "RunScript"
  ==> "InstallDependencies"
#endif

"InstallDependencies"
    ==> "CopySnippets"
    ==> "Default"
    ==> "TagDevelopBranch"
    ==> "PushToMaster"
    ==> "Release"

"CopySnippets"
    ==> "TryPackage"

RunTargetOrDefault "Default"
