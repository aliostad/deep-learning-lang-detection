namespace Nata.IO.Kafunk

open Kafunk

module Error =

    type Code = int16

    exception UnknownException of Code
    exception OffsetOutOfRangeException
    exception InvalidMessageException
    exception UnknownTopicOrPartitionException
    exception InvalidMessageSizeException
    exception LeaderNotAvailableException
    exception NotLeaderForPartitionException
    exception RequestTimedOutException
    exception BrokerNotAvailableException
    exception ReplicaNotAvailableException
    exception MessageSizeTooLargeException
    exception StaleControllerEpochCodeException
    exception OffsetMetadataTooLargeCodeException
    exception GroupLoadInProgressCodeException
    exception GroupCoordinatorNotAvailableCodeException
    exception NotCoordinatorForGroupCodeException
    exception InvalidTopicCodeException
    exception RecordListTooLargeCodeException
    exception NotEnoughReplicasCodeException
    exception NotEnoughReplicasAfterAppendCodeException
    exception InvalidRequiredAcksCodeException
    exception IllegalGenerationCodeException
    exception InconsistentGroupProtocolCodeException
    exception InvalidGroupIdCodeException
    exception UnknownMemberIdCodeException
    exception InvalidSessionTimeoutCodeException
    exception RebalanceInProgressCodeException
    exception InvalidCommitOffsetSizeCodeException
    exception TopicAuthorizationFailedCodeException
    exception GroupAuthorizationFailedCodeException
    exception ClusterAuthorizationFailedCodeException

    let check : ErrorCode -> exn = function
        | 1s -> OffsetOutOfRangeException
        | 2s -> InvalidMessageException
        | 3s -> UnknownTopicOrPartitionException
        | 4s -> InvalidMessageSizeException
        | 5s -> LeaderNotAvailableException
        | 6s -> NotLeaderForPartitionException
        | 7s -> RequestTimedOutException
        | 8s -> BrokerNotAvailableException
        | 9s -> ReplicaNotAvailableException
        | 10s -> MessageSizeTooLargeException
        | 11s -> StaleControllerEpochCodeException
        | 12s -> OffsetMetadataTooLargeCodeException
        | 14s -> GroupLoadInProgressCodeException
        | 15s -> GroupCoordinatorNotAvailableCodeException
        | 16s -> NotCoordinatorForGroupCodeException
        | 17s -> InvalidTopicCodeException
        | 18s -> RecordListTooLargeCodeException
        | 19s -> NotEnoughReplicasCodeException
        | 20s -> NotEnoughReplicasAfterAppendCodeException
        | 21s -> InvalidRequiredAcksCodeException
        | 22s -> IllegalGenerationCodeException
        | 23s -> InconsistentGroupProtocolCodeException
        | 24s -> InvalidGroupIdCodeException
        | 25s -> UnknownMemberIdCodeException
        | 26s -> InvalidSessionTimeoutCodeException
        | 27s -> RebalanceInProgressCodeException
        | 28s -> InvalidCommitOffsetSizeCodeException
        | 29s -> TopicAuthorizationFailedCodeException
        | 30s -> GroupAuthorizationFailedCodeException
        | 31s -> ClusterAuthorizationFailedCodeException
        | ec -> UnknownException ec