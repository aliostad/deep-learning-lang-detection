module ElectroElephant.ConsumerMetadataRequest

open System.IO

open ElectroElephant.StreamHelpers
open ElectroElephant.Common


/// The offsets for a given consumer group are maintained by a 
/// specific broker called the offset coordinator. i.e., a consumer 
/// needs to issue its offset commit and fetch requests to this 
/// specific broker. It can discover the current offset 
/// coordinator by issuing a consumer metadata request.
[<StructuralEquality;StructuralComparison>]
type ConsumerMetadataRequest =
  {consumer_group : ConsumerGroup}


/// <summary>
///   Serialize the ConsumerMetadataRequest to the given stream
/// </summary>
/// <param name="consumer">the ConsumerGroupRequest to serialize</param>
/// <param name="stream">the stream to serialize it to</param>
let serialize consumer (stream : MemoryStream) =
  stream.write_str<StringSize> consumer.consumer_group

/// <summary>
///   Deserialize a ConsumerMetadataRequest from the given Stream
/// </summary>
/// <param name="stream">stream containing a ConsumerGroupRequest</param>
let deserialize (stream : MemoryStream) =
  { consumer_group = stream.read_str<StringSize> ()}
