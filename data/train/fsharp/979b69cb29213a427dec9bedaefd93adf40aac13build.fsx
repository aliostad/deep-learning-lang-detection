#r "packages/FAKE/tools/FakeLib.dll"

#load "paket-files/include-scripts/net46/include.fsharp.data.fsx"
#load "paket-files/lawrencetaylor/FSharpHelpers/FSharp.CoreEx/Async.fs"
#load "paket-files/lawrencetaylor/FSharpHelpers/FSharp.CoreEx/Result.fs"
#load "paket-files/lawrencetaylor/83b628466ac9a2cf77c22efff7d2be90/compile.fs"

open Fake

let sourceDir = __SOURCE_DIRECTORY__
let outputDir = sourceDir </> "build"

Target "PreBuild" (fun _ ->
  trace "Starting Build of Suave.Swagger"
  let targetFile = sourceDir </> "git-subtrees/lawrencetaylor/suave.swagger/bin/Suave.Swagger/Suave.Swagger.dll"
  match targetFile |> fileExists with
  | true -> ()
  | false ->
    let workingDir = sourceDir </> "git-subtrees/lawrencetaylor/suave.swagger/"
    let exitCode =   
      ExecProcess(
        fun a -> 
          a.FileName <- "build.cmd"
          a.Arguments <- "RunTests"
          a.WorkingDirectory <- workingDir)
          (System.TimeSpan.FromSeconds(30.0))
    match exitCode with 
    | 0 -> ()
    | _ -> failwith "Build of Suave.Swagger Failed"
)

module ProcessHelpers = 
  // Kicks off a process in the background
  let run outDir processName = 
    let exe = outDir @@ (sprintf "%s.exe" processName)
    exe |> sprintf "Starting process %s" |> traceImportant
    Shell.AsyncExec (
      outDir @@ (sprintf "%s.exe" processName), 
      Unchecked.defaultof<string>, 
      Unchecked.defaultof<string>) 
    |> Async.map(ignore)
    |> Async.StartImmediate

  // Runs a process and returns the exit Code
  let exec outDir processName = 
    ExecProcess(fun info -> info.FileName <- outDir </> (processName + ".exe")) (System.TimeSpan.FromSeconds(300.0))

  let kill processName = 
    let webServerKiller ids = 
      getProcessesByName processName |> Seq.iter kill
      match getProcessesByName processName |> Seq.toList with
      | [] -> 
        trace (sprintf "No more instances of %s found" processName)
        None 
      | p -> (1, p |> List.map(fun pr -> pr.Id)) |> Some

    Seq.unfold webServerKiller [] |> Seq.toArray |> ignore

module Server = 

  let processName = "WebServer"
  let buildOutDir = outputDir </> "WebServer"
  let executable = sprintf "%s.exe" processName

  let run () = ProcessHelpers.run buildOutDir processName 
  let kill () = ProcessHelpers.kill processName
  let make () = Compile.build buildOutDir executable (sourceDir </> "src/Server/WebServerHost.fsx")

  let downloadSwaggerSchema() = 
    async {
      do! Async.Sleep 2000
      let url = sprintf "http://localhost:8083/swagger/v2/swagger.json"
      let json = FSharp.Data.Http.RequestString(url)
      let schemaDir = "src/Server/Tests/schema"
      CreateDir schemaDir
      System.IO.File.WriteAllText(schemaDir </> "apiDocs.json", json)
    } |> Async.RunSynchronously

  let buildAndRun = kill >> make >> run >> downloadSwaggerSchema

module Test = 

  type T = { ProcessName : string; Source : string }

  let executable t = sprintf "%s.exe" t.ProcessName


  let discoverByConvention () = 
    "src/Server/Tests"
    |> directoryInfo
    |> subDirectories
    |> Seq.map(fun di -> 
      di.GetFiles()
      |> Seq.tryFind(fun fi -> fi.Name = "Tests.fsx")
      |> Option.map(fun fi -> { ProcessName = "Test." + di.Name ; Source = fi.FullName}))
    |> Seq.filter(Option.isSome)
    |> Seq.map(Option.get)

  let build t = 
    try
      let executableName = executable t
      Compile.build (outputDir </> t.ProcessName) executableName t.Source

      t.Source 
      |> fileInfo
      |> fun fi -> fi.Directory
      |> fun di -> di.GetFiles()
      |> Seq.filter(fun fi -> fi.Name.StartsWith("App"))
      |> Seq.iter(fun fi -> CopyFile (outputDir </> t.ProcessName </> (fi.Name.Replace("App.", executableName + "."))) fi.FullName)

      Result.Ok t
    with 
    | e -> Result.Error  (sprintf "Build failed of %s: %A" t.Source e)

  let run t = ProcessHelpers.exec (outputDir </> t.ProcessName) t.ProcessName 

  let z = 
    discoverByConvention ()
    |> Seq.map(build >> Result.mapOk run)
    |> Result.traverse 

  let runAllTests () = 
    async {

      discoverByConvention ()
      |> Seq.map(build >> Result.mapOk run)
      |> Result.traverse 
      |> Result.mapOk(Seq.fold (+) 0)
      |> function 
          | Result.Ok 0 -> () 
          | Result.Ok _ -> traceError "Some of the tests failed" 
          | Result.Error m -> traceError m
    } |> Async.StartImmediate



Target "WatchMode" (fun _ -> 
  Server.buildAndRun() 
  Async.sleepForSeconds 2 |> Async.RunSynchronously
  Test.runAllTests()
  let sources = 
    { BaseDirectory = sourceDir </> "src/Server"
      Includes = [ "**/*.fsx"; "**/*.fs" ; "**/*.fsproj"; "**/*.config"; ]; 
      Excludes = [] } 
  use watcher = 
      sources 
      |> WatchChanges (
        Seq.map (fun x -> x.FullPath |> sprintf "Detected Change in: %s" |> traceImportant) 
        >> Seq.toArray
        >> fun fileChanges -> 
            Server.buildAndRun()
            Test.runAllTests()
            ())

  System.Console.ReadLine() |> ignore

  )

"PreBuild" ==> "WatchMode"


RunTargetOrDefault "WatchMode"
