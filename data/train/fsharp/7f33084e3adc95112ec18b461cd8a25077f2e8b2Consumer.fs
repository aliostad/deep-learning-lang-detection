namespace Franz.HighLevel

#nowarn "40"

open System
open System.Collections.Generic
open Franz
open System.Collections.Concurrent
open Franz.Compression
open Franz.Internal
open System.Threading

type ConsumerException(msg, innerException : exn) = 
    inherit Exception(msg, innerException)

/// A message with offset and partition id
[<NoEquality; NoComparison>]
type MessageWithMetadata = 
    { /// The offset of the message
      Offset : Offset
      /// The message
      Message : Messages.Message
      /// The partition id
      PartitionId : Id }

type IConsumer = 
    inherit IDisposable
    
    /// Consume messages
    abstract Consume : System.Threading.CancellationToken -> IEnumerable<MessageWithMetadata>
    
    /// Get the current consumer position
    abstract GetPosition : unit -> HighLevel.PartitionOffset array
    
    /// Set the current consumer position
    abstract SetPosition : HighLevel.PartitionOffset seq -> unit
    
    /// Gets the offset manager
    abstract OffsetManager : IConsumerOffsetManager
    
    /// Gets the broker router
    abstract BrokerRouter : IBrokerRouter

/// Offset storage type
type OffsetStorage = 
    /// Do not use any offset storage
    | None = 0
    /// Store offsets on the Zookeeper
    | Zookeeper = 1
    /// Store offsets on the Kafka brokers, using version 1
    | Kafka = 2
    /// Store offsets both on the Zookeeper and Kafka brokers
    | DualCommit = 3
    /// Store offsets on the Kafka brokers, using version 2
    | KafkaV2 = 4

/// Consumer options
type ConsumerOptions() = 
    let mutable partitionWhitelist = [||]
    let mutable offsetManager = OffsetStorage.Zookeeper
    abstract TcpTimeout : int with get, set
    
    /// The timeout for sending and receiving TCP data in milliseconds. Default value is 10000.
    override val TcpTimeout = 10000 with get, set
    
    /// The max wait time is the maximum amount of time in milliseconds to block waiting if insufficient data is available at the time the request is issued. Default value is 5000.
    member val MaxWaitTime = 5000 with get, set
    
    /// This is the minimum number of bytes of messages that must be available to give a response. If the client sets this to 0 the server will always respond immediately,
    /// however if there is no new data since their last request they will just get back empty message sets. If this is set to 1, the server will respond as soon as at least one partition has
    // at least 1 byte of data or the specified timeout occurs. By setting higher values in combination with the timeout the consumer can tune for throughput and trade a little additional latency for
    /// reading only large chunks of data (e.g. setting MaxWaitTime to 100 ms and setting MinBytes to 64k would allow the server to wait up to 100ms to try to accumulate 64k of data before responding).
    /// Default value is 1024.
    member val MinBytes = 1024 with get, set
    
    /// The maximum bytes to include in the message set for a partition. This helps bound the size of the response. Default value is 5120.
    member val MaxBytes = 1024 * 5 with get, set
    
    /// Indicates how offsets should be stored
    member val OffsetStorage = offsetManager with get, set
    
    /// The number of milliseconds to wait before retrying, when the connection is lost during consuming. The default values is 5000.
    member val ConnectionRetryInterval = 5000 with get, set

    /// The backoff in ms, used when getting a retriable error. The default value is 1000.
    member val ErrorRetryBackoff = 1000 with get, set

    /// The maximum number of times to retry on retriable errors. 0 means infinite retries, which is the default.
    member val MaximumNumberOfRetriesOnErrors = 0 with get, set
    
    /// The partitions to consume messages from
    member __.PartitionWhitelist 
        with get () = partitionWhitelist
        and set x = 
            if x |> isNull then partitionWhitelist <- [||]
            else partitionWhitelist <- x
    
    /// Gets or sets the consumer topic
    member val Topic = "" with get, set

    /// Gets or sets the Kafka version. This is used to determine what version of the protocol to use. The default version is V0.9
    member val KafkaVersion = KafkaVersion.V0_9

