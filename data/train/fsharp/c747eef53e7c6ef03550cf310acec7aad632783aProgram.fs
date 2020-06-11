namespace SkypeCheckService

open System
open System.ComponentModel
open System.Configuration.Install
open System.ServiceProcess
open System.Runtime.Remoting
open System.Runtime.Remoting.Channels
open Sleddog.Blink1
open System.Drawing
open System.Linq

type SkypeBlinkWindowsService() =
    inherit ServiceBase(ServiceName = "SkypeBlinkWindowsService")
    
    override x.OnStart(args) =
        Console.WriteLine("test")
        let test = new Sleddog.Blink1.Blink1Identifier (Sleddog.Blink1.Blink1Connector.Scan().FirstOrDefault(),Color.Chocolate)
        test.Blink1.Blink(Color.Blue,TimeSpan.FromSeconds((float)5),(uint16)10) |> ignore

    override x.OnStop() = ()

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
          ( DisplayName = "Skype Blink Check Service", 
            ServiceName = "SkypeBlinkService",
            StartType = ServiceStartMode.Automatic )
        |> base.Installers.Add |> ignore

// Run the chat service when the process starts
module Main =
    ServiceBase.Run [| new SkypeBlinkWindowsService() :> ServiceBase |]
