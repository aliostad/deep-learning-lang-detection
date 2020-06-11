namespace Zeriq.Ports.Port

    type PortOpts = {
        baudRate: int;
        parity: System.IO.Ports.Parity;
        stopBits: System.IO.Ports.StopBits;
        dataBits: int;
        handshake: System.IO.Ports.Handshake
        }

    type State = {
        path: string;
        port: System.IO.Ports.SerialPort;
        opts: PortOpts;
        rts: bool
        }


    type Message =
        | Stop
        | Configure of AsyncReplyChannel<bool> * PortOpts
        | Start of AsyncReplyChannel<bool>
        | Write of AsyncReplyChannel<Async<unit>> * byte []


    type Channel(path) = 
        let mailbox = MailboxProcessor.Start(fun inbox ->
            printf "defining serialport: %A\n" path

            let rec loop(port : State) =
                async { let! msg = inbox.Receive()
                        match msg with
                        | Stop ->
                            return()

                        | Start(chan) ->

                            chan.Reply(true)
                            return! loop port

                        | Configure(chan, newopts) ->
                            let newport  = {port with opts = newopts}
                            chan.Reply(true)
                            return! loop newport

                        | Write(chan, buf) ->
                            chan.Reply(port.port.BaseStream.AsyncWrite buf)
                            return! loop port
                    }
            loop {
                path = path;
                opts = {
                        baudRate = 19200;
                        parity = System.IO.Ports.Parity.None;
                        stopBits = System.IO.Ports.StopBits.One;
                        dataBits = 8;
                        handshake = System.IO.Ports.Handshake.RequestToSend
                        };
                port = new System.IO.Ports.SerialPort(path);
                rts = true;
                })

        member a.Start() = mailbox.PostAndReply(fun chan -> Start(chan))
        member a.Stop() = mailbox.Post(Stop)
        member a.Configure(opts) = mailbox.PostAndReply(fun chan -> Configure(chan, opts))
        member a.Write(buf : byte []) = mailbox.PostAndReply(fun chan -> Write(chan, buf))

namespace Zeriq.Ports

    type State = Map<string, Zeriq.Ports.Port.Channel>

    type Message =
        | GetState of AsyncReplyChannel<State>
        | Rescan
        | Stop

    module Scanner =
        let newPort port = new Zeriq.Ports.Port.Channel(port)

        let addPorts state ports =
            Array.fold (fun (acc : State) item ->
                            match acc.TryFind(item) with
                            | None ->
                                printf "scanner: add port %s\n" item
                                acc.Add(item, newPort item)
                            | Some i -> acc) state ports

        let removePorts state ports =
            Seq.fold (fun (acc : State) item ->
                
                printf "scanner: removing port %s\n" item
                Map.remove item acc) state ports

        let ports state =
            let ports = System.IO.Ports.SerialPort.GetPortNames()
            let available = state |> Map.toSeq |> Seq.map fst
            let removed  = available |> Seq.filter (fun port -> not (Array.contains port ports))
            let added = Seq.filter (fun port -> not (Seq.contains port available)) ports

            let newState = removePorts (addPorts state ports) removed

            ( newState, added, removed )
    
    type PortManager() =
        let mailbox = MailboxProcessor.Start(fun inbox ->
            let rec loop(ports : State) =
                async { let! msg = inbox.Receive()
                        match msg with
                        | GetState chan ->
                            chan.Reply(ports)
                            return! loop(ports)

                        | Rescan ->
                            let (newports, added, removed) = Scanner.ports(ports)
                            return! loop(newports)

                        | Stop ->
                            return ()}

            let (ports, added, removed) = Scanner.ports(Map.empty)

            loop(ports))

        member a.Stop() = mailbox.Post(Stop)
        member a.Rescan() = mailbox.Post(Rescan)
        member a.Fetch() = mailbox.PostAndReply(fun chan -> GetState(chan))

