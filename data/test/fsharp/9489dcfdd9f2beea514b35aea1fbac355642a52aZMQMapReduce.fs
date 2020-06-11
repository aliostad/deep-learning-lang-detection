module ZMQMapReduce

open ZeroMQ
open System.Text
open System


let processall nprocesses map initstate mapkeys =
    let inline ssend (socket:ZmqSocket) str = socket.Send(str,Encoding.Unicode) |> ignore
    let inline bsend (socket:ZmqSocket) (bytes:byte[]) = 
        socket.SendFrame(new Frame(bytes)) |> ignore
    let inline bsendmore (socket:ZmqSocket) (bytes:byte[]) = 
        socket.SendFrame(new Frame(bytes,HasMore=true)) |> ignore
    let inline ssendmore (socket:ZmqSocket) str = socket.SendMore(str,Encoding.Unicode) |> ignore
    let inline srecv (socket:ZmqSocket) = socket.Receive(Encoding.Unicode)            
    let inline brecv (socket:ZmqSocket) = socket.ReceiveFrame().Buffer

    let worker workernum = async{
        use context = ZmqContext.Create()
        use worker = context.CreateSocket(SocketType.DEALER)          
        worker.Identity <- Encoding.Unicode.GetBytes(sprintf "%d" workernum)      
        worker.Connect(@"tcp://localhost:5000")
        ssend worker "READY"
        let rec loop fs = 
            let msg = srecv worker
            match msg with
            | "END" -> 
                ()
            | "MAP" ->                
                let key = brecv worker
                let f = map key
                ssend worker "MAP DONE"
                loop (Map.add key f fs)
            | "REDUCE" ->
                let key = brecv worker
                let curstate = brecv worker
                let newstate = (Map.find key fs) curstate
                ssendmore worker "REDUCE DONE"
                bsend worker newstate
                loop (Map.remove key fs)
            | _ -> failwith "Invalid Request"
        loop Map.empty
    }

    use context = ZmqContext.Create()
    use broker = context.CreateSocket(SocketType.ROUTER)
    broker.Bind(@"tcp://*:5000")
    for i in 0..nprocesses-1 do
        worker i |> Async.Start

    let rec loop i keysToMap mapOnHold keysToReduce reducefs state =
        match keysToReduce with
        | key::_  when Map.containsKey key reducefs -> //Reduce Possible
            let reducef = Map.find key reducefs
            reducef state
            loop i keysToMap mapOnHold keysToReduce (Map.remove key reducefs) state
        | _ ->
            match keysToMap,keysToReduce,Map.isEmpty mapOnHold with
            | [],[],true when i >= nprocesses -> //Done
                for i in 0..nprocesses-1 do
                    ssendmore broker (sprintf "%d" i)
                    ssend broker "END" 
                state
            | _ ->
                let ident = srecv broker //identity
                let msg = srecv broker //message
                let newkeysToReduce,newmapOnHold =
                    if msg="MAP DONE" then                 
                        (Map.find ident mapOnHold)::keysToReduce |> List.sort,Map.remove ident mapOnHold
                    else keysToReduce,mapOnHold
                let startnewmap key = 
                    ssendmore broker ident
                    ssendmore broker "MAP"
                    bsend broker key
                    let reducef state =
                        ssendmore broker ident
                        ssendmore broker "REDUCE"
                        bsendmore broker key
                        bsend broker state
                    Map.add ident i newmapOnHold, newkeysToReduce, Map.add i reducef reducefs
                match keysToMap,msg with
                | key::keys,"READY"
                | key::keys,"MAP DONE" -> //Start new map
                    let newmapOnHold,newkeysToReduce,newreducefs = startnewmap key
                    loop (i+1) keys newmapOnHold newkeysToReduce newreducefs state
                | [],"READY"
                | [],"MAP DONE" -> // No more map to be done
                    loop (i+1) [] newmapOnHold newkeysToReduce reducefs state
                | _,"REDUCE DONE" ->
                    let newstate = brecv broker
                    match keysToReduce with
                    | key::keys ->
                        loop i keysToMap mapOnHold keys reducefs newstate
                    | _ -> failwith "Not Possible"                 
                | _ -> failwith "Invalid Reply"
    loop 0 mapkeys Map.empty [] Map.empty initstate
