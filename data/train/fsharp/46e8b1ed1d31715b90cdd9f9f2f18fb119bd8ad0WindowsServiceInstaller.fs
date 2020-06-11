namespace JiraFsharpService
    
open System.ServiceProcess;
open System.ComponentModel
open System.Configuration.Install

[<RunInstaller(true)>]
type FSharpServiceInstaller() =
    inherit Installer()
    do 
        // Specify properties of the hosting process
        new ServiceProcessInstaller
          (Account = ServiceAccount.LocalSystem)
        |> base.Installers.Add |> ignore

        // Specify properties of the service running inside the process
        new ServiceInstaller
          ( DisplayName = "JIRA Report F# service", 
            ServiceName = "JiraFSharpService",
            StartType = ServiceStartMode.Automatic )
        |> base.Installers.Add |> ignore