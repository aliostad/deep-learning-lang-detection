namespace EvilCorp.EventStore

open System;
open System.Diagnostics.Tracing;
open System.Fabric;
open Microsoft.ServiceFabric.Services.Runtime;

[<EventSource(Name = "EvilCorp-EventStore")>]
type ServiceEventSource() = 
    inherit EventSource()
    
    static member Current = new ServiceEventSource()

    [<Event(3, Level = EventLevel.Informational, Message = "Service host process {0} registered service type {1}")>]
    member this.ServiceTypeRegistered(hostProcessId : int, serviceType : string) = 
        this.WriteEvent(3, hostProcessId, serviceType)

    [<NonEvent>]
    member this.ServiceHostInitializationFailed(e : Exception) =
        this.ServiceHostInitializationFailed(e.ToString())

    [<Event(4, Level = EventLevel.Error, Message = "Service host initialization failed")>]
    member this.ServiceHostInitializationFailed(e : string) =
        this.WriteEvent(4, e)
