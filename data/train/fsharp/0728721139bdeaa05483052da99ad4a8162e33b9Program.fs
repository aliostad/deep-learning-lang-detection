open System;
open System.Diagnostics;
open System.Fabric;
open System.Threading;
open EvilCorp.Ingest

[<EntryPoint>]
let main argv = 
    try
        use fabricRuntime = FabricRuntime.Create()

        fabricRuntime.RegisterServiceType("IngestType", typeof<Ingest>)
        ServiceEventSource.Current.ServiceTypeRegistered(Process.GetCurrentProcess().Id, typeof<Ingest>.Name);

        Thread.Sleep(Timeout.Infinite)
    with
    | :? Exception as e -> 
        ServiceEventSource.Current.ServiceHostInitializationFailed(e)
        ()
        
    0
