#r "src/packages/FAKE.3.34.7/tools/FakeLib.dll"

open Fake
open System.IO;

RestorePackages()
 
// Properties
let buildDir = "./build/"
let deployDir = "./deploy/"
 
// version info
let version = environVarOrDefault "PackageVersion" "1.0.0.0"  // or retrieve from CI server
let summary = "Open source .NET library Philips Hue lighting devices."
let copyright = "Ian Bebbington, 2014"
let tags = "Philips Hue light colour color"
let description = "Open source .NET library Philips Hue lighting devices."

// let portableAssemblies = [ "Colourful.dll"; "Colourful.pdb" ]
let net45Assemblies = [ "OneCog.Io.Philips.Hue.dll"; "OneCog.Io.Philips.Hue.pdb" ]
let allAssemblies = net45Assemblies
//let portableTarget = @"portable-net45+netcore45+wp8+wpa81+win8"
let net45Target = "net45"
let libDir = "lib"
 
// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir; deployDir]
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
             OutputFile = buildDir + "TestResults.xml" })
)

Target "Package" (fun _ ->

    // Copy all the package files into a package folder
    let allAssemblyPaths =
      allAssemblies
      |> Seq.map (fun assembly -> buildDir + assembly)
      
    // Copy all the package files into a package folder
    allAssemblyPaths |> CopyFiles deployDir

//    let portableAssemblyFiles =
//      portableAssemblies
//      |> List.map(fun a -> (a, Some(Path.Combine(libDir, portableTarget)), None))

    let net45AssemblyFiles = 
      net45Assemblies // @ portableAssemblies
      |> List.map(fun a -> (a, Some(Path.Combine(libDir, net45Target)), None))

    NuGet (fun p -> 
        {p with
            Authors = [ "Ian Bebbington" ]
            Project = "OneCog.Io.Philips.Hue"
            Description = description
            Summary = summary
            Copyright = copyright
            Tags = tags
            OutputPath = deployDir
            WorkingDir = deployDir
            Version = version
            Files = net45AssemblyFiles  // portableAssemblyFiles @ 
            Publish = false }) 
            "./src/OneCog.Io.Philips.Hue.nuspec"
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