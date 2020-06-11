namespace DarkMadness2.Core

/// Listens for events from producer thread, queues them and provides them to a consumer thread.
/// Used for multithreaded event passing.
type private EventDispatcher<'a> () =
    
    /// Queue for incoming events.
    let eventBuffer = System.Collections.Generic.Queue<_> ()

    /// Thread synchronizer.
    let locker = new System.Threading.AutoResetEvent false

    /// Receives incoming events from producer and puts them to a queue.
    member this.Listener (event : 'a) = 
        System.Threading.Monitor.Enter eventBuffer
        eventBuffer.Enqueue event
        locker.Set () |> ignore
        System.Threading.Monitor.Exit eventBuffer

    /// Returns queued events to consumer, if any, otherwise blocks until new events arrive.
    member this.GetEvent () = 
        // Block consumer thread until Listener gets called by producer.
        locker.WaitOne () |> ignore
        System.Threading.Monitor.Enter eventBuffer
        let result = eventBuffer.Dequeue ()
        if eventBuffer.Count > 0 then
            // If there are queued events, unblock right now.
            locker.Set () |> ignore
        System.Threading.Monitor.Exit eventBuffer
        result

/// Helper functions related to event processing.
module EventProcessing =
    
    /// Event loop, listens for events from given source and calls given handler for every event, until handler returns false.
    let eventLoop (handleEvent : 'a -> bool) (event : IEvent<'a>) =
        let dispatcher = EventDispatcher ()
        let handler = new Handler<_> (fun _ event -> dispatcher.Listener event)
        event.AddHandler handler
        let rec doLoop () =
            let event = dispatcher.GetEvent ()
            if handleEvent event then
                doLoop ()
        doLoop ()
        event.RemoveHandler handler

    /// Receive data from a single event. Blocks calling thread until event occurs, then returns its payload.
    let receiveFromEvent (source : IEvent<_>) =
        let buffer = ref None
        let handler event =
            buffer := Some event
            false
        eventLoop handler source
        (!buffer).Value

    /// Helper that receives data from single event. Blocks calling thread until event occurs, then returns its payload.
    let receive (event : IEvent<_>) = receiveFromEvent event