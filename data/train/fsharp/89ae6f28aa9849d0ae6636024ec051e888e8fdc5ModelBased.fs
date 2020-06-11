namespace Examples

open System

module ClientHandler =

    type Message =
        | Subscribe of ClientId * Sender
        | Unsubscribe of ClientId
        | Send of ClientId * byte array * AsyncReplyChannel<Result<unit, SendingError>>

    and ClientId =
        | CleintId of int

    and Sender =
        byte array -> Async<bool>

    and SendingError =
        | ClientNotSubscribed
        | SendingFailed

    type ClientHandlerAgent = MailboxProcessor<Message>

    let createAgent cancellationToken =
        let agent (inbox: ClientHandlerAgent) = async {
            let clients = System.Collections.Generic.Dictionary()

            while true do
                let! message = inbox.Receive()
                match message with
                | Subscribe (client, sender) ->
                    clients.[client] <- sender

                | Unsubscribe client ->
                    clients.Remove(client) |> ignore

                | Send (client, data, replyChannel) ->
                    match clients.TryGetValue(client) with
                    | true, sender ->
                        try
                            let! sendSucceeded = sender data
                            if sendSucceeded then
                                replyChannel.Reply(Ok ())
                            else
                                replyChannel.Reply(Error SendingFailed)
                        with _ ->
                            replyChannel.Reply(Error SendingFailed)
                    | false, _ -> replyChannel.Reply(Error ClientNotSubscribed)
            }

        ClientHandlerAgent.Start(agent, cancellationToken)

module ClientHandlerTests =

    open System.Threading
    open FsCheck
    open FsCheck.Experimental
    open FsCheck.Xunit
    open ClientHandler

    type ClientHandlerModel = Map<ClientHandler.ClientId, SenderType option>

    and SenderType =
        | SucceedingSender
        | FailingSender
        | ThrowingSender

    let clientHandlerSpec =

        let subscribe client senderType =
            { new Operation<ClientHandlerAgent * CancellationTokenSource, ClientHandlerModel>() with
                member this.Run(model) =
                    // Remember the new client
                    Map.add client (Some senderType) model
                    
                member this.Check((agent, cts), model) =
                    let sender _ = async {
                        match senderType with
                        | SucceedingSender -> return true
                        | FailingSender -> return false
                        | ThrowingSender -> failwith "Boom!"; return false
                    }
                    // Create a sender based on our test type, send actual Subscribe message to the agent instance
                    agent.Post(Subscribe(client, sender))
                    // Nothing to verify here
                    true.ToProperty()

                override this.ToString() = sprintf "Subscribing %A as %A" client senderType }

        let unsubscribe client =
            { new Operation<ClientHandlerAgent * CancellationTokenSource, ClientHandlerModel>() with
                member this.Run(model) =
                    // Replace the client sender with nothing, but keep the client known so that we can use its id later
                    Map.add client None model
                    
                member this.Check((agent, cts), model) =
                    // Send Unsubscribe to the agent instance
                    agent.Post(Unsubscribe(client))
                    // Nothing to verify here
                    true.ToProperty()
                    
                override this.ToString() = sprintf "Unsubscribing %A" client }

        let send client =
            { new Operation<ClientHandlerAgent * CancellationTokenSource, ClientHandlerModel>() with
                member this.Run(model) =
                    // Model does not send anything, no change to the clients map
                    model
                    
                member this.Check((agent, cts), model) =
                    // Execute Send on the agent instance and wait for result
                    let sendResult = agent.PostAndReply(fun c -> Send(client, [||], c))

                    let subscriptionState = model |> Map.tryFind client |> Option.flatten
                    match subscriptionState with
                    | Some SucceedingSender ->
                        sendResult = Ok ()
                    | Some FailingSender
                    | Some ThrowingSender ->
                        sendResult = Error SendingFailed
                    | None ->
                        sendResult = Error ClientNotSubscribed
                    |@ sprintf "Sending message to client %A, subscription state %A, result %A" client subscriptionState sendResult                            
                    
                override this.ToString() = sprintf "Sending message to client %A" client }

        let setup =
            { new Setup<ClientHandlerAgent * CancellationTokenSource, ClientHandlerModel>() with
                member __.Actual() =
                    let cts = new CancellationTokenSource()
                    createAgent cts.Token, cts
                member __.Model() = Map.empty }

        let tearDown =
            { new TearDown<ClientHandlerAgent * CancellationTokenSource>() with
                member __.Actual ((_, cts)) = cts.Cancel() }

        { new Machine<ClientHandlerAgent * CancellationTokenSource, ClientHandlerModel>() with
            member __.Setup = setup |> Gen.constant |> Arb.fromGen
            member __.TearDown = tearDown
            member __.Next m = gen {
                let clientGenAny = Arb.from<ClientId>.Generator
                let clientGenExisting =
                    match Map.toList m with
                    | [] -> clientGenAny // No known clients to pick from, generate a new one
                    | cs -> List.map fst cs |> Gen.elements
                // Let's add known clients to the mix to test fewer scenarios where we only do one operation
                // on a ClientId and then generate only new ones
                let! client = Gen.frequency [ 3, clientGenAny; 1, clientGenExisting ]

                let! senderType = Arb.from<SenderType>.Generator
                return!
                    Gen.elements [
                        subscribe client senderType
                        unsubscribe client
                        send client
                    ]
                }}

    [<Property>]
    let ``ClientHandler behaves as modelled`` () =
        StateMachine.toProperty clientHandlerSpec