namespace ProcessSample

open System
open Owin
open Microsoft.AspNet.SignalR
open Microsoft.Owin
open Dynamic
open System.Threading.Tasks

type Process =
    {
        Id : int
        Name : string
        Machine : string
        Started : string
    }

type ProcessesHub() =
    inherit Hub()

    let GetProcesses() = 
        System.Diagnostics.Process.GetProcesses()
            |> Array.choose (fun p ->
                try Some {
                        Id = p.Id
                        Name = p.ProcessName
                        Machine = p.MachineName
                        Started = if p.ProcessName = "Idle" then "" else p.StartTime.ToString()
                    }
                with _ -> None)
            |> Array.sortBy (fun p -> p.Id)

    static let mutable t = Unchecked.defaultof<System.Threading.Timer>

    member private x.SetupTimer() =
        if t = Unchecked.defaultof<System.Threading.Timer> then
            t <- new System.Threading.Timer(
                (fun _ -> let t:Task = x.Clients.All?processes (GetProcesses())
                          t.Wait()), 
                null, 
                0, 
                5000)

    override x.OnConnected() = 
        x.SetupTimer()
        base.OnConnected()

type Startup() =
    member x.Configuration (app : IAppBuilder) = app.MapSignalR() |> ignore
