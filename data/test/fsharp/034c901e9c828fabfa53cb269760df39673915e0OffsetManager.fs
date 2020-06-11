namespace Franz.HighLevel

open System
open System.Collections.Concurrent
open System.Threading
open Franz
open Franz.Internal

/// Information about offsets
[<StructuredFormatDisplay("Id: {PartitionId}, Offset: {Offset}, Metadata: {Metadata}")>]
type PartitionOffset = 
    { PartitionId : Id
      Offset : Offset
      Metadata : string }

type ErrorCommittingOffsetException(offsetManagerName : string, topic : string, consumerGroup : string, errorCodes : seq<string>) = 
    inherit Exception()
    member __.Codes = errorCodes
    member __.OffsetManagerName = offsetManagerName
    member __.Topic = topic
    member __.ConsumerGroup = consumerGroup
    override e.Message = 
        sprintf "One or more errors occoured while committing offsets (%s) for topic '%s' group '%s': %A" 
            e.OffsetManagerName e.Topic e.ConsumerGroup e.Codes

/// Event raised when offsets are committed
type OffsetsCommittedEventArgs(consumerGroup : string, topic : string, partitionOffsets : PartitionOffset array) = 
    inherit EventArgs()
    
    /// The consumer grop
    member __.ConsumerGroup = consumerGroup
    
    /// The topic
    member __.Topic = topic
    
    /// The partitions and their offset
    member __.PartitionOffsets = partitionOffsets

/// Interface for offset managers
type IConsumerOffsetManager = 
    inherit IDisposable
    
    /// Fetch offset for the specified topic and partitions
    abstract Fetch : string -> PartitionOffset array
    
    /// Commit offset for the specified topic and partitions
    abstract Commit : string * PartitionOffset seq -> unit
    
    /// Event raised when offsets are committed
    [<CLIEvent>]
    abstract OnOffsetsCommitted : IEvent<OffsetsCommittedEventArgs>

