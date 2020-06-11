// include Fake lib
#r @"packages/FAKE/tools/FakeLib.dll"
open Fake
open Fake.AssemblyInfoFile

let version = "1.0.0"

// NuGet settings
let nugetPackageDir = "./.nuget/nupkg"

// NUnit settings
let nunitToolPath = "./packages/NUnit.Runners/tools"
let nunitOutputPath =  "./reports/TestResults.xml"

// Build solution
Target "Build" (fun _ ->
  // Update assembly info for the project With.Extension
  CreateCSharpAssemblyInfo "./src/With.Extensions/Properties/AssemblyInfo.cs"
    [Attribute.Title "With.Extensions"
     Attribute.Description "Extension methods used to copy and update immutable classes (as copy and update record expression in F#)."
     Attribute.Guid "cb6c3a37-63bb-488b-8778-bd52d97007ff"
     Attribute.Product "With.Extensions"
     Attribute.Company "Emmanuel Horrent"
     Attribute.Copyright "Copyright © Emmanuel Horrent 2015"
     Attribute.Version version
     Attribute.FileVersion version]

  let setParams defaults =
    { defaults with
        Verbosity = Some(Minimal)
        Targets = ["Clean"; "Rebuild"]
        Properties = [("Configuration", "Release")]
    }

  build setParams "./With.Extensions.sln"
)

// Unit tests
Target "NUnitTest" (fun _ ->
  CreateDir (directory nunitOutputPath)
  let setParams defaults =
    { defaults with
        ToolPath = nunitToolPath
        Framework = "4.5"
        DisableShadowCopy = true
        OutputFile = nunitOutputPath
    }

  !!("./src/**/bin/release/*.Tests.dll")
    |> NUnit setParams
)

// Create nuget package
Target "CreatePackage" (fun _ ->
  CreateDir nugetPackageDir
  let setParams defaults =
    { defaults with
        OutputPath = nugetPackageDir
        Properties = [("Configuration", "Release")]
        Version = version
        WorkingDir = nugetPackageDir
    }

  NuGetPack setParams "./src/With.Extensions/With.Extensions.csproj"
)

// Dependencies
"Build"
  ==> "NUnitTest"
  ==> "CreatePackage"

// start build
RunTargetOrDefault "NUnitTest"
