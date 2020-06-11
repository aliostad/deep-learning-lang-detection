namespace SmtpServiceInstaller

open System
open System.ComponentModel
open System.Configuration.Install
open System.ServiceProcess

[<RunInstaller(true)>]
type SmtpServiceInstaller() =
    inherit Installer()
    do 
        // Specify properties of the hosting process
        new ServiceProcessInstaller
          (Account = ServiceAccount.LocalSystem)
        |> base.Installers.Add |> ignore
        // Specify properties of the service running inside the process
        new ServiceInstaller
          ( DisplayName = "SimpleMailServerSmtpSsl", 
            ServiceName = "SimpleMailServerSmtpSsl",
            StartType = ServiceStartMode.Automatic )
        |> base.Installers.Add |> ignore
// Run the chat service when the process starts
module Main =
    ServiceBase.Run [| new SmtpService.SmtpService() :> ServiceBase |]
