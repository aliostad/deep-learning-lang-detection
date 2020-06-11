module ElectroElephant.Request

open ElectroElephant.Common
open ElectroElephant.ConsumerMetadataRequest
open ElectroElephant.FetchRequest
open ElectroElephant.MetadataRequest
open ElectroElephant.OffsetCommitRequest
open ElectroElephant.OffsetFetchRequest
open ElectroElephant.OffsetRequest
open ElectroElephant.ProduceRequest
open ElectroElephant.StreamHelpers
open System.IO

type RequestTypes = 
  /// Describes the currently available brokers, their host and port information,
  /// and gives information about which broker hosts which partitions.
  | Metadata of MetadataRequest
  /// Send messages to a broker
  | Produce of ProduceRequest
  /// Fetch messages from a broker, one which fetches data, one which
  /// gets cluster metadata, and one which gets offset information about a topic.
  | Fetch of FetchRequest
  /// Get information about the available offsets for a given topic partition.
  | Offsets of OffsetRequest
  /// Gets the metadata for the commit broker.
  | ConsumerMetadata of ConsumerMetadataRequest
  /// Commit a set of offsets for a consumer group
  | OffsetCommit of OffsetCommitRequest
  /// Fetch a set of offsets for a consumer group
  | OffsetFetch of OffsetFetchRequest

type Request = 
  { /// This is a numeric id for the API being invoked (i.e. is it a 
    /// metadata request, a produce request, a fetch request, etc).
    api_key : ApiKey
    /// This is a numeric version number for this api. We version each 
    /// API and this version number allows the server to properly interpret
    /// the request as the protocol evolves. Responses will always be in 
    /// the format corresponding to the request version. 
    /// Currently the supported version for all APIs is 0.
    api_version : ApiVersion
    /// This is a user-supplied integer. It will be passed back in the response
    /// by the server, unmodified. It is useful for matching request and 
    /// response between the client and server.
    correlation_id : CorrelationId
    /// This is a user supplied identifier for the client application. The user 
    /// can use any identifier they like and it will be used when logging
    /// errors, monitoring aggregates, etc. For example, one might want to 
    /// monitor not just the requests per second overall, but the number 
    /// coming from each client application (each of which could reside on 
    /// multiple servers). This id acts as a logical grouping across all requests from a particular client.
    client_id : ClientId
    /// which API this request targets.
    request_type : RequestTypes }

let serialize req (stream : MemoryStream) = 
  stream.write_int<ApiKey> req.api_key
  stream.write_int<ApiVersion> req.api_version
  stream.write_int<CorrelationId> req.correlation_id
  stream.write_str<StringSize> req.client_id
  match req.request_type with
  | Metadata m -> ElectroElephant.MetadataRequest.serialize m stream
  | Produce s -> ElectroElephant.ProduceRequest.serialize s stream
  | Fetch f -> ElectroElephant.FetchRequest.serialize f stream
  | Offsets o -> ElectroElephant.OffsetRequest.serialize o stream
  | ConsumerMetadata c -> 
    ElectroElephant.ConsumerMetadataRequest.serialize c stream
  | OffsetCommit o -> ElectroElephant.OffsetCommitRequest.serialize o stream
  | OffsetFetch o -> ElectroElephant.OffsetFetchRequest.serialize o stream

let deserialize (stream : MemoryStream) = 
  let api_key = enum<ApiKeys> (stream.read_int32<ApiKey>())
  let api_version = stream.read_int16<ApiVersion>()
  let correlation_id = stream.read_int32<CorrelationId>()
  let client_id = stream.read_str<StringSize>()
  
  let req_type = 
    match api_key with
    | ApiKeys.ProduceRequest -> 
      RequestTypes.Produce(ElectroElephant.ProduceRequest.deserialize stream)
    | ApiKeys.FetchRequest -> 
      RequestTypes.Fetch(ElectroElephant.FetchRequest.deserialize stream)
    | ApiKeys.OffsetRequest -> 
      RequestTypes.Offsets(ElectroElephant.OffsetRequest.deserialize stream)
    | ApiKeys.MetadataRequest -> 
      RequestTypes.Metadata(ElectroElephant.MetadataRequest.deserialize stream)
    | ApiKeys.OffsetCommitRequest -> 
      RequestTypes.OffsetCommit
        (ElectroElephant.OffsetCommitRequest.deserialize stream)
    | ApiKeys.OffsetFetchRequest -> 
      RequestTypes.OffsetFetch
        (ElectroElephant.OffsetFetchRequest.deserialize stream)
    | ApiKeys.ConsumerMetadataRequest -> 
      RequestTypes.ConsumerMetadata
        (ElectroElephant.ConsumerMetadataRequest.deserialize stream)
    | x -> failwith "shouldnt happen!!"
  { api_key = int16 api_key
    api_version = api_version
    correlation_id = correlation_id
    client_id = client_id
    request_type = req_type }
