module FsDispatcher.Parallel

open System
open System.Threading

type Request =
    | Process of (unit -> unit)
    | Free

let create<'a> parallelism (func : 'a -> unit) =
    let queue = MailboxProcessor.Start( 
                    fun inbox ->

                        let start f = 
                            async{  
                                f()
                                inbox.Post Request.Free} 
                            |> Async.Start

                        let rec loop ready = async {

                            let! msg = inbox.Receive()

                            match msg with
                            | Process f -> 
                                if ready > 0 
                                then start f
                                     return! loop (ready - 1)
                                else inbox.Post (Request.Process f)
                                     return! loop ready
                            | Free -> 
                                return! loop (ready + 1)
                            }

                        loop parallelism
        )
    fun x -> 
        queue.Post (Request.Process (fun () -> func x))
       
module Func =
    let mapParallel = create