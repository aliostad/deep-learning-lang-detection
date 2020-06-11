namespace Dashboard.Engine

module AdventDash =
    open System
    open System.Threading
    open Owin
    open FSharp.Interop.Dynamic
    open Microsoft.AspNet.SignalR
    open Microsoft.Owin.Hosting
    open Microsoft.Owin.Cors
    open Microsoft.AspNet.SignalR.Hubs
    open Microsoft.AspNet.SignalR.Owin
    open Startup
    open MetricsHub
    open System.Diagnostics
    open PerfModel

    // the context
    let interval = 1000
    let context : IHubContext = GlobalHost.ConnectionManager.GetHubContext<MetricsHub>()

    /// get the process instance name via provider process id
    let getProcessInstanceName (pid: int) = 
        let cat = new PerformanceCounterCategory("Process")
        let instances = cat.GetInstanceNames()
        instances
        |> Array.filter (fun i -> 
            use cnt = new PerformanceCounter("Process", "ID Process", i, true)
            let intval = (int)cnt.RawValue
            if pid = intval then
                true
            else false)
        |> Seq.head

    /// get the current running process name
    let getCurrentProcessInstanceName =
        let proc = Process.GetCurrentProcess()
        let pid = proc.Id
        getProcessInstanceName pid

    /// set a few service counters so we can track some basic metrics
    let serviceCounters = 
        [
            new PerformanceCounter("Processor Information", "% Processor Time", "_Total")
            new PerformanceCounter("Memory", "Available MBytes")
            new PerformanceCounter("Process", "% Processor Time", getCurrentProcessInstanceName, true)
            new PerformanceCounter("Process", "Working Set", getCurrentProcessInstanceName, true)       
        ]

    /// gram performance metric values and map them to our over the wire F# PerfModel
    let metricsWorkflow (context : IHubContext) = async {
        let mappedCounters = serviceCounters
                             |> Seq.map (fun x ->
                                {
                                    PerfModel.PerfModel.MachineName = x.MachineName
                                    CategoryName = x.CategoryName
                                    CounterName = x.CounterName


                                    InstanceName = x.InstanceName
                                    Value = (double)x.RawValue
                                }
                             )
        printfn "========================"
        // mappedCounters
        // |> Seq.iter (fun perfModel ->   printfn "CategoryName: %s CounterName:%s Value:%A" perfModel.CategoryName perfModel.CounterName perfModel.Value)

        context.Clients.All?broadcastPerformance(mappedCounters)
    }

    // lets recurse infintly to broadcast our metrics
    // we can do a while loop or any other mechanism we like
    let rec iBroadcast() = async {
        do! metricsWorkflow context
        do! Async.Sleep 1000
        return! iBroadcast()
    }

    let start(signalrEndpoint:string) =
        printfn "starting..."
        try
            use webApp = WebApp.Start<Startup>(signalrEndpoint)
            printfn "running..."
            printfn "listening on %s"  signalrEndpoint

            iBroadcast() |> Async.RunSynchronously
        with 
        | ex -> 
            printfn "%A" ex
        ()

