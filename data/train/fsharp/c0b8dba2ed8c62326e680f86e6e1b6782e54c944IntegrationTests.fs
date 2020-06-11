module IntegrationTests

open System
open NUnit.Framework
open Swensen.Unquote
open FSharp.Data.UnitSystems.SI.UnitSymbols
open FsBunny
open System.Collections.Generic
open System.Diagnostics
open System.Threading

let streams =
    RabbitMqEventStreams(RabbitMQ.Client.ConnectionFactory(),"amq.topic",3us,2000us) :> EventStreams

[<Test>]
let ``Can instantiate the streams``() = 
    test <@ not <| Object.ReferenceEquals(null, streams) @>

[<Test>]
[<Category("interactive")>]
let ``Consumer stream performs bind``() = 
    let consumer = streams.GetConsumer<int> (Persistent "test.bind") (Routed("amq.topic", "test.bind")) 
    test <@ not <| Object.ReferenceEquals(null, consumer) @>

[<Test>]
[<Category("interactive")>]
let ``RabbitMQ raw event roundtrips``() = 
    let topicAssebler (topic:string,headers,_) = 
        Int32.Parse(topic.Split('.').[1])
    let topicDisassembler x =
        Routed("amq.topic", sprintf "test.%d.roundtrip" x),None,[||]
    let consumer = streams.GetConsumer<int> Temporary (Routed("amq.topic", "test.*.roundtrip")) topicAssebler
    let publish = streams.GetPublisher<int> topicDisassembler
    
    publish 1

    match consumer.Get 10<s> with
    | Some r -> r.msg =! 1
    | _ -> failwith "should have gotten the message we just sent"
    
let byteAssebler (_,_,payload:byte[]) = 
    int payload.[0]
let byteDisassembler topic x =
    Routed("amq.topic", topic),None,[|byte x|]

[<Test>]
[<Category("interactive")>]
let ``Consumer can read and ack concurrently``() = 
    let consumer = streams.GetConsumer<int> (Persistent "test_conc") (Routed("amq.topic", "test.conc")) byteAssebler
    let publish = streams.GetPublisher<int> (byteDisassembler "test.conc")
    let ms = System.Collections.Concurrent.ConcurrentStack()
    let total = 10000

    async {
        do! async { 
            for i in [1..total] do
                publish i
        }

        async { 
            let mutable count = 0
            while count < total do
                consumer.Get(1<s>) 
                |> function 
                | Some m -> ms.Push m; count <- count + 1
                | None -> ()
        } |> Async.Start
        
        Threading.Thread.Sleep (TimeSpan.FromSeconds 2.0)
        do! async { 
            let mutable count = 0
            while count < total do
                ms.TryPop() 
                |> function 
                | true,msg -> consumer.Ack msg.id; count <- count + 1
                | _ -> () 
        }
    } |> Async.RunSynchronously


[<Test>]
[<Category("interactive")>]
let ``Consumer reconnects``() = 
    let rmq = Process.Start("rabbitmq-server")
    Thread.Sleep (TimeSpan.FromSeconds 10.0)

    let consumer = streams.GetConsumer<int> (Persistent "test_conc") (Routed("amq.topic", "test.recon")) byteAssebler
    let publish = streams.GetPublisher<int> (byteDisassembler "test.recon")

    publish 0

    rmq.CloseMainWindow() |> ignore
    rmq.WaitForExit()

    Thread.Sleep (TimeSpan.FromSeconds 5.0)
    raises<RabbitMQ.Client.Exceptions.BrokerUnreachableException> <@ fun () -> consumer.Get(1<s>) @>

    let rmq = Process.Start("rabbitmq-server")
    Thread.Sleep (TimeSpan.FromSeconds 10.0)
    consumer.Get 1<s> |> fun r -> consumer.Ack r.Value.id

    rmq.CloseMainWindow() |> ignore
    rmq.WaitForExit()


