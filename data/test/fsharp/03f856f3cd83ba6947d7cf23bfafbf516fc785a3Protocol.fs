namespace FsKafka.Protocol

module Common =
  (* For protocol description please refer to https://cwiki.apache.org/confluence/display/KAFKA/A+Guide+To+The+Kafka+Protocol
     New protocol generated from code: http://kafka.apache.org/protocol.html *)
  type Errors =
    | Unknown                      = -1s // The server experienced an unexpected error when processing the request
    | NoError                      =  0s // No errors
    | OffsetOutOfRange             =  1s // The requested offset is not within the range of offsets maintained by the server.
    | CorruptMessage               =  2s // The message contents does not match the message CRC or the message is otherwise corrupt.
    | UnknownTopicOrPartition      =  3s // This server does not host this topic-partition.
    | LeaderNotAvailable           =  5s // There is no leader for this topic-partition as we are in the middle of a leadership election.
    | NotLeaderForPartition        =  6s // This server is not the leader for that topic-partition.
    | RequestTimedOut              =  7s // The request timed out.
    | BrokerNotAvailable           =  8s // The broker is not available.
    | ReplicaNotAvailable          =  9s // The replica is not available for the requested topic-partition
    | MessageTooLarge              = 10s // The request included a message larger than the max message size the server will accept.
    | StaleControllerEpoch         = 11s // The controller moved to another broker.
    | OffsetMetadataTooLarge       = 12s // The metadata field of the offset request was too large.
    | NetworkException             = 13s // The server disconnected before a response was received.
    | GroupLoadInProgress          = 14s // The coordinator is loading and hence can't process requests for this group.
    | GroupCoordinatorNotAvailable = 15s // The group coordinator is not available.
    | NotCoordinatorForGroup       = 16s // This is not the correct coordinator for this group.
    | InvalidTopicException        = 17s // The request attempted to perform an operation on an invalid topic.
    | RecordListTooLarge           = 18s // The request included message batch larger than the configured segment size on the server.
    | NotEnoughReplicas            = 19s // Messages are rejected since there are fewer in-sync replicas than required.
    | NotEnoughReplicasAfterAppend = 20s // Messages are written to the log, but to fewer in-sync replicas than required.
    | InvalidRequiredAcks          = 21s // Produce request specified an invalid value for required acks.
    | IllegalGeneration            = 22s // Specified group generation id is not valid.
    | InconsistentGroupProtocol    = 23s // The group member's supported protocols are incompatible with those of existing members.
    | InvalidGroupId               = 24s // The configured groupId is invalid
    | UnknownMemberId              = 25s // The coordinator is not aware of this member.
    | InvalidSessionTimeout        = 26s // The session timeout is not within an acceptable range.
    | RebalanceInProgress          = 27s // The group is rebalancing, so a rejoin is needed.
    | InvalidCommitOffsetSize      = 28s // The committing offset data size is not valid
    | TopicAuthorizationFailed     = 29s // Topic authorization failed.
    | GroupAuthorizationFailed     = 30s // Group authorization failed.
    | ClusterAuthorizationFailed   = 31s // Cluster authorization failed.
  
  let isRetriable = function
    | Errors.Unknown                      -> false
    | Errors.NoError                      -> false
    | Errors.OffsetOutOfRange             -> false
    | Errors.CorruptMessage               -> true
    | Errors.UnknownTopicOrPartition      -> true
    | Errors.LeaderNotAvailable           -> true
    | Errors.NotLeaderForPartition        -> true
    | Errors.RequestTimedOut              -> true
    | Errors.BrokerNotAvailable           -> false
    | Errors.ReplicaNotAvailable          -> false
    | Errors.MessageTooLarge              -> false
    | Errors.StaleControllerEpoch         -> false
    | Errors.OffsetMetadataTooLarge       -> false
    | Errors.NetworkException             -> true
    | Errors.GroupLoadInProgress          -> true
    | Errors.GroupCoordinatorNotAvailable -> true
    | Errors.NotCoordinatorForGroup       -> true
    | Errors.InvalidTopicException        -> false
    | Errors.RecordListTooLarge           -> false
    | Errors.NotEnoughReplicas            -> true
    | Errors.NotEnoughReplicasAfterAppend -> true
    | Errors.InvalidRequiredAcks          -> false
    | Errors.IllegalGeneration            -> false
    | Errors.InconsistentGroupProtocol    -> false
    | Errors.InvalidGroupId               -> false
    | Errors.UnknownMemberId              -> false
    | Errors.InvalidSessionTimeout        -> false
    | Errors.RebalanceInProgress          -> false
    | Errors.InvalidCommitOffsetSize      -> false
    | Errors.TopicAuthorizationFailed     -> false
    | Errors.GroupAuthorizationFailed     -> false
    | Errors.ClusterAuthorizationFailed   -> false
    | _                                   -> false
  
  let toError = Microsoft.FSharp.Core.LanguagePrimitives.EnumOfValue<int16, Errors>
    
  type MessageCodec =
    | None   = 0x00
    | GZIP   = 0x01
    | Snappy = 0x02
    
  open FsKafka.Pickle
  
  exception UnsupportedCompressionException of MessageCodec
  
  let compress data = function
    | MessageCodec.None   -> data
    | MessageCodec.GZIP   -> FsKafka.Compression.gzipCompress data
    | MessageCodec.Snappy -> FsKafka.Compression.snappyCompress data
    | codec               -> raise <| UnsupportedCompressionException codec
    
  type Message =
    { Crc        : int32
      MagicByte  : int8
      Attributes : MessageCodec
      //Timestamp  : int64 - from kafka 0.10
      Key        : byte[]
      Value      : byte[] }
    with static member Create(version, codec, key, value) =(* ?timestamp, ?timestampType *)
           { Crc        = 0
             MagicByte  = version
             Attributes = codec
             //Timestamp  = timestamp
             Key        = key
             Value      = value }
         static member Pickler(m) =
           let messageDataPickler m =
             (pInt8   m.MagicByte) >>
             (pInt8  (m.Attributes |> int8)) >>
             (pBytes  m.Key) >>
             (pBytes (compress m.Value m.Attributes))
           let messageData = encode messageDataPickler m
           let crc = FsKafka.Crc32.calculate messageData |> int32
           (pInt32 crc) >> (pUnit messageData)
           
  type MessageSetItem =
    { Offset      : int64
      MessageSize : int32
      Message     : Message }
    with static member Create(message, ?offset) =
           { Offset      = defaultArg offset 0L
             MessageSize = 0
             Message     = message }
         static member Pickler(entry) =
           (pInt64          entry.Offset) >>
           (pInt32          entry.MessageSize) >>
           (Message.Pickler entry.Message)
           
  type MessageSet =
    { Data : MessageSetItem seq }
    with static member Create(entries) =
           { Data = entries}
         static member Pickler(messageSet:MessageSet) =
           fun s -> Seq.fold(fun s e -> (MessageSetItem.Pickler e) s) s messageSet.Data
  
module Requests =
  open Common
  open FsKafka.Pickle

  (* ========= Produce request ========= *)
  type TopicPartitionData =
    { Partition : int32
      RecordSet : byte[] }
    with static member Create(partition, recordSet) =
           { Partition = partition
             RecordSet = recordSet }
         static member Pickler(r:TopicPartitionData) =
           (pInt32 r.Partition) >>
           (pBytes r.RecordSet)
           
  type TopicData =
    { Topic : string
      Data  : TopicPartitionData list }
    with static member Create(topic, data) =
           { Topic = topic
             Data  = data }
         static member Pickler(r:TopicData) =
           (pString                          r.Topic) >>
           (pList TopicPartitionData.Pickler r.Data)
           
  type ProduceRequest =
    { RequiredAcks : int16
      Timeout      : int32
      TopicsData   : TopicData list }
    with static member Create(acks, timeout, data) =
           { RequiredAcks = acks
             Timeout      = timeout
             TopicsData   = data }
         static member Pickler(r:ProduceRequest) =
           (pInt16                  r.RequiredAcks) >>
           (pInt32                  r.Timeout) >>
           (pList TopicData.Pickler r.TopicsData)
    
  (* ========= Metadata request ========= *)
  type MetadataRequest =
    { Topics : string list }
    with static member Create(topics) =
           { Topics = topics }
         static member Pickler(r:MetadataRequest) =
           pList pString r.Topics

  (* ========= GroupCoordinator request ========= *)
  type GroupCoordinatorRequest =
    { GroupId : string }
    with static member Create(groupId) =
           { GroupId = groupId }
         static member Pickler(r:GroupCoordinatorRequest) =
           pString r.GroupId
  
  (* ========= JoinGroup request ========= *)
  type ProtocolMetadata =
    { Version      : int16
      Subscription : string list
      UserData     : byte[] } // no idea where to use :)
    with static member Create(version, subscription, data) =
           { Version      = version
             Subscription = subscription
             UserData     = data }
         static member Pickler(r:ProtocolMetadata) =
           (pInt16        r.Version) >>
           (pList pString r.Subscription) >>
           (pBytes        r.UserData)
           
  type GroupProtocol =
    { ProtocolName     : string
      ProtocolMetadata : byte[] }
    with static member Create(name, data) =
           { ProtocolName     = name
             ProtocolMetadata = data }
         static member Pickler(r:GroupProtocol) =
           (pString r.ProtocolName) >>
           (pBytes  r.ProtocolMetadata)
           
  type JoinGroupRequest =
    { GroupId        : string
      SessionTimeout : int32
      MemberId       : string
      ProtocolType   : string
      GroupProtocols : GroupProtocol list }
    with static member Create(groupId, timeout, memberId, protocol, protocols) =
           { GroupId        = groupId
             SessionTimeout = timeout
             MemberId       = memberId
             ProtocolType   = protocol
             GroupProtocols = protocols }
         static member Pickler(r:JoinGroupRequest) =
           (pString                     r.GroupId) >>
           (pInt32                      r.SessionTimeout) >>
           (pString                     r.MemberId) >>
           (pString                     r.ProtocolType) >>
           (pList GroupProtocol.Pickler r.GroupProtocols)

  type RequestType =
    | Produce            of ProduceRequest // v0, v1 - from 0.9.0, v2 - from 0.10.0
    //| Fetch              of FetchRequest
    //| Offsets            of OffsetsRequest
    | Metadata           of MetadataRequest
    //| LeaderAndIsr       of LeaderAndIsrRequest
    //| StopReplica        of StopReplicaRequest
    //| UpdateMetadata     of UpdateMetadataRequest
    //| ControlledShutdown of ControlledShutdownRequest
    //| OffsetCommit       of OffsetCommitRequest
    //| OffsetFetch        of OffsetFetchRequest
    | GroupCoordinator   of GroupCoordinatorRequest
    | JoinGroup          of JoinGroupRequest
    //| Heartbeat          of HeartbeatRequest
    //| LeaveGroup         of LeaveGroupRequest
    //| SyncGroup          of SyncGroupRequest
    //| DescribeGroups     of DescribeGroupsRequest
    //| ListGroups         of ListGroupsRequest
    
  let toPickler = function
    | Produce            r -> ProduceRequest.Pickler r
    //| Fetch              r -> FetchRequest.Pickler r
    //| Offsets            r -> OffsetsRequest.Pickler r
    | Metadata           r -> MetadataRequest.Pickler r
    //| LeaderAndIsr       r -> LeaderAndIsrRequest.Pickler r
    //| StopReplica        r -> StopReplicaRequest.Pickler r
    //| UpdateMetadata     r -> UpdateMetadataRequest.Pickler r
    //| ControlledShutdown r -> ControlledShutdownRequest.Pickler r
    //| OffsetCommit       r -> OffsetCommitRequest.Pickler r
    //| OffsetFetch        r -> OffsetFetchRequest.Pickler r
    | GroupCoordinator   r -> GroupCoordinatorRequest.Pickler r
    | JoinGroup          r -> JoinGroupRequest.Pickler r
    //| Heartbeat          r -> HeartbeatRequest.Pickler r
    //| LeaveGroup         r -> LeaveGroupRequest.Pickler r
    //| SyncGroup          r -> SyncGroupRequest.Pickler r
    //| DescribeGroups     r -> DescribeGroupsRequest.Pickler r
    //| ListGroups         r -> ListGroupsRequest.Pickler r
    
  let toApiKey = function
    | Produce            _ ->  0s
    //| Fetch              _ ->  1s
    //| Offsets            _ ->  2s
    | Metadata           _ ->  3s
    //| LeaderAndIsr       _ ->  4s
    //| StopReplica        _ ->  5s
    //| UpdateMetadata     _ ->  6s
    //| ControlledShutdown _ ->  7s
    //| OffsetCommit       _ ->  8s
    //| OffsetFetch        _ ->  9s
    | GroupCoordinator   _ -> 10s
    | JoinGroup          _ -> 11s
    //| Heartbeat          _ -> 12s
    //| LeaveGroup         _ -> 13s
    //| SyncGroup          _ -> 14s
    //| DescribeGroups     _ -> 15s
    //| ListGroups         _ -> 16s
    
  type RequestMessage =
    { ApiKey        : int16
      ApiVersion    : int16
      CorrelationId : int32
      ClientId      : string
      Message       : RequestType }
    with static member Create(apiKey, apiVersion, correlationId, clientId, message) =
           { ApiKey        = apiKey
             ApiVersion    = apiVersion
             CorrelationId = correlationId
             ClientId      = clientId
             Message       = message }
         static member Pickler(r:RequestMessage) =
           ( pInt16    r.ApiKey ) >>
           ( pInt16    r.ApiVersion ) >>
           ( pInt32    r.CorrelationId ) >>
           ( pString   r.ClientId ) >>
           ( toPickler r.Message )
    
module Responses =
  open Common
  open FsKafka.Common
  open FsKafka.Unpickle

  (* ========= Produce response ========= *)
  type TopicData =
    { Partition : int32
      ErrorCode : Errors
      Offset    : int64
      (*Timestamp : int64 // v2*) }
    with static member Unpickler(stream) = unpickle {
           let! (partition, stream) = upInt32 stream
           let! (errorCode, stream) = upInt16 stream
           let! (offset,    stream) = upInt64 stream
           //let! (timestamp, stream) = upInt64 stream
           return { Partition = partition
                    ErrorCode = errorCode |> toError
                    Offset    = offset
                    (*Timestamp = timestamp*) }, stream }
                    
  type ProduceResponseItem =
    { TopicName : string
      TopicData : TopicData list }
    with static member Unpickler(stream) = unpickle {
           let! (name,     stream) = upString                   stream
           let! (payloads, stream) = upList TopicData.Unpickler stream
           return { TopicName = name
                    TopicData = payloads }, stream }
                    
  type ProduceResponse =
    { Responses    : ProduceResponseItem list
      ThrottleTime : int32 (* v1 && v2 *) }
    with static member Unpickler(stream) = unpickle {
           let! (responses,    stream) = upList ProduceResponseItem.Unpickler stream
           let! (throttleTime, stream) = upInt32                              stream
           return { Responses    = responses
                    ThrottleTime = throttleTime }, stream }
       
  (* ========= Metadata response ========= *)
  type Broker =
    { NodeId : int32
      Host   : string
      Port   : int32 }
    with static member Unpickler(stream) = unpickle {
           let! (nodeId, stream) = upInt32  stream
           let! (host,   stream) = upString stream
           let! (port,   stream) = upInt32  stream
           return { NodeId = nodeId
                    Host   = host
                    Port   = port }, stream }
                    
  type PartitionMetadata =
    { ErrorCode   : Errors
      PartitionId : int32
      Leader      : int32
      Replicas    : int32 list
      Isr         : int32 list }
    with static member Unpickler(stream) = unpickle {
           let! (errorCode,   stream) = upInt16        stream
           let! (partitionId, stream) = upInt32        stream
           let! (leader,      stream) = upInt32        stream
           let! (replicas,    stream) = upList upInt32 stream
           let! (isr,         stream) = upList upInt32 stream
           return { ErrorCode   = errorCode |> toError
                    PartitionId = partitionId
                    Leader      = leader
                    Replicas    = replicas
                    Isr         = isr }, stream }
                    
  type TopicMetadata =
    { ErrorCode          : Errors
      Topic              : string
      PartitionsMetadata : PartitionMetadata list }
    with static member Unpickler(stream) = unpickle {
           let! (errorCode,  stream) = upInt16                            stream
           let! (name,       stream) = upString                           stream
           let! (partitions, stream) = upList PartitionMetadata.Unpickler stream
           return { ErrorCode          = errorCode |> toError
                    Topic              = name
                    PartitionsMetadata = partitions }, stream }
  type MetadataResponse =
    { Brokers        : Broker list
      TopicsMetadata : TopicMetadata list }
    with static member Unpickler(stream) = unpickle {
           let! (brokers,        stream) = upList Broker.Unpickler        stream
           let! (topicsMetadata, stream) = upList TopicMetadata.Unpickler stream
           return { Brokers        = brokers
                    TopicsMetadata = topicsMetadata }, stream }

  (* ========= GroupCoordinator response ========= *)
  type GroupCoordinatorResponse =
    { ErrorCode          : Errors
      Coordinator        : Broker }
    with static member Unpickler(stream) = unpickle {
           let! (errorCode, stream) = upInt16          stream
           let! (broker,    stream) = Broker.Unpickler stream
           return { ErrorCode   = errorCode |> toError
                    Coordinator = broker }, stream }

  (* ========= JoinGroup response ========= *)
  type GroupMember =
    { MemberId       : string
      MemberMetadata : byte[] }
    with static member Unpickler(stream) = unpickle {
           let! (memberId, stream) = upString stream
           let! (metadata, stream) = upBytes  stream
           return { MemberId       = memberId
                    MemberMetadata = metadata }, stream }
                    
  type JoinGroupResponse =
    { ErrorCode     : Errors
      GenerationId  : int32
      GroupProtocol : string
      LeaderId      : string
      MemberId      : string
      Members       : GroupMember list }
    with static member Unpickler(stream) = unpickle {
           let! (errorCode,     stream) = upInt16                      stream
           let! (generationId,  stream) = upInt32                      stream
           let! (groupProtocol, stream) = upString                     stream
           let! (leaderId,      stream) = upString                     stream
           let! (memberId,      stream) = upString                     stream
           let! (members,       stream) = upList GroupMember.Unpickler stream
           return { ErrorCode     = errorCode |> toError
                    GenerationId  = generationId
                    GroupProtocol = groupProtocol
                    LeaderId      = leaderId
                    MemberId      = memberId
                    Members       = members }, stream }

  type ResponseType =
    | Produce            of ProduceResponse
    //| Fetch              of FetchResponse
    //| Offsets            of OffsetsResponse
    | Metadata           of MetadataResponse
    //| LeaderAndIsr       of LeaderAndIsrResponse
    //| StopReplica        of StopReplicaResponse
    //| UpdateMetadata     of UpdateMetadataResponse
    //| ControlledShutdown of ControlledShutdownResponse
    //| OffsetCommit       of OffsetCommitResponse
    //| OffsetFetch        of OffsetFetchResponse
    | GroupCoordinator   of GroupCoordinatorResponse
    | JoinGroup          of JoinGroupResponse
    //| Heartbeat          of HeartbeatResponse
    //| LeaveGroup         of LeaveGroupResponse
    //| SyncGroup          of SyncGroupResponse
    //| DescribeGroups     of DescribeGroupsResponse
    //| ListGroups         of ListGroupsResponse
    
  type ResponseMessage =
    { CorrelationId : int32
      Message       : ResponseType }
    with static member Create(correlationId, message) =
           { CorrelationId = correlationId
             Message       = message }