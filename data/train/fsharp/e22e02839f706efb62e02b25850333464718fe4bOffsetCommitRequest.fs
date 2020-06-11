module ElectroElephant.OffsetCommitRequest

open ElectroElephant.Common
open ElectroElephant.StreamHelpers
open System.IO

[<StructuralEquality; StructuralComparison>]
type PartitionOffsetCommit = 
  { partition_id : PartitionId
    partition_offset : Offset
    /// If the time stamp field is set to -1, then the broker sets the 
    /// time stamp to the receive time before committing the offset.
    timestamp : Time
    metadata : Metadata }

[<StructuralEquality; StructuralComparison>]
type TopicOffsetCommit = 
  { topic_name : TopicName
    partition_offset_commit : PartitionOffsetCommit list }

[<StructuralEquality; StructuralComparison>]
type OffsetCommitRequest = 
  { consumer_group : ConsumerGroup
    topic_offset_commit : TopicOffsetCommit list }

let private serialize_partition_commit (stream : MemoryStream) partition_offset = 
  stream.write_int<PartitionId> partition_offset.partition_id
  stream.write_int<Offset> partition_offset.partition_offset
  stream.write_int<Time> partition_offset.timestamp
  stream.write_str<StringSize> partition_offset.metadata

let private serialize_topic_offsets (stream : MemoryStream) topic_offset = 
  stream.write_str<StringSize> topic_offset.topic_name
  stream.write_int<ArraySize> topic_offset.partition_offset_commit.Length
  topic_offset.partition_offset_commit |> List.iter (serialize_partition_commit stream)

/// serializes the OffsetCommitRequest to the given stream
let serialize offset_commit (stream : MemoryStream) = 
  stream.write_str<StringSize> offset_commit.consumer_group
  stream.write_int<ArraySize> offset_commit.topic_offset_commit.Length
  offset_commit.topic_offset_commit |> List.iter (serialize_topic_offsets stream)

let private deserialize_partition_offset (stream : MemoryStream) = 
  { partition_id = stream.read_int32<PartitionId>()
    partition_offset = stream.read_int64<Offset>()
    timestamp = stream.read_int64<Time>()
    metadata = stream.read_str<Metadata>() }

let private deserialize_topic_offset (stream : MemoryStream) = 
  { topic_name = stream.read_str<StringSize>()
    partition_offset_commit = read_array<PartitionOffsetCommit> stream deserialize_partition_offset }

/// deserializes a OffsetCommitRequest from the given stream
let deserialize (stream : MemoryStream) = 
  { consumer_group = stream.read_str<StringSize>()
    topic_offset_commit = read_array<TopicOffsetCommit> stream deserialize_topic_offset }