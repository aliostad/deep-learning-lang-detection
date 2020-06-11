module ElectroElephant.Common

//===========Fixed Width Primitives==============
//
//int8, int16, int32, int64 
//   Signed integers with the given precision (in bits) stored 
//   in big endian order.
//
//=========Variable Length Primitives============
//
//bytes, string - These types consist of a signed integer 
// giving a length N followed by N bytes of content. 
// A length of -1 indicates null. string uses an int16 
// for its size, and bytes uses an int32.
//
//Arrays
//
//This is a notation for handling repeated structures. These will always be 
//encoded as an int32 size containing the length N followed by N repetitions of 
//the structure which can itself be made up of other primitive types. In the BNF 
//grammars below we will show an array of a structure foo as [foo].
type StringSize = int16

type ByteArraySize = int32

type ArraySize = int32

type MessageSize = int32

type ApiKey = int16

type ApiVersion = int16

type CorrelationId = int32

type ClientId = string

type Offset = int64

type Crc32 = int32

type MagicByte = int8

type MessageAttribute = int8

type MessageKey = byte []

type MessageValue = byte []

type ErrorCode = int16

type TopicName = string

type PartitionId = int32

type LeaderId = int32

type ReplicaId = int32

type Isr = int32

type NodeId = int32

type Hostname = string

type Port = int32

type MaxWaitTime = int32

type MinBytes = int32

type MaxBytes = int32

type RequiredAcks = int16

type Timeout = int32

type MessageSetSize = int32

type Time = int64

type MaxNumberOfOffsets = int32

type ConsumerGroup = string

type CoordinatorId = int32

type Metadata = string


/// Magic Constant, for a magic world!
let MessageMagicByte : MagicByte = 1y

// The following are the numeric codes that 
// the ApiKey in the request can take for each of the above request types.
type ApiKeys = 
  | ProduceRequest          = 0
  | FetchRequest            = 1
  | OffsetRequest           = 2
  | MetadataRequest         = 3
  | OffsetCommitRequest     = 8
  | OffsetFetchRequest      = 9
  | ConsumerMetadataRequest = 10

type ErrorCodes = 
  //No error--it worked!
  | NoError =  0
  // An unexpected server error
  | Unknown = -1
  // The requested offset is outside the range of 
  // offsets maintained by the server for the given topic/partition.
  | OffsetOutOfRange = 1
  // This indicates that a message contents does not match its CRC
  | InvalidMessage = 2
  // This request is for a topic or partition that does not exist on this broker.
  | UnknownTopicOrPartition = 3
  // The message has a negative size
  | InvalidMessageSize = 4
  // This error is thrown if we are in the middle of a leadership 
  // election and there is currently no leader for this partition 
  // and hence it is unavailable for writes.
  | LeaderNotAvailable = 5
  // This error is thrown if the client attempts to send messages 
  // to a replica that is not the leader for some partition. It 
  // indicates that the clients metadata is out of date.
  | NotLeaderForPartition = 6
  // This error is thrown if the request exceeds the 
  // user-specified time limit in the request.
  | RequestTimedOut = 7
  // This is not a client facing error and is used mostly by tools when a broker is not alive.
  | BrokerNotAvailable = 8
  // If replica is expected on a broker, but is not.
  | ReplicaNotAvailable = 9
  // The server has a configurable maximum message size to avoid 
  // unbounded memory allocation. This error is thrown if 
  // the client attempt to produce a message larger than this maximum.
  | MessageSizeTooLarge = 10
  // Internal error code for broker-to-broker communication.
  | StaleControllerEpochCode = 11
  // If you specify a string larger than configured maximum for offset metadata
  | OffsetMetadataTooLargeCode = 12
  // The broker returns this error code for an offset fetch 
  // request if it is still loading offsets (after a leader 
  // change for that offsets topic partition).
  | OffsetsLoadInProgressCode = 14
  // The broker returns this error code for consumer metadata 
  // requests or offset commit requests if the 
  // offsets topic has not yet been created.
  | ConsumerCoordinatorNotAvailableCode = 15
  // The broker returns this error code if it receives an offset 
  // fetch or commit request for a consumer group 
  // that it is not a coordinator for.
  | NotCoordinatorForConsumerCode = 16