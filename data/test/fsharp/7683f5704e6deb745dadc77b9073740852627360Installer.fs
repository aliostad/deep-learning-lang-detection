namespace Cronix

/// Module responsible for installing, uninstalling and starting up the cronix service
module ProjectInstaller =

    open System.Collections
    open System.Configuration.Install
    open System.Reflection
    open System.ServiceProcess
    open Chessie.ErrorHandling
    open Logging
    open System.IO
    open System

    /// Project installer module specific logger
    let logger = logger()

    /// Performs required initialization steps in order to install or uninstall the cronix service
    let initialize (installer : Installer) (assembly : Assembly) =
        let serviceName = assembly.GetName().Name
        let serviceProcessInstaller = new ServiceProcessInstaller()
        serviceProcessInstaller.Account <- ServiceAccount.LocalService
        installer.Installers.Add(serviceProcessInstaller) |> ignore

        let serviceInstaller = new ServiceInstaller()
        serviceInstaller.ServiceName <- serviceName
        serviceInstaller.DisplayName <- serviceName
        serviceInstaller.Description <- "Executes scheduled jobs."
        serviceInstaller.StartType <- ServiceStartMode.Automatic
        installer.Installers.Add(serviceInstaller) |> ignore

        installer.Context <- new InstallContext()
        installer.Context.Parameters.["assemblypath"] <- assembly.Location;

    /// Installs the cronix service. An installation rollback will be done on failure.
    let Install : Install =
        fun(assembly) ->
            let installer = new Installer()
            initialize installer assembly

            let mutable state = new Hashtable()
            try
                installer.Install(state)
                installer.Commit(state)
                installer.Dispose()
                ok("installed")
            with
            | exn ->
                try 
                    installer.Rollback(state)
                    installer.Dispose()
                    fail("rollback: " + exn.Message)
                with
                | ex -> fail("failed to rollback: " + ex.Message)
    
    /// Uninstalls the cronix service.
    let Uninstall : Uninstall = 
        fun(assembly) ->
            try
                let installer = new Installer()
                initialize installer assembly
                installer.Uninstall(null);
                installer.Dispose()
                ok("uninstalled")
            with 
            | ex -> fail("failed to uninstall: " + ex.Message)

