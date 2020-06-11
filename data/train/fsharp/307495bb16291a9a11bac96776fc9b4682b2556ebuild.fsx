// include Fake lib
#r "packages/FAKE/tools/FakeLib.dll"
open Fake
open Fake.AssemblyInfoFile

let projDesc =
  "A tiny, but powerful option parsing library written in a single F# file"
let releaseNotes =
  ReadFile "ReleaseNotes.md"
  |> ReleaseNotesHelper.parseReleaseNotes

let buildMode = getBuildParamOrDefault "buildMode" "Release"
let buildDir = "./src/bin/Release/"
let packagingRoot = "./packaging/"
let packagingDir = packagingRoot @@ "OptParse"

Target "Clean" (fun _ ->
  CleanDir buildDir
)

Target "AssemblyInfo" (fun _ ->
  CreateFSharpAssemblyInfo "src/AssemblyInfo.fs"
    [
      Attribute.Title "OptParse.Runtime"
      Attribute.Product "OptParse.Runtime"
      Attribute.Description projDesc
      Attribute.Version releaseNotes.AssemblyVersion
      Attribute.FileVersion releaseNotes.AssemblyVersion
    ]
)

Target "Default" (fun _ ->
  let setParams defaults =
    {defaults with
      Verbosity = Some (Normal)
      Targets = ["Build"]
      Properties =
        [
          "Optimize", "True"
          "DebugSymbols", "True"
          "Configuration", buildMode
          "AllowedReferenceRelatedFileExtensions", "none"
        ]
      ToolsVersion = if isMono then Some "12.0" else None
    }
  build setParams "src/OptParse.fsproj" |> DoNothing
)

Target "CreatePackage" (fun _ ->
  let net45Dir = packagingDir @@ "lib/net45/"
  CleanDir net45Dir
  CopyFile net45Dir (buildDir @@ "OptParse.dll")
  CopyFile net45Dir (buildDir @@ "OptParse.pdb")
  CopyFile net45Dir (buildDir @@ "OptParse.xml")
  CopyFiles packagingDir ["LICENSE"; "README.md"; "ReleaseNotes.md"]
  NuGet
    (fun p ->
      {p with
        Description = projDesc
        Version = releaseNotes.AssemblyVersion
        ReleaseNotes = toLines releaseNotes.Notes
        WorkingDir = packagingDir
        OutputPath = packagingRoot
      }
    )
    "OptParse.nuspec"
)

Target "Pack" DoNothing

// Dependencies
"Clean"
  ==> "AssemblyInfo"
  ==> "Default"

"CreatePackage"
  ==> "Pack"

// start build
RunTargetOrDefault "Default"
