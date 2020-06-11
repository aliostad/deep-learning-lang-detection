open System.Net
open System.Threading.Tasks
open System.Threading
open fszmq.Context
open fszmq.Socket 
open fszmq.Polling
open System.IO
open System.Text
open fszmq
open System

let encode: string -> byte[] = Encoding.UTF8.GetBytes
let decode = Encoding.UTF8.GetString
let tee f x = f x; x
let readFile (x: string) = 
    try 
        Path.Combine(AppDomain.CurrentDomain.BaseDirectory, x) |> File.ReadAllText
    with 
    | _ -> sprintf "Cant open file with name %s" x

let zBroker workerPrefix masterPrefix = 
    let context = new Context()
    let frontend, backend = router context, dealer context
    bind frontend masterPrefix
    bind backend workerPrefix
    
    let transfer inbound outbound = 
        let message = new Message()
        let rec loop () =
            Message.recv message inbound
            if Message.hasMore message then
                Message.sendMore message outbound
                loop ()
            else
                Message.send message outbound
        loop ()
   
    let items =
        [ frontend |> pollIn (fun _ -> transfer frontend backend)
          backend  |> pollIn (fun _ -> transfer backend frontend) ]
    while items |> pollForever do ()
            

let zWorker prefix =
    let context = new Context()
    let responder = rep context
    connect responder prefix
    while true do
        responder 
        |> recv 
        |> decode
        |> tee (printfn "Got request. Read file with name %s")
        |> readFile
        |> encode
        |> send responder

let zMaster prefix (ctx: HttpListenerContext) =
    try 
        let context = new Context()
        let requester = req context
        connect requester prefix
        let encoded = encode (ctx.Request.RawUrl.TrimStart '/')
        send requester encoded
        let reply = recv requester
        ctx.Response.OutputStream.WriteAsync(reply, 0, reply.Length).ContinueWith (fun _ -> ctx.Response.Close())
    with 
    | ex -> printfn "%A" ex |> Task.FromResult :> Task
        
let handleHttp listenPrefixes handleContext =
    let listen (listener: HttpListener) =
        while true do
            let context = listener.GetContext()
            Task.Run (fun _ -> handleContext context) |> ignore
        
    let listener = new HttpListener()
    listener.Prefixes.Add listenPrefixes
    listener.Start()
    let listenThread = Thread(ThreadStart(fun _ -> listen listener))
    listenThread.Start()


[<EntryPoint>]
let main args = 
    let workerPrefix = "tcp://127.0.0.1:5555/"
    let masterPrefix = "tcp://127.0.0.1:5556/"
    match args with
    | [| "worker" |] ->
        zWorker workerPrefix
    | [| "master" |] ->
        handleHttp "http://+:8080/" (zMaster masterPrefix)
    | [| "broker" |] -> 
        zBroker workerPrefix masterPrefix
    | _ -> 
        printfn "specify worker or master or broker"
    0