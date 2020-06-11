module SynchronizationContext

open Agent
open System.Threading

type SynchronizationContext with 
    /// A standard helper extension method to raise an event on the GUI thread
    member syncContext.RaiseDelegateEvent (event: DelegateEvent<_>) args = 
        syncContext.Post((fun _ -> event.Trigger([|box args; System.EventArgs.Empty|])),state=null)

    member syncContext.RaiseEvent (event: Event<_>) args = 
        syncContext.Post((fun _ -> event.Trigger args),state=null)
    /// A standard helper extension method to capture the current synchronization context.
    /// If none is present, use a context that executes work in the thread pool.
    static member CaptureCurrent () = 
        match SynchronizationContext.Current with 
        | null -> new SynchronizationContext()
        | ctxt -> ctxt

let syncContext = SynchronizationContext.CaptureCurrent()

// F# 
let canceled      = new Event<System.OperationCanceledException>()
//let jobCompleted<'a> = new Event<Agent<Message> * string>()

let phevEvent     = new Event<string>()
let brpEvent      = new Event<string>()
let trfEvent      = new Event<string>()
let pnodeEvent    = new Event<string>()
let updateEvent   = new Event<float[]>()
let progressEvent = new Event<string>()
let debugEvent    = new Event<string>()

let phevBatteryLeft      = new Event<int*float>()

// Delegate Events for cross-language communication
let jobDebug        = new DelegateEvent<System.EventHandler>()
let jobProgress     = new DelegateEvent<System.EventHandler>()
let jobError         = new DelegateEvent<System.EventHandler>()
let jobStarted      = new DelegateEvent<System.EventHandler>()

// EventHandlers for tracking progress
let progressTotal       = new DelegateEvent<System.EventHandler>()
let progressPhev        = new DelegateEvent<System.EventHandler>()
let progressPnode       = new DelegateEvent<System.EventHandler>()

// EventHandlers for debugging Dayahead-algorithm
let dayaheadStep       = new DelegateEvent<System.EventHandler>()
let dayaheadProgress   = new DelegateEvent<System.EventHandler>()
let dayaheadInit       = new DelegateEvent<System.EventHandler>()
let dayaheadSupervisor = new DelegateEvent<System.EventHandler>()
let dayaheadAnt        = new DelegateEvent<System.EventHandler>()
let dayaheadExpected   = new DelegateEvent<System.EventHandler>()

// EventHandlers for displaying cumulative pdf 
let probEvent           = new DelegateEvent<System.EventHandler>()
let probReset           = new DelegateEvent<System.EventHandler>()

let phevBattery         = new DelegateEvent<System.EventHandler>()
let phevStatus          = new DelegateEvent<System.EventHandler>()
let phevLeft            = new DelegateEvent<System.EventHandler>()
let phevFailed          = new DelegateEvent<System.EventHandler>()

let trfFailed           = new DelegateEvent<System.EventHandler>()
let trfCapacity         = new DelegateEvent<System.EventHandler>()
let trfCurrent          = new DelegateEvent<System.EventHandler>()
let trfFiltered         = new DelegateEvent<System.EventHandler>()
let trfUpdate           = new DelegateEvent<System.EventHandler>()
