module MSMQ.Util

open System.Messaging

type Receiver(queue:MessageQueue) =
    let mutable disposed = false
    let mutable currKeepConsuming = true

    let cleanup() =
        if not disposed then
            disposed <- true
            queue.Dispose()
    
    interface System.IDisposable with
        member x.Dispose() = cleanup()

    member this.keepConsuming 
        with get() = currKeepConsuming 
        and  set (v:bool) = currKeepConsuming <- v

    member this.startConsuming (queue:MessageQueue) (formatter:IMessageFormatter) handler = 
        queue.Formatter <- new BinaryMessageFormatter()
        queue.ReceiveCompleted.AddHandler(new ReceiveCompletedEventHandler(handler))
        queue.BeginReceive() |> ignore
        while this.keepConsuming do ()

//gets MSMQ queue by name	
let queue name = 
    if MessageQueue.Exists(name) then new MessageQueue(name)
    else MessageQueue.Create(name)

//MSMQ Messages
let publishMsg (q:MessageQueue) (msg:Message) tag =
    q.Send(msg)

//consumes from MSMQ and calls the RMQ publisher
let startConsuming (queue:MessageQueue) (formatter:IMessageFormatter) handler = 
    queue.Formatter <- new BinaryMessageFormatter()
    queue.ReceiveCompleted.AddHandler(new ReceiveCompletedEventHandler(handler))
    queue.BeginReceive() |> ignore
    while true do ()
