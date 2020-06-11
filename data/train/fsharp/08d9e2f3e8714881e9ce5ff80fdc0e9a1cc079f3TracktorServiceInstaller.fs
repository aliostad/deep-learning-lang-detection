namespace Tracktor.Service

open System.ComponentModel
open System.Configuration.Install
open System.ServiceProcess

[<RunInstaller(true)>]
type TracktorServiceInstaller() as this =
    inherit Installer()

    let processInstaller = new ServiceProcessInstaller(Account = ServiceAccount.LocalSystem)
    let installer = new ServiceInstaller(ServiceName = TracktorWindowsService.Name,
                                         DisplayName = "Tracktor Service",
                                         StartType = ServiceStartMode.Manual)

    do ignore <| this.Installers.Add processInstaller
    do ignore <| this.Installers.Add installer
    
