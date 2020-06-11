// Learn more about F# at http://fsharp.org

open System
open System.Collections.Generic
open System.Text
open RdKafka

[<EntryPoint>]
let main argv =     
    printfn "Kafka message consumer"

    let config = new RdKafka.Config( GroupId = "simple-csharp-consumer" )
    let consumer = new EventConsumer( config, "localhost:9092" )
    let topic = new TopicPartitionOffset( "test", 0, 0L )
    let topics = new Collections.Generic.List<TopicPartitionOffset>( [ topic ] )

    let messageHandler (msg : Message) = 
      let text = Encoding.UTF8.GetString( msg.Payload, 0, msg.Payload.Length )
      printfn "%A" [ msg.Topic, text ]  

    consumer.OnMessage.Add( messageHandler ) 
    consumer.Assign( topics )
    consumer.Start()     

    Console.ReadLine() |> ignore
    printfn "broker - localhost:2181"
    0 // return an integer exit code
