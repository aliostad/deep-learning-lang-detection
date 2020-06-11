module AgentHelper

type Agent<'T> = MailboxProcessor<'T>
 
type SerialMsg<'T,'U> =
| ProcessData of 'T
| WaitForCompletion of 'U

let agentSerial initState =
    Agent.Start(fun inbox ->
        let rec loop state ender = async {
            match ender with
            | Some (endfunc,reply:AsyncReplyChannel<_>) -> 
                if endfunc state then reply.Reply(state)
            | None -> ()
            let! msg = inbox.Receive()
            match msg with
            | ProcessData func ->
                let newstate = func state
                return! loop newstate ender
            | WaitForCompletion r ->
                return! loop state (Some r)
        }
        loop initState None)

let mapreduce nprocesses map reduce initState xs =
    let aP = ThrottlingAgent nprocesses
    let aS = agentSerial (0,initState,[])
    
    let rec reduceall curi state is =
        match is with
        | (h,v)::t when h=curi -> 
            reduceall (curi+1) (reduce state v) t
        | _ -> (curi,state,is)
                            
    let processItem i k = async {
            let! v = map k
            aS.Post (ProcessData (fun (curi,curstate,is) ->
                 let newis = (i,v)::is |> List.sortBy fst
                 reduceall curi curstate newis
            ))
        }
    let n =
        xs
        |> AsyncSeq.fold (fun i x -> 
            aP.DoWork(processItem i x)
            i+1) 0
        |> Async.RunSynchronously
    let _,finalstate,_ = aS.PostAndReply(fun reply -> WaitForCompletion ((fun (blocknum,_,_) -> blocknum = n),reply))
    finalstate