/// Offset manager for version 0. This commits and fetches offset to/from Zookeeper instances.
type ConsumerOffsetManagerV0(topicName, brokerRouter : IBrokerRouter) = 
    let mutable disposed = false
    let onOffsetsCommitted = new Event<OffsetsCommittedEventArgs>()
    
    let refreshMetadataOnException f = 
        try 
            f()
        with _ -> 
            brokerRouter.RefreshMetadata()
            f()
    
    let innerFetch consumerGroup = 
        let broker = brokerRouter.GetAllBrokers() |> Seq.head
        let partitions = brokerRouter.GetAvailablePartitionIds(topicName)
        
        let request = 
            new OffsetFetchRequest(consumerGroup, 
                                   [| { OffsetFetchRequestTopic.Name = topicName
                                        Partitions = partitions } |], int16 0)
        
        let response = broker.Send(request)
        
        let offsets = 
            response.Topics
            |> Seq.filter (fun x -> x.Name = topicName)
            |> Seq.collect (fun x -> x.Partitions)
            |> Seq.filter (fun x -> x.ErrorCode.IsSuccess())
            |> Seq.map (fun x -> 
                   { PartitionId = x.Id
                     Metadata = x.Metadata
                     Offset = x.Offset })
            |> Seq.toArray
        LogConfiguration.Logger.Info.Invoke
            (sprintf "Offsets fetched from Zookeeper, topic '%s', group '%s': %A" topicName consumerGroup offsets)
        offsets
    
    let handleOffsetCommitResponseCodes (offsetCommitResponse : OffsetCommitResponse) (offsets : seq<PartitionOffset>) 
        (consumerGroup : string) (managerName : string) = 
        let errorCodes = 
            offsetCommitResponse.Topics 
            |> Seq.collect 
                (fun t -> 
                    t.Partitions
                    |> Seq.filter (fun p -> p.ErrorCode <> ErrorCode.NoError)
                    |> Seq.map 
                        (fun p -> 
                            sprintf "Topic: %s Partition: %i ErrorCode: %s" t.Name p.Id (p.ErrorCode.ToString())))
        
        let topic = 
            match offsetCommitResponse.Topics |> Seq.tryHead with
            | Some x -> x.Name
            | None -> "Could not get topic name"
        
        match Seq.isEmpty errorCodes with
        | false -> raiseWithErrorLog (ErrorCommittingOffsetException(managerName, topic, consumerGroup, errorCodes))
        | true -> 
            onOffsetsCommitted.Trigger(new OffsetsCommittedEventArgs(consumerGroup, topic, offsets |> Seq.toArray))
            LogConfiguration.Logger.Info.Invoke
                (sprintf "Offsets committed to %s, topic '%s', group '%s': %A" managerName topic consumerGroup offsets)
    
    let innerCommit offsets consumerGroup = 
        if offsets |> Seq.isEmpty then ()
        let broker = brokerRouter.GetAllBrokers() |> Seq.head
        
        let partitions = 
            offsets
            |> Seq.map (fun x -> 
                   { OffsetCommitRequestV0Partition.Id = x.PartitionId
                     Metadata = x.Metadata
                     Offset = x.Offset })
            |> Seq.toArray
        
        let request = 
            new OffsetCommitV0Request(consumerGroup, 
                                      [| { OffsetCommitRequestV0Topic.Name = topicName
                                           Partitions = partitions } |])
        
        let response = broker.Send(request)
        handleOffsetCommitResponseCodes response offsets consumerGroup "Zookeeper"
    
    do brokerRouter.Connect()
    new(brokerSeeds, topicName, tcpTimeout) = 
        new ConsumerOffsetManagerV0(topicName, new BrokerRouter(brokerSeeds, tcpTimeout))
    
    member __.Dispose() = 
        if not disposed then 
            brokerRouter.Dispose()
            disposed <- true
    
    /// Fetch offset for the specified topic and partitions
    member __.Fetch(consumerGroup) = 
        raiseIfDisposed (disposed)
        refreshMetadataOnException (fun () -> innerFetch consumerGroup)
    
    /// Commit offset for the specified topic and partitions
    member __.Commit(consumerGroup, offsets) = 
        raiseIfDisposed (disposed)
        refreshMetadataOnException (fun () -> innerCommit offsets consumerGroup)
    
    /// Event raised when offsets are committed
    [<CLIEvent>]
    member __.OnOffsetsCommitted = onOffsetsCommitted.Publish
    
    interface IConsumerOffsetManager with
        
        /// Fetch offset for the specified topic and partitions
        member self.Fetch(consumerGroup) = self.Fetch(consumerGroup)
        
        /// Commit offset for the specified topic and partitions
        member self.Commit(consumerGroup, offsets) = self.Commit(consumerGroup, offsets)
        
        member self.Dispose() = self.Dispose()
        [<CLIEvent>]
        member self.OnOffsetsCommitted = self.OnOffsetsCommitted

module internal ErrorHelper = 
    let inline (|HasError|) errorCode (x : ^a seq) = 
        x
        |> Seq.map (fun x -> (^a : (member ErrorCode : ErrorCode) (x)))
        |> Seq.contains errorCode

