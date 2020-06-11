module RateLimiting

open System
open FSharp.Control

type RateLimitedMessage<'a,'b> = {payload: 'a ; response: ('b -> Async<unit>) option}

type RateLimitedAgent<'a,'b>(
                                operation: 'a -> 'b,
                                maxQueueCount, 
                                workerCount, 
                                ?workerCoolDown: int,
                                ?errorHandler: Exception -> 'a -> Async<unit>
                            ) = class
    let blockingQueue = new BlockingQueueAgent<RateLimitedMessage<'a, 'b>>(maxQueueCount)
    let semaphore = new System.Threading.Semaphore(workerCount, workerCount)

    let errorHandler = defaultArg errorHandler (fun _ _ -> async{()})
    let workerCoolDown = defaultArg workerCoolDown -1

    let createWorker () =
        async {
            while true do
                semaphore.WaitOne()
                |> ignore

                let! message = blockingQueue.AsyncGet()

                let messageProcessor =
                    async {
                            try
                                let response = operation message.payload
                                if message.response.IsSome then
                                    do! message.response.Value response
                            with 
                            | ex ->
                                errorHandler ex message.payload
                                |> Async.Start
                        }

                   
                seq {
                        yield messageProcessor
                        yield async {
                                do! Async.Sleep(workerCoolDown)
                                semaphore.Release()
                                    |> ignore
                            }
                    }
                |> Async.Parallel
                |> Async.Ignore
                |> Async.Start
            }

    do
        {1 .. workerCount}
        |> AsyncSeq.ofSeq
        |> AsyncSeq.iterAsync(fun _ -> createWorker ())
        |> Async.Start

    member x.QueueItem item =
        blockingQueue.AsyncAdd item
end