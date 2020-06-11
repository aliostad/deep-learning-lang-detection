module internal Angara.MailboxProcessor

// An abstraction after "A simpler F# MailboxProcessor", Luca Bolognese, 2010
// http://blogs.msdn.com/b/lucabol/archive/2010/02/12/a-simpler-f-mailboxprocessor.aspx

[<Interface>]
type ILinearizingAgent<'message> =
    inherit System.IDisposable
    abstract member Post: 'message -> unit


type AfterError<'state> =
    | ContinueProcessing of 'state
    | StopProcessing
    | RestartProcessing

type AfterMessage<'state> =
    | ContinueProcessing of 'state
    | StopProcessing

type SpawnAgent<'message,'state> = ('message->'state->AfterMessage<'state>) * ('state) * (System.Exception -> 'message -> 'state -> AfterError<'state>) -> ILinearizingAgent<'message>

type private MailboxProcessorLinearizingAgent<'a> (mb : MailboxProcessor<'a>) =
    interface ILinearizingAgent<'a> with
        member x.Post a = mb.Post a
    interface System.IDisposable with
        member x.Dispose() =
            (mb :> System.IDisposable).Dispose()

/// Creates and starts MailboxProcessor from a messsage handler, an initial state value and an error handler.
let spawnMailboxProcessor : SpawnAgent<'message,'state> = fun (messageHandler, initialState, errorHandler) ->
    let mb = 
        MailboxProcessor.Start(fun inbox ->
        let rec loop state = async {
            let! msg = inbox.Receive()
            try
                let res = messageHandler msg state
                match res with
                | AfterMessage.ContinueProcessing newState -> return! loop(newState)
                | AfterMessage.StopProcessing -> return ()
            with
            | ex -> match errorHandler ex msg state with
                    | AfterError.ContinueProcessing(newState)    -> return! loop(newState)
                    | AfterError.StopProcessing        -> return ()
                    | AfterError.RestartProcessing     -> return! loop(initialState)
            }
        loop(initialState))

    upcast new MailboxProcessorLinearizingAgent<'message>(mb)
