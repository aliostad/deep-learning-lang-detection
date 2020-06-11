namespace XeSoft.Utilities.Agents

open System.Threading

type private AgentOp<'message, 'result> =
| Stop of signalComplete:(unit -> unit)
| Process of message:'message * reply:('result -> unit)

// these are mainly events which affect memory profile or component status
type AgentEvent =
| AgentReceivedMessage
| AgentProcessedMessage
| AgentStopped

type Agent<'message, 'result> =
    private {
        Mailbox: MailboxProcessor<AgentOp<'message,'result>>;
        Canceller: CancellationTokenSource;
        StatsFn: AgentEvent -> unit;
    }

module Agent =

    /// Create an agent to process messages with the provided function.
    /// The processFn is performed on each submitted message in order.
    /// The failFn is called when the processFn throws an exception.
    /// The statsFn is called when events occur in the agent
    let createWithStats (processFn:'message -> Async<'result>) (failFn:exn -> 'result) (statsFn:AgentEvent -> unit) =

        let startAgent t f = MailboxProcessor.Start (f, cancellationToken = t)
        let canceller = new System.Threading.CancellationTokenSource ()

        let runTurn op =
            match op with
            | Stop signalComplete ->
                statsFn AgentStopped
                signalComplete ()
                async { return false }
            | Process (message, reply) ->
                async {
                    let! result =
                        async {
                            try return! processFn message
                            with ex -> return failFn ex
                        }
                    statsFn AgentProcessedMessage
                    reply result
                    return true
                }

        let mailbox =
            startAgent
            <| canceller.Token
            <| fun inbox ->
                let rec loop () =
                    async {
                        let! op = inbox.Receive ()
                        let! doContinue = runTurn op
                        match doContinue with
                        | false -> return () // exit
                        | true -> return! loop () // continue
                    }
                loop ()

        { Mailbox = mailbox; Canceller = canceller; StatsFn = statsFn;}

    /// Create an agent to process messages with the provided function.
    /// The processFn is performed on each submitted message in order.
    /// The failFn is called when the processFn throws an exception.
    let create (processFn:'message -> Async<'result>) (failFn:exn -> 'result) =
        createWithStats processFn failFn ignore

    /// Send a message for an agent to process.
    /// Returns an async that will complete with the result when the message is processed.
    let send (m:'message) (a:Agent<'message,'result>) =
        a.StatsFn AgentReceivedMessage
        a.Mailbox.PostAndAsyncReply (fun channel -> Process (m, channel.Reply))

    /// Queue a message for an agent to process.
    let queue (m:'message) (a:Agent<'message,'result>) =
        a.StatsFn AgentReceivedMessage
        a.Mailbox.Post (Process (m, ignore))

    /// Stop an agent after all remaining messages have been processed.
    /// Returns an async that will complete when all remaining messages have been processed.
    let stop (a:Agent<'message, 'result>) =
        a.Mailbox.PostAndAsyncReply (fun channel -> Stop channel.Reply)

    /// Stop an agent immediately.
    /// Any messages remaining in queue will not be processed.
    let stopNow (a:Agent<'message, 'result>) =
        a.StatsFn AgentStopped
        a.Canceller.Cancel ()
        // must post the stop message to trigger the cancel check in case queue is empty
        a.Mailbox.Post (Stop ignore)

// convenience methods
type Agent<'message, 'result> with
    /// Send a message for processing.
    /// Returns an async that will complete with the result when the message is processed.
    member me.Send m = Agent.send m me
    /// Queue a message for processing.
    member me.Queue m = Agent.queue m me
    /// Stop the agent after all remaining messages have been processed.
    /// Returns an async that will complete when all remaining messages have been processed.
    member me.Stop () = Agent.stop me
    /// Stop the agent immediately.
    /// Any messages remaining in queue will not be processed.
    member me.StopNow () = Agent.stopNow me