/// Base class for consumers, containing shared functionality
[<AbstractClass>]
type BaseConsumer(brokerRouter : IBrokerRouter, consumerOptions : ConsumerOptions) = 
    let mutable disposed = false
    
    let offsetManager = 
        match consumerOptions.OffsetStorage with
        | OffsetStorage.Zookeeper -> 
            (new ConsumerOffsetManagerV0(consumerOptions.Topic, brokerRouter)) :> IConsumerOffsetManager
        | OffsetStorage.Kafka -> 
            if consumerOptions.KafkaVersion |> int < 2 then invalidOp "Cannot save offsets on Kafka versions prior to 0.8.2"
            (new ConsumerOffsetManagerV1(consumerOptions.Topic, brokerRouter)) :> IConsumerOffsetManager
        | OffsetStorage.KafkaV2 -> 
            if consumerOptions.KafkaVersion |> int < 3 then invalidOp "Cannot use KafkaV2 offset storage on Kafka versions prior to 0.9"
            (new ConsumerOffsetManagerV2(consumerOptions.Topic, brokerRouter)) :> IConsumerOffsetManager
        | OffsetStorage.DualCommit -> 
            if consumerOptions.KafkaVersion |> int < 2 then invalidOp "Cannot save offsets on Kafka versions prior to 0.8.2"
            (new ConsumerOffsetManagerDualCommit(consumerOptions.Topic, brokerRouter)) :> IConsumerOffsetManager
        | _ -> (new DisabledConsumerOffsetManager()) :> IConsumerOffsetManager
    
    let partitionOffsets = new ConcurrentDictionary<Id, Offset>()
    
    let updateTopicPartitions (brokers : Broker seq) = 
        brokers
        |> Seq.collect (fun x -> x.LeaderFor)
        |> Seq.filter (fun x -> x.TopicName = consumerOptions.Topic)
        |> Seq.collect
               (fun x -> 
               match consumerOptions.PartitionWhitelist with
               | [||] -> x.PartitionIds
               | _ -> 
                   Set.intersect (Set.ofArray x.PartitionIds) (Set.ofArray consumerOptions.PartitionWhitelist) 
                   |> Set.toArray)
        |> Seq.iter 
               (fun id -> 
               partitionOffsets.AddOrUpdate(id, new Func<Id, Offset>(fun _ -> int64 0), fun _ value -> value) |> ignore)
    
    let handleOffsetOutOfRangeError (broker : Broker) (partitionId : Id) (topicName : string) = 
        let request = 
            new OffsetRequest(-1, 
                              [| { Name = topicName
                                   Partitions = 
                                       [| { Id = partitionId
                                            MaxNumberOfOffsets = 1
                                            Time = int64 -2 } |] } |])
        
        let response = broker.Send(request)
        response.Topics
        |> Seq.filter (fun x -> x.Name = topicName)
        |> Seq.collect (fun x -> x.Partitions)
        |> Seq.filter (fun x -> x.Id = partitionId && x.ErrorCode.IsSuccess())
        |> Seq.collect (fun x -> x.Offsets)
        |> Seq.min
    
    let getThePartitionOffsetsWeWantToAddOrUpdate (offsets : HighLevel.PartitionOffset seq) = 
        match (Seq.isEmpty consumerOptions.PartitionWhitelist) with
        | true -> offsets
        | false -> 
            offsets 
            |> Seq.filter (fun x -> consumerOptions.PartitionWhitelist |> Seq.exists (fun y -> y = x.PartitionId))
    
    do 
        brokerRouter.Error.Add
            (fun x -> LogConfiguration.Logger.Fatal.Invoke(sprintf "Unhandled exception in BrokerRouter", x))
        brokerRouter.Connect()
        brokerRouter.GetAllBrokers() |> updateTopicPartitions
        brokerRouter.MetadataRefreshed.Add(fun x -> x |> updateTopicPartitions)
    
    /// Gets the broker router
    member __.BrokerRouter = brokerRouter
    
    /// The position of the consumer
    abstract PartitionOffsets : ConcurrentDictionary<Id, Offset>
    
    /// Consume messages from the topic specified in the consumer. This function returns a sequence of messages, the size is defined by the chunk size.
    /// Multiple calls to this method consumes the next chunk of messages.
    abstract ConsumeInChunks : Id * int option -> Async<seq<MessageWithMetadata>>
    
    /// Get the current consumer offsets
    abstract GetPosition : unit -> HighLevel.PartitionOffset array
    
    /// Sets the current consumer offsets
    abstract SetPosition : HighLevel.PartitionOffset seq -> unit
    
    /// Gets the offset manager
    abstract OffsetManager : IConsumerOffsetManager
    
    /// Gets the offset manager
    override __.OffsetManager = offsetManager
    
    /// The position of the consumer
    override __.PartitionOffsets = partitionOffsets
    
    /// Get the current consumer offsets
    override __.GetPosition() = 
        partitionOffsets
        |> Seq.map (fun x -> 
               { PartitionId = x.Key
                 Offset = x.Value
                 Metadata = String.Empty })
        |> Seq.toArray
    
    /// Sets the current consumer offsets
    override __.SetPosition(offsets : HighLevel.PartitionOffset seq) = 
        offsets
        |> getThePartitionOffsetsWeWantToAddOrUpdate
        |> Seq.iter 
               (fun x -> 
               partitionOffsets.AddOrUpdate(x.PartitionId, new Func<Id, Offset>(fun _ -> x.Offset), fun _ _ -> x.Offset) 
               |> ignore)
    
    /// Consume messages from the topic specified in the consumer. This function returns a sequence of messages, the size is defined by the chunk size.
    /// Multiple calls to this method consumes the next chunk of messages.
    override self.ConsumeInChunks(partitionId, maxBytes : int option) = 
        let rec consume numberOfRetries =
            async { 
                try 
                    let (_, offset) = partitionOffsets.TryGetValue(partitionId)
                
                    let request = 
                        new FetchRequest(-1, consumerOptions.MaxWaitTime, consumerOptions.MinBytes, 
                                         [| { Name = consumerOptions.Topic
                                              Partitions = 
                                                  [| { FetchOffset = offset
                                                       Id = partitionId
                                                       MaxBytes = defaultArg maxBytes consumerOptions.MaxBytes } |] } |])
                
                    let response = brokerRouter.TrySendToBroker(consumerOptions.Topic, partitionId, request)
                
                    let partitionResponse = 
                        response.Topics
                        |> Seq.collect (fun x -> x.Partitions)
                        |> Seq.head
                    match partitionResponse.ErrorCode with
                    | ErrorCode.NoError | ErrorCode.ReplicaNotAvailable -> 
                        let messages = 
                            partitionResponse.MessageSets
                            |> Compression.DecompressMessageSets
                            |> Seq.map (fun x -> 
                                   { Message = x.Message
                                     Offset = x.Offset
                                     PartitionId = partitionId })
                        if partitionResponse.MessageSets
                           |> Seq.isEmpty
                           |> not
                        then 
                            let nextOffset = 
                                (partitionResponse.MessageSets
                                 |> Seq.map (fun x -> x.Offset)
                                 |> Seq.max)
                                + int64 1
                            partitionOffsets.AddOrUpdate
                                (partitionId, new Func<Id, Offset>(fun _ -> nextOffset), fun _ _ -> nextOffset) |> ignore
                        return messages
                    | ErrorCode.OffsetOutOfRange -> 
                        let broker = brokerRouter.GetBroker(consumerOptions.Topic, partitionId)
                        let earliestOffset = handleOffsetOutOfRangeError broker partitionId consumerOptions.Topic
                        partitionOffsets.AddOrUpdate
                            (partitionId, new Func<Id, Offset>(fun _ -> earliestOffset), fun _ _ -> earliestOffset) 
                        |> ignore
                        return! self.ConsumeInChunks(partitionId, maxBytes)
                    | x when x.IsRetriable() && numberOfRetries <= consumerOptions.MaximumNumberOfRetriesOnErrors -> 
                        LogConfiguration.Logger.Info.Invoke(sprintf "Got retriable error '%s'. Retrying in %i ms" (x.ToString()) consumerOptions.ErrorRetryBackoff)
                        do! Async.Sleep consumerOptions.ErrorRetryBackoff
                        brokerRouter.RefreshMetadata()
                        return! consume (numberOfRetries + 1)
                    | _ -> 
                        if numberOfRetries > consumerOptions.MaximumNumberOfRetriesOnErrors then
                            LogConfiguration.Logger.Info.Invoke "Maxmimum number of retries exceeded"
                        raise (BrokerReturnedErrorException partitionResponse.ErrorCode)
                        return Seq.empty<_>
                with
                | :? BufferOverflowException -> 
                    let increasedFetchSize = (defaultArg maxBytes consumerOptions.MaxBytes) * 2
                    LogConfiguration.Logger.Info.Invoke
                        (sprintf "Temporarily increasing fetch size to %i to accommodate increased message size." 
                             increasedFetchSize)
                    return! self.ConsumeInChunks(partitionId, Some increasedFetchSize)
                | e -> 
                    LogConfiguration.Logger.Error.Invoke
                        (sprintf "Got exception while consuming from topic '%s' partition '%i'" 
                             consumerOptions.Topic partitionId, e)
                    return Seq.empty<_>
            }
        consume 0
    
    /// Dispose the consumer
    member __.Dispose() = 
        if not disposed then 
            offsetManager.Dispose()
            brokerRouter.Dispose()
            disposed <- true
    
    member internal __.CheckDisposedState() = raiseIfDisposed (disposed)
    member internal __.ClearPositions() = partitionOffsets.Clear()
    interface IDisposable with
        member self.Dispose() = self.Dispose()

