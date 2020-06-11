module ElectroElephant.Api

open ElectroElephant.Common
open ElectroElephant.Connection
open ElectroElephant.MetadataRequest
open ElectroElephant.MetadataResponse
open ElectroElephant.Model
open ElectroElephant.Request
open ElectroElephant.Response
open ElectroElephant.SocketHelpers
open ElectroElephant.StreamHelpers
open Logary
open Microsoft.FSharp.Core.Operators
open System
open System.Collections.Generic
open System.IO
open System.Net.Sockets
open System.Threading

let logger = Logging.getLoggerByName("EE.API")

/// This should be configurable at some point.
let read_buffer_size = 1024

/// start the correlation id on Zero, this is only interesting on a session basis
let mutable correlation_id = 0

/// get and increment the correlation id, not thread safe currently.
let next_correlation_id() = 
  correlation_id <- correlation_id + 1
  correlation_id

/// This clients sender ID, Should be configurable and correlate to the applications
/// name/type w/e
let get_client_id = "kamils client"

/// Correlate an request type with an ApiKey
let api_key (req_t : RequestTypes) = 
  match req_t with
  | RequestTypes.Metadata _ ->  ApiKeys.MetadataRequest
  | RequestTypes.Produce _ -> ApiKeys.ProduceRequest
  | RequestTypes.Fetch _ ->  ApiKeys.FetchRequest
  | RequestTypes.Offsets _ -> ApiKeys.OffsetRequest
  | RequestTypes.ConsumerMetadata _ -> ApiKeys.ConsumerMetadataRequest
  | RequestTypes.OffsetCommit _ ->  ApiKeys.OffsetCommitRequest
  | RequestTypes.OffsetFetch _ -> ApiKeys.OffsetFetchRequest

/// <summary>
///  Sends a Request to a kafka broker and returns an async handle to the Response.
///  Premises:
///    = Outgoing requests will be buffered in the Socket layer because kafka only accepts one in-flight message at a time.
///      Implications/Simplifications:
///       Once we fire the BeginSend on the socket to the current broker that Request might be waiting in the OS socket layer
///      until kafka starts to accept the next request. Thus directly after we do the BeginSend we can do the BeginReceive because the callback in it
///        will fire as soon as we have data available to read ( that is, kafka has finished processing our request and starts sending the response to us)
///
/// </summary>
/// <param name="req_t">The type of request that we want to transmitt</param>
/// <param name="callback">The callback which should be called when we get a response</param>
/// <param name="topic">which topic the message is for</param>
/// <param name="key">the key decides which partition the message is for</param>
/// <param name="value">what we want to publish</param>
let private send_request<'RequestType> (req_t : RequestTypes) (socket : Socket) : Async<Response> = 
    async {
      Logger.info logger "send_request called"

      let current_correlation_id = next_correlation_id()

      // SHOULD BE MOVE SOMEWHERE ELSE
      let req = 
        { api_version = 0s
          api_key = int16 (api_key req_t)
          correlation_id = current_correlation_id
          client_id = get_client_id
          request_type = req_t }

      // SERIALIZE THE PAYLOAD
      use stream = new MemoryStream()
      ElectroElephant.Request.serialize req stream
      let serialized_request = stream.ToArray()

      // SEND MSG SIZE
      Logger.info logger "sending request size"
      let! bytes_sent_size = socket.AsyncSend (correct_endianess <| BitConverter.GetBytes(serialized_request.Length))
      LogLine.debug "bytes sent" |> LogLine.setData "sent" bytes_sent_size |> logger.Log

      // SEND PAYLOAD
      Logger.info logger "sending request"
      let! bytes_sent_payload = socket.AsyncSend serialized_request
      LogLine.debug "bytes sent" |> LogLine.setData "sent" bytes_sent_payload |> logger.Log

      // RECEIVE PAYLOAD SIZE
      let size_buffer = Array.zeroCreate sizeof<int32>
      let! bytes_received_size = socket.AsyncReceive size_buffer
      LogLine.debug "bytes received" |> LogLine.setData "received" bytes_received_size |> logger.Log
      let payload_size = BitConverter.ToInt32(size_buffer |> correct_endianess, 0)
      LogLine.info "received response size " |> LogLine.setData "size" payload_size |> logger.Log

      // RECEIVE PAYLOAD
      let resp_buffer = Array.zeroCreate payload_size
      let! response_bytes_received = socket.AsyncReceive resp_buffer 

      // DESERIALIZE THE RESPONSE
      LogLine.debug "bytes received" 
        |> LogLine.setData "received" response_bytes_received
        |> logger.Log
      return Response.deserialize (api_key req_t) (new MemoryStream(resp_buffer))
    }

//let do_produce (topic : string) (key : string) (value : byte list) = ()
//let do_fetch (topic : string) (key : string) (offset : Offset) = ()
//let do_offset_commit = ()
//let do_offset_fetch = ()
//let do_offset = ()


//let create_produce_req msg topic partition : ProduceRequest =
  

//let do_produce_request tcp_client msg topic  =
//  async {
//    
//  }

/// <summary>
///   wraps the metaresponse callback so the api will be a bit cleaner.
/// </summary>
/// <param name="orginial">the originial callback</param>
/// <param name="resp">the response gotten from the server</param>
let private unwrapp_metadata (resp : Response) = 
  match resp.response_type with
  | ResponseTypes.Metadata md -> md
  | wrong -> 
    LogLine.error 
      "expected a metadata response, but got another type of response"
    |> LogLine.setData "incorrect response" wrong
    |> Logger.log logger
    failwith "got incorrect response type"

let do_metadata_request 
    (hostname : string) 
    (port : int) 
    (topics : string list option) : Async<MetadataResponse> =
  async{
    //any specific topic that we want to constraint us to?
    let meta_req = 
      match topics with
      | Some tps -> RequestTypes.Metadata({ topic_names = tps })
      | None -> RequestTypes.Metadata({ topic_names = [] })

    Logger.info logger "starting connection"

    let socket = new TcpClient(hostname, port)

    let! result = send_request<MetadataRequest> meta_req socket.Client

    Logger.info logger "waiting for the response.."
    return unwrapp_metadata result
  }
