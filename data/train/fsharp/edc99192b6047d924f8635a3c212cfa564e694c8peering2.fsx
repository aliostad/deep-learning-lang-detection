#I @"../packages/fszmq/lib/net40"
#r "fszmq.dll"
#load "zhelpers.fs"

module peering2 =

    open System
    open fszmq

    [<Literal>] 
    let private NBR_CLIENTS = 2
    [<Literal>] 
    let private NBR_WORKERS = 2

    let private WORKER_READY = "\001"B // Signals worker is ready

    let private socketName socket = 
        Socket.getOption socket ZMQ.IDENTITY 
        |> zhelpers.decode

    let private align n (s : string) = 
        String.Format(sprintf "{0,%d}" n, s) 

    let private clientTask brokerName = 
        use context = new Context ()
        let client = Context.req context
        zhelpers.s_setID client
        let clientName = socketName client
        Socket.connect client <| sprintf "ipc://%s-localfe.ipc" brokerName
        let rec loop () = 
            Socket.send client <| zhelpers.encode (sprintf "Hello from %s" clientName)
            client
            |> Socket.recv
            |> zhelpers.decode
            |> (sprintf "[Agent : Client] [Id : %s] [Received response: %s]" clientName)
            |> stdout.WriteLine
            async {do! Async.Sleep 3000} |> Async.RunSynchronously
            loop ()
        loop ()

    let private workerTask brokerName =
        use context = new Context ()
        let worker = Context.req context
        zhelpers.s_setID worker
        let workerName = socketName worker
        Socket.connect worker <| sprintf "ipc://%s-localbe.ipc" brokerName
        let workerName = socketName worker
        // Tell broker we are ready for work
        Socket.send worker WORKER_READY
        // Process messages as they arrive
        let rec loop () = 
            let msg = Socket.recvAll worker 
            msg
            |> Array.last
            |> zhelpers.decode
            |> (sprintf "[Agent : Worker] [Id : %s] [Received task: %s]" workerName)
            |> stdout.WriteLine
            msg.[Array.length msg - 1] <- zhelpers.encode (sprintf "OK from %s" workerName)
            Socket.sendAll worker msg
            loop ()
        loop ()

    let main (rng : System.Random) = function
        | _ :: (brokerName : string) :: peers ->
            // First argument is this broker's name.
            // Other arguments are our peers' names.
            stdout.WriteLine (sprintf "[Agent : Broker] [Id : %s] [Preparing broker...]" 
                                      (align 9 brokerName))

            use ctx = new Context ()

            // Bind cloud frontend to endpoint
            let cloudfe = Context.router ctx
            Socket.bind cloudfe <| sprintf "ipc://%s-cloud.ipc" brokerName
            // Connect cloud backend to all peers
            let cloudbe = Context.router ctx
            for peer in peers do
                let log = sprintf "[Agent : Broker] [Id : %s] [Connecting to cloud frontend at %s]" 
                                  (align 9 brokerName) 
                                  peer
                stdout.WriteLine (log)
                Socket.connect cloudbe <| sprintf "ipc://%s-cloud.ipc" peer

            // Prepare local frontend and backend
            let localfe = Context.router ctx
            Socket.bind localfe <| sprintf "ipc://%s-localfe.ipc" brokerName

            let localbe = Context.router ctx
            Socket.bind localbe <| sprintf "ipc://%s-localbe.ipc" brokerName

            // Get user to tell us when to start...
            stdout.WriteLine "Press Enter when all brokers are started: "
            System.Console.ReadLine() |> ignore

            // Start local workers
            for _ in 0 .. NBR_WORKERS do
                async {workerTask brokerName} |> Async.Start

            // Start local clients
            for _ in 0 .. NBR_CLIENTS do
                async {clientTask brokerName} |> Async.Start
    
            // Interesting part ...

            // Least recently used queue of available workers
            let workers = new System.Collections.Generic.Queue<_> () 

            while true do

                let msg = ref None
                let reroutable = ref false

                // Handle reply from local worker
                let handleLocalBe = fun localbe' -> 
                    let payload = Socket.recvAll localbe'
                    let identity = Array.head payload
                    let msg' = Array.last payload
                    if msg' = WORKER_READY then
                        workers.Enqueue identity
                    else 
                        workers.Enqueue identity
                        msg := Some <| payload.[2..]

                // Handle reply from peer broker
                let handleCloudBe = fun cloudbe' ->
                    // We don't use peer broker identity for anything                     
                    let msg' = Socket.recvAll cloudbe' |> Array.skip 2 
                    msg := Some msg'

                // First, route any waiting replies from workers
                [
                    Polling.pollIn handleLocalBe localbe
                    Polling.pollIn handleCloudBe cloudbe
                ]
                // If we have no workers, wait indefinitely
                |> Polling.poll (if workers.Count > 0 then 900L else -1L) 
                |> ignore

                match !msg with
                | Some msg -> 
                    let identity = msg |> Array.head |> zhelpers.decode
                    let peerToRoute = peers |> List.tryFind ((=) identity)
                    match peerToRoute with
                    | Some peer -> 
                        let log = sprintf "[Agent : Broker] [Id : %s] [Routing reply (%s) to cloudefe peer %s]" 
                                          (align 9 brokerName)
                                          (msg.[2] |> zhelpers.decode)
                                          (msg.[0] |> zhelpers.decode)
                        stdout.WriteLine (log)
                        // Reply is addressed to a broker so route reply to cloud
                        Socket.sendAll cloudfe msg
                    | None -> 
                        // Route reply to client if we need to
                        let log = sprintf "[Agent : Broker] [Id : %s] [Routing reply (%s) to localfe client %s]"
                                          (align 9 brokerName)
                                          (msg.[2] |> zhelpers.decode)
                                          (msg.[0] |> zhelpers.decode)
                        stdout.WriteLine (log)
                        Socket.sendAll localfe msg
                | None -> ()
                let request = ref None
                let takeRequest = (:=) request << Some << Socket.recvAll
                let handleCloud = 
                    reroutable := false
                    takeRequest
                let handleLocal =
                    reroutable := true
                    takeRequest

                let pollFrontends = 
                    [
                        Polling.pollIn handleCloud cloudfe; 
                        Polling.pollIn handleLocal localfe
                    ] 

                // Now, route client requests for as much as we have worker capacity
                while workers.Count > 0 && (Polling.poll 0L pollFrontends) do
                    // If reroutable, route to cloud 20% of the time
                    // Normally, we would use cloud status information here here
                    let (workerAddress, backend, flag) =
                        if !reroutable && (not <| List.isEmpty peers) && rng.Next(0, 5) = 0 then
                            (peers.[rng.Next peers.Length] |> zhelpers.encode, cloudbe, true)
                        else
                            (workers.Dequeue(), localbe, false)
                    let addressFrame = [| workerAddress; Array.empty |]
                    match !request with
                    | Some request ->
                        let log = sprintf "[Agent : Broker] [Id : %s] [Routing message (%s) from client %s to %s %s]"
                                          (align 9 brokerName)
                                          (request.[2] |> zhelpers.decode)
                                          (request.[0] |> zhelpers.decode)
                                          (if flag then "cloud address" else "local address")
                                          (workerAddress |> zhelpers.decode)
                        stdout.WriteLine (log)
                        request
                        |> Array.append addressFrame
                        |> Socket.sendAll backend
                    | None -> ()
        | _ -> failwith "No args passed in"

    main (new System.Random 0) (Array.toList fsi.CommandLineArgs)