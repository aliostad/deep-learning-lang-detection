module Kafka

open System
open System.Text
open System.Collections.Generic

open Confluent.Kafka
open Newtonsoft.Json

let createPublisher (broker : string) topic =
    let config = new Dictionary<string, obj>()
    config.Add("bootstrap.servers", broker)
    config.Add("log.connection.close", "false")

    let producer = new Producer(config)
    producer.OnError.Add(fun e -> printfn "Error in producer: %s %A" e.Reason e.Code)
    producer.OnLog.Add(fun m -> printfn "OnLog %s" m.Message)

    fun message -> 
        producer.ProduceAsync(topic, null, message) |> Async.AwaitTask

let createConsumer broker (topic : string) =
    let topicConfig = new Dictionary<string, obj>()
    topicConfig.Add("auto.offset.reset", "smallest")

    let config = new Dictionary<string, obj>()
    config.Add("bootstrap.servers", broker)
    config.Add("log.connection.close", "false")
    config.Add("group.id", "kfs-consumer")
    config.Add("default.topic.config", topicConfig)

    let consumer = new Consumer(config)
    consumer.Subscribe(topic)
    consumer

let inline publish broker topic message =
    let publisher = createPublisher broker topic

    message 
    |> JsonConvert.SerializeObject
    |> Encoding.Unicode.GetBytes
    |> publisher

let inline consume broker topic (timeout : TimeSpan) (consumeMessage : 'T -> unit) =
    let consumer = createConsumer broker topic

    consumer.OnMessage.Add(
        fun m -> 
            printfn "[Consumer]: Topic: %s Partition: %A Offset: %A" m.Topic m.Partition m.Offset

            m.Value 
            |> Encoding.Unicode.GetString 
            |> JsonConvert.DeserializeObject<'T> 
            |> consumeMessage
    )

    fun () -> consumer.Poll(timeout)