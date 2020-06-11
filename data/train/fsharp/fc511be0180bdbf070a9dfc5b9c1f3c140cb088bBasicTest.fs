module BasicTest

open Swensen.Unquote
open Cluster
open Franz
open Franz.HighLevel
open System.Threading

let topicName = "Franz.Integration.Test"

[<FranzFact>]
let ``must produce and consume 1 message`` () =
    reset()

    let broker = new BrokerRouter(kafka_brokers, 10000)
    let producer = new RoundRobinProducer(broker)
    let expectedMessage = {Key = ""; Value = "must produce and consume 1 message"}
    producer.SendMessage(topicName, expectedMessage);
    let options = new ConsumerOptions()
    options.Topic <- topicName
    let consumer = new ChunkedConsumer(broker, options)
    let tokenSource = new CancellationTokenSource()

    let message = consumer.Consume(tokenSource.Token) |> Seq.head
    tokenSource.Cancel()

    test <@ System.Text.Encoding.UTF8.GetString(message.Message.Value) = expectedMessage.Value @>