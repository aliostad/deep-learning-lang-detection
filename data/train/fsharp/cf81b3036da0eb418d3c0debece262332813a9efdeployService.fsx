#load "refs.fsx"

open Fake
open FSharp.Data
open System
open System.IO

type Config = JsonProvider<"ServiceManifest.json">
let config = Config.Load "ServiceManifest.json"

let public bindir = __SOURCE_DIRECTORY__ @@ "MailTester"
let timeout = TimeSpan.FromMinutes 5.

let addUrlAcl url username =
  let arg = sprintf """http add urlacl url=%s user=%s""" url username
  ExecProcessElevated "netsh" arg timeout |> ignore

Target "Install" (fun _ ->
  trace "installing"
  let exe = config.InstallDir @@ config.ExeName
  let firstInstall = not <| fileExists exe

  if not firstInstall
  then ExecProcessElevated exe "stop" timeout |> ignore
  else CreateDir config.InstallDir
  
  XCopyHelper.XCopy bindir config.InstallDir
  
  for url in config.UrlAcls do
    addUrlAcl url config.ServiceUser

  if firstInstall
  then ExecProcessElevated exe "install" timeout |> ignore
  
  ExecProcessElevated exe "start" timeout |> ignore
)

RunTargetOrDefault "Install"
