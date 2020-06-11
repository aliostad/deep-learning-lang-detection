namespace Franz.HighLevel

open System
open System.Collections.Generic
open Franz
open Franz.Compression
open Franz.Internal

module Seq = 
    /// Helper function to convert a sequence to a List<T>
    let toBclList (x : 'a seq) = new List<_>(x)

type BrokerReturnedErrorException(errorCode : ErrorCode) = 
    inherit Exception()
    member __.Code = errorCode
    override e.Message = sprintf "Broker returned a response with error code: %s" (e.Code.ToString())

type RequestTimedOutRetryExceededException() = 
    inherit Exception()
    override __.Message = "Producer received RequestTimedOut on Ack from Brokers to many times"

type RequestTimedOutException() = 
    inherit Exception()
    override __.Message = "Producer received RequestTimedOut on Ack from Brokers"

type Message = 
    { Value : string
      Key : string }

type PartiontionIds = List<Id>

type NextPartitionId = Id

type TopicPartitions = Dictionary<string, PartiontionIds * NextPartitionId>

type IProducer = 
    inherit IDisposable
    abstract SendMessage : string * Message * RequiredAcks * int -> unit
    abstract SendMessage : string * Message -> unit
    abstract SendMessages : string * Message array -> unit
    abstract SendMessages : string * Message array * RequiredAcks * int -> unit

[<AbstractClass>]
type BaseProducer(brokerRouter : IBrokerRouter, compressionCodec, partitionSelector : Func<string, string, Id>) = 
    let mutable disposed = false
    
    let retryOnRequestTimedOut retrySendFunction (retryCount : int) = 
        LogConfiguration.Logger.Warning.Invoke
            (sprintf "Producer received RequestTimedOut on Ack from Brokers, retrying (%i) with increased timeout" 
                 retryCount, RequestTimedOutException())
        if retryCount > 1 then raiseWithErrorLog (RequestTimedOutRetryExceededException())
        retrySendFunction()
    
    let rec send key topicName messages requiredAcks brokerProcessingTimeout retryCount = 
        let messageSets = Compression.CompressMessages(compressionCodec, messages)
        let partitionId = partitionSelector.Invoke(topicName, key)
        
        let partitions = 
            { PartitionProduceRequest.Id = partitionId
              MessageSets = messageSets
              TotalMessageSetsSize = messageSets |> Seq.sumBy (fun x -> x.MessageSetSize) }
        
        let topic = 
            { TopicProduceRequest.Name = topicName
              Partitions = [| partitions |] }
        
        let request = new ProduceRequest(requiredAcks, brokerProcessingTimeout, [| topic |])
        let response = brokerRouter.TrySendToBroker(topicName, partitionId, request)
        
        let partitionResponse = 
            response.Topics
            |> Seq.map (fun x -> x.Partitions)
            |> Seq.concat
            |> Seq.head
        match partitionResponse.ErrorCode with
        | ErrorCode.NoError | ErrorCode.ReplicaNotAvailable -> ()
        | ErrorCode.RequestTimedOut -> 
            retryOnRequestTimedOut 
                (fun () -> send key topicName messages requiredAcks (brokerProcessingTimeout * 2) (retryCount + 1)) 
                retryCount
        | x when x.IsRetriable() ->
            LogConfiguration.Logger.Info.Invoke (sprintf "Got retriable error, '%s', while sending message..." (x.ToString()))
            brokerRouter.RefreshMetadata()
            send key topicName messages requiredAcks brokerProcessingTimeout 0
        | _ -> raiseWithErrorLog (BrokerReturnedErrorException partitionResponse.ErrorCode)
    
    let sendMessages key topic requiredAcks brokerProcessingTimeout messages = 
        let messageSets = 
            messages
            |> Seq.map 
                   (fun x -> 
                   MessageSet.Create
                       (int64 -1, int8 0, 
                        System.Text.Encoding.UTF8.GetBytes(if x.Key <> null then x.Key
                                                           else ""), System.Text.Encoding.UTF8.GetBytes(x.Value)))
            |> Seq.toArray
        try 
            let key = 
                if key <> null then key
                else ""
            send key topic messageSets requiredAcks brokerProcessingTimeout 0
        with _ -> 
            brokerRouter.RefreshMetadata()
            send key topic messageSets requiredAcks brokerProcessingTimeout 0
    
    do 
        brokerRouter.Error.Add
            (fun x -> LogConfiguration.Logger.Fatal.Invoke(sprintf "Unhandled exception in BrokerRouter", x))
        brokerRouter.Connect()
    
    /// Sends a message to the specified topic
    abstract SendMessages : string * Message array * RequiredAcks * int -> unit
    
    /// Sends a message to the specified topic
    override __.SendMessages(topic, messages, requiredAcks, brokerProcessingTimeout) = 
        let messagesGroupedByKey = messages |> Seq.groupBy (fun x -> x.Key)
        messagesGroupedByKey 
        |> Seq.iter (fun (key, msgs) -> msgs |> sendMessages key topic requiredAcks brokerProcessingTimeout)
    
    /// Get all available brokers
    member __.GetAllBrokers() = brokerRouter.GetAllBrokers()
    
    /// Releases all connections and disposes the producer
    member __.Dispose() = 
        if not disposed then 
            brokerRouter.Dispose()
            disposed <- true
    
    /// Releases all connections and disposes the producer
    interface IDisposable with
        member self.Dispose() = self.Dispose()

/// High level kafka producer
type Producer(brokerRouter : IBrokerRouter, compressionCodec : CompressionCodec, partitionSelector : Func<string, string, Id>) = 
    inherit BaseProducer(brokerRouter, compressionCodec, partitionSelector)
    new(brokerSeeds, partitionSelector : Func<string, string, Id>) = new Producer(brokerSeeds, 10000, partitionSelector)
    new(brokerSeeds, tcpTimeout : int, partitionSelector : Func<string, string, Id>) = 
        new Producer(new BrokerRouter(brokerSeeds, tcpTimeout), partitionSelector)
    new(brokerSeeds, tcpTimeout : int, compressionCodec : CompressionCodec, partitionSelector : Func<string, string, Id>) = 
        new Producer(new BrokerRouter(brokerSeeds, tcpTimeout), compressionCodec, partitionSelector)
    new(brokerRouter : IBrokerRouter, partitionSelector : Func<string, string, Id>) = 
        new Producer(brokerRouter, CompressionCodec.None, partitionSelector)
    
    /// Sends a message to the specified topic
    member self.SendMessages(topicName : string, message : Message array) = 
        self.SendMessages(topicName, message, RequiredAcks.LocalLog, 500)
    
    /// Sends a message to the specified topic
    member self.SendMessage(topicName : string, message : Message) = self.SendMessages(topicName, [| message |])
    
    /// Sends a message to the specified topic
    member self.SendMessage(topicName, message, requiredAcks, brokerProcessingTimeout) = 
        self.SendMessages(topicName, [| message |], requiredAcks, brokerProcessingTimeout)
    
    /// Releases all connections and disposes the producer
    member __.Dispose() = base.Dispose()
    
    interface IProducer with
        member self.SendMessage(topicName, message, requiredAcks, brokerProcessingTimeout) = 
            self.SendMessages(topicName, [| message |], requiredAcks, brokerProcessingTimeout)
        member self.SendMessage(topicName, message) = self.SendMessages(topicName, [| message |])
        member self.SendMessages(topicName, messages, requiredAcks, brokerProcessingTimeout) = 
            self.SendMessages(topicName, messages, requiredAcks, brokerProcessingTimeout)
        member self.SendMessages(topicName, messages) = self.SendMessages(topicName, messages)
        member self.Dispose() = self.Dispose()

/// Producer sending messages in a round-robin fashion
type RoundRobinProducer(brokerRouter : IBrokerRouter, compressionCodec : CompressionCodec, partitionWhiteList : Id array) = 
    let mutable producer = None
    let topicPartitions = new TopicPartitions()
    
    let sortTopicPartitions() = 
        topicPartitions |> Seq.iter (fun kvp -> 
                               let (ids, _) = kvp.Value
                               ids.Sort())
    
    let updateTopicPartitions (brokers : Broker seq) = 
        brokers
        |> Seq.map (fun x -> x.LeaderFor)
        |> Seq.concat
        |> Seq.map (fun x -> (x.TopicName, x.PartitionIds))
        |> Seq.iter (fun (topic, partitions) -> 
               if not <| topicPartitions.ContainsKey(topic) then 
                   topicPartitions.Add(topic, (partitions |> Seq.toBclList, 0))
               else 
                   let (ids, _) = topicPartitions.[topic]
                   
                   let partitionsToAdd = 
                       partitions |> Seq.filter (fun x -> 
                                         ids
                                         |> Seq.exists (fun i -> i = x)
                                         |> not)
                   ids.AddRange(partitionsToAdd))
        sortTopicPartitions()
    
    let getNextPartitionId topicName _ = 
        let success, result = topicPartitions.TryGetValue(topicName)
        if (not success) then 
            brokerRouter.GetBroker(topicName, 0) |> ignore
            0
        else 
            let (partitionIds, nextId) = result
            
            let filteredPartitionIds = 
                match partitionWhiteList with
                | null | [||] -> partitionIds |> Seq.toBclList
                | _ -> 
                    Set.intersect (Set.ofArray (partitionIds.ToArray())) (Set.ofArray partitionWhiteList) 
                    |> Seq.toBclList
            
            let nextId = 
                if nextId = (filteredPartitionIds |> Seq.max) then filteredPartitionIds |> Seq.min
                else filteredPartitionIds |> Seq.find (fun x -> x > nextId)
            
            topicPartitions.[topicName] <- (filteredPartitionIds, nextId)
            nextId
    
    do 
        producer <- Some 
                    <| new Producer(brokerRouter, compressionCodec, new Func<string, string, Id>(getNextPartitionId))
        brokerRouter.GetAllBrokers() |> updateTopicPartitions
        brokerRouter.MetadataRefreshed.Add(fun x -> x |> updateTopicPartitions)
    
    new(brokerSeeds) = new RoundRobinProducer(brokerSeeds, 10000)
    new(brokerSeeds, tcpTimeout : int) = new RoundRobinProducer(new BrokerRouter(brokerSeeds, tcpTimeout))
    new(brokerSeeds, tcpTimeout : int, compressionCodec : CompressionCodec) = 
        new RoundRobinProducer(new BrokerRouter(brokerSeeds, tcpTimeout), compressionCodec, null)
    new(brokerSeeds, tcpTimeout : int, compressionCodec : CompressionCodec, partitionWhiteList : Id array) = 
        new RoundRobinProducer(new BrokerRouter(brokerSeeds, tcpTimeout), compressionCodec, partitionWhiteList)
    new(brokerRouter : IBrokerRouter) = new RoundRobinProducer(brokerRouter, CompressionCodec.None, null)
    
    /// Releases all connections and disposes the producer
    member __.Dispose() = (producer.Value :> IDisposable).Dispose()
    
    /// Sends a message to the specified topic
    member __.SendMessages(topicName, message) = 
        producer.Value.SendMessages(topicName, message, RequiredAcks.LocalLog, 500)
    
    /// Sends a message to the specified topic
    member __.SendMessages(topicName, messages : Message array, requiredAcks, brokerProcessingTimeout) = 
        producer.Value.SendMessages(topicName, messages, requiredAcks, brokerProcessingTimeout)
    
    /// Sends a message to the specified topic
    member self.SendMessage(topicName : string, message : Message) = self.SendMessages(topicName, [| message |])
    
    interface IProducer with
        member self.SendMessage(topicName, message, requiredAcks, brokerProcessingTimeout) = 
            self.SendMessages(topicName, [| message |], requiredAcks, brokerProcessingTimeout)
        member self.SendMessage(topicName, message) = self.SendMessages(topicName, [| message |])
        member self.SendMessages(topicName, messages, requiredAcks, brokerProcessingTimeout) = 
            self.SendMessages(topicName, messages, requiredAcks, brokerProcessingTimeout)
        member self.SendMessages(topicName, messages) = self.SendMessages(topicName, messages)
        member self.Dispose() = self.Dispose()