namespace EventSourceIO

open System
open System.Net
open System.Text
open NLog.FSharp
open KafkaNet
open KafkaNet.Model
open KafkaNet.Protocol

module Kafka =
    
    let log = new Logger()

    type HostInfo = {
        Name : string
        Port : int
    }

    type ClusterInfo = {
        Hosts : HostInfo list
        Topic : string
    }
    
    type Offsets = Map<int, int64>

    [<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
    module Offsets =

        let internal pairwise (l : Offsets, r : Offsets) = 
            let joiner partition (l,_) (_,r) = (l,r)
            let l = l |> Map.map (fun _ x -> x, -1L)
            let r = r |> Map.map (fun _ x -> -1L, x)
            Map.join joiner l r

        let incomplete =
            pairwise
            >> Map.exists(fun _ (current, required) -> current + 1L < required)

        let byPartition (consumer : Consumer) =
            fun topic -> consumer.GetTopicOffsetAsync(topic,1048576,-1)
            >> Async.AwaitTask
            >> Async.RunSynchronously
            >> Seq.map(fun x ->
                log.Info "%s partition:%d error:%d offsets:%A" x.Topic x.PartitionId x.Error (Seq.toList x.Offsets)
                x)
            >> Seq.filter(fun x -> x.Error = 0s)
            >> Seq.filter(fun x -> x.Offsets.Count > 1)
            >> Seq.map(fun x ->
                    let id = x.PartitionId
                    let start = Seq.min x.Offsets
                    let finish = Seq.max x.Offsets
                    id, (start, finish))
            >> Map.ofSeq

    let route (hosts : HostInfo seq) =
        let hosts = [| for x in hosts -> new Uri(sprintf "http://%s:%d" x.Name x.Port) |]
        new BrokerRouter(new KafkaOptions(hosts))
            
    let read (cluster : ClusterInfo) =
        seq {
            let topic = cluster.Topic
            use router = cluster.Hosts |> route
            
            let start, finish : Offsets*Offsets =
                let consumer = new Consumer(new ConsumerOptions(topic, router))
                let partitions = Offsets.byPartition consumer topic
                
                log.Info "offset [partition(start,finish)]: %A" partitions

                partitions |> Map.map(fun partition (start,_) -> start),
                partitions |> Map.map(fun partition (_,finish) -> finish)

            use consumer = 
                let start = [| for partition, offset in start |> Map.toSeq -> new OffsetPosition(partition, offset) |]
                let options = new ConsumerOptions(topic, router)
                options.PartitionWhitelist.Clear()
                options.PartitionWhitelist.AddRange(start |> Seq.map (fun x -> x.PartitionId))
                new Consumer(options, start)
                

            let events = consumer.Consume().GetEnumerator()

            let rec loop (current : Offsets) =
                seq {
                    if Offsets.incomplete(current, finish) && events.MoveNext() then
                        log.Debug "offsets: %A" (Offsets.pairwise(current,finish))

                        let event = events.Current
                        let eventType = event.Key |> function | null | [||] -> topic
                                                              | key -> Encoding.UTF8.GetString key

                        let partition = event.Meta.PartitionId
                        let offset = event.Meta.Offset

                        yield { Type = eventType
                                Stream = topic
                                Date = DateTime.Now
                                Data = event.Value
                                Metadata = Array.empty }
                        yield! current |> Map.add partition offset |> loop
                }

            yield! loop (start)
        }
        
    let write (cluster : ClusterInfo) (events : seq<Event>) : unit =
        use router = cluster.Hosts |> route
        use producer = new Producer(router)

        let events =
            seq {
                for event in events ->
                    new Message(Encoding.UTF8.GetString event.Data, event.Type)
            }

        producer.SendMessageAsync(cluster.Topic, events)
        |> Async.AwaitTask
        |> Async.RunSynchronously
        |> Seq.iter (function
            | response when response.Error = 0s -> ()
            | response -> 
                let message = sprintf "error code %d writing to %A" response.Error cluster
                message |> log.Error "%s"
                message |> failwith)
        