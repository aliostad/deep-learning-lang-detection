namespace C_Omega.Delta
module Extensions = 
    module Option = 
        let ofBoolObjTuple (a,b) = if a then Some(b) else None
module Processes = 
    open System.Reflection
    open Extensions

    ///An enumeration of the signals that can be sent
    type Sig = 
        |START = 0uy
        |RESTART = 1uy
        |STOP = 2uy
        |PAUSE = 3uy
        |RESUME = 4uy
        |END = 5uy
        |KILL = 6uy
        |ERR = 7uy
        |NONEXIST = 255uy

    ///A channel for sending signals
    type SigChannel(signalHandler : Sig -> unit) = member x.Send (s:Sig) = signalHandler s

    ///A record type cotaining the pid, channel and state of a process
    type Process = 
        {
            pid : uint64
            channel : SigChannel
            get_state : unit -> Sig
            name : string
        }

    ///Options required to create a process
    type ProcessCreationOptions = 
        {
            channel : Sig -> unit
            name : string
            get_state : unit -> Sig
            on_create : Process -> unit
        }

    ///An interface that represents a processor.
    type IProcessor = 
        abstract start : ProcessCreationOptions -> Process
        abstract get_all : unit -> Process[]
        abstract get_pid : uint64 -> Process option
        abstract kill : uint64 -> unit
    let LocalProcessor() =
        let reg f (ct:System.Threading.CancellationToken) = 
            let v = System.Threading.Thread(System.Threading.ThreadStart(f))
            ct.Register(new System.Action(v.Abort))|>ignore
            v.Start()
        let processes = new System.Collections.Generic.Dictionary<uint64, Process>()
        let nextpid =
            let pid = ref 0uL
            let rec inner() = if processes.ContainsKey(!pid) then pid := !pid + 1uL;inner() else !pid
            fun() -> lock pid inner
        let cts = new System.Collections.Generic.Dictionary<uint64, (unit -> unit)>()
        {new IProcessor with
            member x.start(pco) = 
                let pid = nextpid() 
                let ct = new System.Threading.CancellationTokenSource()
                lock cts (fun () -> cts.Add(pid,ct.Cancel))
                let v = 
                    {
                        pid = pid
                        channel = SigChannel(fun s -> 
                            printfn "Test: %A" s
                            reg(fun()-> pco.channel(s)) ct.Token
                            )
                        get_state = pco.get_state
                        name = pco.name
                    }
                lock processes (fun() -> processes.Add (pid,v))
                reg(fun () -> pco.on_create v) ct.Token
                v
            member x.get_all() = processes.Values|>Seq.toArray
            member x.get_pid i = processes.TryGetValue(i)|>Option.ofBoolObjTuple
            member x.kill(i) = 
                lock processes (fun() -> lock cts (fun () ->
                    match cts.TryGetValue(i) with
                    |true,v -> v();processes.Remove(i)|>ignore
                    |_ -> ()
                ))
        }
    let ip = LocalProcessor()
    let p = ip.start {channel = (fun v -> printfn "NOOOOOO!");name = "lol!"; get_state = (fun() -> Sig.START); on_create = (fun(_) -> while true do System.Threading.Thread.Sleep(1000);printfn "hi!")}
    p.channel.Send Sig.END
    printfn "~"
    System.Threading.Thread.Sleep 10000
    if not(p.get_state() = Sig.STOP) then ip.kill p.pid
    ip.get_pid p.pid
    (*
    let f() =
        (System.Reflection.MethodInfo.GetCurrentMethod()).GetMethodBody().GetILAsByteArray()

*)