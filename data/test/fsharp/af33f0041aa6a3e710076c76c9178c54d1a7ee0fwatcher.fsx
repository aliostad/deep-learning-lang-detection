#r "../packages/Fake/tools/FakeLib.dll"

open System
open Fake
open Fake.MSBuild
open Fake.REST
open Fake.FileHelper

Environment.CurrentDirectory <- __SOURCE_DIRECTORY__

Target "Watch" (fun _ ->
    use watcher = 
        //Not sure why it won't find my path if I don't specify a full path.
        !! "/Users/kimsereylam/Projects/watcher/spa/*.fs"
        |> WatchChanges (fun _ -> 
            let setParams defaults =
                { defaults with
                    Verbosity = Some(MSBuildVerbosity.Quiet)
                    Targets = ["Build"]
                    Properties =
                        [
                            "Optimize", "True"
                            "DebugSymbols", "False"
                        ] }
            
            //Builds solution to recompile WebSharper spa.
            build setParams "../watcher.sln"

            //Copies the static files to /site folder.
            DeleteDir "Content"
            CopyDir   "Content" "../spa/Content" (fun _ -> true)
            CopyFile  "index.html" "../spa/index.html"

            //Sends a POST request to refresh the browser.
            printfn "POST refresh "
            ExecutePost "http://127.0.0.1:8083/refresh" "." "." "" |> ignore)

          
    //Prevents watcher from stopping
    System.Console.ReadLine() |> ignore
    watcher.Dispose()
)

RunTargetOrDefault "Watch"
