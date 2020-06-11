module Build

#r "packages/FAKE/tools/FakeLib.dll"

open Fake

let solutionFile = !!"*.sln" |> Seq.head

Target "KillProcesses" <| fun () -> 
  ProcessHelper.killProcess "nunit-agent"
  ProcessHelper.killMSBuild()
Target "Build" <| fun () -> 
  !!"src/**/bin/Release/" |> CleanDirs
  CleanDir "build"
  build (fun x -> 
    { x with Verbosity = Some MSBuildVerbosity.Quiet
             Properties = [ "Configuration", "Release" ] }) solutionFile
Target "Test" <| fun () -> !!"src/**/bin/Release/*Tests.dll" |> NUnit id
Target "Default" DoNothing
"KillProcesses" ==> "Build" ==> "Test" ==> "Default"
RunTargetOrDefault "Default"