/// High level kafka consumer.
type Consumer(brokerRouter : IBrokerRouter, consumerOptions : ConsumerOptions) = 
    inherit BaseConsumer(brokerRouter, consumerOptions)
    new(brokerSeeds, consumerOptions : ConsumerOptions) = 
        new Consumer(new BrokerRouter(brokerSeeds, consumerOptions.TcpTimeout), consumerOptions)
    
    /// Consume messages from the topic specified in the consumer. This function returns a blocking IEnumerable. Also returns offset of the message.
    member self.Consume(cancellationToken : System.Threading.CancellationToken) = 
        base.CheckDisposedState()
        let blockingCollection = new System.Collections.Concurrent.BlockingCollection<_>()
        
        let rec consume() = 
            async { 
                let! messagesFromAllPartitions = self.PartitionOffsets.Keys
                                                 |> Seq.map (fun x -> async { return! self.ConsumeInChunks(x, None) })
                                                 |> Async.Parallel
                messagesFromAllPartitions
                |> Seq.concat
                |> Seq.iter (fun x -> blockingCollection.Add(x))
                return! consume()
            }
        Async.Start(consume(), cancellationToken)
        blockingCollection.GetConsumingEnumerable(cancellationToken)
    
    interface IConsumer with
        
        /// Get the current consumer position
        member self.GetPosition() = self.GetPosition()
        
        /// Set the current consumer position
        member self.SetPosition(offsets) = self.SetPosition(offsets)
        
        member self.OffsetManager = self.OffsetManager
        member self.Consume(cancellationToken) = self.Consume(cancellationToken)
        member self.Dispose() = self.Dispose()
        /// Gets the broker router
        member self.BrokerRouter = self.BrokerRouter

