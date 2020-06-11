// include Fake libs
#r "./packages/FAKE/tools/FakeLib.dll"

open Fake
open System

// Directories
let buildDir  = "./build/"
let deployDir = "./deploy/"
let portNumber = 8901


// Filesets
let appReferences  =
    !! "/**/*.csproj"
    ++ "/**/*.fsproj"

// version info
let version = "0.1"  // or retrieve from CI server

let copyAppFolder () =
    CopyDir  (buildDir </> "app") ("redfedora" </> "app") (fun f -> true)

// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir; deployDir]
)

Target "CopyAppFolder" (fun _ ->
    copyAppFolder()
)

Target "Build" (fun _ ->
    // compile all projects below src/app/
    MSBuildDebug buildDir "Build" appReferences
    |> Log "AppBuild-Output: "
)   

Target "Deploy" (fun _ ->
    !! (buildDir + "/**/*.*")
    -- "*.zip"
    |> Zip buildDir (deployDir + "ApplicationName." + version + ".zip")
)

Target "BuildClientside" (fun _ ->
    NpmHelper.Npm (fun p ->
              { p with
                  Command = (NpmHelper.Run "build")
                  WorkingDirectory = "./redfedora/"
              })
)

Target "Run" (fun _ -> 
    
    let mono = isMono
    let procInf (info:Diagnostics.ProcessStartInfo) =
        if mono then
            trace "--mono--"
            info.FileName <- "mono"
            info.Arguments <- sprintf "%s %s" (buildDir </> "redfedora.exe") (portNumber.ToString())
        else
            info.FileName <- buildDir </> "redfedora.exe"
            info.Arguments <- portNumber.ToString()
    if mono then
        let timeOut = TimeSpan.FromMinutes 30.0
        ExecProcess procInf timeOut |> ignore
    else
        fireAndForget procInf
        
        let startPage = sprintf "http://127.0.0.1:%d" portNumber 
        Diagnostics.Process.Start(startPage) |> ignore
        use watcher = !! "redfedora/app/**/*.*" |> WatchChanges (fun c -> copyAppFolder())
        
        System.Console.Read() |> ignore
    ()
)




"Build" 
    ==> "Run"

// Build order
"Clean"
  ==> "BuildClientside"
  ==> "CopyAppFolder"
  ==> "Build"
  ==> "Deploy"

// start build
RunTargetOrDefault "Build"
