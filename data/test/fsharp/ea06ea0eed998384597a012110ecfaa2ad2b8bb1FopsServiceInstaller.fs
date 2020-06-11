namespace GabeSoft.FOPS.Service

open System
open System.ComponentModel
open System.Configuration.Install
open System.ServiceProcess

[<RunInstaller(true)>]
type FopsServiceInstaller() as this =
    inherit Installer ()

    do
        let pinstaller = new ServiceProcessInstaller()
        let sinstaller = new ServiceInstaller()

        pinstaller.Account <- ServiceAccount.LocalSystem
        pinstaller.Username <- null
        pinstaller.Password <- null

        sinstaller.DisplayName <- "File Operations Service"
        sinstaller.ServiceName <- "FopsService"
        sinstaller.StartType <- ServiceStartMode.Automatic

        this.Installers.Add(pinstaller) |> ignore
        this.Installers.Add(sinstaller) |> ignore



