module agent

//todo:  copyright attribution??

open System
open Stm

type Agent<'T>(init :'T) = 
    let mutable state : 'T = init
    let mutable error : Exception option = None
    let mutable errorHandler : Exception -> unit = fun e -> ()
    let mutable continueOnError = false
    let mutable validator : ('T -> bool) = fun v -> true
    //static let cache : Set<Agent<'T>>    //  need to support shutdown-agents somehow

    let newqueue() = new MailboxProcessor<'T -> 'T>( fun inbox ->
            let rec loop count = 
                async {
                    let! msg = inbox.Receive()
                    try
                        let v = msg(state)
                        if not( validator(v) ) then failwith "Invalid value"
                        state <- v
                    with ex ->
                        if not(continueOnError) then error <- Some(ex)
                        errorHandler(ex)
                    return! loop(count + 1)
                }
            loop 0)

    let mutable queue = newqueue()

    member __.Start() =
        queue.Start()

    member __.Restart() =
        (queue :> IDisposable).Dispose()
        error <- None
        queue <- newqueue()
        queue.Start()
        
 
    member __.Send(action:'T -> 'T) =
        match error with
        | Some(ex) -> InvalidOperationException("Agent is failed, needs restart", ex) |> raise
        | _ ->  
            if TLog.Current = null then queue.Post(action)
            else TLog.Current.AddAgentAction(fun () -> queue.Post(action))

    member __.Deref() =
        state

    member __.Validator with get() = validator
                        and set(v) = validator <- v

    member __.ErrorHandler with get() = errorHandler
                           and set(v) = errorHandler <- v

    member __.ContinueOnError with get() = continueOnError
                              and set(v) = continueOnError <- v
