module ElectroElephant.OffsetRequest

open ElectroElephant.Common
open ElectroElephant.StreamHelpers
open System.IO

[<StructuralEquality; StructuralComparison>]
type PartitionFetchRequestData = 
  { partition_id : PartitionId
    /// Used to ask for all messages before a certain time (ms). There 
    /// are two special values. 
    /// Specify: 
    ///  -1 to receive the latest offset (i.e. the 
    ///     offset of the next coming message) and 
    ///  -2 to receive the earliest available offset. 
    ///     Note that because offsets are pulled in descending order, 
    ///     asking for the earliest offset will always return you 
    ///     a single element.
    time : Time
    max_number_of_offsets : MaxNumberOfOffsets }

[<StructuralEquality; StructuralComparison>]
type TopicOffsetRequestData = 
  { /// name of the topic
    topic_name : TopicName
    partition_fetch_data : PartitionFetchRequestData list }

[<StructuralEquality; StructuralComparison>]
type OffsetRequest = 
  { /// The replica id indicates the node id of the replica initiating this 
    /// request. Normal client consumers should always specify 
    /// this as -1 as they have no node id. Other brokers set 
    /// this to be their own node id. The value -2 is accepted 
    /// to allow a non-broker to issue fetch requests as if it
    /// were a replica broker for debugging purposes.
    replica_id : ReplicaId
    topic_offset_data : TopicOffsetRequestData list }

let private serialize_partition_data (stream : MemoryStream) partition = 
  stream.write_int<PartitionId> partition.partition_id
  stream.write_int<Time> partition.time
  stream.write_int<MaxNumberOfOffsets> partition.max_number_of_offsets

let private serialize_topic_data (stream : MemoryStream) topic = 
  stream.write_str<StringSize> topic.topic_name
  stream.write_int<ArraySize> topic.partition_fetch_data.Length
  topic.partition_fetch_data |> List.iter (serialize_partition_data stream)

/// <summary>
///   Serialize a OffsetRequest to the given stream
/// </summary>
/// <param name="offset_req">the OffsetRequest to serialize</param>
/// <param name="stream">the stream to serialize to</param>
let serialize offset_req (stream : MemoryStream) = 
  stream.write_int<ReplicaId> offset_req.replica_id
  stream.write_int<ArraySize> offset_req.topic_offset_data.Length
  offset_req.topic_offset_data |> List.iter (serialize_topic_data stream)

let private deserialize_partition_data (stream : MemoryStream) = 
  { partition_id = stream.read_int32<PartitionId>()
    time = stream.read_int64<Time>()
    max_number_of_offsets = stream.read_int32<MaxNumberOfOffsets>() }

let private deserialize_topic_data (stream : MemoryStream) = 
  { topic_name = stream.read_str<StringSize>()
    partition_fetch_data = read_array<PartitionFetchRequestData> stream deserialize_partition_data }

/// <summary>
///  Deserialize a OffsetRequest from the given stream
/// </summary>
/// <param name="stream">stream containing a OffsetRequest</param>
let deserialize (stream : MemoryStream) = 
  { replica_id = stream.read_int32<ReplicaId>()
    topic_offset_data = read_array<TopicOffsetRequestData> stream deserialize_topic_data }