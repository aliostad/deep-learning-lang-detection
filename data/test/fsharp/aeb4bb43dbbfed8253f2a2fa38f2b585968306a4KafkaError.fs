module Sunergeo.Kafka.KafkaError

open Sunergeo.Logging
open Confluent.Kafka

let toLogLevel
    (errorCode: ErrorCode)
    : LogLevel =
        
    match errorCode with
    | ErrorCode.Local_BadMsg                // Received message is incorrect
    | ErrorCode.Local_BadCompression        // Bad/unknown compression
    | ErrorCode.Local_Fail                  // Generic failure
    | ErrorCode.Local_Transport             // Broker transport failure
    | ErrorCode.Local_CritSysResource       // Critical system resource
    | ErrorCode.Local_Resolve               // Failed to resolve broker
    | ErrorCode.Local_UnknownPartition      // Permanent: Partition does not exist in cluster.
    | ErrorCode.Local_FS                    // File or filesystem error
    | ErrorCode.Local_UnknownTopic          // Permanent: Topic does not exist in cluster.
    | ErrorCode.Local_AllBrokersDown        // All broker connections are down.
    | ErrorCode.Local_InvalidArg            // Invalid argument, or invalid configuration
    | ErrorCode.Local_QueueFull             // Queue is full
    | ErrorCode.Local_IsrInsuff             // ISR count &lt; required.acks
    | ErrorCode.Local_NodeUpdate            // Broker node update
    | ErrorCode.Local_Ssl                   // SSL error
    | ErrorCode.Local_UnknownGroup          // Unknown client group
    | ErrorCode.Local_InProgress            // Operation in progress
    | ErrorCode.Local_PrevInProgress        // Previous operation in progress, wait for it to finish.
    | ErrorCode.Local_ExistingSubscription  // This operation would interfere with an existing subscription
    | ErrorCode.Local_Conflict              // Conflicting use
    | ErrorCode.Local_State                 // Wrong state
    | ErrorCode.Local_UnknownProtocol       // Unknown protocol
    | ErrorCode.Local_NotImplemented        // Not implemented
    | ErrorCode.Local_Authentication        // Authentication failure
    | ErrorCode.Local_Outdated              // Outdated
    | ErrorCode.Local_TimedOutQueue         // Timed out in queue
    | ErrorCode.Local_UnsupportedFeature    // Feature not supported by broker
    | ErrorCode.Local_WaitCache             // Awaiting cache update
    | ErrorCode.Local_Intr                  // Operation interrupted
    | ErrorCode.Local_KeySerialization      // Key serialization error
    | ErrorCode.Local_ValueSerialization    // Value serialization error
    | ErrorCode.Local_KeyDeserialization    // Key deserialization error
    | ErrorCode.Local_ValueDeserialization  // Value deserialization error
    | ErrorCode.Unknown                     // Unknown broker error
    | ErrorCode.BrokerNotAvailable          // Broker not available
    | ErrorCode.ReplicaNotAvailable         // Replica not available
    | ErrorCode.MsgSizeTooLarge             // Message size too large
    | ErrorCode.StaleCtrlEpoch              // StaleControllerEpochCode
    | ErrorCode.OffsetMetadataTooLarge      // Offset metadata string too large
    | ErrorCode.NetworkException            // Broker disconnected before response received
    | ErrorCode.GroupLoadInProress          // Group coordinator load in progress
    | ErrorCode.GroupCoordinatorNotAvailable // Group coordinator not available
    | ErrorCode.NotCoordinatorForGroup      // Not coordinator for group
    | ErrorCode.TopicException              // Invalid topic
    | ErrorCode.RecordListTooLarge          // Message batch larger than configured server segment size
    | ErrorCode.NotEnoughReplicas           // Not enough in-sync replicas
    | ErrorCode.NotEnoughReplicasAfterAppend // Message(s) written to insufficient number of in-sync replicas
    | ErrorCode.InvalidRequiredAcks         // Invalid required acks value
    | ErrorCode.IllegalGeneration           // Specified group generation id is not valid
    | ErrorCode.InconsistentGroupProtocol   // Inconsistent group protocol
    | ErrorCode.InvalidGroupId              // Invalid group.id
    | ErrorCode.UnknownMemberId             // Unknown member
    | ErrorCode.InvalidSessionTimeout       // Invalid session timeout
    | ErrorCode.RebalanceInProgress         // Group rebalance in progress
    | ErrorCode.InvalidCommitOffsetSize     // Commit offset data size is not valid
    | ErrorCode.TopicAuthorizationFailed    // Topic authorization failed
    | ErrorCode.GroupAuthorizationFailed    // Group authorization failed
    | ErrorCode.ClusterAuthorizationFailed  // Cluster authorization failed
    | ErrorCode.InvalidTimestamp            // Invalid timestamp
    | ErrorCode.UnsupportedSaslMechanism    // Unsupported SASL mechanism
    | ErrorCode.IllegalSaslState            // Illegal SASL state
    | ErrorCode.UnsupportedVersion          // Unsupported version
    | ErrorCode.OffsetOutOfRange            // Offset out of range
    | ErrorCode.InvalidMsg                  // Invalid message
    | ErrorCode.UnknownTopicOrPart          // Unknown topic or partition
    | ErrorCode.InvalidMsgSize              // Invalid message size
    | ErrorCode.LeaderNotAvailable          // Leader not available
    | ErrorCode.NotLeaderForPartition ->    // Not leader for partition
        LogLevel.Error

    | ErrorCode.Local_Destroy               // Broker is going away
    | ErrorCode.Local_MsgTimedOut           // Produced message timed out
    | ErrorCode.Local_TimedOut              // Operation timed out
    | ErrorCode.Local_WaitCoord             // Waiting for coordinator to become available.
    | ErrorCode.Local_NoOffset              // No stored offset
    | ErrorCode.RequestTimedOut ->          // Request timed out
        LogLevel.Warning

    | ErrorCode.Local_PartitionEOF          // Reached the end of the topic+partition queue on the broker. Not really an error.
    | ErrorCode.Local_AssignPartitions      // Assigned partitions (rebalance_cb)
    | ErrorCode.Local_RevokePartitions      // Revoked partitions (rebalance_cb)
    | ErrorCode.NoError ->                  // Success
        LogLevel.Information

    | _ ->
        sprintf "%A (%i) not implemented" errorCode (errorCode |> int) |> invalidOp
        


let writeToLog
    (logger: Logger)
    (error: Confluent.Kafka.Error)
    :unit =
        
    let logLevel =
        error.Code |> toLogLevel

    let logMessage = 
        sprintf "Kafka: %A (%i): %s" error.Code (error.Code |> int) error.Reason

    logger logLevel logMessage