/// Offset manager for version 1. This commits and fetches offset to/from Kafka broker.
type ConsumerOffsetManagerV1(topicName, brokerRouter : IBrokerRouter) = 
    let mutable disposed = false
    let onOffsetsCommitted = new Event<OffsetsCommittedEventArgs>()
    let coordinatorDictionary = new ConcurrentDictionary<string, Broker>()
    
    let refreshMetadataOnException f = 
        try 
            f()
        with _ -> 
            brokerRouter.RefreshMetadata()
            f()
    
    let send consumerGroup = 
        let allBrokers = brokerRouter.GetAllBrokers()
        let broker = allBrokers |> Seq.head
        let request = new ConsumerMetadataRequest(consumerGroup)
        let response = broker.Send(request)
        allBrokers
        |> Seq.filter (fun x -> x.Id = response.CoordinatorId)
        |> Seq.exactlyOne
    
    let getOffsetCoordinator consumerGroup = refreshMetadataOnException (fun () -> send consumerGroup)
    
    let rec innerFetch consumerGroup = 
        let coordinator = coordinatorDictionary.GetOrAdd(consumerGroup, getOffsetCoordinator)
        let partitions = brokerRouter.GetAvailablePartitionIds(topicName)
        
        let request = 
            new OffsetFetchRequest(consumerGroup, 
                                   [| { OffsetFetchRequestTopic.Name = topicName
                                        Partitions = partitions } |], int16 1)
        
        let response = coordinator.Send(request)
        
        let partitions = 
            response.Topics
            |> Seq.filter (fun x -> x.Name = topicName)
            |> Seq.collect (fun x -> x.Partitions)
            |> Seq.toArray
        match partitions with
        | ErrorHelper.HasError ErrorCode.ConsumerCoordinatorNotAvailable true | ErrorHelper.HasError ErrorCode.GroupLoadInProgressCode 
                                                                                true -> innerFetch consumerGroup
        | ErrorHelper.HasError ErrorCode.NotCoordinatorForConsumer true -> 
            coordinatorDictionary.TryUpdate(consumerGroup, getOffsetCoordinator consumerGroup, coordinator) |> ignore
            innerFetch consumerGroup
        | _ -> 
            let offsets = 
                partitions
                |> Seq.filter (fun x -> x.ErrorCode.IsSuccess())
                |> Seq.map (fun x -> 
                       { PartitionId = x.Id
                         Metadata = ""
                         Offset = x.Offset })
                |> Seq.toArray
            LogConfiguration.Logger.Info.Invoke
                (sprintf "Offsets fetched from Kafka, topic '%s', group '%s': %A" topicName consumerGroup offsets)
            offsets
    
    let handleOffsetCommitResponseCodes (offsetCommitResponse : OffsetCommitResponse) (offsets : seq<PartitionOffset>) 
        (consumerGroup : string) (managerName : string) = 
        let errorCodes = 
            offsetCommitResponse.Topics 
            |> Seq.collect 
                (fun t -> 
                    t.Partitions
                    |> Seq.filter (fun p -> p.ErrorCode <> ErrorCode.NoError)
                    |> Seq.map 
                        (fun p -> 
                            sprintf "Topic: %s Partition: %i ErrorCode: %s" t.Name p.Id (p.ErrorCode.ToString())))
        
        let topic = (offsetCommitResponse.Topics |> Seq.head).Name
        match Seq.isEmpty errorCodes with
        | false -> raiseWithErrorLog (ErrorCommittingOffsetException(managerName, topic, consumerGroup, errorCodes))
        | true -> 
            onOffsetsCommitted.Trigger(new OffsetsCommittedEventArgs(consumerGroup, topic, offsets |> Seq.toArray))
            LogConfiguration.Logger.Info.Invoke
                (sprintf "Offsets committed to %s, topic '%s', group '%s': %A" managerName topic consumerGroup offsets)
    
    let rec innerCommit consumerGroup offsets = 
        let coordinator = coordinatorDictionary.GetOrAdd(consumerGroup, getOffsetCoordinator)
        
        let partitions = 
            offsets
            |> Seq.map (fun x -> 
                   { OffsetCommitRequestV1Partition.Id = x.PartitionId
                     Metadata = ""
                     Offset = x.Offset
                     TimeStamp = DefaultTimestamp })
            |> Seq.toArray
        
        let request = 
            new OffsetCommitV1Request(consumerGroup, DefaultGenerationId, "", 
                                      [| { OffsetCommitRequestV1Topic.Name = topicName
                                           Partitions = partitions } |])
        
        let response = coordinator.Send(request)
        
        let partitions = 
            response.Topics
            |> Seq.filter (fun x -> x.Name = topicName)
            |> Seq.collect (fun x -> x.Partitions)
            |> Seq.toArray
        match partitions with
        | ErrorHelper.HasError ErrorCode.ConsumerCoordinatorNotAvailable true | ErrorHelper.HasError ErrorCode.GroupLoadInProgressCode 
                                                                                true -> 
            innerCommit consumerGroup offsets
        | ErrorHelper.HasError ErrorCode.NotCoordinatorForConsumer true -> 
            coordinatorDictionary.TryUpdate(consumerGroup, getOffsetCoordinator consumerGroup, coordinator) |> ignore
            innerCommit consumerGroup offsets
        | _ -> handleOffsetCommitResponseCodes response offsets consumerGroup "Kafka"
    
    do brokerRouter.Connect()
    new(brokerSeeds, topicName, tcpTimeout) = 
        new ConsumerOffsetManagerV1(topicName, new BrokerRouter(brokerSeeds, tcpTimeout))
    
    member __.Dispose() = 
        if not disposed then 
            brokerRouter.Dispose()
            disposed <- true
    
    /// Fetch offset for the specified topic and partitions
    member __.Fetch(consumerGroup) = 
        raiseIfDisposed (disposed)
        refreshMetadataOnException (fun () -> innerFetch consumerGroup)
    
    /// Commit offset for the specified topic and partitions
    member __.Commit(consumerGroup, offsets) = 
        raiseIfDisposed (disposed)
        refreshMetadataOnException (fun () -> innerCommit consumerGroup offsets)
    
    /// Event raised when offsets are committed
    [<CLIEvent>]
    member __.OnOffsetsCommitted = onOffsetsCommitted.Publish
    
    interface IConsumerOffsetManager with
        
        /// Fetch offset for the specified topic and partitions
        member self.Fetch(consumerGroup) = self.Fetch(consumerGroup)
        
        /// Commit offset for the specified topic and partitions
        member self.Commit(consumerGroup, offsets) = self.Commit(consumerGroup, offsets)
        
        member self.Dispose() = self.Dispose()
        [<CLIEvent>]
        member self.OnOffsetsCommitted = self.OnOffsetsCommitted

