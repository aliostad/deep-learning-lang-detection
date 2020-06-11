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

let buildLabel = getBuildParamOrDefault "buildLabel" ""
let buildInfo =   if(hasBuildParam "buildInfo") then (getBuildParam "buildInfo") else ""
let version = releaseNotes.AssemblyVersion
let semVersion = releaseNotes.AssemblyVersion + (if buildLabel <> "" then ("-" + buildLabel) else "")

// Define directories.
let buildDir = "./src/Tail/bin" @@ buildMode
let buildResultDir = "./build" @@ "v" + semVersion + "/"
let testResultsDir = buildResultDir @@ "test-results"
let nugetRoot = buildResultDir @@ "nuget/"
let binDir = buildResultDir @@ "bin/"

////////////////////////////////////////////////////////////////////

let Block (message : string) action =
    printfn "\n----------------------------------------"
    printfn "%s" (message.ToUpper())
    printfn "----------------------------------------\n"
    action()

////////////////////////////////////////////////////////////////////

Target "Clean" (fun _ ->
    Block "Cleaning directories" (fun _ ->
        CleanDirs [buildDir; binDir; testResultsDir; nugetRoot]
    )
)

Target "Build" (fun _ ->
    Block "Building Tail" (fun _ ->
        MSBuild null "Build" ["Configuration", buildMode] ["./src/Tail.sln"]
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

Target "Copy-Files" (fun _ ->
    Block "Copying files" (fun _ ->
        CopyFile binDir (buildDir + "/Tail.exe")

        CopyFile binDir (buildDir + "/BlackBox.dll")
        CopyFile binDir (buildDir + "/Caliburn.Micro.dll")
        CopyFile binDir (buildDir + "/Castle.Core.dll")
        CopyFile binDir (buildDir + "/Ninject.dll")
        CopyFile binDir (buildDir + "/Ninject.Extensions.Factory.dll")
        CopyFile binDir (buildDir + "/System.Windows.Interactivity.dll")
        CopyFile binDir (buildDir + "/Tail.Extensibility.dll")
        CopyFile binDir (buildDir + "/Tail.exe.config")
 
        CopyFiles binDir ["LICENSE"; "README.md"; "ReleaseNotes.md"]
    )
)

Target "Package-Files" (fun _ ->
    Block "Packagin files" (fun _ ->
        !! (binDir + "**/*") 
            --(binDir + "**/*.md")
            --(binDir + "**/LICENSE")
            |> Zip binDir (buildResultDir + "Tail-bin-" + releaseNotes.AssemblyVersion + ".zip")
    )
)

Target "Create-NuGet-Package" (fun _ ->
    Block "Creating NuGet package" (fun _ ->
        let coreRootDir = nugetRoot @@ "Tail.Extensibility"
        let coreLibDir = coreRootDir @@ "lib/net40/"
        CleanDirs [coreRootDir; coreLibDir]

        CopyFile coreLibDir (binDir @@ "Tail.Extensibility.dll")
        CopyFile coreRootDir (binDir @@ "LICENSE")
        CopyFile coreRootDir (binDir @@ "README.md")
        CopyFile coreRootDir (binDir @@ "ReleaseNotes.md")

        NuGet (fun p -> 
            {p with
                Project = "Tail.Extensibility"                           
                OutputPath = nugetRoot
                WorkingDir = coreRootDir
                Version = releaseNotes.AssemblyVersion
                ReleaseNotes = toLines releaseNotes.Notes
                AccessKey = getBuildParamOrDefault "nugetkey" ""
                Publish = hasBuildParam "nugetkey" }) "./Tail.Extensibility.nuspec"
    )
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

////////////////////////////////////////////////////////////////////

"Clean"
   ==> "Build"
   ==> "Run-Unit-Tests"
   ==> "Copy-Files"
   ==> "Package-Files"
   ==> "Create-NuGet-Package"
   ==> "All"

RunTargetOrDefault "All"

////////////////////////////////////////////////////////////////////