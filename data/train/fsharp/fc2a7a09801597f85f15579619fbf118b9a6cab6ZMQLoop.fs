namespace fszmq

open System
open fszmq.Collections
open System.Threading.Tasks
open System.Collections.Concurrent
open FSharp.Fx
open System.Threading

type ZMQLoop (?context: Context, ?token: CancellationToken) = 
    let context = context |> Shared.create (fun () -> new Context())
    let cancel = Async.inheritToken token
    let token = cancel.Token
    let polls = VersionedBag()
    let disposables = new DisposableBag()
    let sync = new ZMQSync(context.Value, token)

    do polls.Register(sync.Poll)

    let registerSocket socket = 
        disposables.Add(socket)

    let createSender socket = 
        fun message -> sync.Enqueue(fun () -> Socket.sendAll socket message)

    let createReceiver (handler: byte[][] -> unit) socket =
        let poll = Polling.pollIn (Socket.recvAll >> handler) socket
        polls.Register(poll)

    let createResponder (handler: byte[][] -> byte[][]) socket =
        let poll = Polling.pollIn (Socket.recvAll >> handler >> Socket.sendAll socket) socket
        polls.Register(poll)

    let createRequester socket =
        let requests = ConcurrentQueue<TaskCompletionSource<_>>()
        let handler message = 
            let success, request = requests.TryDequeue()
            match success with
            | true -> request.SetResult(message)
            | _ -> message |> sprintf "Unexpected message: %A, response ignored" |> trace |> ignore
        createReceiver handler socket
        let sender = createSender socket
        fun message -> async {
            let result = TaskCompletionSource()
            requests.Enqueue(result)
            sender message
            return! Async.AwaitTask result.Task
        }

    let pollingLoop () =
        let rec loop pollSnapshot = 
            token.ThrowIfCancellationRequested()
            let (_, pollArray) as pollSnapshot = polls.Refresh(pollSnapshot)
            Polling.poll 100L pollArray |> ignore
            loop pollSnapshot
        polls.Refresh() |> loop
    let pollingThread, pollingDone = Async.startThread token pollingLoop ()

    let close () = 
        cancel.Cancel()
        pollingDone |> Async.waitAndIgnore
        pollingThread.Join()
        disposeMany [sync; disposables]
        dispose context

    member x.RegisterSocket(socket: Socket) = 
        registerSocket socket

    member x.CreateSocket(factory: Context -> Socket) =
        let socket = factory context.Value
        registerSocket socket

    member x.CreateSender(socket: Socket) = 
        createSender socket

    member x.CreateSender(socket: Socket, encoder: 'msg -> byte[][]) = 
        encoder >> (createSender socket)

    member x.CreateReceiver(socket: Socket, handler: byte[][] -> unit) = 
        createReceiver handler socket

    member x.CreateReceiver(socket: Socket, decoder: byte[][] -> 'msg, handler: 'msg -> unit) = 
        createReceiver (decoder >> handler) socket

    member x.CreateReceiver(socket: Socket) =
        let event = Event<_>()
        createReceiver event.Trigger socket
        event.Publish :> IObservable<_>

    member x.CreateReceiver(socket: Socket, decoder: byte[][] -> 'msg) = 
        let event = Event<_>()
        createReceiver (decoder >> event.Trigger) socket
        event.Publish :> IObservable<_>

    member x.CreateResponder(socket: Socket, handler: byte[][] -> byte[][]) = 
        createResponder handler socket

    member x.CreateResponder(socket: Socket, decoder: byte[][] -> 'msgi, encoder: 'msgo -> byte[][], handler: 'msgi -> 'msgo) = 
        createResponder (decoder >> handler >> encoder) socket

    member x.CreateRequester(socket: Socket) =
        createRequester socket

    member x.CreateRequester(socket: Socket, decoder: byte[][] -> 'msgi, encoder: 'msgo -> byte[][]) =
        let requester = createRequester socket
        fun request -> async {
            let! response = request |> encoder |> requester
            return response |> decoder
        }

    member x.Context = context.Value

    interface IDisposable with
        member x.Dispose() = close ()