/// Offset manager for version 2. This commits and fetches offset to/from Kafka broker.
type ConsumerOffsetManagerV2(topicName, brokerRouter : IBrokerRouter) = 
    let mutable disposed = false
    let onOffsetsCommitted = new Event<OffsetsCommittedEventArgs>()
    let coordinatorDictionary = new ConcurrentDictionary<string, Broker>()
    
    let refreshMetadataOnException f = 
        try 
            f()
        with _ -> 
            brokerRouter.RefreshMetadata()
            f()
    
    let send consumerGroup = 
        let allBrokers = brokerRouter.GetAllBrokers()
        let broker = allBrokers |> Seq.head
        let request = new ConsumerMetadataRequest(consumerGroup)
        let response = broker.Send(request)
        allBrokers
        |> Seq.filter (fun x -> x.Id = response.CoordinatorId)
        |> Seq.exactlyOne
    
    let getOffsetCoordinator consumerGroup = refreshMetadataOnException (fun () -> send consumerGroup)
    
    let rec innerFetch consumerGroup = 
        let coordinator = coordinatorDictionary.GetOrAdd(consumerGroup, getOffsetCoordinator)
        let partitions = brokerRouter.GetAvailablePartitionIds(topicName)
        
        let request = 
            new OffsetFetchRequest(consumerGroup, 
                                   [| { OffsetFetchRequestTopic.Name = topicName
                                        Partitions = partitions } |], int16 1)
        
        let response = coordinator.Send(request)
        
        let partitions = 
            response.Topics
            |> Seq.filter (fun x -> x.Name = topicName)
            |> Seq.collect (fun x -> x.Partitions)
            |> Seq.toArray
        match partitions with
        | ErrorHelper.HasError ErrorCode.ConsumerCoordinatorNotAvailable true | ErrorHelper.HasError ErrorCode.GroupLoadInProgressCode 
                                                                                true -> innerFetch consumerGroup
        | ErrorHelper.HasError ErrorCode.NotCoordinatorForConsumer true -> 
            coordinatorDictionary.TryUpdate(consumerGroup, getOffsetCoordinator consumerGroup, coordinator) |> ignore
            innerFetch consumerGroup
        | _ -> 
            let offsets = 
                partitions
                |> Seq.filter (fun x -> x.ErrorCode.IsSuccess())
                |> Seq.map (fun x -> 
                       { PartitionId = x.Id
                         Metadata = ""
                         Offset = x.Offset })
                |> Seq.toArray
            LogConfiguration.Logger.Info.Invoke
                (sprintf "Offsets fetched from KafkaV2, topic '%s', group '%s': %A" topicName consumerGroup offsets)
            offsets
    
    let handleOffsetCommitResponseCodes (offsetCommitResponse : OffsetCommitResponse) (offsets : seq<PartitionOffset>) 
        (consumerGroup : string) (managerName : string) = 
        let errorCodes = 
            offsetCommitResponse.Topics 
            |> Seq.collect 
                (fun t -> 
                    t.Partitions
                    |> Seq.filter (fun p -> p.ErrorCode <> ErrorCode.NoError)
                    |> Seq.map 
                        (fun p -> 
                        sprintf "Topic: %s Partition: %i ErrorCode: %s" t.Name p.Id (p.ErrorCode.ToString())))
        
        let topic = (offsetCommitResponse.Topics |> Seq.head).Name
        match Seq.isEmpty errorCodes with
        | false -> raiseWithErrorLog (ErrorCommittingOffsetException(managerName, topic, consumerGroup, errorCodes))
        | true -> 
            onOffsetsCommitted.Trigger(new OffsetsCommittedEventArgs(consumerGroup, topic, offsets |> Seq.toArray))
            LogConfiguration.Logger.Info.Invoke
                (sprintf "Offsets committed to %s, topic '%s', group '%s': %A" managerName topic consumerGroup offsets)
    
    let rec innerCommit consumerGroup offsets = 
        let coordinator = coordinatorDictionary.GetOrAdd(consumerGroup, getOffsetCoordinator)
        
        let partitions = 
            offsets
            |> Seq.map (fun x -> 
                   { OffsetCommitRequestV0Partition.Id = x.PartitionId
                     Metadata = ""
                     Offset = x.Offset })
            |> Seq.toArray
        
        let request = 
            new OffsetCommitV2Request(consumerGroup, DefaultGenerationId, "", DefaultRetentionTime, 
                                      [| { OffsetCommitRequestV0Topic.Name = topicName
                                           Partitions = partitions } |])
        
        let response = coordinator.Send(request)
        
        let partitions = 
            response.Topics
            |> Seq.filter (fun x -> x.Name = topicName)
            |> Seq.collect (fun x -> x.Partitions)
            |> Seq.toArray
        match partitions with
        | ErrorHelper.HasError ErrorCode.ConsumerCoordinatorNotAvailable true | ErrorHelper.HasError ErrorCode.GroupLoadInProgressCode 
                                                                                true -> 
            innerCommit consumerGroup offsets
        | ErrorHelper.HasError ErrorCode.NotCoordinatorForConsumer true -> 
            coordinatorDictionary.TryUpdate(consumerGroup, getOffsetCoordinator consumerGroup, coordinator) |> ignore
            innerCommit consumerGroup offsets
        | _ -> handleOffsetCommitResponseCodes response offsets consumerGroup "KafkaV2"
    
    do brokerRouter.Connect()
    new(brokerSeeds, topicName, tcpTimeout) = 
        new ConsumerOffsetManagerV2(topicName, new BrokerRouter(brokerSeeds, tcpTimeout))
    
    member __.Dispose() = 
        if not disposed then 
            brokerRouter.Dispose()
            disposed <- true
    
    /// Fetch offset for the specified topic and partitions
    member __.Fetch(consumerGroup) = 
        raiseIfDisposed (disposed)
        refreshMetadataOnException (fun () -> innerFetch consumerGroup)
    
    /// Commit offset for the specified topic and partitions
    member __.Commit(consumerGroup, offsets) = 
        raiseIfDisposed (disposed)
        refreshMetadataOnException (fun () -> innerCommit consumerGroup offsets)
    
    /// Event raised when offsets are committed
    [<CLIEvent>]
    member __.OnOffsetsCommitted = onOffsetsCommitted.Publish
    
    interface IConsumerOffsetManager with
        
        /// Fetch offset for the specified topic and partitions
        member self.Fetch(consumerGroup) = self.Fetch(consumerGroup)
        
        /// Commit offset for the specified topic and partitions
        member self.Commit(consumerGroup, offsets) = self.Commit(consumerGroup, offsets)
        
        member self.Dispose() = self.Dispose()
        [<CLIEvent>]
        member self.OnOffsetsCommitted = self.OnOffsetsCommitted

