namespace FSharp.AspNetCore.ServiceWrapper

open System
open System.Configuration
open System.Configuration.Install
open System.ComponentModel
open System.Linq
open System.ServiceProcess

[<RunInstaller(true)>]
type public ProjectInstaller() as installer =
    inherit Installer()

    let processInstaller = new ServiceProcessInstaller();
    let serviceInstaller = new ServiceInstaller();

    let initInstaller =

        // Define the process settings
        processInstaller.Account <- ServiceAccount.LocalSystem
        processInstaller.Password <- null
        processInstaller.Username <- null
        
        // Define the service settings
        serviceInstaller.Description <- "Service that sinks model audit results from verify to hbase."
        serviceInstaller.DisplayName <- "ModelAuditFirehose"
        serviceInstaller.ServiceName <- "ModelAuditFirehose"
        serviceInstaller.StartType <- ServiceStartMode.Automatic;
        
        // Define the installers
        let installers = [| processInstaller :> Installer; serviceInstaller :> Installer|]
        installer.Installers.AddRange(installers)

    do
        initInstaller
