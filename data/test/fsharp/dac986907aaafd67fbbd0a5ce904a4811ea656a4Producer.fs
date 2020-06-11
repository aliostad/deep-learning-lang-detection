namespace FsKafka
// https://kafka.apache.org/08/configuration.html
open FsKafka.Common
open FsKafka.Protocol
open FsKafka.Protocol.Common
open FsKafka.Protocol.Requests
open FsKafka.Protocol.Responses
open FsKafka.Logging
open System.Threading

module Producer =
  type ProducerType                 = Sync | Async
  type TopicMetadataRefreshInterval = OnlyOnError | AfterEveryMessage | Scheduled of int
  type RequestRequiredAcks          = None | Leader | All | Special of int16
  let acksToInt16 = function
    | None      -> 0s
    | Leader    -> 1s
    | All       -> -1s
    | Special x -> if x > 1s then x else sprintf "Wrong RequestRequiredAcks: Special(%A)" x |> failwith
  type Compression                  = None | GZip | Snappy
  let compressionToMessageCodec = function
    | None   -> MessageCodec.None
    | GZip   -> MessageCodec.GZIP
    | Snappy -> MessageCodec.Snappy
  type Codec<'T>                    = 'T -> byte[]
  type Partitioner                  = (MetadataProvider.PartitionId * MetadataProvider.Endpoint) list -> string -> byte[] -> (MetadataProvider.PartitionId * MetadataProvider.Endpoint)
  type Message<'T>                  = { Value: 'T; Key: byte[]; Topic: string }
  type Config<'a>                   =
    { RequestRequiredAcks:            RequestRequiredAcks
      ClientId:                       string
      RequestTimeoutMs:               int
      ProducerType:                   ProducerType
      Codec:                          Codec<'a>
      Partitioner:                    Partitioner
      Compression:                    Compression
      CompressedTopics:               string list
      MessageSendMaxRetries:          int
      RetryBackoffMs:                 int
      TopicMetadataRefreshIntervalMs: TopicMetadataRefreshInterval
      BatchBufferingMaxMs:            int
      BatchNumberMessages:            int
      SendBufferBytes:                int
      Log:                            Logger }

  let defaultConfig codec =
    { RequestRequiredAcks            = Leader
      ClientId                       = "FsKafka"
      RequestTimeoutMs               = 10000
      ProducerType                   = Sync
      Codec                          = codec
      Partitioner                    = fun partitions topic key -> System.Linq.Enumerable.First(partitions)
      Compression                    = Compression.None
      CompressedTopics               = []
      MessageSendMaxRetries          = 3
      RetryBackoffMs                 = 100
      TopicMetadataRefreshIntervalMs = OnlyOnError
      BatchBufferingMaxMs            = 5000
      BatchNumberMessages            = 10000
      SendBufferBytes                = 100 * 1024 (* implemented in Connection.T by failing if message is too big *)
      Log                            = defaultLogger Verbose }
  
  type T<'a>(config:Config<'a>, connection:Connection.T, metadata:MetadataProvider.T, ?errorHandler:exn -> unit, ?responseHandler:ResponseMessage -> unit) =
    let verbosef f = verbosef config.Log "FsKafka.Producer" f
    let verbosee   = verbosee config.Log "FsKafka.Producer"
    
    let defaultErrorHandler (exn:exn) : unit =
      verbosee exn "Some fatal exception happened"
      exit(1)
      
    let defaultResponseMessageHandler (message:ResponseMessage) : unit =
      match message.Message with
      | Produce response ->
          response.Responses
          |> List.iter(fun i ->
              i.TopicData
              |> List.iter(fun tp ->
                  if tp.ErrorCode <> Errors.NoError then
                    verbosef (fun f -> f "Produce messages for topic:%s, partition:%i failed with %A" i.TopicName tp.Partition tp.ErrorCode) ) )
      | _ -> ()

    let errorEvent = new Event<exn>()
    let handleResponse =
      match responseHandler with
      | Some handler -> handler
      | Option.None  -> defaultResponseMessageHandler
      
    let batchAgent = BatchAgent<Message<'a>>(config.BatchNumberMessages, config.BatchBufferingMaxMs)
    
    let toMessageSet topic (partition, messages) =
      let messageSet =
        messages
        |> Seq.map(fun (_,_,m) -> m.Key, m.Value |> config.Codec)
        |> List.ofSeq
        |> Optics.mkMessageSet MessageCodec.None
      let compression =
        if config.CompressedTopics |> List.exists((=) topic)
        then config.Compression |> compressionToMessageCodec
        else MessageCodec.None
      partition, Optics.encodeMessageSet compression messageSet

    let toTopicPayload (topic, messages) =
      let payload =
        messages
        |> Seq.groupBy (fun (_,p,_) -> p)
        |> Seq.map (toMessageSet topic)
        |> List.ofSeq
      topic, payload

    let readResponse = config.RequestRequiredAcks <> RequestRequiredAcks.None

    let produceRequest messages =
      messages
      |> Seq.groupBy(fun (_, _, m) -> m.Topic)
      |> Seq.map toTopicPayload
      |> List.ofSeq
      |> Optics.produce config.ClientId (config.RequestRequiredAcks |> acksToInt16) config.RequestTimeoutMs

    let rec writeBatchToBroker attempt (endpoint, batch:(_ * int * Message<'a>) seq) = async {
      let (host, port) = endpoint
      let request = produceRequest batch
      let! writeResult = connection.SendAsync(endpoint, request, readResponse)
      match writeResult with
      | Success result ->
          verbosef (fun f -> f "Batch sent to Host=%s, Port=%i, BatchSize=%i, Response=%A" host port (batch |> Seq.length) result)
          match result with
          | Some response -> handleResponse response
          | _             -> ()
      | Failure error  ->
          verbosee error (sprintf "Batch failed on Host=%s, Port=%i, BatchSize=%i" host port (batch |> Seq.length))
          if attempt > config.MessageSendMaxRetries then
            verbosef (fun f -> f "Reached max send retries for %A:%A" endpoint (batch |> List.ofSeq))
          else
            metadata.RefreshMetadata []
            do! Async.Sleep config.RetryBackoffMs
            return! writeBatchToBroker (attempt + 1) (endpoint, batch) }
             
    let rec syncWriteBatchToBroker attempt (endpoint, batch:(_ * int * Message<'a>) seq) =
      let (host, port) = endpoint
      let request = produceRequest batch
      let writeResult = connection.Send(endpoint, request, readResponse)
      match writeResult with
      | Success r ->
          verbosef (fun f -> f "Batch sent to Host=%s, Port=%i, BatchSize=%i, Response=%A" host port (batch |> Seq.length) r)
          match r with
          | Some response -> handleResponse response
          | _             -> ()
      | Failure e ->
          verbosee e (sprintf "Batch failed on Host=%s, Port=%i, BatchSize=%i" host port (batch |> Seq.length))
          if attempt > config.MessageSendMaxRetries then
            verbosef (fun f -> f "Reached max send retries for %A:%A" endpoint (batch |> List.ofSeq))
          else
            metadata.RefreshMetadata []
            Thread.Sleep config.RetryBackoffMs
            syncWriteBatchToBroker (attempt + 1) (endpoint, batch)

    let addBrokerData message =
      try
        match metadata.BrokersFor message.Topic with
        | Success (_, brokers) ->
            let (MetadataProvider.PartitionId partitionId, endpoint) = config.Partitioner brokers message.Topic message.Key
            Some(endpoint, partitionId, message)
        | Failure err          ->
            verbosee err (sprintf "Failed to retrieve brokers for Topic=%s" message.Topic )
            Option.None
      with exn -> errorEvent.Trigger(exn); Option.None

    let writeBatch (batch:Message<'a> seq) =
      let data = batch |> Seq.map addBrokerData
      if data |> Seq.exists Option.isNone then async {()}
      else
        data
        |> Seq.map Option.get
        |> Seq.groupBy (fun (endpoint, _, _) -> endpoint)
        |> Seq.map (writeBatchToBroker 0)
        |> Async.Parallel
        |> Async.Ignore
        
    let syncSend (batch:Message<'a> seq) =
      let data = batch |> Seq.map addBrokerData
      if data |> Seq.exists Option.isNone then ()
      else
        data
        |> Seq.map Option.get
        |> Seq.groupBy (fun (endpoint, _, _) -> endpoint)
        |> Seq.iter (syncWriteBatchToBroker 0)

    let refreshMetadataIfRequired () =
      match config.TopicMetadataRefreshIntervalMs with
      | TopicMetadataRefreshInterval.AfterEveryMessage -> metadata.RefreshMetadata []
      | _ -> ()
      
    let cancellationTokenSource = new CancellationTokenSource()
    
    let startRefreshMetadataSchedulerIfRequired () =
      match config.TopicMetadataRefreshIntervalMs with
      | TopicMetadataRefreshInterval.Scheduled timeout ->
          let rec loop () = async {
            do! Async.Sleep timeout
            metadata.RefreshMetadata []
            return! loop () }
          Async.StartImmediate(loop (), cancellationTokenSource.Token)
      | _ -> ()
    
    do
      verbosef (fun f -> f "initializing producer")
      match errorHandler with
      | Some handler -> errorEvent.Publish.Add(handler)
      | Option.None  -> errorEvent.Publish.Add(defaultErrorHandler)
      batchAgent.BatchProduced.Add (writeBatch >> Async.Start)
      startRefreshMetadataSchedulerIfRequired()
      
    member x.Send(topic, key, message) =
      match config.ProducerType with
      | Async -> batchAgent.Enqueue { Topic = topic; Value = message; Key = key }
      | Sync  -> syncSend [ { Topic = topic; Value = message; Key = key } ]
      refreshMetadataIfRequired()

    member x.Send(messages:Message<'a> list) =
      match config.ProducerType with
      | Async -> messages |> List.iter batchAgent.Enqueue
      | Sync  -> messages |> syncSend
      refreshMetadataIfRequired()

  let start<'a> (config:Config<'a>) connection metadataProvider = T<'a>(config, connection, metadataProvider)

  let send (producer:T<_>) topic key message = producer.Send(topic, key, message)

(**
Message should contain Partition also
Add metrics
Add support for v1 and v2 and versioning :)
*)