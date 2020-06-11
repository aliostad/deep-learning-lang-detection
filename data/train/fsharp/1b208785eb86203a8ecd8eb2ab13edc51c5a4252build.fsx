// Load the FAKE assembly.
#r @"tools/FAKE/tools/FakeLib.dll"
open Fake 
open Fake.AssemblyInfoFile

// Get the release notes.
// It's here we will get stuff like version number from.
let releaseNotes = 
    ReadFile "ReleaseNotes.md"
    |> ReleaseNotesHelper.parseReleaseNotes

// Set the build mode (default to release).
let buildMode = getBuildParamOrDefault "buildMode" "Release"

// Define directories.
let buildDir = "./src/NTiled/bin" @@ buildMode
let buildResultDir = "./build" @@ "v" + releaseNotes.AssemblyVersion + "/"
let testResultsDir = buildResultDir @@ "test-results"
let nugetRoot = buildResultDir @@ "nuget/"
let binDir = buildResultDir @@ "bin/"

Target "Clean" (fun _ ->

    printfn "\n----------------------------------------"
    printfn "CLEANING DIRECTORIES"
    printfn "----------------------------------------\n"

    CleanDirs [buildDir; binDir; testResultsDir; nugetRoot]
)

Target "Set-Versions" (fun _ ->

    let attributes = 
        [
            Attribute.Product "NTiled"
            Attribute.Version releaseNotes.AssemblyVersion
            Attribute.FileVersion releaseNotes.AssemblyVersion
            Attribute.ComVisible false
            Attribute.Copyright "Copyright (c) Patrik Svensson 2014"
        ]

    CreateCSharpAssemblyInfoWithConfig "./src/SolutionInfo.cs" attributes <| AssemblyInfoFileConfig(false)
)

Target "Build" (fun _ ->

    printfn "\n----------------------------------------"
    printfn "BUILDING NTILED"
    printfn "----------------------------------------\n"

    MSBuild null "Build" ["Configuration", buildMode] ["./src/NTiled.sln"]
    |> Log "AppBuild-Output: "
)

Target "Run-Unit-Tests" (fun _ ->

    printfn "\n----------------------------------------"
    printfn "RUNNING UNIT TESTS"
    printfn "----------------------------------------\n"

    !! (@"./src/**/bin/" + buildMode + "/*.Tests.dll")
        |> xUnit (fun p -> 
            {p with 
                ShadowCopy = false;
                HtmlOutput = true;
                XmlOutput = true;
                OutputDir = testResultsDir })
)

Target "Copy-Files" (fun _ ->

    printfn "\n----------------------------------------"
    printfn "COPYING FILES"
    printfn "----------------------------------------\n"

    CopyFile binDir (buildDir + "/NTiled.dll")
    CopyFile binDir (buildDir + "/NTiled.xml")  
    CopyFiles binDir ["LICENSE"; "README.md"; "ReleaseNotes.md"]

)

Target "Package-Files" (fun _ ->

    printfn "\n----------------------------------------"
    printfn "PACKAGING FILES"
    printfn "----------------------------------------\n"

    !! (binDir + "**/*") 
        --(binDir + "**/*.md")
        --(binDir + "**/LICENSE")
        |> Zip binDir (buildResultDir + "NTiled-bin-" + releaseNotes.AssemblyVersion + ".zip")
)


Target "Create-NuGet-Package" (fun _ ->

    printfn "\n----------------------------------------"
    printfn "CREATING NUGET PACKAGE"
    printfn "----------------------------------------\n"

    let coreRootDir = nugetRoot @@ "NTiled"
    let coreLibDir = coreRootDir @@ "lib/net45/"
    CleanDirs [coreRootDir; coreLibDir]

    CopyFile coreLibDir (binDir @@ "NTiled.dll")
    CopyFile coreLibDir (binDir @@ "NTiled.xml")
    CopyFile coreRootDir (binDir @@ "LICENSE")
    CopyFile coreRootDir (binDir @@ "README.md")
    CopyFile coreRootDir (binDir @@ "ReleaseNotes.md")

    NuGet (fun p -> 
        {p with
            Project = "NTiled"
            OutputPath = nugetRoot
            WorkingDir = coreRootDir
            Version = releaseNotes.AssemblyVersion
            ReleaseNotes = toLines releaseNotes.Notes
            AccessKey = getBuildParamOrDefault "nugetkey" ""
            Publish = hasBuildParam "nugetkey" }) "./NTiled.nuspec"
)

Target "Help" (fun _ ->
    printfn ""
    printfn "  Please specify the target by calling 'build <Target>'"
    printfn "  Targets for building:"
    printfn ""
    printfn "  * Clean"
    printfn "  * Build"
    printfn "  * Run-Unit-Tests"
    printfn "  * Copy-Files"
    printfn "  * Package-Files"
    printfn "  * Create-NuGet-Package"
    printfn "  * All (calls all previous)"
    printfn "")

Target "All" DoNothing

// Setup the target dependency graph.
"Clean"
   ==> "Build"
   ==> "Set-Versions"
   ==> "Run-Unit-Tests"
   ==> "Copy-Files"
   ==> "Package-Files"
   ==> "Create-NuGet-Package"
   ==> "All"

// Set the default target to the last node in the
// target dependency graph.
RunTargetOrDefault "All"