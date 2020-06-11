namespace Franz

open System
open Franz.Internal
open System.Net.Sockets
open System.IO
open Franz.Stream
open Franz.Zookeeper

type KafkaVersion =
    | V0_8_1 = 1
    | V0_8_2 = 2
    | V0_9 = 3
    | V0_10 = 4
    | V0_10_1 = 5

type NoBrokerFoundForTopicPartitionException(topic : string, partition : int) = 
    inherit Exception()
    member __.Topic = topic
    member __.Partition = partition
    override e.Message = 
        sprintf "Could not find broker for topic %s partition %i after several retries." e.Topic e.Partition

type BrokerNotFound(id : int) = 
    inherit Exception()
    override __.Message = sprintf "Could not find broker with id %i" id

type NoBrokersAvailable() = 
    inherit Exception()
    override __.Message = "No brokers available"

type UnableToConnectToAnyBrokerException() = 
    inherit Exception()
    override __.Message = "Could not connect to any of the broker seeds"

type UnableToConnectToAnyZookeeperException() = 
    inherit Exception()
    override __.Message = "Could not connect to any of zookeeper servers"

/// Extensions to help determine outcome of error codes
[<AutoOpen>]
module ErrorCodeExtensions = 
    type Messages.ErrorCode with
        
        /// Check if error code is an real error
        member self.IsError() = self <> Messages.ErrorCode.NoError && self <> Messages.ErrorCode.ReplicaNotAvailable
        
        /// Check if error code is success
        member self.IsSuccess() = not <| self.IsError()
        
        /// Check if error code is retriable
        member self.IsRetriable() =
            match self with
            | Messages.ErrorCode.InvalidMessage
            | Messages.ErrorCode.UnknownTopicOrPartition
            | Messages.ErrorCode.LeaderNotAvailable
            | Messages.ErrorCode.NotLeaderForPartition
            | Messages.ErrorCode.RequestTimedOut
            | Messages.ErrorCode.NetworkException
            | Messages.ErrorCode.GroupLoadInProgressCode
            | Messages.ErrorCode.ConsumerCoordinatorNotAvailable
            | Messages.ErrorCode.NotCoordinatorForConsumer
            | Messages.ErrorCode.NotEnoughReplicasCode
            | Messages.ErrorCode.NotController -> true
            | _ -> false

/// Type containing which nodes is leaders for which topic and partition
type TopicPartitionLeader = 
    { TopicName : string
      PartitionIds : Id array }