namespace Zeriq      
    // Manage serial ports TCP/IP
    //
    // - Scans for serialports and publish to all clients
    // - Configure a port (port/:port -> {rts, opts} -> true|false); publishes ports
    // - connect a port (port/:port -> start -> true|false)
    // - disconnect a port (port/:port -> stop  -> true|false)
    // - write data (port/:port -> data -> buf -> true|false)
    // - receive data port/:port

    module Server =
        open System.Net
        open System.Net.Sockets
        open System.Threading
        open System.Threading.Tasks

        // 
        // https://github.com/Jallah/FS_ClientServer/blob/a8ce82ef549ca74969f9442ce4f61948535901f0/src/Server/Server.fs

        let removeFirst pred list = 
            let rec removeFirstTailRec p l acc =
                match l with
                | [] -> acc |> List.rev
                | h::t when p h -> (acc |> List.rev) @ t
                | h::t -> removeFirstTailRec p t (h::acc)
            removeFirstTailRec pred list []

        let mutable clients : (string * CancellationTokenSource * Task * TcpClient) list = []

        let matchClient client = (fun (id, _, _, _) -> id = client)
        let addClient client = clients <- client :: clients
        let getClient client = clients |> List.find (matchClient client)
        let delClient client = clients |> removeFirst (matchClient client)

        let worker (id : string) (tcpclient : TcpClient) handler = 
            async {
                let stream = tcpclient.GetStream()
                use reader = new System.IO.BinaryReader(stream)

                try
                    let mutable input: byte[] = Array.init tcpclient.ReceiveBufferSize (fun _ -> byte 0)

                    let remote = (tcpclient.Client.RemoteEndPoint :?> IPEndPoint).Address.ToString()
                    let rec loop lastInput state =
                        match lastInput with
                            | 0 -> None
                            | _ ->
                                let nBytes = stream.Read(input, 0, tcpclient.ReceiveBufferSize)
                                loop nBytes (handler id tcpclient input.[..nBytes] state)

                    loop 1 None |> ignore

                with err ->
                    printf "client#%s err: %A\n" id err

                let _, cts, task, tcpClient = getClient id
                cts.Cancel()
                task.Dispose()
                tcpClient.GetStream().Dispose()
                clients <- delClient id

                printf "client#%s disconnected\n" id
            }

        let listen port handler = 
            Async.StartAsTask (
                async { 
                    let listener = new TcpListener(IPAddress.Any, port)
                    listener.Start()
                    printfn "listener/start listening on port %i\n" port

                    while true do
                        let! client = listener.AcceptTcpClientAsync() |> Async.AwaitTask
                        let endpoint = (client.Client.RemoteEndPoint :?> IPEndPoint).Address
                        printfn "listener/client connected: %A\n" (endpoint.ToString())

                        let id = System.Guid.NewGuid().ToString()
                        let cts = new System.Threading.CancellationTokenSource();

                        let worker = Async.StartAsTask(worker id client handler, cancellationToken = cts.Token)
                        addClient (id, cts, worker, client)
                })

    module Program =

        let rescan (manager : Zeriq.Ports.PortManager) t =
            let timer = new System.Timers.Timer(t)

            timer.Elapsed.Add (fun _ -> manager.Rescan() )
            timer.Start()

            timer

        [<EntryPoint>]
        let main argv =
            let exitEv = new System.Threading.AutoResetEvent(false)

            let manager = new Zeriq.Ports.PortManager()
            let timer = rescan manager 1500.0
         
            let port = 5675
            printf "server/starting :%A\n" port

            let handler id (tcpclient : System.Net.Sockets.TcpClient) buf state = 
                printf "client/%s recv: %A\n" id buf
                tcpclient.GetStream().Write(buf, 0, Array.length buf)
                state

            Async.AwaitTask (Server.listen 5675 handler) |> ignore
            printf "server/stopping :%A\n" port


            exitEv.WaitOne() |> ignore

            0 // return an integer exit code


// zmq is complicated, tcp is easy. Only doing simple stuff so no point in relying
// on another library to perform communication.
//
// The API is as follows:
// - client connects
//  - supports a req/reply command seq:
//   - (*) retrieve port list
//   - (*) ask for rescan of ports
//   - (*) *async receive port changes whenever they change
//
//   - (port) configure a port
//   - (port) start port com
//   - (port) stop port com
//   - (port) write port data
//
//   - (port) *async receive async data
//
// the following will be true for the protocol
//  a) envelop support (ie prefix the cmd/ev with a resource identifier)
//  b) commands are sync; a request demands a reply
//  c) subscriber is async; will interleave (a)?sync (send cmd; recv sub; recv reply must work)
//
// IE:
// ### n == < REPLY?, REQUIRE-REPLY?, cmd-number >
//
// > */ports#<0, 1, n>
// < */ports#<1, 0, n> ... a whole lot of data ...
//
// < */ports#<0, 0, n> ... a whole lot of data, sent async as ports change
//
// > */rescan#<0, 0, n> ; there's no data and REQUIRE-REPLY? := 0 so no reply sent
//
// > /dev/ttyUSB#<0, 1, n> connect
// < /dev/ttyUSB#<1, 0, n> ok
// < */ports#<0, 0, n> ... a whole lot of data, sent async as port came available
// < /dev/ttyUSB#<0, 0, n> data: simon-says abc
// < /dev/ttyUSB#<0, 0, n> data: simon-says def
// < /dev/ttyUSB#<0, 0, n> data: simon-says ghi
// > /dev/ttyUSB#<0, 1, n> data: and then xyz's your uncle
// > /dev/ttyUSB#<0, 1, n> disconnect
// < */ports#<0, 0, n> ... async data since ports went offline; this one is interleaved req/rep
// < /dev/ttyUSB#<1, 0, n> ok
