open KafkaNet
open KafkaNet.Model
open KafkaNet.Protocol
open System

let printMe s = printfn "%s" s
let encoding = new System.Text.UTF8Encoding()

let getTopic (argv : string []) = 
    match argv.Length with
    | len when len > 0 -> argv.[0]
    | _ -> failwithf "topic sux"

let getRouter (argv : string []) = 
    match argv.Length with
    | len when len > 1 -> new BrokerRouter(new KafkaOptions(new Uri(argv.[1])))
    | _ -> failwithf "url sux"

[<EntryPoint>]
let main argv = 
    let topic = getTopic argv
    let router = getRouter argv
    let consumer = new KafkaNet.Consumer(new ConsumerOptions(topic, router))
    consumer.SetOffsetPosition(new OffsetPosition(0, 0L))
    for message in consumer.Consume() do
        message.Value
        |> encoding.GetString
        |> printMe
    0
