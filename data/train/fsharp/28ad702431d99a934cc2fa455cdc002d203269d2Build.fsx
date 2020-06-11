#if INTERACTIVE
System.Environment.CurrentDirectory <- __SOURCE_DIRECTORY__
#endif

#r "packages/FAKE.4.5.1/tools/FakeLib.dll"

open Fake
open Fake.AssemblyInfoFile 

let buildDir = "./build"
let workDir = "./work"
let srcDir = "Leeloo"
let outputPath = "nupkgs"
let toolsPath = workDir @@ "tools"

let version =
    let major = environVarOrDefault "LEELOO_MAJORVERSION" "1"
    let minor = environVarOrDefault "LEELOO_MINORVERSION" "1"    
    let build = environVarOrDefault "LEELOO_BUILDNUMBER"  "0"
    sprintf "%s.%s.%s" major minor build

let deployPath = "."
//let deployPath = @"\\dev-web-01\Websites\nuget\Packages"

let writeFileWithReplace (mutator: string -> string) (outputFile: string) (inputFilePath: string) =
    let content = System.IO.File.ReadAllText inputFilePath
    let mutated = mutator content
    System.IO.File.WriteAllText(outputFile, mutated)
let versionReplacer (s: string) = s.Replace("{{Version}}", version)
let replaceVersionForToolFile (toolFileName: string) = toolsPath @@ toolFileName |> writeFileWithReplace versionReplacer 

Target "Clean" (fun _ -> 
    trace "Running clean"
    CleanDirs [ buildDir ; workDir ; toolsPath ; outputPath ])

Target "Build" (fun _ ->
    [ Attribute.Version version ; Attribute.FileVersion version ]
    |> AssemblyInfoFile.CreateFSharpAssemblyInfo (srcDir @@ "AssemblyInfo.fs")

    !! (srcDir @@ "Leeloo.fsproj")
    |> MSBuildRelease buildDir "Build"
    |> Log "Building: ") 

Target "Nuget" (fun _ ->
    trace "Building package"

    !! ("packages/Fake.*/tools/*") 
    |> CopyFiles toolsPath

    !! ("packages/NuGet.CommandLine.*/tools/*") 
    |> CopyFiles toolsPath

    !! ("packages/NUnit.Runners.2.6.4/tools/**")
    |> CopyFiles (toolsPath @@ "NUnit")

    !! (buildDir @@ "*.*")
    |> CopyFiles toolsPath
    
    "ClientInstallFiles" @@ "Init.ps1"          |> CopyFile toolsPath
    "ClientInstallFiles" @@ "sample.nuspec.txt" |> CopyFile toolsPath
    "ClientInstallFiles" @@ "SampleBuild.fsx"   |> replaceVersionForToolFile "build.fsx"
    "ClientInstallFiles" @@ "SampleBuild.cmd"   |> replaceVersionForToolFile "Build.cmd"

    "Leeloo.nuspec" |> NuGet (fun p ->
        { p with Project    = "Leeloo"
                 Version    = version
                 WorkingDir = workDir
                 OutputPath = outputPath
                 ToolPath   = "./packages/NuGet.CommandLine.2.8.6/tools/Nuget.exe" }))

Target "Deploy" (fun _ ->
    !! (outputPath @@ "Leeloo." + version + ".*")
    |> CopyFiles deployPath)

Target "Default" (fun _ ->
    trace "Packaging done") 

"Clean" 
==> "Build"
==> "Nuget"
==> "Deploy"
==> "Default"

RunTargetOrDefault "Default"