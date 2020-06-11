#I @"../packages/fszmq/lib/net40"
#r "fszmq.dll"
#load "zhelpers.fs"

module rereq =

    open fszmq
    open zhelpers 
    open Socket
        
    let [<Literal>] private NBR_WORKERS = 10

    let private workerTask () = 
        let context = new Context ()
        let worker = Context.req context
        do 
            s_setID worker
            Socket.connect worker "tcp://localhost:5671"
        let rec loop n = 
            s_send worker "Hi Boss"
            let workload = s_recv worker
            if workload = "Fired!" then
                stdout.WriteLine (sprintf "Completed: %d" n)
            else 
                sleep (srandom().Next (1, 500))
                loop <| n + 1
        loop 0
        Socket.disconnect worker "tcp://localhost:5671"

    let main () = 

        use context = new Context ()
        let broker = Context.router context
        do
            Socket.bind broker "tcp://*:5671"

        // Start workers
        let stopwatch = s_clock_start ()

        for _ in 1 .. NBR_WORKERS do
            async {do workerTask ()} |> Async.Start

        let rec loop = function
            | NBR_WORKERS -> 
                stopwatch.Stop ()
                stopwatch.Reset ()
            | workersFired ->
                let identity = s_recv broker
                s_sendmore broker identity
                ignore <| s_recv broker // Envelope delimiter
                ignore <| s_recv broker // Response from worker
                s_sendmore broker ""
                if stopwatch.Elapsed < System.TimeSpan.FromSeconds 10. then
                    s_send broker "Work harder"
                    loop workersFired 
                else
                    s_send broker "Fired!"
                    loop <| workersFired + 1

        loop 0

        Socket.unbind broker "tcp://*:5671"