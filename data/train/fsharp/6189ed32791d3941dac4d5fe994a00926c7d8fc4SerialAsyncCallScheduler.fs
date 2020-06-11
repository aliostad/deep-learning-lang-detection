namespace TypeInferred.HashBang.SignalR

open System.Collections.Concurrent
open System.Threading

/// Prevents async computations from overlapping. Makes async computations execute serially.
type internal SerialAsyncCallScheduler<'TArgument>(f:'TArgument -> unit Async) =
    
    // Hide f with safer version.
    let f x = 
        async {
            try do! f x
            with _ -> () // TODO: log
        }

    let q = ConcurrentQueue()
    let mutable itemCount = 0
    let mutable item = Unchecked.defaultof<_>

    let processUntilEmpty() =
        let rec processActions processedActionCount =
            async {
                let hasItem = q.TryDequeue(&item)
                if hasItem then
                    do! f item
                    return! processActions (processedActionCount+1)
                else
                    item <- Unchecked.defaultof<_>
                    let newCount = Interlocked.Add(&itemCount, -processedActionCount)
                    if newCount <> 0 then return! processActions 0
            }
        async {
            do! f item
            let newCount = Interlocked.Decrement &itemCount
            if newCount <> 0 then 
                return! processActions 0
        }

    let doOrEnqueue i =
        let newItemCount = Interlocked.Increment &itemCount
        let isFirstItem = newItemCount = 1
        if isFirstItem then 
            item <- i
            processUntilEmpty() |> Async.Start
        else q.Enqueue i

    member __.Enqueue item = doOrEnqueue item