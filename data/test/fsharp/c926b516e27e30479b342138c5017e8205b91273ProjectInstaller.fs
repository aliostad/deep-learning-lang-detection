#light

namespace Sliver

open System.ComponentModel
open System.Configuration.Install
open System.ServiceProcess

[<RunInstaller(true)>]
type public ProjectInstaller() as self =
    inherit Installer()
    
    let si = new ServiceInstaller()
    let spi = new ServiceProcessInstaller()
    do
        si.ServiceName <- "Sliver"
        si.StartType <- ServiceStartMode.Automatic
        spi.Account <- ServiceAccount.LocalSystem
        self.Installers.AddRange([| (si :> Installer); (spi :> Installer) |])
    
    member self.ServiceInstaller = si
    member self.ServiceProcessInstaller = spi