/// High level kafka consumer, consuming messages in chunks defined by MaxBytes, MinBytes and MaxWaitTime in the consumer options. Each call to the consume functions,
/// will provide a new chunk of messages. If no messages are available an empty sequence will be returned.
type ChunkedConsumer(brokerRouter : IBrokerRouter, consumerOptions : ConsumerOptions) = 
    inherit BaseConsumer(brokerRouter, consumerOptions)
    new(brokerSeeds, consumerOptions : ConsumerOptions) = 
        new ChunkedConsumer(new BrokerRouter(brokerSeeds, consumerOptions.TcpTimeout), consumerOptions)
    
    /// Consume messages from the topic specified in the consumer. This function returns a sequence of messages, the size is defined by the chunk size.
    /// Multiple calls to this method consumes the next chunk of messages.
    member self.Consume(cancellationToken : System.Threading.CancellationToken) = 
        base.CheckDisposedState()
        let consume = 
            self.PartitionOffsets.Keys
            |> Seq.map (fun x -> async { return! self.ConsumeInChunks(x, None) })
            |> Async.Parallel
        Async.RunSynchronously(consume, cancellationToken = cancellationToken) |> Seq.concat
    
    /// Releases all connections and disposes the consumer
    member __.Dispose() = base.Dispose()
    
    interface IConsumer with
        
        /// Get the current consumer position
        member self.GetPosition() = self.GetPosition()
        
        /// Set the current consumer position
        member self.SetPosition(offsets) = self.SetPosition(offsets)
        
        member self.OffsetManager = self.OffsetManager
        member self.Consume(cancellationToken) = self.Consume(cancellationToken)
        member self.Dispose() = self.Dispose()
        /// Gets the broker router
        member self.BrokerRouter = self.BrokerRouter

/// Interface used to implement consumer group assignors
type IAssignor = 
    
    /// Name of the assignor
    abstract Name : string
    
    /// Perform group assignment given the topic, group members and available partition ids
    abstract Assign : string * GroupMember seq * Id seq -> GroupAssignment array

/// Assigns partitions to group memebers using round robin
type RoundRobinAssignor() = 
    let version = 0s
    
    /// Name of the assignor
    member __.Name = "roundrobin"
    
    /// Assign partitions to members
    member __.Assign(topic : string, members : GroupMember seq, partitions : Id seq) = 
        let rec memberSeq = 
            seq { 
                for x in members do
                    yield x
                yield! memberSeq
            }
        
        let assignments = new Dictionary<string, int list>()
        members |> Seq.iter (fun x -> assignments.Add(x.MemberId, []))
        partitions 
        |> Seq.iter2 (fun (m : GroupMember) p -> assignments.[m.MemberId] <- p :: assignments.[m.MemberId]) memberSeq
        assignments
        |> Seq.map (fun x -> 
               { GroupAssignment.MemberId = x.Key
                 MemberAssignment = 
                     { Version = version
                       UserData = [||]
                       PartitionAssignment = 
                           [| { Topic = topic
                                Partitions = x.Value |> Seq.toArray } |] } })
        |> Seq.toArray
    
    interface IAssignor with
        
        /// Name of the assignor
        member self.Name = self.Name
        
        /// Perform group assignment given the topic, group members and available partition ids
        member self.Assign(topic, members, partitions) = self.Assign(topic, members, partitions)

type internal CoordinatorMessage = 
    | JoinGroup of CancellationToken
    | LeaveGroup

type GroupConsumerOptions() = 
    inherit ConsumerOptions()
    
    /// Gets or sets the interval between heartbeats. The default values is 3000 ms.
    member val HeartbeatInterval = 3000 with get, set
    
    /// Gets or sets the session timeout. The default value is 30000 ms.
    member val SessionTimeout = 30000 with get, set
    
    /// Gets or sets the TCP timeout, this value must be greater than the session timeout. The default value is 40000 ms.
    override val TcpTimeout = 40000 with get, set
    
    /// Gets or sets the available assignors
    member val Assignors : IAssignor array = [| new RoundRobinAssignor() |] with get, set
    
    /// Gets or sets the group id
    member val GroupId = Guid.NewGuid().ToString() with get, set

