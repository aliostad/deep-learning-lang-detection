#r @"packages/build/FAKE/tools/FakeLib.dll"
open Fake
open System
open System.Diagnostics
open System.IO

Target "LiveCode" (fun _ ->
    let files = !! "**/*.fsx" ++ "**/*.fs"
    let testFile = getBuildParamOrDefault "file" "Test1.fsx"
    
    printfn "testFile: %A" testFile
    let run() =
      async {
        let (succeed, logs) = Fake.FSIHelper.executeFSI __SOURCE_DIRECTORY__ testFile []
        if not succeed
        then
            logs 
            |> Seq.filter(fun l -> l.IsError)
            |> Seq.iter(fun l -> traceError l.Message)
      } |> Async.StartAsTask |> ignore
    run()

    use watcher = files |> WatchChanges (fun changes -> 
        tracefn "%A" changes
        let processlist = Process.GetProcesses()
        for p in processlist do
          if p.MainWindowTitle.StartsWith "LiveCoding"
          then p.Kill()
        run()
    )

    printfn "Press any key to quit ..."
    ignore <| Console.ReadKey true
    
    watcher.Dispose() // Use to stop the watch from elsewhere, ie another task.
)

Target "RestorePackages" (fun _ ->
    RestorePackages()
)

Target "Clean" (fun _ ->
    ensureDirectory "bin"
    CleanDirs ["bin"]
)

Target "Build" (fun _ ->
  !! "src/FsharpDiyBrowser.sln"
  |> MSBuildRelease "" "Rebuild"
  |> ignore
)

Target "CopyBinaries" (fun _ ->
    !! "**/*.??proj"
    -- "**/*.shproj"
    |>  Seq.map (fun f -> ((System.IO.Path.GetDirectoryName f) @@ "bin/Release", "bin" @@ (System.IO.Path.GetFileNameWithoutExtension f)))
    |>  Seq.iter (fun (fromDir, toDir) -> CopyDir toDir fromDir (fun _ -> true))
)

Target "BuildAll" DoNothing

"RestorePackages"
  ==> "Clean"
  ==> "Build"
  ==> "CopyBinaries"
  ==> "BuildAll"

RunTargetOrDefault "BuildAll"

