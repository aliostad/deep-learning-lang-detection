#r "packages/FAKE/tools/FakeLib.dll"

open Fake.FscHelper
open Fake
open Fake.Azure
open System.IO

// This is the destination directory for your build.
let buildDir = "./bin/"

// Best practice is to distribute FSharp.Core with an executable.
let copyCore dir =
  [ "packages/FAKE/tools/FSharp.Core.dll"
    "packages/FAKE/tools/FSharp.Core.optdata"
    "packages/FAKE/tools/FSharp.Core.sigdata"
  ] |> FileHelper.Copy dir

// This builds and deploys an .fsx file and a list of references.
let buildScript dir file refs options =
  // Create the target directory if it does not exist.
  FileHelper.CreateDir dir

  // Infer the file extension from the target type.
  let ext =
    options
    |> List.filter (function
      | FscHelper.Target _ -> true
      | _ -> false)
    |> List.tryLast
    |> function
      | Some (FscHelper.Target TargetType.Library) -> "dll"
      | Some (FscHelper.Target TargetType.Module) -> "netmodule"
      | _ ->
        // For executables, deploy FSharp.Core.
        copyCore dir
        "exe"

  // The output name is the script name with the correct extension.
  let out = dir @@ Path.ChangeExtension(Path.GetFileName(file), ext)

  // If an App.config is alongside the script, deploy it.
  let configIn = Path.GetDirectoryName(file) @@ "/App.config"
  let configOut = out + ".config"

  if File.Exists configIn then
    FileHelper.CopyFile configOut configIn

  // Build the target and deploy it with the list of references.
  FscHelper.Compile (FscHelper.Out out :: options) [file]
  refs |> FileHelper.Copy dir

// Clean out the build directory before doing anything else.
Target "Clean" <| fun _ ->
  CleanDirs [ buildDir ]

// Run tests before trying to build the target.
Target "Test" <| fun _ ->
  // Execute the test script using FSI.
  let (result, msgs) = executeFSI "." "src/test.fsx" Seq.empty
  msgs
  |> Seq.iter (fun msg -> printfn "%s" msg.Message)
  if not result then
    failwith "Tests failed"
  ()

// Build our target.
Target "Build" <| fun _ ->
  buildScript
    buildDir
    "src/webserver.fsx"
    [ "packages/Suave/lib/net40/Suave.dll" ]
    []

Target "StageFiles" <| fun _ ->
  FileHelper.CopyFile Kudu.deploymentTemp "web.config"
  Kudu.stageFolder buildDir <| fun _ -> true

Target "Deploy" Kudu.kuduSync

"Clean"
==> "Test"
==> "Build"
==> "StageFiles"
==> "Deploy"

RunTargetOrDefault "Build"
