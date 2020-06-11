module ElectroElephant.Response

open ElectroElephant.Common
open ElectroElephant.ConsumerMetadataResponse
open ElectroElephant.FetchResponse
open ElectroElephant.MetadataResponse
open ElectroElephant.OffsetCommitResponse
open ElectroElephant.OffsetFetchResponse
open ElectroElephant.OffsetResponse
open ElectroElephant.ProduceResponse
open ElectroElephant.StreamHelpers
open System.IO

type ResponseTypes = 
  | Metadata of MetadataResponse
  | Produce of ProduceResponse
  | Fetch of FetchResponse
  | Offset of OffsetResponse
  | ConsumerMetadata of ConsumerMetadataResponse
  | CommitOffset of OffsetCommitResponse
  | FetchOffset of OffsetFetchResponse

type Response = 
  { // The server passes back whatever integer the client supplied as 
    // the correlation in the request.
    correlation_id : CorrelationId
    response_type : ResponseTypes }

let serialize resp (stream : MemoryStream) = 
  stream.write_int<CorrelationId> resp.correlation_id
  match resp.response_type with
  | ResponseTypes.Metadata m -> 
    ElectroElephant.MetadataResponse.serialize m stream
  | ResponseTypes.Produce p -> 
    ElectroElephant.ProduceResponse.serialize p stream
  | ResponseTypes.Fetch f -> ElectroElephant.FetchResponse.serialize f stream
  | ResponseTypes.Offset o -> ElectroElephant.OffsetResponse.serialize o stream
  | ResponseTypes.ConsumerMetadata cm -> 
    ElectroElephant.ConsumerMetadataResponse.serialize cm stream
  | ResponseTypes.CommitOffset co -> 
    ElectroElephant.OffsetCommitResponse.serialize co stream
  | ResponseTypes.FetchOffset fo -> 
    ElectroElephant.OffsetFetchResponse.serialize fo stream

let deserialize api_key (stream : MemoryStream) = 
  { correlation_id = stream.read_int32<CorrelationId>()
    response_type = 
      match api_key with
      | ApiKeys.MetadataRequest -> 
        ResponseTypes.Metadata
          (ElectroElephant.MetadataResponse.deserialize stream)
      | ApiKeys.ConsumerMetadataRequest -> 
        ResponseTypes.ConsumerMetadata
          (ElectroElephant.ConsumerMetadataResponse.deserialize stream)
      | ApiKeys.FetchRequest -> 
        ResponseTypes.Fetch(ElectroElephant.FetchResponse.deserialize stream)
      | ApiKeys.OffsetCommitRequest -> 
        ResponseTypes.CommitOffset
          (ElectroElephant.OffsetCommitResponse.deserialize stream)
      | ApiKeys.OffsetFetchRequest -> 
        ResponseTypes.FetchOffset
          (ElectroElephant.OffsetFetchResponse.deserialize stream)
      | ApiKeys.OffsetRequest -> 
        ResponseTypes.Offset(ElectroElephant.OffsetResponse.deserialize stream)
      | ApiKeys.ProduceRequest -> 
        ResponseTypes.Produce
          (ElectroElephant.ProduceResponse.deserialize stream)
      | _ -> failwith "shouldn't happen" }