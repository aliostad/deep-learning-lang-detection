open System
open System.Diagnostics
open JiraFsharpService
open System.ServiceProcess;
open System.Threading;

[<EntryPoint>]
let main argv = 
    
    if Environment.UserInteractive then
        // Run in console
        Process.Start("http://localhost:3443/?showComments=false&personFilter=tupitsyn&includeAll=true") |> ignore
        WebServer.runWebServer()
        Thread.Sleep(Timeout.Infinite)
    else
        // Start a windows service
        ServiceBase.Run [| new WindowsService() :> ServiceBase |]

    0 // return an integer exit code