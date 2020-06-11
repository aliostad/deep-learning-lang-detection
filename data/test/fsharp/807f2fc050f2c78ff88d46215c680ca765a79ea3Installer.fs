namespace Monitor
open System.ServiceProcess
open System.Configuration.Install
open System.ComponentModel
// Installer for the service
[<RunInstaller(true)>]
type FSharpServiceInstaller() =
    inherit Installer()
    do
        new ServiceProcessInstaller
            (Account = ServiceAccount.LocalSystem)
        |> base.Installers.Add |> ignore

        new ServiceInstaller (
            DisplayName = Constants.DisplayName,
            ServiceName = Constants.ServiceName,
            StartType = ServiceStartMode.Automatic
        ) |> base.Installers.Add |> ignore

module Main =
    ServiceBase.Run [| new MonitorService.Service() :> ServiceBase |]