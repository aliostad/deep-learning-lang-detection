namespace Lapin

open RabbitMQ.Client
open System
open Lapin.Types
open Lapin.Channel

module Consumers =
    type DeliveryHandler =
        IChannel -> ConsumerTag -> Envelope -> IBasicProperties -> Body -> unit
    type ConsumerTagHandler =
        IChannel -> ConsumerTag -> unit
    type ConsumeOkHandler = ConsumerTagHandler
    type CancelOkHandler  = ConsumerTagHandler
    type CancelHandler    = ConsumerTagHandler

    type ConsumerOptions = {
        deliveryHandler: DeliveryHandler
        consumeOkHandler: Option<ConsumeOkHandler>
        cancelOkHandler: Option<CancelOkHandler>
        cancelHandler: Option<CancelHandler>
        shudownHandler: Option<ShutdownHandler>
    }

    type DelegatingConsumer(ch: IChannel, opts: ConsumerOptions) =
        inherit DefaultBasicConsumer(ch)

        let channel          = ch
        let deliveryHandler  = opts.deliveryHandler
        let consumeOkHandler = opts.consumeOkHandler
        let cancelOkHandler  = opts.cancelOkHandler
        let cancelHandler    = opts.cancelHandler
        let shutdownHandler  = opts.shudownHandler

        interface IBasicConsumer with

            override t.HandleBasicDeliver(consumerTag: string, deliveryTag: uint64,
                                          redelivered: bool, exchange: string, routingKey: string,
                                          properties: IBasicProperties, body: byte[]): unit =
                let envelope = {deliveryTag = deliveryTag; redelivered = redelivered;
                                exchange = exchange; routingKey = routingKey}
                deliveryHandler channel consumerTag envelope properties body |> ignore

            override t.HandleBasicCancel(consumerTag: string): unit =
                match cancelHandler with
                    | None    -> ()
                    | Some fn -> fn ch consumerTag |> ignore

            override t.HandleBasicCancelOk(consumerTag: string): unit =
                match cancelOkHandler with
                    | None    -> ()
                    | Some fn -> fn ch consumerTag |> ignore

            override t.HandleBasicConsumeOk(consumerTag: string): unit =
                match consumeOkHandler with
                    | None    -> ()
                    | Some fn -> fn ch consumerTag |> ignore

            override t.HandleModelShutdown(_: Object, args: ShutdownEventArgs): unit =
                match shutdownHandler with
                    | None    -> ()
                    | Some fn -> fn ch args |> ignore

    let defaultConsumerFrom(ch: IChannel, opts: ConsumerOptions): DefaultBasicConsumer =
        upcast DelegatingConsumer(ch, opts)