/// Broker information and actions
type Broker(brokerId : Id, endPoint : EndPoint, leaderFor : TopicPartitionLeader array, tcpTimeout : int) = 
    let sendLock = new Object()
    let mutable disposed = false
    let mutable leaderFor = leaderFor
    let mutable client : TcpClient = null
    
    let send (self : Broker) (request : Request<'TResponse>) = 
        try 
            if client |> isNull then self.Connect()
            let stream = client.GetStream()
            stream |> request.Serialize
            let messageSize = stream |> BigEndianReader.ReadInt32
            LogConfiguration.Logger.Trace.Invoke(sprintf "Received message of size %i" messageSize)
            let buffer = stream |> BigEndianReader.Read messageSize
            new MemoryStream(buffer)
        with _ -> 
            client <- null
            reraise()
    
    /// Check if broker is leader for the specified topic and partition
    member self.IsLeaderFor(topic, partitionId) = 
        self.LeaderFor
        |> Seq.filter (fun x -> x.TopicName = topic)
        |> Seq.collect (fun x -> x.PartitionIds)
        |> Seq.exists (fun x -> x = partitionId)
    
    member internal self.SetAsLeaderFor(topic, partitionId) = 
        let topicIndex = self.LeaderFor |> Array.tryFindIndex (fun x -> x.TopicName = topic)
        match topicIndex with
        | Some x -> 
            let topicLeader = self.LeaderFor.[x]
            let leaderPartitions = topicLeader.PartitionIds |> Array.append [| partitionId |]
            self.LeaderFor.[x] <- { topicLeader with PartitionIds = leaderPartitions }
        | None -> 
            self.LeaderFor <- self.LeaderFor |> Array.append [| { TopicName = topic
                                                                  PartitionIds = [| partitionId |] } |]
    
    member internal self.NoLongerLeaderFor(topic, partitionId) = 
        let topicIndex = self.LeaderFor |> Array.tryFindIndex (fun x -> x.TopicName = topic)
        match topicIndex with
        | Some x -> 
            let topicLeader = self.LeaderFor.[x]
            
            let leaderPartitions = 
                topicLeader.PartitionIds
                |> Seq.filter (fun x -> x = partitionId)
                |> Seq.toArray
            self.LeaderFor.[x] <- { topicLeader with PartitionIds = leaderPartitions }
        | None -> ()
    
    /// Gets the broker TcpClient
    member __.Client = client
    
    /// Gets the broker endpoint
    member __.EndPoint = endPoint
    
    /// Is the TcpClient connected
    member __.IsConnected = 
        client
        |> isNull
        |> not
        && client.Connected
    
    /// Gets the  topic partitions the broker is leader for
    member __.LeaderFor 
        with get () = leaderFor
        and internal set (x) = leaderFor <- x
    
    /// Gets the node id
    member __.Id = brokerId
    
    /// Connect the broker
    member __.Connect() = 
        raiseIfDisposed (disposed)
        LogConfiguration.Logger.Info.Invoke("Creating new tcp connecting...")
        try 
            client <- new TcpClient()
            client.ReceiveTimeout <- tcpTimeout
            client.SendTimeout <- tcpTimeout
            client.Connect(endPoint.Address, endPoint.Port)
        with _ -> 
            client <- null
            reraise()
    
    /// Send a request to the broker
    member self.Send(request : Request<'TResponse>) = 
        raiseIfDisposed (disposed)
        let rawResponseStream = 
            lock sendLock (fun () -> 
                try 
                    send self request
                with
                | :? IOException as ioe -> 
                    if ioe.InnerException |> isNull then LogConfiguration.Logger.Info.Invoke(ioe.InnerException.Message)
                    LogConfiguration.Logger.Info.Invoke(ioe.Message)
                    LogConfiguration.Logger.Info.Invoke("Retrying send...")
                    send self request
                | :? UnderlyingConnectionClosedException as ucce -> 
                    LogConfiguration.Logger.Info.Invoke(ucce.Message)
                    LogConfiguration.Logger.Info.Invoke("Retrying send...")
                    send self request
                | :? SocketException as se ->
                    if se.ErrorCode = 10061 then LogConfiguration.Logger.Info.Invoke (sprintf "Connection to broker %i was lost" brokerId)
                    reraise()
                | e -> 
                    LogConfiguration.Logger.Warning.Invoke
                        ("An unexpected exception occured during send. Please investigate.", e)
                    LogConfiguration.Logger.Info.Invoke("Retrying send...")
                    send self request)
        request.DeserializeResponse(rawResponseStream)
    
    /// Closes the connection and disposes the broker
    member __.Dispose() = 
        if not disposed then 
            try 
                client.Close()
            with _ -> ()
            disposed <- true
    
    override __.ToString() = 
        sprintf "{Id: %i, EndPoint: %A, LeaderFor: %A, TcpTimeout: %i}" brokerId endPoint leaderFor tcpTimeout
    interface IDisposable with
        /// Dispose the broker
        member self.Dispose() = self.Dispose()

/// Indicates ok or failure message
type BrokerRouterReturnMessage<'T> = 
    private
    | Ok of 'T
    | Failure of exn

type IBrokerRouter = 
    inherit IDisposable
    
    /// Connect the the router
    abstract Connect : unit -> unit
    
    /// Get all available brokers
    abstract GetAllBrokers : unit -> Broker seq
    
    /// Get broker by topic and partition id
    abstract GetBroker : string * Id -> Broker
    
    /// Try to send a request to broker handling the specified topic and partition
    abstract TrySendToBroker : string * Id * Request<'a> -> 'a
    
    /// Try to send a request to a broker using round robin algorithm
    abstract TrySendToBroker : Request<'a> -> 'a
    
    /// Try to send a request to a broker specified by id
    abstract TrySendToBroker : Id * Request<'a> -> 'a
    
    /// Get all available partitions of the specified topic
    abstract GetAvailablePartitionIds : string -> Id array
    
    /// Event used in case of unhandled exception in internal agent
    abstract Error : IEvent<exn>
    
    /// Event triggered when metadata is refreshed
    abstract MetadataRefreshed : IEvent<Broker list>
    
    /// Refresh cluster metadata
    abstract RefreshMetadata : unit -> unit

type ZookeeperBrokerRouterMessage = 
    private
    | FetchInitialInformation
    | BrokerIdsChanged
    | TopicPartitionStateUpdated of string * Id
    | GetAllBrokers of AsyncReplyChannel<Broker seq>
    | GetRandomBroker of AsyncReplyChannel<Broker option>
    | TopicsChanged
    | TopicPartitionsChanged of string

/// The broker router. Handles all logic related to broker metadata and available brokers, using the Zookeeper cluster as the source of information
type ZookeeperBrokerRouter(zookeeperManager : ZookeeperManager, brokerTcpTimeout : int) = 
    let mutable disposed = false
    let errorEvent = new Event<_>()
    let metadataRefreshed = new Event<_>()
    let random = new Random()
    
    let agent = 
        new Agent<_>(fun inbox -> 
        let getAndWatchBrokerIds() = zookeeperManager.GetBrokerIds(fun () -> inbox.Post(BrokerIdsChanged))
        let getAndWatchTopics() = zookeeperManager.GetTopics(fun () -> inbox.Post(TopicsChanged))
        let getAndWatchTopicPartitionStateInformation topic partitionId = 
            zookeeperManager.GetTopicPartitionState
                (topic, partitionId, fun () -> inbox.Post(TopicPartitionStateUpdated(topic, partitionId)))
        
        let getPartitions topics = 
            topics
            |> Seq.map (fun x -> (x, zookeeperManager.GetTopicRegistrationInfo x))
            |> Seq.map (fun (topic, pi) -> 
                   (topic, 
                    pi.Partitions
                    |> Seq.map (fun x -> int32 x.Key)
                    |> Seq.toArray))
            |> Map.ofSeq
        
        let fetchInitialInformation() = 
            let brokerIds = getAndWatchBrokerIds()
            
            let bri = 
                zookeeperManager.GetAllBrokerRegistrationInfo()
                |> Seq.map (fun x -> (x.Id, x))
                |> dict
            
            let topics = getAndWatchTopics()
            let topicPartitions = topics |> getPartitions
            
            let tps = 
                topicPartitions
                |> Seq.collect (fun x -> x.Value |> Seq.map (fun id -> (x.Key, id)))
                |> Seq.map (fun (topic, pid) -> (topic, pid, getAndWatchTopicPartitionStateInformation topic pid))
                |> Seq.toArray
            
            let brokers = 
                brokerIds
                |> Seq.map (fun brokerId -> 
                       let endpoint = 
                           { Address = bri.[brokerId].Host
                             Port = bri.[brokerId].Port }
                       
                       let leaderFor = 
                           tps
                           |> Seq.filter (fun (_, _, tps) -> tps.Leader = brokerId)
                           |> Seq.map (fun (topic, pid, _) -> (topic, pid))
                           |> Seq.groupBy (fun (topic, _) -> topic)
                           |> Seq.map (fun (topic, x) -> 
                                  { TopicName = topic
                                    PartitionIds = 
                                        x
                                        |> Seq.map (fun (_, pi) -> pi)
                                        |> Seq.toArray })
                           |> Seq.toArray
                       
                       new Broker(brokerId, endpoint, leaderFor, brokerTcpTimeout))
                |> Seq.map (fun x -> (x.Id, x))
                |> Map.ofSeq
            
            LogConfiguration.Logger.Info.Invoke
                (sprintf "Initial brokers is %O, initial topic and partitions is %A" brokers topicPartitions)
            metadataRefreshed.Trigger(brokers
                                      |> Map.getValues
                                      |> Seq.toList)
            (brokers, topicPartitions)
        
        let topicPartitionStateUpdated (topic, partitionId) (brokers : Map<Id, Broker>) = 
            LogConfiguration.Logger.Info.Invoke
                (sprintf "Partition state for topic '%s' partition '%i' changed" topic partitionId)
            let tps = zookeeperManager.GetTopicPartitionState(topic, partitionId)
            let currentLeader = brokers |> Seq.tryFind (fun x -> x.Value.IsLeaderFor(topic, partitionId))
            match currentLeader with
            | Some x when x.Value.Id <> tps.Leader -> 
                x.Value.NoLongerLeaderFor(topic, partitionId)
                let newLeader = brokers |> Map.tryFind tps.Leader
                match newLeader with
                | Some n -> n.SetAsLeaderFor(topic, partitionId)
                | None -> ()
            | Some _ -> ()
            | None -> 
                let newLeader = brokers |> Map.tryFind tps.Leader
                match newLeader with
                | Some n -> n.SetAsLeaderFor(topic, partitionId)
                | None -> ()
            LogConfiguration.Logger.Info.Invoke(sprintf "Updated brokers is: %O" brokers)
            metadataRefreshed.Trigger(brokers
                                      |> Map.getValues
                                      |> Seq.toList)
            brokers
        
        let idsChanged (topics : Map<string, int array>) (brokers : Map<Id, Broker>) = 
            LogConfiguration.Logger.Info.Invoke("Brokers changed")
            let allBrokers = 
                zookeeperManager.GetAllBrokerRegistrationInfo()
                |> Seq.map (fun x -> (x.Id, x))
                |> Map.ofSeq
            
            let allBrokerIds = 
                allBrokers
                |> Map.getKeys
                |> Set.ofSeq
            
            let currentBrokerIds = 
                brokers
                |> Map.getKeys
                |> Set.ofSeq
            
            let newBrokerIds = Set.difference allBrokerIds currentBrokerIds
            
            let newBrokers = 
                newBrokerIds
                |> Seq.map (fun x -> (x, allBrokers.[x]))
                |> Seq.map (fun (id, brokerInfo) -> 
                       (id, 
                        { Address = brokerInfo.Host
                          Port = brokerInfo.Port }))
                |> Seq.map (fun (id, endpoint) -> new Broker(id, endpoint, [||], brokerTcpTimeout))
            
            let removedBrokerIds = Set.difference currentBrokerIds allBrokerIds
            removedBrokerIds |> Seq.iter (fun x -> brokers.[x].Dispose())
            let brokers = 
                removedBrokerIds
                |> Seq.fold (fun state item -> state |> Map.remove (item)) brokers
                |> Seq.map (fun x -> x.Value)
                |> Seq.append newBrokers
                |> Seq.map (fun x -> (x.Id, x))
                |> Map.ofSeq
            LogConfiguration.Logger.Info.Invoke(sprintf "Updated broker list is: %O" brokers)
            metadataRefreshed.Trigger(brokers
                                      |> Map.getValues
                                      |> Seq.toList)
            (brokers, topics)
        
        let joinBy f (x : 'a seq) (y : 'b seq) = 
            x
            |> Seq.map (fun x -> (x, y |> Seq.tryFind (f x)))
            |> Seq.filter (fun (_, y) -> y.IsSome)
            |> Seq.map (fun (x, y) -> (x, y.Value))
        
        let topicsChanged (brokers : Map<Id, Broker>) (topicPartitions : Map<string, int array>) = 
            LogConfiguration.Logger.Info.Invoke("Topics changed")
            let allTopics = zookeeperManager.GetTopics() |> Set.ofArray
            
            let currentTopics = 
                topicPartitions
                |> Map.getKeys
                |> Set.ofSeq
            
            let removedTopics = Set.difference currentTopics allTopics
            brokers
            |> Map.getValues
            |> joinBy (fun topic broker -> broker.LeaderFor |> Seq.exists (fun x -> x.TopicName = topic)) removedTopics
            |> Seq.iter 
                   (fun (topic, broker) -> 
                   broker.LeaderFor <- broker.LeaderFor |> Array.filter (fun l -> l.TopicName = topic))
            let updatedPartitions = 
                topicPartitions
                |> Seq.filter (fun x -> removedTopics |> Set.contains x.Key)
                |> Seq.map (fun x -> (x.Key, x.Value))
                |> Map.ofSeq
            LogConfiguration.Logger.Info.Invoke(sprintf "Updated topic and partitions is: %A" updatedPartitions)
            metadataRefreshed.Trigger(brokers
                                      |> Map.getValues
                                      |> Seq.toList)
            (brokers, updatedPartitions)
        
        let partitionsChanged (brokers : Map<Id, Broker>) (topicPartitions : Map<string, int array>) topic = 
            LogConfiguration.Logger.Info.Invoke(sprintf "Topic '%s' partitions changed" topic)
            let allPartitions = 
                [ topic ]
                |> getPartitions
                |> Map.getValues
                |> Seq.concat
                |> Set.ofSeq
            
            let currentPartitions = topicPartitions.[topic] |> Set.ofSeq
            let newPartitions = Set.difference allPartitions currentPartitions
            let newState = 
                newPartitions |> Seq.map (fun pid -> (pid, getAndWatchTopicPartitionStateInformation topic pid))
            newState
            |> Seq.map (fun (pid, state) -> (brokers.[state.Leader], pid))
            |> Seq.iter (fun (broker, pid) -> broker.NoLongerLeaderFor(topic, pid))
            let removedPartitions = Set.difference currentPartitions allPartitions
            brokers
            |> Map.getValues
            |> joinBy (fun pid broker -> broker.IsLeaderFor(topic, pid)) removedPartitions
            |> Seq.iter (fun (pid, broker) -> broker.SetAsLeaderFor(topic, pid))
            let updatedPartitions = 
                topicPartitions
                |> Map.find topic
                |> Seq.except removedPartitions
                |> Seq.append newPartitions
                |> Seq.toArray
            
            let topicPartitions = 
                topicPartitions
                |> Map.remove topic
                |> Map.add topic updatedPartitions
            
            LogConfiguration.Logger.Info.Invoke(sprintf "Updated partitions for '%s' is %A" topic updatedPartitions)
            metadataRefreshed.Trigger(brokers
                                      |> Map.getValues
                                      |> Seq.toList)
            (brokers, topicPartitions)
        
        let rec loop brokers topicPartitions = 
            async { 
                let! msg = inbox.Receive()
                let (brokers, topicPartitions) = 
                    match msg with
                    | FetchInitialInformation -> fetchInitialInformation()
                    | TopicPartitionStateUpdated(topic, partition) -> 
                        (brokers |> topicPartitionStateUpdated (topic, partition), topicPartitions)
                    | BrokerIdsChanged -> brokers |> idsChanged topicPartitions
                    | GetAllBrokers reply -> 
                        reply.Reply(brokers |> Map.getValues)
                        (brokers, topicPartitions)
                    | GetRandomBroker reply -> 
                        let index = random.Next(brokers.Count)
                        brokers
                        |> Map.getValues
                        |> Seq.tryItem index
                        |> reply.Reply
                        (brokers, topicPartitions)
                    | TopicsChanged -> topicsChanged brokers topicPartitions
                    | TopicPartitionsChanged topic -> topic |> partitionsChanged brokers topicPartitions
                return! loop brokers topicPartitions
            }
        
        loop Map.empty Map.empty)
    
    let getRandomBroker() = 
        match agent.PostAndReply(GetRandomBroker) with
        | Some x -> x
        | None -> 
            LogConfiguration.Logger.Warning.Invoke("No brokers available", null)
            raise (NoBrokersAvailable())
    
    let getBroker (id) = 
        let broker = agent.PostAndReply(GetAllBrokers) |> Seq.tryFind (fun x -> x.Id = id)
        match broker with
        | Some x -> x
        | None -> 
            LogConfiguration.Logger.Info.Invoke(sprintf "Unable to find broker with id %i" id)
            raise (BrokerNotFound(id))
    
    do 
        agent.Error.Add(fun x -> errorEvent.Trigger(raiseWithFatalLog (x)))
        zookeeperManager.ConnectionLost.Add
            (fun () -> errorEvent.Trigger(raiseWithFatalLog (UnableToConnectToAnyZookeeperException())))
    
    /// Dispose the router
    member __.Dispose() = 
        if not disposed then 
            (zookeeperManager :> IDisposable).Dispose()
            disposed <- false
    
    /// Connect to the Zookeeper server.
    member __.Connect() = 
        raiseIfDisposed disposed
        zookeeperManager.Connect()
        agent.Start()
        agent.Post(FetchInitialInformation)
    
    /// Get all available brokers
    member __.GetAllBrokers() = 
        raiseIfDisposed disposed
        agent.PostAndReply(GetAllBrokers)
    
    /// Get all available partitions of the specified topic
    member __.GetAvailablePartitionIds(topic) = 
        raiseIfDisposed disposed
        agent.PostAndReply(GetAllBrokers)
        |> Seq.collect (fun x -> x.LeaderFor)
        |> Seq.filter (fun x -> x.TopicName = topic)
        |> Seq.collect (fun x -> x.PartitionIds)
        |> Seq.toArray
    
    /// Get broker by topic and partition id
    member __.GetBroker(topic, partitionId) = 
        raiseIfDisposed disposed
        let broker = agent.PostAndReply(GetAllBrokers) |> Seq.tryFind (fun x -> x.IsLeaderFor(topic, partitionId))
        match broker with
        | Some x -> x
        | None -> 
            LogConfiguration.Logger.Info.Invoke(sprintf "Unable to find broker of %s partition %i..." topic partitionId)
            raise (NoBrokerFoundForTopicPartitionException(topic, partitionId))
    
    /// Try to send a request to broker handling the specified topic and partition.
    /// If this fails an exception is thrown and should be handled by the caller.
    member self.TryToSendToBroker(topic, partitionId, request) = 
        raiseIfDisposed disposed
        let broker = self.GetBroker(topic, partitionId)
        broker.Send(request)
    
    /// Try to send a request to a random broker.
    /// If this fails an exception is thrown and should be handled by the caller.
    member __.TryToSendToBroker(request) = 
        raiseIfDisposed disposed
        getRandomBroker().Send(request)
    
    /// Try to send a request to a specific broker.
    /// If this fails an exception is thrown and should be handled by the caller.
    member __.TryToSendToBroker(id, request) = 
        raiseIfDisposed disposed
        getBroker(id).Send(request)
    
    /// Refresh cluster metadata
    member __.RefreshMetadata() = ()
    
    /// Event triggered when metadata is refreshed
    member __.MetadataRefreshed = metadataRefreshed.Publish
    
    /// Event used in case of unhandled exception in internal agent
    member __.Error = errorEvent.Publish
    
    interface IBrokerRouter with
        member self.Connect() = self.Connect()
        member self.GetAllBrokers() = self.GetAllBrokers()
        member self.GetAvailablePartitionIds(topic) = self.GetAvailablePartitionIds(topic)
        member self.GetBroker(topic, partitionId) = self.GetBroker(topic, partitionId)
        member self.TrySendToBroker(topic, partitionId, request) = self.TryToSendToBroker(topic, partitionId, request)
        member self.TrySendToBroker(request) = self.TryToSendToBroker(request)
        member self.Error = self.Error
        member self.MetadataRefreshed = self.MetadataRefreshed
        member self.RefreshMetadata() = self.RefreshMetadata()
        member self.TrySendToBroker(id, request) = self.TryToSendToBroker(id, request)
    
    interface IDisposable with
        /// Dispose the router
        member self.Dispose() = self.Dispose()

/// Available messages for the broker router
type BrokerRouterMessage = 
    private
    /// Add a broker to the list of available brokers
    | AddBroker of Broker
    /// Refresh metadata
    | RefreshMetadata of AsyncReplyChannel<BrokerRouterReturnMessage<unit>>
    /// Get a broker by topic and partition id
    | GetBroker of string * Id * AsyncReplyChannel<BrokerRouterReturnMessage<Broker>>
    /// Get all available brokers
    | GetAllBrokers of AsyncReplyChannel<Broker seq>
    /// Closes the router
    | Close
    /// Connect to the cluster
    | Connect of EndPoint seq * AsyncReplyChannel<unit>
    /// Get a random broker
    | GetRandomBroker of AsyncReplyChannel<Broker option>

/// The broker router. Handles all logic related to broker metadata and available brokers, using the Kafka cluster as the source of information
type BrokerRouter(brokerSeeds : EndPoint seq, tcpTimeout) as self = 
    let mutable disposed = false
    let cts = new System.Threading.CancellationTokenSource()
    let errorEvent = new Event<_>()
    let metadataRefreshed = new Event<_>()
    let random = new Random()
    
    let getPartitions nodeId response = 
        response.TopicMetadata
        |> Seq.map (fun t -> 
               { TopicName = t.Name
                 PartitionIds = 
                     t.PartitionMetadata
                     |> Seq.filter (fun p -> p.ErrorCode.IsSuccess() && p.Leader = nodeId)
                     |> Seq.map (fun p -> p.PartitionId)
                     |> Seq.toArray })
        |> Seq.toArray
    
    let mapMetadataResponseToBrokers brokers brokerSeeds (response : MetadataResponse) = 
        let newBrokers = 
            response.Brokers
            |> Seq.map (fun x -> 
                   ({ Address = x.Host
                      Port = x.Port }, x.NodeId))
            |> Seq.filter (fun (x, _) -> 
                   brokers
                   |> Seq.exists (fun (b : Broker) -> b.EndPoint = x)
                   |> not)
            |> Seq.map 
                   (fun (endPoint, nodeId) -> new Broker(nodeId, endPoint, getPartitions nodeId response, tcpTimeout))
            |> Seq.toList
        brokers |> Seq.iter (fun x -> x.LeaderFor <- getPartitions x.Id response)
        if brokers
           |> Seq.isEmpty
           && newBrokers |> Seq.isEmpty then 
            brokerSeeds
            |> Seq.map (fun x -> new Broker(-1, x, [||], tcpTimeout))
            |> Seq.toList
        else 
            [ brokers; newBrokers ]
            |> Seq.concat
            |> Seq.toList
    
    let rec innerConnect seeds = 
        match seeds with
        | head :: tail -> 
            try 
                LogConfiguration.Logger.Info.Invoke(sprintf "Connecting to %s:%i..." head.Address head.Port)
                let broker = new Broker(-1, head, [||], tcpTimeout)
                broker.Connect()
                broker.Send(new MetadataRequest([||])) |> mapMetadataResponseToBrokers [] seeds
            with e -> 
                LogConfiguration.Logger.Info.Invoke
                    (sprintf "Could not connect to %s:%i due to (%s), retrying." head.Address head.Port e.Message)
                innerConnect tail
        | [] -> raiseWithFatalLog (UnableToConnectToAnyBrokerException())
    
    let connect brokerSeeds = 
        raiseIfDisposed (disposed)
        if brokerSeeds |> isNull then invalidArg "brokerSeeds" "Brokerseeds cannot be null"
        if brokerSeeds |> Seq.isEmpty then invalidArg "brokerSeeds" "At least one broker seed must be supplied"
        innerConnect (brokerSeeds |> Seq.toList) |> Seq.iter (fun x -> self.AddBroker(x))
    
    let router = 
        Agent.Start((fun inbox -> 
                    let rec loop brokers lastRoundRobinIndex connected = 
                        async { 
                            let! msg = inbox.Receive()
                            match msg with
                            | AddBroker broker -> 
                                LogConfiguration.Logger.Info.Invoke
                                    (sprintf "Adding broker %i with endpoint %A" broker.Id broker.EndPoint)
                                if not broker.IsConnected then broker.Connect()
                                let existingBrokers = 
                                    (brokers
                                     |> Seq.filter (fun (x : Broker) -> x.EndPoint <> broker.EndPoint)
                                     |> Seq.toList)
                                return! loop (broker :: existingBrokers) lastRoundRobinIndex connected
                            | RefreshMetadata reply -> 
                                try 
                                    let (index, updatedBrokers) = self.RefreshMetadata(brokers, lastRoundRobinIndex)
                                    reply.Reply(Ok())
                                    return! loop updatedBrokers index connected
                                with e -> 
                                    reply.Reply(Failure e)
                                    return! loop brokers lastRoundRobinIndex connected
                            | GetBroker(topic, partitionId, reply) -> 
                                match self.GetBroker(brokers, lastRoundRobinIndex, topic, partitionId) with
                                | Ok(broker, index) -> 
                                    reply.Reply(Ok(broker))
                                    return! loop brokers index connected
                                | Failure e -> 
                                    reply.Reply(Failure(e))
                                    return! loop brokers lastRoundRobinIndex connected
                            | GetAllBrokers reply -> 
                                reply.Reply(brokers)
                                return! loop brokers lastRoundRobinIndex connected
                            | Close -> 
                                brokers |> Seq.iter (fun x -> x.Dispose())
                                cts.Cancel()
                                disposed <- true
                                return! loop brokers lastRoundRobinIndex connected
                            | Connect(brokerSeeds, reply) -> 
                                if not connected then connect brokerSeeds
                                reply.Reply()
                                return! loop brokers lastRoundRobinIndex true
                            | GetRandomBroker reply -> 
                                let index = random.Next(brokers.Length)
                                brokers
                                |> Seq.tryItem index
                                |> reply.Reply
                                return! loop brokers lastRoundRobinIndex true
                        }
                    loop [] -1 false), cts.Token)
    
    let rec getMetadata brokers attempt lastRoundRobinIndex topics = 
        let (index, broker : Broker) = brokers |> Seq.roundRobin lastRoundRobinIndex
        try 
            try 
                if not broker.IsConnected then broker.Connect()
                let response = broker.Send(new MetadataRequest(topics))
                (index, response)
            with _ -> 
                if not broker.IsConnected then broker.Connect()
                let response = broker.Send(new MetadataRequest(topics))
                (index, response)
        with e -> 
            LogConfiguration.Logger.Info.Invoke
                (sprintf "Unable to get metadata from broker %i due to (%s), retrying." broker.Id e.Message)
            if attempt < (brokers |> Seq.length) then getMetadata brokers (attempt + 1) index topics
            else raiseWithFatalLog (UnableToConnectToAnyBrokerException())
    
    let rec findBroker brokers lastRoundRobinIndex attempt topic partitionId = 
        let candidateBrokers = 
            brokers 
            |> Seq.filter 
                   (fun (x : Broker) -> 
                   x.LeaderFor 
                   |> Seq.exists 
                          (fun y -> y.TopicName = topic && y.PartitionIds |> Seq.exists (fun id -> id = partitionId)))
        match candidateBrokers |> Seq.length with
        | 0 -> 
            LogConfiguration.Logger.Info.Invoke
                (sprintf "Unable to find broker of %s partition %i... Refreshing metadata..." topic partitionId)
            let (index, brokers) = self.RefreshMetadata(brokers, lastRoundRobinIndex, [| topic |])
            System.Threading.Thread.Sleep(500)
            if attempt < 3 then findBroker brokers index (attempt + 1) topic partitionId
            else Failure(NoBrokerFoundForTopicPartitionException(topic, partitionId))
        | _ -> 
            let broker = candidateBrokers |> Seq.head
            Ok(broker, lastRoundRobinIndex)
    
    let refreshMetadataOnException (brokerRouter : IBrokerRouter) (e : exn) = 
        LogConfiguration.Logger.Info.Invoke
            (sprintf "Unable to send request to broker due to (%s), refreshing metadata." e.Message)
        brokerRouter.RefreshMetadata()
    
    let getBroker (id) = 
        let brokers = router.PostAndReply(fun reply -> GetAllBrokers(reply))
        match brokers |> Seq.tryFind (fun x -> x.Id = id) with
        | Some x -> x
        | None -> 
            LogConfiguration.Logger.Info.Invoke(sprintf "Unable to find broker with id %i" id)
            raise (BrokerNotFound(id))
    
    let getRandomBroker() = 
        match router.PostAndReply(GetRandomBroker) with
        | Some x -> x
        | None -> 
            LogConfiguration.Logger.Warning.Invoke("No brokers available", null)
            raise (NoBrokersAvailable())
    
    do router.Error.Add(fun x -> errorEvent.Trigger(x))
    
    /// Event used in case of unhandled exception in internal agent
    [<CLIEvent>]
    member __.Error = errorEvent.Publish
    
    /// Event triggered when metadata is refreshed
    [<CLIEvent>]
    member __.MetadataRefreshed = metadataRefreshed.Publish
    
    /// Connect the router to the cluster using the broker seeds.
    member __.Connect() = router.PostAndReply(fun reply -> Connect(brokerSeeds, reply))
    
    /// Refresh metadata for the broker cluster
    member private __.RefreshMetadata(brokers, lastRoundRobinIndex, ?topics) = 
        LogConfiguration.Logger.Info.Invoke("Refreshing metadata...")
        let topics = 
            match topics with
            | Some x -> x
            | None -> [||]
        
        let (index, response) = getMetadata brokers 0 lastRoundRobinIndex topics
        
        let getPartitions nodeId = 
            response.TopicMetadata
            |> Seq.map (fun t -> 
                   { TopicName = t.Name
                     PartitionIds = 
                         t.PartitionMetadata
                         |> Seq.filter (fun p -> p.ErrorCode.IsSuccess() && p.Leader = nodeId)
                         |> Seq.map (fun p -> p.PartitionId)
                         |> Seq.toArray })
            |> Seq.toArray
        
        let newBrokers = 
            response.Brokers
            |> Seq.map (fun x -> 
                   ({ Address = x.Host
                      Port = x.Port }, x.NodeId))
            |> Seq.filter (fun (x, _) -> 
                   brokers
                   |> Seq.exists (fun b -> b.EndPoint = x)
                   |> not)
            |> Seq.map (fun (endPoint, nodeId) -> new Broker(nodeId, endPoint, getPartitions nodeId, tcpTimeout))
        
        newBrokers 
        |> Seq.iter (fun x -> 
               try 
                   x.Connect()
               with e -> LogConfiguration.Logger.Warning.Invoke(sprintf "Could not connect to NEW broker %A" x, e))
        let nonExistingBrokers = 
            newBrokers
            |> Seq.filter (fun x -> x.IsConnected)
            |> Seq.toList
        brokers
        |> Seq.filter (fun x -> response.Brokers |> Seq.exists (fun b -> b.NodeId = x.Id))
        |> Seq.iter (fun x -> x.LeaderFor <- getPartitions x.Id)
        let updatedBrokers = 
            [ brokers; nonExistingBrokers ]
            |> Seq.concat
            |> Seq.toList
        metadataRefreshed.Trigger(updatedBrokers)
        (index, updatedBrokers)
    
    /// Get broker by topic and partition id
    member private __.GetBroker(brokers, lastRoundRobinIndex, topic, partitionId) = 
        findBroker brokers lastRoundRobinIndex 0 topic partitionId
    
    /// Add broker to the list of available brokers
    member __.AddBroker(broker : Broker) = 
        raiseIfDisposed (disposed)
        router.Post(AddBroker(broker))
    
    /// Refresh cluster metadata
    member __.RefreshMetadata() = 
        raiseIfDisposed (disposed)
        match router.PostAndReply(fun reply -> RefreshMetadata(reply)) with
        | Ok _ -> ()
        | Failure e -> raise e
    
    /// Get all available brokers
    member __.GetAllBrokers() = 
        raiseIfDisposed (disposed)
        router.PostAndReply(fun reply -> GetAllBrokers(reply))
    
    /// Get broker by topic and partition id
    member __.GetBroker(topic, partitionId) = 
        raiseIfDisposed (disposed)
        match router.PostAndReply(fun reply -> GetBroker(topic, partitionId, reply)) with
        | Ok x -> x
        | Failure e -> raise e
    
    /// Try to send a request to broker handling the specified topic and partition.
    /// If an exception occurs while sending the request, the metadata is refreshed and the request is send again.
    /// If this also fails the exception is thrown and should be handled by the caller.
    member self.TrySendToBroker(topicName, partitionId, request) = 
        let broker = self.GetBroker(topicName, partitionId)
        Retry.retryOnException broker (fun x -> 
            refreshMetadataOnException self x
            self.GetBroker(topicName, partitionId)) (fun x -> x.Send(request))
    
    /// Try to send a request to a random broker.
    /// If an exception is thrown this should be handled by the caller.
    member __.TrySendToBroker(request) = 
        raiseIfDisposed disposed
        let broker = getRandomBroker()
        Retry.retryOnException broker (fun x -> 
            refreshMetadataOnException self x
            getRandomBroker()) (fun x -> x.Send(request))
    
    /// Get all available partitions of the specified topic
    member __.GetAvailablePartitionIds(topicName) = 
        raiseIfDisposed (disposed)
        let brokers = router.PostAndReply(fun reply -> GetAllBrokers(reply))
        brokers
        |> Seq.collect (fun x -> x.LeaderFor)
        |> Seq.filter (fun x -> x.TopicName = topicName)
        |> Seq.collect (fun x -> x.PartitionIds)
        |> Seq.toArray
    
    /// Try to send a request to a specific broker.
    /// If this fails an exception is thrown and should be handled by the caller.
    member __.TrySendToBroker(id, request) = 
        raiseIfDisposed disposed
        let broker = getBroker (id)
        Retry.retryOnException broker (fun x -> 
            refreshMetadataOnException self x
            getBroker (id)) (fun x -> x.Send(request))
    
    /// Dispose the router
    member __.Dispose() = 
        if not disposed then 
            router.Post(Close)
            disposed <- true
    
    interface IDisposable with
        /// Dispose the router
        member self.Dispose() = self.Dispose()
    
    interface IBrokerRouter with
        member self.Connect() = self.Connect()
        member self.GetAllBrokers() = self.GetAllBrokers()
        member self.GetAvailablePartitionIds(topicName) = self.GetAvailablePartitionIds(topicName)
        member self.TrySendToBroker(topicName, partitionId, request) = 
            self.TrySendToBroker(topicName, partitionId, request)
        member self.TrySendToBroker(request) = self.TrySendToBroker(request)
        member self.GetBroker(topic, partitionId) = self.GetBroker(topic, partitionId)
        member self.Error = self.Error
        member self.MetadataRefreshed = self.MetadataRefreshed
        member self.RefreshMetadata() = self.RefreshMetadata()
        member self.TrySendToBroker(id, request) = self.TrySendToBroker(id, request)