/// Offset manager commiting offfsets to both Zookeeper and Kafka, but only fetches from Zookeeper. Used when migrating from Zookeeper to Kafka.
type ConsumerOffsetManagerDualCommit(topicName, brokerRouter : IBrokerRouter) = 
    let mutable disposed = false
    let onOffsetsCommitted = new Event<OffsetsCommittedEventArgs>()
    let consumerOffsetManagerV0 = new ConsumerOffsetManagerV0(topicName, brokerRouter) :> IConsumerOffsetManager
    let consumerOffsetManagerV1 = new ConsumerOffsetManagerV1(topicName, brokerRouter) :> IConsumerOffsetManager
    new(brokerSeeds, topicName, tcpTimeout : int) = 
        new ConsumerOffsetManagerDualCommit(topicName, new BrokerRouter(brokerSeeds, tcpTimeout))
    
    /// Fetch offset for the specified topic and partitions
    member __.Fetch(consumerGroup) = 
        raiseIfDisposed (disposed)
        consumerOffsetManagerV0.Fetch(consumerGroup)
    
    /// Commit offset for the specified topic and partitions
    member __.Commit(consumerGroup, offsets) = 
        raiseIfDisposed (disposed)
        let bothOffsetsCommitted = new CountdownEvent(2)
        use v0OffsetsCommitted = consumerOffsetManagerV0.OnOffsetsCommitted.Subscribe(fun _ -> bothOffsetsCommitted.Signal() |> ignore)
        use v1OffsetsCommitted = consumerOffsetManagerV1.OnOffsetsCommitted.Subscribe(fun _ -> bothOffsetsCommitted.Signal() |> ignore)
        consumerOffsetManagerV0.Commit(consumerGroup, offsets)
        consumerOffsetManagerV1.Commit(consumerGroup, offsets)
        if bothOffsetsCommitted.IsSet then
            onOffsetsCommitted.Trigger(new OffsetsCommittedEventArgs(consumerGroup, topicName, offsets |> Seq.toArray))
    
    member __.Dispose() = 
        if not disposed then 
            consumerOffsetManagerV0.Dispose()
            consumerOffsetManagerV1.Dispose()
            disposed <- true
    
    /// Event raised when offsets are committed
    [<CLIEvent>]
    member __.OnOffsetsCommitted = onOffsetsCommitted.Publish
    
    interface IConsumerOffsetManager with
        
        /// Fetch offset for the specified topic and partitions
        member self.Fetch(consumerGroup) = self.Fetch(consumerGroup)
        
        /// Commit offset for the specified topic and partitions
        member self.Commit(consumerGroup, offsets) = self.Commit(consumerGroup, offsets)
        
        member self.Dispose() = self.Dispose()
        [<CLIEvent>]
        member self.OnOffsetsCommitted = self.OnOffsetsCommitted

/// Noop offsetmanager, used when no offset should be commit
type DisabledConsumerOffsetManager() = 
    let onOffsetsCommitted = new Event<OffsetsCommittedEventArgs>()
    interface IConsumerOffsetManager with
        
        /// Fetch offset for the specified topic and partitions
        member __.Fetch(_) = [||]
        
        /// Commit offset for the specified topic and partitions
        member __.Commit(_, _) = ()
        
        member __.Dispose() = ()
        [<CLIEvent>]
        member __.OnOffsetsCommitted = onOffsetsCommitted.Publish
