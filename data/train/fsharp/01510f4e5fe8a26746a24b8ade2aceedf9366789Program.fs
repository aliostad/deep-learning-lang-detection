open System;
open System.Diagnostics;
open System.Fabric;
open System.Threading;
open EvilCorp.EventStore

[<EntryPoint>]
let main argv = 
    try
        use fabricRuntime = FabricRuntime.Create()

        fabricRuntime.RegisterServiceType("EventStoreType", typeof<EventStore>)
        ServiceEventSource.Current.ServiceTypeRegistered(Process.GetCurrentProcess().Id, typeof<EventStore>.Name);

        Thread.Sleep(Timeout.Infinite)
    with
    | :? Exception as e -> 
        ServiceEventSource.Current.ServiceHostInitializationFailed(e)
        ()
        
    0
