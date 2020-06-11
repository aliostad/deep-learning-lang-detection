
namespace NuGetPackageMonitorService
         
open System.ServiceProcess
open System.Configuration.Install

[<System.ComponentModel.RunInstaller(true)>]
type public PackageMontorServiceInstaller() as this =
    inherit Installer()

       do 
            let spi = new ServiceProcessInstaller() 
            let si = new ServiceInstaller() 
            spi.Account <- ServiceAccount.LocalSystem 
            spi.Username <- null 
            spi.Password <- null

            si.DisplayName <- "FSharp NuGet Package Monitor Service" 
            si.StartType <- ServiceStartMode.Automatic 
            si.ServiceName <- "FSharp NuGet Package Monitor Service"

            this.Installers.Add(spi) |> ignore 
            this.Installers.Add(si) |> ignore
