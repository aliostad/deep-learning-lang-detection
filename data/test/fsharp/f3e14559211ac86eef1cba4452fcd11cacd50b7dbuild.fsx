#r "packages/fake/tools/fakelib.dll"
open Fake
open System.Diagnostics

let buildDir = "build"
let deployDir = "deploy"
let dispatcherBuildDir = buildDir </> "dispatcher"
let workerBuildDir = buildDir </> "worker"
let solutionFile = Include "./*.sln"

Target "Clean" (fun _ -> 
    CleanDirs ["./build/"; "./deploy/"]
)

Target "Build" (fun _ ->
    MSBuildRelease dispatcherBuildDir "Build" ["Dispatcher\Dispatcher.csproj"] |> ignore
    MSBuildRelease workerBuildDir "Build" ["Worker\Worker.csproj"] |> ignore
)

Target "Deploy" (fun _-> 
    let dispatcherStartInfo = new ProcessStartInfo(dispatcherBuildDir </> "Dispatcher.exe")
    let workerStartInfo = new ProcessStartInfo(workerBuildDir </> "Worker.exe")
    Process.Start (workerStartInfo) |> ignore
    Process.Start (dispatcherStartInfo) |> ignore
)

"Clean"
    ==> "Build"
    ==> "Deploy"



RunTargetOrDefault "Build"