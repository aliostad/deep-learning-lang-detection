module ElectroElephant.MetadataResponse

open ElectroElephant.Common
open ElectroElephant.StreamHelpers
open System.IO

[<StructuralEquality; StructuralComparison>]
type Broker = 
  { node_id : NodeId
    host : Hostname
    port : Port }

[<StructuralEquality; StructuralComparison>]
type PartitionMetadata = 
  { error_code : ErrorCode
    id : PartitionId
    // The node id for the kafka broker currently acting as leader for this 
    // partition. If no leader exists because we are in 
    // the middle of a leader election this id will be -1.
    leader : LeaderId
    // The set of alive nodes that currently acts as slaves for the leader for this partition.
    replicas : ReplicaId list
    //The set subset of the replicas that are "caught up" to the leader
    isr : Isr list }

[<StructuralEquality; StructuralComparison>]
type TopicMetadata = 
  { error_code : ErrorCode
    name : TopicName
    partitions : PartitionMetadata list }

[<StructuralEquality; StructuralComparison>]
type MetadataResponse = 
  { brokers : Broker list
    topic_metadatas : TopicMetadata list }

let private serialize_broker (stream : MemoryStream) broker = 
  stream.write_int<NodeId> (broker.node_id)
  stream.write_str<StringSize> (broker.host)
  stream.write_int<Port> (broker.port)

let private serialize_partition (stream : MemoryStream) (partition : PartitionMetadata) = 
  stream.write_int<ErrorCode> partition.error_code
  stream.write_int<PartitionId> partition.id
  stream.write_int<LeaderId> partition.leader
  stream.write_int_list<ByteArraySize, ReplicaId> partition.replicas
  stream.write_int_list<ByteArraySize, Isr> partition.isr

let private serialize_topic (stream : MemoryStream) topic = 
  stream.write_int<ErrorCode> topic.error_code
  stream.write_str<StringSize> topic.name
  write_array<PartitionMetadata> stream topic.partitions serialize_partition

//  topic.partitions |> List.iter (serialize_partition stream)
/// <summary>
///   Writes the metadata response to the stream in the format
///   <num of brokers><broker1><brokerN><num of topics><topic1><topicN>
/// </summary>
/// <param name="meta_resp">MetadataResponse to be serialized</param>
/// <param name="stream">stream to write serialization to</param>
let serialize meta_resp (stream : MemoryStream) = 
  write_array<Broker> stream meta_resp.brokers serialize_broker
  write_array<TopicMetadata> stream meta_resp.topic_metadatas serialize_topic

//  stream.write_int<ArraySize> meta_resp.brokers.Length
//  meta_resp.brokers |> List.iter (serialize_broker stream)
//  stream.write_int<ArraySize> meta_resp.topic_metadatas.Length
//  meta_resp.topic_metadatas |> List.iter (serialize_topic stream)
let private deserialize_broker (stream : MemoryStream) = 
  { node_id = stream.read_int32<NodeId>()
    host = stream.read_str<StringSize>()
    port = stream.read_int32<Port>() }

let private deserialize_partition_metadata (stream : MemoryStream) = 
  { error_code = stream.read_int16<ErrorCode>()
    id = stream.read_int32<PartitionId>()
    leader = stream.read_int32<LeaderId>()
    replicas = stream.read_int32_list<ByteArraySize, ReplicaId>()
    isr = stream.read_int32_list<ByteArraySize, Isr>() }

let private deserialize_topic_metadata (stream : MemoryStream) = 
  { error_code = stream.read_int16<ErrorCode>()
    name = stream.read_str<StringSize>()
    partitions = read_array<PartitionMetadata> stream deserialize_partition_metadata }

/// <summary>
///  Reads a Metadata Response from the given stream
/// </summary>
/// <param name="stream">stream containing a metadata response</param>
let deserialize (stream : MemoryStream) : MetadataResponse = 
  { brokers = read_array<Broker> stream deserialize_broker
    topic_metadatas = read_array<TopicMetadata> stream deserialize_topic_metadata }