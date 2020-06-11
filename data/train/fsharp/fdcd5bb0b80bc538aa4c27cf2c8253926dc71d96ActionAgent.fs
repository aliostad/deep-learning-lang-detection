namespace ActionAgent
open System
open System.Threading
open System.Threading.Tasks

type Agent<'T> (handler: System.Action<'T>) = 
    let cts = new CancellationTokenSource()
    let agent = new MailboxProcessor<'T>(fun inbox -> 
        let rec messageLoop() = async {
            let! message = inbox.Receive()
            handler.Invoke(message)
            return! messageLoop()
        }
        messageLoop()
    , cts.Token)
    do agent.Start()
    
    member this.Post message = agent.Post message
    
    interface IDisposable with
        member this.Dispose() = cts.Cancel()

type AsyncAgent<'T> (handler: System.Func<'T, Task>) =
    let cts = new CancellationTokenSource()
    let agent = new MailboxProcessor<'T>(fun inbox ->
        let rec messageLoop() = async {
            let! message = inbox.Receive()
            handler.Invoke(message).ContinueWith(fun t -> true) |> Async.AwaitTask |> ignore
            return! messageLoop()
        }
        messageLoop()
    , cts.Token)
    do agent.Start()

    member this.Post message = agent.Post message
    
    interface IDisposable with
        member this.Dispose() = cts.Cancel()