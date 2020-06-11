namespace IVR.Asterisk

open System

open IVR
open AsterNET.ARI
open AsterNET.ARI.Middleware

open IVR.Threading

module Client = 

    [<NoComparison>]
    type ARIClientEvent =
        | ARIEvent of obj
        | Connected
        | Disconnected

    type ARIConnection(disconnect: unit -> unit) =
        interface IDisposable with
            member this.Dispose() = 
                disconnect()

    type ARIConnectionWithQueue(queue: SynchronizedQueue<ARIClientEvent>, disconnect: unit -> unit) =
        interface IDisposable with
            member this.Dispose() =
                disconnect()

        member this.nextEvent() = 
            queue.dequeue()

    // Hack: don't see yet how to unify the following two:

    let deliverARIEventToRuntimeQueue (queue : SynchronizedQueue<_>) event = 
        match event with
        | ARIEvent e -> e |> queue.enqueue
        | Disconnected -> Runtime.CancelIVR |> queue.enqueue
        | _ -> failwithf "unexpected ARI event: %A" event

    let deliverARIEventToRuntime (runtime : Runtime.Runtime) event = 
        match event with
        | ARIEvent e -> e |> runtime.scheduleEvent
        | Disconnected -> Runtime.CancelIVR |> runtime.scheduleEvent
        | _ -> failwithf "unexpected ARI event: %A" event

    type AriClient with

        member this.connect() = 

            let queue = SynchronizedQueue()
            let connection = this.connect(queue.enqueue)
            new ARIConnectionWithQueue(queue, (connection :> IDisposable).Dispose)

        member this.connect(eventReceiver : ARIClientEvent -> unit) : ARIConnection =
            
            this.EventDispatchingStrategy <- EventDispatchingStrategy.DedicatedThread

            let connectionStateChanged f (_:obj) = 
                match this.ConnectionState with
                | ConnectionState.Closed -> f Disconnected
                | ConnectionState.Open -> f Connected
                | _ -> ()

            let unhandledEvent _ event = 
                event |> ARIEvent |> eventReceiver

            let eventHandler = UnhandledEventHandler unhandledEvent

            this.OnUnhandledEvent.AddHandler eventHandler

            let cleanup() =
                this.OnUnhandledEvent.RemoveHandler eventHandler

            // we never want to handle auto reconnect, the application should completely fail, when the connection
            // gets disconnected, we consider this an application failure, and not a temporary glitch of the connection
            // An application failure usually has a much greater impact and will be reported, and that's what we actually
            // want here!

            // later on, we will poll for the Connected flag to find out when the connection closes.

            let connectionQueue = SynchronizedQueue()

            let connectionHandler = AriClient.ConnectionStateChangedHandler (connectionStateChanged connectionQueue.enqueue)
            this.OnConnectionStateChanged.AddHandler connectionHandler
                
            this.Connect(autoReconnect = false)
            assert(this.ConnectionState = Middleware.ConnectionState.Connecting)

            try
                match connectionQueue.dequeue() with
                | Connected -> 
                    let connectedHandler = AriClient.ConnectionStateChangedHandler(connectionStateChanged eventReceiver)
                    this.OnConnectionStateChanged.AddHandler connectedHandler

                    let cleanup() = 
                        this.OnConnectionStateChanged.RemoveHandler connectedHandler
                        this.Disconnect()
                        cleanup()
                    new ARIConnection(cleanup)

                | _ ->
                    failwithf "failed to connect to ARI, connection state is %s" (string this.ConnectionState)

            finally
                this.OnConnectionStateChanged.RemoveHandler connectionHandler

        /// Connect and deliver all events from ARI to the IVR runtime.
        member this.connect(runtime: IVR.Runtime.Runtime) = 
            this.connect(deliverARIEventToRuntime runtime)

        member this.service (context: IVR.Runtime.IServiceContext) =
            fun (cmd : Command) ->
                match cmd with
                | :? IAriActionClientDispatch as d -> d.dispatch this |> Some
                | _ -> failwithf "Unsupported command: %A" cmd
