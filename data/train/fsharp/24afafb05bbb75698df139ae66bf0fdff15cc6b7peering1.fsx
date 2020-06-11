#I @"../packages/fszmq/lib/net40"
#r "fszmq.dll"
#load "zhelpers.fs"


module peering1 =

    open fszmq

    let main (rng : System.Random) = function
        // First argument is this broker's name
        // Other arguments are our peers' names
        | brokerName :: peersNames ->

            let context = new Context ()

            // Bind state backend to endpoint 
            let statebe = Context.pub context
            Socket.bind statebe <| sprintf "ipc://%s-state" brokerName

            // Connect state frontend to all peers 
            let statefe = Context.sub context
            Socket.subscribe statefe <| [zhelpers.encode ""]
            for name in peersNames do
                Socket.connect statefe <| sprintf "ipc://%s-state" name
            
            while true do
                // Poll for activity, or 1 second timeout
                let recieveHeartbeats = fun statefe' -> 
                    let peerName = zhelpers.s_recv statefe'
                    let availableWorkers = zhelpers.s_recv statefe'
                    stdout.WriteLine (sprintf "[Peer %s] %s - %s workers free" brokerName peerName availableWorkers)
                let recievedStateMessage = Polling.poll 1000L [Polling.pollIn recieveHeartbeats statefe]

                if not recievedStateMessage then
                    // Send random numbers for worker availability
                    zhelpers.s_sendmore statebe brokerName
                    zhelpers.s_send statebe <| sprintf "%d" (rng.Next ())

        | [] -> failwith "No args passed in"