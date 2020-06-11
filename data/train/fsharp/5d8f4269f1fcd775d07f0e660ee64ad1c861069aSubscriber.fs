namespace RabbitMQ.Subscriber

open System
open RabbitMQ.Client
open RabbitMQ.Client.Events

/// The base class for RabbitMQ message handlers
[<AbstractClass>]
type MessageHandlerBase() = 
    abstract member Handle : Guid -> DateTime -> byte[] -> Async<unit>
    abstract MessageType : Type with get

/// An implementation base class for RabbitMQ message handlers that deserializes the content from JSON into a message type
[<AbstractClass>]
type MessageHandler<'T>() =
    inherit MessageHandlerBase()
    abstract HandleMessage : Guid -> DateTime -> 'T -> Async<unit>
    override this.Handle messageId sentAt content = async {
        let message = Newtonsoft.Json.JsonConvert.DeserializeObject<'T>(content |> Text.Encoding.UTF8.GetString)
        do! this.HandleMessage messageId sentAt message
    }
    override this.MessageType with get() = typeof<'T>

/// And implementation base class for RabbitMQ message handlers that deserializes the content from JSON and also provides access to a RabbitMQ publish channel
[<AbstractClass>]
type PublishingMessageHandler<'T>(publish : obj -> Async<unit>) =
    inherit MessageHandler<'T>()
    member this.Publish (message : obj) = publish message

/// A helper class that initializes and manages message receipt from RabbitMQ
type Service(connection : RabbitMQ.Client.IConnection, queue_name, prefetch_count) =
    let subscription_channel = connection.CreateModel()
    // Set the Quality of Service so we limit the number of unacknowledged messages that the service can have at one time
    do subscription_channel.BasicQos(0u, prefetch_count, true)
    do subscription_channel.QueueDeclare(queue_name, true, false, false) |> ignore
    
    let handlers = Collections.Generic.Dictionary<string, MessageHandlerBase>()

    /// Adds a handler that subscribes to events from other services
    member this.``add subscriber`` (handler : MessageHandlerBase)  =
        let exchange = handler.MessageType.FullName
        subscription_channel.ExchangeDeclare(exchange, "fanout", true, false)
        subscription_channel.QueueBind(queue_name, exchange, "")
        handlers.Add(exchange, handler)

    member this.Start() = 
        let toString (data : obj) = 
            data :?> byte[]
            |> System.Text.UTF8Encoding.UTF8.GetString

        let eventingConsumer = EventingBasicConsumer(subscription_channel)
        eventingConsumer.Received |> Observable.add(fun msg -> 
            let messageType = msg.BasicProperties.Headers.["EnclosedType"] |> toString
            let messageSentAt = msg.BasicProperties.Headers.["SentAt"] |> toString |> DateTime.Parse
            let messageId = msg.BasicProperties.Headers.["MessageId"] |> toString |> Guid.Parse

            // deliver the message to its corresponding handler
            match handlers.TryGetValue(messageType) with
            | true, handler -> 
                // We found a handler now invoke it (asynchronously)
                async {
                    try 
                        do! handler.Handle messageId messageSentAt msg.Body
                        // Mark the message as acknowledged so it gets removed from the queue
                        subscription_channel.BasicAck(msg.DeliveryTag, multiple = false)
                    with error -> 
                        // Something went wrong while handling the message, so requeue it
                        printfn "Error while handling message: %s" error.Message
                        // Mark the message as failed so it gets retried
                        subscription_channel.BasicReject(msg.DeliveryTag, requeue = not msg.Redelivered)
                } |> Async.Start
            | _ -> 
                // We couldn't find a handler for the message. Reject it so we can delete it from the queue
                printfn "Received an unknown message"
                subscription_channel.BasicReject(msg.DeliveryTag, requeue = false)
        )
        subscription_channel.BasicConsume(queue_name, false, eventingConsumer) |> ignore