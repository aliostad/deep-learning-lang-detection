namespace Shutdown

open System
open System.ComponentModel
open System.Configuration.Install
open System.Net
open System.ServiceProcess
open System.Text
open System.Diagnostics
open FSharp.Net.HttpExtensions


type ShutdownService () =
  inherit ServiceBase (ServiceName = "shutdown")

  override this.OnStart (args) = 
    HttpListener.Start ("http://*:8080/shutdown/", fun (req, resp) -> 
      async {
        Process.Start ("c:\windows\system32\shutdown.exe", "/s") |> ignore

        let txt = Encoding.UTF8.GetBytes "shutting down!"
        resp.OutputStream.Write (txt, 0, txt.Length)
        resp.Close ()
      })

  override this.OnStop () = ()


[<RunInstaller (true)>]
type ShutdownServiceInstaller () =
  inherit Installer () do
    new ServiceProcessInstaller (Account = ServiceAccount.LocalSystem)
    |> base.Installers.Add
    |> ignore

    new ServiceInstaller (DisplayName = "Shutdown",
                          ServiceName = "Shutdown",
                          StartType = ServiceStartMode.Automatic)
    |> base.Installers.Add
    |> ignore


module Main =
  ServiceBase.Run [| new ShutdownService () :> ServiceBase |]