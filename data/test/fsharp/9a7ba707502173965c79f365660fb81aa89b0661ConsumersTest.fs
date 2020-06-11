namespace Lapin

open NUnit.Framework
open FsUnit
open Lapin.Channel
open Lapin.Consumers
open Lapin.Tests
open System.Threading

module ConsumersTests =
    [<TestFixture>]
    type ConsumersTests() =
        inherit IntegrationTest()

        [<Test>]
        member t.``basic.consume and defaultConsumerFrom``() =
            t.WithChannel(fun _ ch ->
                ch |> enablePublisherConfirms |> ignore
                Lapin.Exchange.declare(ch, t.ExchangeDeclareArgs)
                let q    = t.declareTemporaryQueueBoundToDefaultFanout(ch)
                let body = t.enc.GetBytes("msg")
                let latch = new ManualResetEvent(false)

                let fn    = fun ch tag envelope properties body -> latch.Set() |> ignore
                let cons  = Lapin.Consumers.defaultConsumerFrom(ch, {deliveryHandler  = fn;
                                                                     cancelHandler    = None;
                                                                     cancelOkHandler  = None;
                                                                     shudownHandler   = None;
                                                                     consumeOkHandler = None})
                Lapin.Basic.consumeAutoAck(ch, q, cons) |> ignore
                Lapin.Basic.publish(ch,
                                    { exchange = t.defaultFanout
                                      routingKey = "" }, body, None)
                Lapin.Channel.waitForConfirms(ch, t.defaultTimespan) |> should equal true
                latch.WaitOne(t.defaultTimespan) |> should equal true
                Lapin.Queue.delete(ch, q, None))

        [<Test>]
        member t.``basic.consume-ok handler``() =
            t.WithChannel(fun _ ch ->
                Lapin.Exchange.declare(ch, t.ExchangeDeclareArgs)
                let q    = t.declareTemporaryQueueBoundToDefaultFanout(ch)
                let latch = new ManualResetEvent(false)

                let fn    = fun ch tag envelope properties body -> body |> ignore
                let okFn  = fun ch tag -> latch.Set() |> ignore
                let cons  = Lapin.Consumers.defaultConsumerFrom(ch, {deliveryHandler  = fn;
                                                                     cancelHandler    = None;
                                                                     cancelOkHandler  = None;
                                                                     shudownHandler   = None;
                                                                     consumeOkHandler = Some okFn})
                let tag = Lapin.Basic.consumeAutoAck(ch, q, cons)
                latch.WaitOne(t.defaultTimespan) |> should equal true
                Lapin.Queue.delete(ch, q, None))

        [<Test>]
        member t.``basic.cancel-ok handler``() =
            t.WithChannel(fun _ ch ->
                Lapin.Exchange.declare(ch, t.ExchangeDeclareArgs)
                let q    = t.declareTemporaryQueueBoundToDefaultFanout(ch)
                let latch = new ManualResetEvent(false)

                let fn    = fun ch tag envelope properties body -> body |> ignore
                let clFn  = fun ch tag -> latch.Set() |> ignore
                let cons  = Lapin.Consumers.defaultConsumerFrom(ch, {deliveryHandler  = fn;
                                                                     cancelHandler    = None;
                                                                     cancelOkHandler  = Some clFn;
                                                                     shudownHandler   = None;
                                                                     consumeOkHandler = None})
                let tag = Lapin.Basic.consumeAutoAck(ch, q, cons)
                Lapin.Basic.cancel(ch, tag)
                latch.WaitOne(t.defaultTimespan) |> should equal true
                Lapin.Queue.delete(ch, q, None))

        [<Test>]
        member t.``basic.cancel handler``() =
            t.WithChannel(fun _ ch ->
                Lapin.Exchange.declare(ch, t.ExchangeDeclareArgs)
                let q    = t.declareTemporaryQueueBoundToDefaultFanout(ch)
                let latch = new ManualResetEvent(false)

                let fn    = fun ch tag envelope properties body -> body |> ignore
                let clFn  = fun ch tag -> latch.Set() |> ignore
                let cons  = Lapin.Consumers.defaultConsumerFrom(ch, {deliveryHandler  = fn;
                                                                     cancelHandler    = Some clFn;
                                                                     cancelOkHandler  = None;
                                                                     shudownHandler   = None;
                                                                     consumeOkHandler = None})
                let tag = Lapin.Basic.consumeAutoAck(ch, q, cons)
                Lapin.Queue.delete(ch, q, None)
                latch.WaitOne(t.defaultTimespan) |> should equal true)