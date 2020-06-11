// Load the FAKE assembly.
#r @"tools/fake/tools/FakeLib.dll"
open Fake
open Fake.AssemblyInfoFile

// Get the release notes.
// It's here we will get stuff like version number from.
let releaseNotes = 
    ReadFile "ReleaseNotes.md"
    |> ReleaseNotesHelper.parseReleaseNotes

// Set the build mode (default to release).
let buildMode = getBuildParamOrDefault "buildMode" "Release"
let teamCity = hasBuildParam "teamCity"

let buildLabel = getBuildParamOrDefault "buildLabel" ""
let buildInfo =   if(hasBuildParam "buildInfo") then (getBuildParam "buildInfo") else ""
let version = releaseNotes.AssemblyVersion
let semVersion = releaseNotes.AssemblyVersion + (if buildLabel <> "" then ("-" + buildLabel) else "")

// Define directories.
let buildDir = "./src/Lake/bin" @@ buildMode
let buildResultDir = "./build" @@ "v" + semVersion + "/"
let testResultsDir = buildResultDir @@ "test-results"
let nugetRoot = buildResultDir @@ "nuget/"
let binDir = buildResultDir @@ "bin/"

////////////////////////////////////////////////////////////////////
// Define helper function for TeamCity log messages
////////////////////////////////////////////////////////////////////

let TeamCityBlock (message : string) action =
    printfn "##teamcity[blockOpened name='%s']" message
    action()
    printfn "##teamcity[blockClosed name='%s']" message

let LocalBlock (message : string) action =
    printfn "\n----------------------------------------"
    printfn "%s" (message.ToUpper())
    printfn "----------------------------------------\n"
    action()

let Block (message : string) action =
    if teamCity = true then (TeamCityBlock message action) else (LocalBlock message action)

////////////////////////////////////////////////////////////////////

Target "Clean" (fun _ ->
    Block "Cleaning directories" (fun _ ->
        CleanDirs [buildDir; binDir; testResultsDir; nugetRoot]
    )
)

Target "Update-TeamCity-Build-Number" (fun _ ->
    Block "Updating TeamCity build number" (fun _ ->
        printfn "##teamcity[buildNumber '%s']" semVersion
    )
)

Target "Set-Versions" (fun _ ->
    Block "Settings version information" (fun _ ->            
        CreateCSharpAssemblyInfo "./src/SolutionInfo.cs"
            [Attribute.Product "Lunt"
             Attribute.Version version
             Attribute.FileVersion version
             Attribute.InformationalVersion ((version + buildInfo).Trim())
             Attribute.Copyright "Copyright (c) Patrik Svensson 2014"]
    )
)

Target "Build" (fun _ ->
    Block "Building Lunt" (fun _ ->
        MSBuild null "Build" ["Configuration", buildMode] ["./src/Lunt.sln"]
        |> Log "AppBuild-Output: "
    )
)

Target "Run-Unit-Tests" (fun _ ->
    Block "Running unit tests" (fun _ ->
        !! (@"./src/**/bin/" + buildMode + "/*.Tests.dll")
            |> xUnit (fun p -> 
                {p with 
                    ShadowCopy = false;
                    HtmlOutput = true;
                    XmlOutput = true;
                    OutputDir = testResultsDir })
    )
)

Target "Run-Integration-Tests" (fun _ ->
    Block "Running integration tests" (fun _ ->
        !! (@"./src/**/bin/" + buildMode + "/*.Tests.Integration.dll")
            |> xUnit (fun p -> 
                {p with 
                    ShadowCopy = false;
                    HtmlOutput = true;
                    XmlOutput = true;
                    OutputDir = testResultsDir })
    )
)

Target "Copy-Files" (fun _ ->
    Block "Copying files" (fun _ ->
        CopyFile binDir (buildDir + "/Lake.exe")
        CopyFile binDir (buildDir + "/Lunt.dll")
        CopyFile binDir (buildDir + "/Lunt.xml")  
        CopyFiles binDir ["LICENSE"; "README.md"; "ReleaseNotes.md"]
    )
)

