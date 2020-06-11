// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.


#r "../packages/Rx-Core.2.2.5/lib/net45/System.Reactive.Core.dll"
#r "../packages/Rx-Interfaces.2.2.5/lib/net45/System.Reactive.Interfaces.dll"
#r "../packages/Rx-Linq.2.2.5/lib/net45/System.Reactive.Linq.dll"


#r "../packages/kafka-net.0.9.0.65/lib/net45/kafka-net.dll"

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


let topic = "foo"
let router =  new BrokerRouter(new KafkaOptions(new Uri("http://localhost:9092")))

let producer = new Producer(router)

let createAndSendMessage msg = [ new Message(msg) ] |> produceWith producer topic


 
let obs = Observable.Interval(TimeSpan.FromMilliseconds(1.)) |> Observable.subscribe (fun s -> createAndSendMessage (s.ToString()))


createAndSendMessage "Some Message here"

//Console.ReadKey() |> ignore

//producer.Dispose()
    
    0 // return an integer exit code
