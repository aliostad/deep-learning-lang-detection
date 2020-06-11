open KafkaNet
open KafkaNet.Model
open KafkaNet.Protocol
open System
open System.Reactive
open System.Reactive.Linq

let produceWith (producer : Producer) topic messages = 
        producer.SendMessageAsync(topic, messages)
        |> Async.AwaitTask
        |> ignore

[<EntryPoint>]
let main argv = 
 
    let topic = "testTopic"

    let router =  new BrokerRouter(new KafkaOptions(new Uri("http://localhost:9092")))

    use producer = new Producer(router)

    let createAndSendMessage = (fun x -> [ new Message(x) ] |> produceWith producer topic)

    let obs = Observable.Interval(TimeSpan.FromSeconds(0.)) 
                |> Observable.subscribe(fun s -> createAndSendMessage (s.ToString()))

    Console.ReadKey() |> ignore

    producer.Dispose()
    
    0