#if COMPILED
module ZMQMapReduce
#else
System.Environment.CurrentDirectory <- __SOURCE_DIRECTORY__
#endif

open ZeroMQ
open System.Text
open System
open Nessos.FsPickler
open System.IO
open System.Threading.Tasks

let GetWorkerAndServer ():(('a->('b->'b*(Task<unit>[])))->string->string->unit)*(int->'b->'a list->string->'b) =
    let inline ssend (socket:ZmqSocket) str = socket.Send(str,Encoding.Unicode) |> ignore
    let inline bsend (socket:ZmqSocket) (bytes:byte[]) = 
        socket.SendFrame(new Frame(bytes)) |> ignore
    let inline bsendmore (socket:ZmqSocket) (bytes:byte[]) = 
        socket.SendFrame(new Frame(bytes,HasMore=true)) |> ignore
    let inline ssendmore (socket:ZmqSocket) str = socket.SendMore(str,Encoding.Unicode) |> ignore
    let inline srecv (socket:ZmqSocket) = socket.Receive(Encoding.Unicode)       
    let inline srecvTimed (socket:ZmqSocket) timespan = socket.Receive(Encoding.Unicode,timespan)    
    let inline brecv (socket:ZmqSocket) = socket.ReceiveFrame().Buffer

    let fsp = FsPickler()
    let serialize x =
        use ms = new MemoryStream()
        fsp.Serialize(x.GetType(),ms,x)
        let d = Array.zeroCreate<byte> (ms.Length|>int)
        ms.Seek(0L,SeekOrigin.Begin) |> ignore
        ms.Read(d,0,d.Length) |> ignore
        d

    let deserialize (x:byte[]) =     
        use ms = new MemoryStream(x)
        fsp.Deserialize(ms)
        

    let worker (map:'a->('b->'b*(Task<unit>[]))) ep (workername:string)  = 
        printfn "Worker %s started" workername
        use context = ZmqContext.Create()
        use worker = context.CreateSocket(SocketType.DEALER)          
        worker.Identity <- Encoding.Unicode.GetBytes(workername)      
        worker.Connect(ep)
        ssend worker "READY"
        let rec loop fTasks fs waithandles =         
            let msg = srecvTimed worker (TimeSpan.FromMilliseconds(100.))
            match msg with
            | "END" -> 
                for wh in waithandles do
                    for (w:Task<unit>) in wh do
                        w.Wait()
            | "MAP" ->                
                let key = brecv worker
                let dkey = deserialize key
                printfn "%A" dkey
                let fTask = async{return map dkey} |> Async.StartAsTask
                loop ((key,fTask)::fTasks) fs waithandles
            | "REDUCE" ->
                let key = brecv worker
                let curstate = brecv worker
                let newstate,wh = (Map.find key fs) (deserialize curstate)
                ssendmore worker "REDUCE DONE"
                bsend worker (newstate|>serialize)
                loop fTasks (Map.remove key fs) (wh::waithandles)
            | null -> //no message
                match (fTasks|>List.partition(fun (_,fTask) -> fTask.IsCompleted)) with
                | completed,remaining ->
                    let newfs = 
                        completed |> List.fold(fun curfs (key,fTask) ->
                            ssend worker "MAP DONE"
                            Map.add key fTask.Result curfs
                        ) fs
                    loop remaining newfs waithandles
            | _ -> failwith "Invalid Request"
        loop [] Map.empty []

    let server maxbacklog (initstate:'b) (mapkeys:'a list) ep =
        use context = ZmqContext.Create()
        use broker = context.CreateSocket(SocketType.ROUTER)
        broker.Bind(ep)

        let rec loop workers freeworkers i curi keysToMap mapOnHold itemstoreduce reducefs state =
            match itemstoreduce with
            | key::_  when key=curi -> //Reduce Possible
                let reducef = Map.find key reducefs
                reducef state
                loop workers freeworkers i (curi+1) keysToMap mapOnHold itemstoreduce (Map.remove key reducefs) state
            | _ ->
                match keysToMap,itemstoreduce,Map.isEmpty mapOnHold with
                | [],[],true -> //Done
                    for worker in workers do
                        ssendmore broker worker
                        ssend broker "END" 
                    state
                | _ ->
                    match freeworkers,keysToMap with
                    | ident::freeworkers,key::keysToMap when (i-curi <= maxbacklog) -> //More mapping to be done
                        ssendmore broker ident
                        ssendmore broker "MAP"
                        let keybytes = serialize key
                        bsend broker keybytes
                        let reducef state =
                            ssendmore broker ident
                            ssendmore broker "REDUCE"
                            bsendmore broker keybytes
                            bsend broker (serialize state)
                        loop workers freeworkers (i+1) curi keysToMap (Map.add ident i mapOnHold) itemstoreduce (Map.add i reducef reducefs) state
                    | _ ->
                        let ident = srecv broker //identity
                        let msg = srecv broker //message
                        let workers = 
                            if msg="READY" then ident::workers else workers
                        let newitemsToReduce,newmapOnHold =
                            if msg="MAP DONE" then
                                (Map.find ident mapOnHold)::itemstoreduce |> List.sort,Map.remove ident mapOnHold
                            else itemstoreduce,mapOnHold
                        match msg with
                        | "READY"
                        | "MAP DONE" ->
                            loop workers (freeworkers@[ident]) i curi keysToMap newmapOnHold newitemsToReduce reducefs state
                        | "REDUCE DONE" ->
                            let newstate = brecv broker |> deserialize
                            printfn "Completed Item %d" curi
                            match itemstoreduce with
                            | key::keys ->
                                loop workers freeworkers i curi keysToMap mapOnHold keys reducefs newstate
                            | _ -> failwith "Not Possible"                 
                        | _ -> failwith "Invalid Reply"
        loop [] [] 0 0 mapkeys Map.empty [] Map.empty initstate
    worker,server