/// Blocking message queue, much like BlockingCollection in BCL, but doesn't support threadsafe consuming
type MessageQueue() as self = 
    let stopEvent = new ManualResetEventSlim(false)
    let runningEvent = new ManualResetEventSlim(true)
    let mutable fatalException : Exception option = None
    let mutable innerMessageQueue = new ConcurrentQueue<MessageWithMetadata>()
    let queueAvailableResetEvent = new AutoResetEvent(false)
    let queueEmptyEvent = new Event<EventHandler, EventArgs>()
    
    let queue = 
        let checkException() = 
            if fatalException.IsSome then 
                LogConfiguration.Logger.Fatal.Invoke(fatalException.Value.Message, fatalException.Value)
                raise (ConsumerException(fatalException.Value.Message, fatalException.Value))
        
        let rec loop() = 
            if not runningEvent.IsSet then 
                checkException()
                let index = WaitHandle.WaitAny([| stopEvent.WaitHandle; runningEvent.WaitHandle |])
                if index = 0 then Seq.empty
                else seq { yield! loop() }
            elif stopEvent.IsSet then Seq.empty
            else 
                checkException()
                let success, msg = innerMessageQueue.TryDequeue()
                if success then 
                    seq { 
                        yield msg
                        yield! loop()
                    }
                else 
                    queueEmptyEvent.Trigger(self, EventArgs.Empty)
                    waitForData()
        
        and waitForData() = 
            let index = WaitHandle.WaitAny([| queueAvailableResetEvent; stopEvent.WaitHandle |])
            if index = 0 then seq { yield! loop() }
            else Seq.empty
        
        seq { yield! loop() }
    
    /// Event raised when the queue is empty
    [<CLIEvent>]
    member __.QueueEmpty = queueEmptyEvent.Publish
    
    /// Add a message to the queue
    member __.Add(msg) = 
        innerMessageQueue.Enqueue(msg)
        queueAvailableResetEvent.Set() |> ignore
    
    /// Add multiple messages to the queue
    member self.Add(msgs : MessageWithMetadata seq) = msgs |> Seq.iter self.Add
    
    /// Stop consuming, this makes callers iterating over the queue return
    member __.Stop() = stopEvent.Set()
    
    /// Pause consuming, this doesn't make callers iterating over the queue return
    member __.Pause() = runningEvent.Reset()
    
    /// Start consuming, if not started the queue always returns an empty sequence, even if data has been added
    member __.Start() = runningEvent.Set()
    
    /// Set exception, this make the queue throw an exception on the next iteration
    member __.SetFatalException(e) = 
        queueAvailableResetEvent.Set() |> ignore
        fatalException <- Some(e :> Exception)
    
    /// Find the lowest unprocessed partition offsets in the queue. To get consistent results, the queue should be stopped or paused.
    member __.FindLowestUnprocessedPartitionOffsets() = 
        innerMessageQueue
        |> Seq.groupBy (fun x -> x.PartitionId)
        |> Seq.map (fun (id, msgs) -> 
               { PartitionId = id
                 Offset = 
                     msgs
                     |> Seq.map (fun x -> x.Offset)
                     |> Seq.min
                 Metadata = "" })
    
    /// Clear the queue
    member __.Clear() = 
        innerMessageQueue <- new ConcurrentQueue<MessageWithMetadata>()
        queueEmptyEvent.Trigger(self, EventArgs.Empty)
    
    interface IEnumerable<MessageWithMetadata> with
        member __.GetEnumerator() = queue.GetEnumerator()
        member __.GetEnumerator() = queue.GetEnumerator() :> Collections.IEnumerator

type ConnectedEventArgs(groupId : string, assignment : MemberAssignment) = 
    inherit EventArgs()
    
    /// Group id
    member __.GroupId = groupId
    
    /// Assignment
    member __.Assignment = assignment

/// Indicates a consumers has left the consumer group
type DisconnectedEventArgs(groupId : string) =
    inherit EventArgs()

    /// The group id
    member __.GroupId = groupId

