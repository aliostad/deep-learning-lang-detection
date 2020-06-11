#I @"../packages/fszmq/lib/net40"
#r "fszmq.dll"
#load "zhelpers.fs"

module llbroker =

    open fszmq
    open zhelpers
    open System.Collections.Generic

    let [<Literal>] private NBR_CLIENTS = 10
    let [<Literal>] private NBR_WORKERS = 3

    // Basic request-reply client using Req socket.
    // Since s_send and s_recv can't handle ØMQ binary identities we
    // set a printable text identity to allow routing.

    let private clientTask () = 
        use context = new Context ()
        let client = Context.req context
        s_setID client // Set a printable identity
        Socket.connect client "ipc://frontend.ipc"

        // Send request, get reply
        s_send client "Hello"
        let reply = s_recv client
        stdout.WriteLine(sprintf "Client: %s" reply)  
        Socket.disconnect client "ipc://frontend.ipc"

    let private workerTask () =
        use context = new Context ()
        let worker = Context.req context
        s_setID worker // Set a printable identity
        Socket.connect worker "ipc://backend.ipc"

        // Tell broker we're ready for work
        s_send worker "READY"
        let rec loop () =
            let identity = s_recv worker
            let empty = s_recv worker
            if empty = "" then
                let request = s_recv worker
                stdout.WriteLine(sprintf "Worker: %s" request)
                s_sendmore worker identity
                s_sendmore worker ""
                s_send worker "OK"
                loop ()
            else ()

        loop ()
        Socket.disconnect worker "ipc://backend.ipc"

    let main () = 
        use context = new Context ()
        let frontend = Context.router context
        let backend = Context.router context
        Socket.bind frontend "ipc://frontend.ipc"
        Socket.bind backend "ipc://backend.ipc"

        let clientNumber = ref 0

        for i in 1 .. NBR_CLIENTS do
            async {do clientTask ()} |> Async.Start
            incr clientNumber 

        for i in 1 .. NBR_WORKERS do
            async {do workerTask ()} |> Async.Start

        // Queue of available workers
        let workerQueue = new Queue<string> ()

        // Handle worker activity on the backend
        let pollBackend (queue : Queue<string>) frontendSocket backendSocket = 
            // Queue worker identity for load-balancing
            if queue.Count < NBR_WORKERS then
                let workerId = s_recv backendSocket
                queue.Enqueue workerId
            else
                stderr.WriteLine ("Queue length was longer than number of workers (NBR_WORKERS)")
                assert false

            // Second frame is empty
            let empty = s_recv backendSocket
            if empty <> "" then
                stderr.WriteLine ("Second frame is not empty")
                assert false

            // Third frame is READY or else a client reply identity
            let clientId = s_recv backendSocket

            // If client reply, send rest back to frontend
            if clientId <> "READY" then
                let empty = s_recv backendSocket
                if empty <> "" then
                    stderr.WriteLine ("Second frame is not empty")
                    assert false
                let reply = s_recv backendSocket
                s_sendmore frontendSocket clientId
                s_sendmore frontendSocket ""
                s_sendmore frontendSocket reply
                decr clientNumber

        let pollFrontend (queue : Queue<string>) backendSocket frontendSocket = 
            // Now get next client request, route to last-used worker
            // Client request is [identity][empty][request]
            let clientId = s_recv frontendSocket
            let empty = s_recv frontendSocket
            if empty <> "" then
                stderr.WriteLine ("Second frame is not empty")
                assert false
            let request = s_recv frontendSocket
            s_sendmore backendSocket <| queue.Dequeue ()
            s_sendmore backendSocket ""
            s_sendmore backendSocket clientId
            s_sendmore backendSocket ""
            s_send backendSocket request

        while !clientNumber > 0 do
            seq {
                let pollBackend = pollBackend workerQueue frontend
                yield Polling.pollIn pollBackend backend
                if workerQueue.Count > 0 then 
                    let pollFrontend = pollFrontend workerQueue backend
                    yield Polling.pollIn pollFrontend frontend
            }
            |> Polling.poll -1L
            |> ignore

        Socket.unbind frontend "ipc://frontend.ipc"
        Socket.unbind backend "ipc://backend.ipc"

    