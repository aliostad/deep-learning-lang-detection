// Copyright: 2017-, Copenhagen Business School
// Author: Rasmus Ulslev Pedersen (rp.digi@cbs.dk)
// License: Simplified BSD License
// LIPS: Queue

namespace LIPSLIB

[<AutoOpen>]
module QueueModule =
    open System.Threading

    /// Overflow: tail + 1 = head and Put(msg) is called. 
    /// Underflow: when the queue is empty (tail + 1 = head) and Take()
    /// Wrap: if index + 1 = cap then index = 0
    type Queue(cap:int) as __ =
        let locker = obj()
        let capacity = cap
        let mutable tail = 0
        let mutable head = 0
        let data : string[] = Array.zeroCreate cap
        //let data : byte[][] = [| for a in 0 .. cap - 1  do yield [||] |]
        let rwlock = new ReaderWriterLock()

        // Write if not full
        //member __.Put(msg : byte[]) : bool = 
        member __.Put(msg : string) : bool = 
            writeLock rwlock (fun () ->
                let newtail = if tail + 1 = cap then 0 else tail + 1
                if newtail <> head then // not full
                    //data.[tail] <- Array.copy msg
                    data.[tail] <- msg
                    tail <- newtail
                    true
                else // full
                    false
                ) 

        // Return Some copy of msg or None if empty 
        //member __.Take() : byte[] option =
        member __.Take() : string option =
            readLock rwlock (fun () ->
                if head <> tail then // not empty
                    let oldhead = head
                    if head + 1 = cap then head <- 0 else head <- head + 1
                    //Some (Array.copy data.[oldhead])
                    Some data.[oldhead]
                else 
                    None
                )