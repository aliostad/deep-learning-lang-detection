module Konfig.TaskRunner

#I "../packages/FAKE/tools/"
#r "FakeLib.dll"

open Konfig.Domain
open Fake

let private appOfflineName = "App_Offline.htm"

let private copyBuildTo rootDir (cfg:ProjectConfig) destination =
    let src = rootDir </> cfg.Build.OutputDirectory
    CopyDir destination src (fun _ -> true)

let private createAppOffline rootDir src destination = 
    let destFile = destination </> appOfflineName
    rootDir </> src |> Fake.FileHelper.CopyFile destFile

let private removeAppOffline destination = destination </> appOfflineName |> DeleteFile

let runPostBuild rootDir (cfg:ProjectConfig) = function
    | CopyDirectory(src,dest) -> 
        let src = rootDir </> cfg.SourceDirectory </> src
        let dest = rootDir </> cfg.Build.OutputDirectory </> dest
        CopyDir dest src (fun _ -> true)
    | TransformConfig(src,trans) ->
        let src = rootDir </> cfg.SourceDirectory </> src
        let trans = rootDir </> cfg.SourceDirectory </> trans
        let dest = rootDir </> cfg.Build.OutputDirectory </> (Fake.FileHelper.filename src)
        XDTHelper.TransformFile src trans dest
    | GenericTask(runFunc) -> runFunc()
    | RunTests(pattern,taskRunner) ->
        !! (cfg.Build.OutputDirectory + "/" + pattern) |> taskRunner

let runDeploy rootDir (cfg:ProjectConfig) = function
    | Zip(destination) ->
        Konfig.Utils.Default.runWithRepeat (fun _ ->
            let src = rootDir </> cfg.Build.OutputDirectory
            !! (src + "/**/*.*") |> Zip src destination
        )
    | CopyTo(destination) -> Konfig.Utils.Default.runWithRepeat (fun _ -> destination |> copyBuildTo rootDir cfg)
    | CopyToIIS(destination, appOfflineSrc) ->
        try
            Konfig.Utils.Default.runWithRepeat (fun _ -> destination |> createAppOffline rootDir appOfflineSrc)
            Konfig.Utils.Default.runWithRepeat (fun _ -> destination |> copyBuildTo rootDir cfg)
        finally
            Konfig.Utils.Default.runWithRepeat (fun _ -> destination |> removeAppOffline)