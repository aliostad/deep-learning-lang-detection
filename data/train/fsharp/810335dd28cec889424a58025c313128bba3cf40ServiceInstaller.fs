namespace ServiceInstaller

open System.ServiceProcess
open System.ComponentModel
open System.Configuration.Install

//This can't be inside a module, if it is then installutil cannot find it!
[<RunInstaller(true)>]
    type MyInstaller() as this =
        inherit Installer()
        do
            let spi = new ServiceProcessInstaller()
            let si = new ServiceInstaller()
            spi.Account <- ServiceAccount.LocalSystem
            si.DisplayName <- "Test F# Service"
            si.StartType <- ServiceStartMode.Automatic
            si.ServiceName <- "TestService"
            this.Installers.Add(spi) |> ignore
            this.Installers.Add(si) |> ignore