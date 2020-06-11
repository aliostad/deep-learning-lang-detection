module ThreadedHandler

open Model
open System.Collections.Generic
open System
open Microsoft.FSharp.Reflection

let subscriptions = new Dictionary<string, MessageHandler list>();

let GetUnionCaseName (x:'a) = 
    match FSharpValue.GetUnionFields(x, typeof<'a>) with
    | case, _ -> case.Name  

let getMessageType = fun (msg: Message) ->
    match msg with
    | OrderPlaced _ -> GetUnionCaseName(OrderPlacedTopic)
    | OrderCooked _ -> GetUnionCaseName(OrderCookedTopic)
    | OrderPriced _ -> GetUnionCaseName(OrderPricedTopic)
    | OrderPaid _ -> GetUnionCaseName(OrderPaidTopic)

let getCorrId = fun (msg: Message) ->
    match msg with
    | OrderPlaced o -> o.CorrId.ToString()
    | OrderCooked o -> o.CorrId.ToString()
    | OrderPriced o -> o.CorrId.ToString()
    | OrderPaid o -> o.CorrId.ToString()

let publishToTopic (topic : string) (msg : Message) =
    match subscriptions.TryGetValue(topic) with
        | (true, s) ->
            for handler in s do
                handler msg
        | (false, _) -> ()

        
let publish (msg: Message) =
    publishToTopic (getMessageType msg) msg
    publishToTopic (getCorrId msg) msg

type Agent<'T> = MailboxProcessor<'T>

type ThreadedHandler (handler: MessageHandler, name : string) =
    let queue = new Queue<Order>()

    let agent = new Agent<Message>(fun inbox ->
        async {
            while true do
                let! msg = inbox.Receive()
                handler msg
        }
    )
    
    member this.Handle (msg : Message) = agent.Post msg
    
    member this.Count = agent.CurrentQueueLength
    member this.Name = name

    member this.Start () = agent.Start()


let subscribe (topic : string) (handler : MessageHandler) =
    subscriptions.[topic] <-
        match subscriptions.TryGetValue(topic) with
        | (true, s) -> s @ [ handler ]
        | (false, _) -> [ handler ]


let subscribeByTopic = fun (msgTopic : Topic) (handler : MessageHandler) ->
    let topic = GetUnionCaseName msgTopic
    subscribe topic handler


let subscribeByCorrelationId = fun (topicId : Guid) (handler : MessageHandler) ->
    let topic = topicId.ToString()
    subscribe topic handler

