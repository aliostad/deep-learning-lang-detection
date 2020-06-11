#r "./packages/FAKE.4.20.0/tools/FakeLib.dll"

open Fake
open System.IO;

//RestorePackages()
 
// Properties
let buildDir = "./build/"
let deployDir = "./deploy/"
 
// version info
let version = environVarOrDefault "PackageVersion" "1.0.0.0"  // or retrieve from CI server
let summary = "Open source library for interacting with the Owl Intuition series of devices."
let copyright = "Ian Bebbington, 2015"
let tags = "OneCog Owl Intuition"
let description = "Open source library for interacting with the Owl Intuition series of devices."

let assemblies = [ "OneCog.Io.Owl.Intuition.dll"; "OneCog.Io.Owl.Intuition.pdb"; ]

let libDir = "lib"
let srcDir = "src"
let net45Target = "net45"
let uapTarget = "uap"
let srcTarget = "src"
 
// Targets
Target "Clean" (fun _ ->
    CleanDirs [ deployDir ]
)
 
Target "Build" (fun _ ->
   !! "./src/**/*.csproj"
     |> MSBuildRelease buildDir "Build"
     |> Log "AppBuild-Output: "
)

Target "Test" (fun _ ->
    !! (buildDir + "*.Test.dll") 
    ++ (buildDir + "*.Tests.dll")
      |> NUnit (fun p ->
          {p with
             DisableShadowCopy = true;
             ExcludeCategory = "Integration"
             OutputFile = buildDir + "TestResults.xml" })
)

Target "Package" (fun _ ->

    // Copy to deployment folder
    CopyWithSubfoldersTo deployDir [ !! "./src/OneCog.Io.Owl.Intuition/**/*.cs" ]
    assemblies |> List.map(fun a -> buildDir @@ a) |> CopyFiles deployDir  

    // Setup files to include in package
    let net45Files = assemblies |> List.map(fun a -> (a, Some(Path.Combine(libDir, net45Target)), None))
    let srcFiles = [ (@"src\**\*.*", Some "src", None) ]

    let dependencies = getDependencies "./src/OneCog.Io.Owl.Intuition/packages.config" |> List.filter (fun (name, version) -> name <> "FAKE")
    
    NuGet (fun p -> 
        {p with
            Authors = [ "Ian Bebbington" ]
            Project = "OneCog.Io.Owl.Intuition"
            Description = description
            Summary = summary
            Copyright = copyright
            Tags = tags
            OutputPath = deployDir
            WorkingDir = deployDir
            SymbolPackage = NugetSymbolPackage.Nuspec
            Version = version
            Dependencies = dependencies
            Files = net45Files @ srcFiles
            Publish = false }) 
            "./OneCog.Io.Owl.Intuition.nuspec"
)

Target "Run" (fun _ -> 
    trace "FAKE build complete"
)
  
// Dependencies
"Clean"
  ==> "Build"
  ==> "Test"
  ==> "Package"
  ==> "Run"
 
// start build
RunTargetOrDefault "Run"