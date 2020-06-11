namespace sync.today.service

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
        processInstaller.Account <- ServiceAccount.User
        processInstaller.Password <- null
        processInstaller.Username <- null
        
        // Define the service settings
        serviceInstaller.Description <- "Main service of the Sync.Today business processes automation platform. Provides HTTP access. Uses Orleans silos."
        serviceInstaller.ServiceName <- Service.serviceName
        serviceInstaller.StartType <- ServiceStartMode.Automatic;
        
        // Define the installers
        let installers = [| processInstaller :> Installer; serviceInstaller :> Installer|]
        installer.Installers.AddRange(installers) 

    do
        initInstaller