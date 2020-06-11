open KafkaNet
open KafkaNet.Model
open KafkaNet.Protocol
open System
open System.Reactive.Linq

let printMessage (message: Message) =
    let encoding = new System.Text.UTF8Encoding()
    message.Value
    |> encoding.GetString
    |> printfn "%s"  

[<EntryPoint>]
let main argv = 

    let topic = "testTopic"

    let router =  new BrokerRouter(new KafkaOptions(new Uri("http://localhost:9092")))

    let consumer = new KafkaNet.Consumer(new ConsumerOptions(topic, router))

    consumer.SetOffsetPosition(new OffsetPosition(0, 0L))

    let observable = consumer.Consume() 
                        |> Observable.ToObservable
                        |> Observable.subscribe(fun m -> printMessage m)

    0 
