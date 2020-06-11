namespace FSharp.Service1

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

    // TODO initialize your service
    let initInstaller = 

        // Define the process settings
        processInstaller.Account <- ServiceAccount.LocalSystem
        processInstaller.Password <- null
        processInstaller.Username <- null
        
        // Define the service settings
        serviceInstaller.Description <- "FSharp.Service1 MyService"
        serviceInstaller.ServiceName <- "FSharp.Service1.MyService"
        serviceInstaller.StartType <- ServiceStartMode.Manual;
        
        // Define the installers
        let installers = [| processInstaller :> Installer; serviceInstaller :> Installer|]
        installer.Installers.AddRange(installers) 

    do
        initInstaller