Target "Package-Files" (fun _ ->
    Block "Packagin files" (fun _ ->
        !! (binDir + "**/*") 
            --(binDir + "**/*.md")
            --(binDir + "**/LICENSE")
            |> Zip binDir (buildResultDir + "Lunt-bin-" + releaseNotes.AssemblyVersion + ".zip")
    )
)

Target "Create-Lunt-NuGet-Package" (fun _ ->
    Block "Creating NuGet package" (fun _ ->
        let coreRootDir = nugetRoot @@ "Lunt"
        let coreLibDir = coreRootDir @@ "lib/net45/"
        CleanDirs [coreRootDir; coreLibDir]

        CopyFile coreLibDir (binDir @@ "Lunt.dll")
        CopyFile coreLibDir (binDir @@ "Lunt.xml")
        CopyFile coreRootDir (binDir @@ "LICENSE")
        CopyFile coreRootDir (binDir @@ "README.md")
        CopyFile coreRootDir (binDir @@ "ReleaseNotes.md")

        NuGet (fun p -> 
            {p with
                Project = "Lunt"                           
                OutputPath = nugetRoot
                WorkingDir = coreRootDir
                Version = releaseNotes.AssemblyVersion
                ReleaseNotes = toLines releaseNotes.Notes
                AccessKey = getBuildParamOrDefault "nugetkey" ""
                Publish = hasBuildParam "nugetkey" }) "./Lunt.nuspec"
    )
)

Target "Create-Lake-NuGet-Package" (fun _ ->
    Block "Creating NuGet package" (fun _ ->
        let coreRootDir = nugetRoot @@ "Lunt.Make"
        CleanDirs [coreRootDir;]

        CopyFile coreRootDir (binDir @@ "Lake.exe")
        CopyFile coreRootDir (binDir @@ "Lunt.dll")
        CopyFile coreRootDir (binDir @@ "LICENSE")
        CopyFile coreRootDir (binDir @@ "README.md")
        CopyFile coreRootDir (binDir @@ "ReleaseNotes.md")

        NuGet (fun p -> 
            {p with
                Project = "Lunt.Make"
                NoPackageAnalysis = true
                OutputPath = nugetRoot
                WorkingDir = coreRootDir
                Version = releaseNotes.AssemblyVersion
                ReleaseNotes = toLines releaseNotes.Notes
                AccessKey = getBuildParamOrDefault "nugetkey" ""
                Publish = hasBuildParam "nugetkey" }) "./Lake.nuspec"
    )
)

Target "Help" (fun _ ->
    printfn ""
    printfn "  Please specify the target by calling 'build <Target>'"
    printfn "  Targets for building:"
    printfn ""
    printfn "  * Clean"
    printfn "  * Update-TeamCity-Build-Number"
    printfn "  * Set-Versions"
    printfn "  * Build"
    printfn "  * Run-Unit-Tests"
    printfn "  * Run-Integration-Tests"
    printfn "  * Copy-Files"
    printfn "  * Package-Files"
    printfn "  * Create-Lunt-NuGet-Package"
    printfn "  * Create-Lake-NuGet-Package"
    printfn "  * All (calls all previous)"
    printfn "")

Target "All" DoNothing

// Setup the target dependency graph.
"Clean"
   =?> ("Update-TeamCity-Build-Number", hasBuildParam "teamCity") 
   ==> "Set-Versions"
   ==> "Build"
   ==> "Run-Unit-Tests"
   ==> "Run-Integration-Tests"
   ==> "Copy-Files"
   ==> "Package-Files"
   ==> "Create-Lunt-NuGet-Package"
   ==> "Create-Lake-NuGet-Package"
   ==> "All"

// Set the default target to the last node in the
// target dependency graph.
RunTargetOrDefault "All"