/// High level kafka consumer using the group management features of Kafka.
type GroupConsumer(brokerRouter : BrokerRouter, options : GroupConsumerOptions) = 
    let mutable disposed = false
    let groupCts = new CancellationTokenSource()
    let messageQueue = new MessageQueue()
    let onConnected = new Event<ConnectedEventArgs>()
    let onDisconnected = new Event<DisconnectedEventArgs>()

    let consumer = 
        if options.TcpTimeout < options.HeartbeatInterval then 
            invalidOp "TCP timeout must be greater than heartbeat interval"
        if options.GroupId |> String.IsNullOrEmpty then invalidOp "Group id cannot be null or empty"
        if options.Topic |> String.IsNullOrEmpty then invalidOp "Topic cannot be null or empty"
        new ChunkedConsumer(brokerRouter, options)
    
    let rec getGroupCoordinatorId() = 
        let response = new ConsumerMetadataRequest(options.GroupId) |> consumer.BrokerRouter.TrySendToBroker
        if response.CoordinatorId = -1 then getGroupCoordinatorId()
        else response.CoordinatorId
    
    let tryFindAssignor protocol : IAssignor option = options.Assignors |> Seq.tryFind (fun x -> x.Name = protocol)
    
    let getAssigment response = 
        match tryFindAssignor response.GroupProtocol with
        | Some x -> 
            consumer.BrokerRouter.RefreshMetadata()
            x.Assign(options.Topic, response.Members, consumer.BrokerRouter.GetAvailablePartitionIds(options.Topic))
        | None -> 
            raiseWithErrorLog 
                (invalidOp (sprintf "Coordinator selected unsupported protocol %s" response.GroupProtocol))
    
    let trySendToBroker coordinatorId request = consumer.BrokerRouter.TrySendToBroker(coordinatorId, request)
    let createSyncRequest response assignment = 
        new SyncGroupRequest(options.GroupId, response.GenerationId, response.MemberId, assignment)
    
    let joinAsLeader response = 
        response
        |> getAssigment
        |> createSyncRequest response
    
    let joinAsFollower response = createSyncRequest response [||]
    
    let (|Leader|Follower|) response = 
        if response.LeaderId = response.MemberId then Leader
        else Follower
    
    let sendJoinGroupAsync (coordinatorId : Id) success failure = 
        async { 
            try 
                let response = 
                    new JoinGroupRequest(options.GroupId, options.SessionTimeout, "", "consumer", 
                                         options.Assignors |> Seq.map (fun x -> 
                                                                  { Name = x.Name
                                                                    Metadata = [||] }))
                    |> trySendToBroker coordinatorId
                match response.ErrorCode with
                | ErrorCode.NoError -> return! success response
                | _ -> return! failure response.ErrorCode
            with e -> 
                LogConfiguration.Logger.Warning.Invoke
                    ("Got unexpected exception while joining group. Trying to rejoin...", e)
                return! failure ErrorCode.Unknown
        }
    
    let sendSyncGroupRequestAsync (request : SyncGroupRequest) (coordinatorId : Id) success failure = 
        async { 
            try 
                let response = request |> trySendToBroker coordinatorId
                match response.ErrorCode with
                | ErrorCode.NoError -> return! success coordinatorId response
                | _ -> return! failure response.ErrorCode
            with e -> 
                LogConfiguration.Logger.Warning.Invoke
                    ("Got unexpected exception while syncing group. Trying to rejoin...", e)
                return! failure ErrorCode.Unknown
        }
    
    let sendHeartbeatRequestAsync (generationId : Id) memberId (coordinatorId : Id) cts success failure = 
        async { 
            try 
                let response = 
                    new HeartbeatRequest(options.GroupId, generationId, memberId) |> trySendToBroker coordinatorId
                match response.ErrorCode with
                | ErrorCode.NoError -> return! success cts generationId memberId coordinatorId
                | _ -> return! failure cts response.ErrorCode
            with e -> 
                LogConfiguration.Logger.Warning.Invoke
                    ("Got unexpected exception while sending heartbeat. Trying to rejoin...", e)
                return! failure cts ErrorCode.Unknown
        }
    
    let updateConsumerPosition (partitionAssignments : PartitionAssignment array) = 
        consumer.ClearPositions()
        let assignedPartitions = 
            partitionAssignments
            |> Seq.filter (fun x -> x.Topic = options.Topic)
            |> Seq.collect (fun x -> x.Partitions)
            |> Seq.toArray
        
        let offsetsForAssignedPartitions = 
            consumer.OffsetManager.Fetch(options.GroupId) 
            |> Seq.filter (fun x -> assignedPartitions |> Seq.contains (x.PartitionId))
        
        let unavailableOffsets = 
            assignedPartitions
            |> Seq.filter (fun x -> 
                   offsetsForAssignedPartitions
                   |> Seq.map (fun y -> y.PartitionId)
                   |> Seq.contains (x)
                   |> not)
            |> Seq.map (fun x -> 
                   { HighLevel.PartitionOffset.Offset = 0L
                     HighLevel.PartitionOffset.PartitionId = x
                     HighLevel.PartitionOffset.Metadata = "" })
        
        let offsetsForAssignedPartitions = unavailableOffsets |> Seq.append offsetsForAssignedPartitions
        consumer.SetPosition(offsetsForAssignedPartitions)
    
    let joinGroup success failure = 
        let coordinatorId = getGroupCoordinatorId()
        sendJoinGroupAsync coordinatorId (success coordinatorId) failure
    
    let consumeAsync (token) = 
        async { 
            let addMessagesToQueue() = 
                let mutable breakLoop = false
                while not breakLoop do
                    try 
                        let msgs = consumer.Consume(token)
                        if msgs
                           |> Seq.length
                           > 0 then 
                            msgs |> messageQueue.Add
                            breakLoop <- true
                    with
                    | :? OperationCanceledException -> breakLoop <- true
                    | :? ObjectDisposedException -> breakLoop <- true
            addMessagesToQueue()
            use _ = messageQueue.QueueEmpty.Subscribe(fun _ -> addMessagesToQueue())
            ()
        }
    
    let stopConsuming (cts : CancellationTokenSource) = 
        LogConfiguration.Logger.Trace.Invoke("Stopping consuming...")
        cts.Cancel()
    
    let stopConsumingAndCommitOffsets (cts : CancellationTokenSource) = 
        stopConsuming cts
        consumer.OffsetManager.Commit(options.GroupId, consumer.GetPosition())
    
    let createLinkedCancellationTokenSource token = 
        CancellationTokenSource.CreateLinkedTokenSource([| token; groupCts.Token |])
    
    let agent = 
        Agent<CoordinatorMessage>.Start(fun inbox -> 
            let mutable agentCts : CancellationTokenSource = null
            
            let rec notConnectedState() = 
                async { 
                    let! msg = inbox.Receive()
                    match msg with
                    | JoinGroup token -> 
                        agentCts <- createLinkedCancellationTokenSource token
                        return! joinGroup joiningState (failedJoinState false)
                    | LeaveGroup -> return! notConnectedState()
                }
            
            and delayedReconnectState commitOffsets = reconnectState commitOffsets true
            and immediateReconnectState commitOffsets = reconnectState commitOffsets false
            
            and reconnectState commitOffsets delayedReconnect = 
                async { 
                    let currentPosition = consumer.GetPosition()
                    if commitOffsets && currentPosition
                                        |> Seq.isEmpty
                                        |> not
                    then 
                        try 
                            onDisconnected.Trigger(new DisconnectedEventArgs(options.GroupId))
                            consumer.OffsetManager.Commit(options.GroupId, currentPosition)
                        with e -> 
                            LogConfiguration.Logger.Error.Invoke("Could not save offsets before rejoining group", e)
                    let reconnectInterval = 
                        if delayedReconnect then 
                            LogConfiguration.Logger.Info.Invoke
                                (sprintf "Rejoining group '%s' in %i ms" options.GroupId options.ConnectionRetryInterval)
                            options.ConnectionRetryInterval
                        else 0
                    let! msg = inbox.TryReceive(reconnectInterval)
                    match msg with
                    | Some x -> 
                        match x with
                        | LeaveGroup -> return! notConnectedState()
                        | JoinGroup token -> 
                            agentCts <- createLinkedCancellationTokenSource token
                            return! joinGroup joiningState (failedJoinState commitOffsets)
                    | None -> 
                        if agentCts.IsCancellationRequested then ()
                        else return! joinGroup joiningState (failedJoinState commitOffsets)
                }
            
            and failedJoinState (commitOffsets : bool) (errorCode : ErrorCode) = 
                async { 
                    match errorCode with
                    | x when x.IsRetriable() || x = ErrorCode.UnknownMemberIdCode ->
                        LogConfiguration.Logger.Info.Invoke
                            (sprintf "Joining group '%s' failed with %O. Trying to rejoin..." options.GroupId errorCode)
                        return! delayedReconnectState commitOffsets
                    | ErrorCode.InconsistentGroupProtocolCode -> 
                        messageQueue.SetFatalException
                            (InvalidOperationException
                                 (sprintf "Could not join group '%s', as none for the protocols requested are supported" 
                                      options.GroupId))
                    | ErrorCode.InvalidSessionTimeoutCode -> 
                        messageQueue.SetFatalException
                            (InvalidOperationException
                                 (sprintf "Tried to join group '%s' with invalid session timeout" options.GroupId))
                    | ErrorCode.GroupAuthorizationFailedCode -> 
                        messageQueue.SetFatalException
                            (InvalidOperationException(sprintf "Not authorized to join group '%s'" options.GroupId))
                    | _ -> 
                        LogConfiguration.Logger.Info.Invoke
                            (sprintf 
                                 "Got unexpected error code '%A', while trying to join group '%s'. Trying to rejoin..." 
                                 errorCode options.GroupId)
                        let ex = 
                            InvalidOperationException
                                (sprintf 
                                     "Got unexpected error code '%A', while trying to join group '%s'. Trying to rejoin..." 
                                     errorCode options.GroupId)
                        LogConfiguration.Logger.Error.Invoke(ex.Message, ex)
                        return! delayedReconnectState commitOffsets
                }
            
            and joiningState (coordinatorId : Id) (response : JoinGroupResponse) = 
                async { 
                    LogConfiguration.Logger.Trace.Invoke(sprintf "Syncing consumer group '%s'" options.GroupId)
                    let syncRequest = 
                        response |> match response with
                                    | Leader -> joinAsLeader
                                    | Follower -> joinAsFollower
                    return! sendSyncGroupRequestAsync syncRequest coordinatorId 
                                (syncingState response.GenerationId response.MemberId) failedSyncState
                }
            
            and failedSyncState (errorCode : ErrorCode) = 
                async { 
                    match errorCode with
                    | x when x.IsRetriable() || x = ErrorCode.UnknownMemberIdCode || x = ErrorCode.RebalanceInProgressCode ->
                        LogConfiguration.Logger.Info.Invoke
                            (sprintf "Sync for group '%s' failed with %O. Trying to rejoin..." options.GroupId errorCode)
                        return! delayedReconnectState true
                    | ErrorCode.GroupAuthorizationFailedCode -> 
                        messageQueue.SetFatalException
                            (InvalidOperationException(sprintf "Not authorized to join group '%s'" options.GroupId))
                    | _ -> 
                        let ex = 
                            InvalidOperationException
                                (sprintf 
                                     "Got unexpected error code '%A', while trying to join group '%s'. Trying to rejoin..." 
                                     errorCode options.GroupId)
                        LogConfiguration.Logger.Error.Invoke(ex.Message, ex)
                        return! delayedReconnectState true
                }
            
            and syncingState (generationId : Id) (memberId : string) (coordinatorId : Id) (response : SyncGroupResponse) = 
                async { 
                    try 
                        updateConsumerPosition response.MemberAssignment.Value.PartitionAssignment
                    with e -> 
                        LogConfiguration.Logger.Warning.Invoke
                            ("Got unexpected exception while updating consumer offsets. Trying to rejoin...", e)
                        return! delayedReconnectState true
                    LogConfiguration.Logger.Info.Invoke
                        (sprintf "Connected to group '%s' with assignment %A" options.GroupId 
                             response.MemberAssignment.Value.PartitionAssignment)
                    let cts = CancellationTokenSource.CreateLinkedTokenSource(agentCts.Token)
                    Async.Start(consumeAsync (cts.Token), cts.Token)
                    onConnected.Trigger(new ConnectedEventArgs(options.GroupId, response.MemberAssignment.Value))
                    return! connectedState cts generationId memberId coordinatorId
                }
            
            and connectedState (cts : CancellationTokenSource) (generationId : Id) (memberId : string) 
                (coordinatorId : Id) = 
                async { 
                    let! msg = inbox.TryReceive(options.HeartbeatInterval)
                    match msg with
                    | Some x -> 
                        match x with
                        | LeaveGroup -> 
                            stopConsumingAndCommitOffsets cts
                            return! notConnectedState()
                        | _ -> 
                            return! sendHeartbeatRequestAsync generationId memberId coordinatorId cts connectedState 
                                        failedHeartbeatState
                    | None -> 
                        if agentCts.IsCancellationRequested then stopConsumingAndCommitOffsets cts
                        else 
                            return! sendHeartbeatRequestAsync generationId memberId coordinatorId cts connectedState 
                                        failedHeartbeatState
                }
            
            and failedHeartbeatState (cts : CancellationTokenSource) (errorCode : ErrorCode) = 
                async { 
                    stopConsuming cts
                    match errorCode with
                    | x when x.IsRetriable() || x = ErrorCode.IllegalGenerationCode || x = ErrorCode.UnknownMemberIdCode ->
                        LogConfiguration.Logger.Trace.Invoke
                            (sprintf "Heartbeat failed with %O. Trying to rejoin..." errorCode)
                        return! delayedReconnectState true
                    | ErrorCode.RebalanceInProgressCode -> return! immediateReconnectState true
                    | ErrorCode.GroupAuthorizationFailedCode -> 
                        messageQueue.SetFatalException
                            (InvalidOperationException(sprintf "Not authorized to join group '%s'" options.GroupId))
                    | _ -> 
                        let ex = 
                            InvalidOperationException
                                (sprintf 
                                     "Got unexpected error code '%A', while trying to send heartbeat '%s'. Trying to rejoin..." 
                                     errorCode options.GroupId)
                        LogConfiguration.Logger.Error.Invoke(ex.Message, ex)
                        return! delayedReconnectState true
                }
            
            notConnectedState())
    
    new(brokerSeeds, options : GroupConsumerOptions) = 
        new GroupConsumer(new BrokerRouter(brokerSeeds, options.TcpTimeout), options)
    
    /// Consume messages from the topic specified. Uses the IConsumer provided in the constructor to consume messages.
    member __.Consume(token) = 
        raiseIfDisposed disposed
        agent.Post(JoinGroup token)
        messageQueue :> IEnumerable<MessageWithMetadata>
    
    /// Gets the offset manager
    member __.OffsetManager = consumer.OffsetManager
    
    /// Gets the consumer position
    member __.GetPosition = consumer.GetPosition
    
    /// Sets the consumer position
    member __.SetPosition = consumer.SetPosition
    
    /// Leave the joined group
    member __.LeaveGroup() = 
        raiseIfDisposed disposed
        agent.Post(LeaveGroup)
    
    /// Event raised the consumer has connected to group
    [<CLIEvent>]
    member __.OnConnected = onConnected.Publish
    
    /// Event raised the consumer has left the group
    [<CLIEvent>]
    member __.OnDisconnected = onDisconnected.Publish
    
    /// Releases all connections and disposes the consumer
    member __.Dispose() = 
        if not disposed then 
            groupCts.Cancel()
            consumer.Dispose()
            disposed <- true
    
    /// Gets the broker router
    member __.BrokerRouter = 
        raiseIfDisposed disposed
        consumer.BrokerRouter
    
    interface IConsumer with
        member self.GetPosition() = self.GetPosition()
        member self.SetPosition(offsets) = self.SetPosition(offsets)
        member self.OffsetManager = self.OffsetManager
        member self.Consume(cancellationToken) = self.Consume(cancellationToken)
        member self.Dispose() = self.Dispose()
        member self.BrokerRouter = self.BrokerRouter
