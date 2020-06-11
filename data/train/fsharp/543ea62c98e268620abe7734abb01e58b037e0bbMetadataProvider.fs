namespace FsKafka

open FsKafka.Common
open FsKafka.Protocol
open FsKafka.Protocol.Common
open FsKafka.Protocol.Requests
open FsKafka.Protocol.Responses
open FsKafka.Logging
open System
open System.Threading
open System.Collections.Generic

module MetadataProvider =
  type Config =
    { TestConnectionTopics: string list
      Log:                  Logger
      ClientId:             string
      RetryBackoffMs:       int }
  let defaultConfig =
    { TestConnectionTopics = []
      Log                  = defaultLogger LogLevel.Verbose
      ClientId             = "FsKafka"
      RetryBackoffMs       = 100 }

  type TopicName   = TopicName of string
  type PartitionId = PartitionId of int
  type Endpoint    = string * int

  exception BrokerHostMissingException             of unit
  exception BrokerPortMissingException             of unit
  exception TopicErrorReceivedException            of string * Errors
  exception GroupCoordinatorErrorReceivedException of string * Errors
  exception ServerUnreachableException             of unit
  exception UnexpectedException                    of string

  type T(config:Config, connection:Connection.T) =
    let verbosef f = verbosef config.Log "FsKafka.MetadataProvider" f
    let failWith e = fatale config.Log "FsKafka.MetadataProvider" e ""; raise e
    
    let locker = obj()
    let metadata = new Dictionary<TopicName, Dictionary<PartitionId, Endpoint>>()
    
    let rec validateBrokers  acc = function
      | []    -> acc
      | x::xs ->
          match (x.NodeId, x.Host, x.Port) with
          | (-1, _, _)                             -> validateBrokers false xs
          | ( _, h, _) when String.IsNullOrEmpty h -> BrokerHostMissingException() |> failWith
          | ( _, _, p) when p <= 0                 -> BrokerPortMissingException() |> failWith
          | _                                      -> validateBrokers acc xs
      
    let rec validateMetadata acc (metadata : TopicMetadata list) =
      match metadata with
      | []    -> acc
      | x::xs ->
          match x.ErrorCode with
          | Errors.NoError                      -> validateMetadata acc xs
          | Errors.LeaderNotAvailable           -> validateMetadata false xs
          | Errors.GroupLoadInProgress          -> validateMetadata false xs
          | Errors.GroupCoordinatorNotAvailable -> validateMetadata false xs
          | c         -> TopicErrorReceivedException(x.Topic, c) |> failWith

    let updateBrokers brokers    =
      brokers
      |> List.map (fun b -> b.Host, b.Port)
      |> Set.ofList 
      |> connection.UpdateBrokersList

    let updateMetadata nodeIdMapping newMetadata =
      metadata.Clear()
      newMetadata
      |> List.iter(fun topic ->
          let partitions = new Dictionary<PartitionId, Endpoint>()
          topic.PartitionsMetadata
          |> List.iter ( fun partition ->
              let broker = nodeIdMapping partition.Leader
              partitions.Add(partition.PartitionId |> PartitionId, (broker.Host, broker.Port)) )
          metadata.Add(topic.Topic |> TopicName, partitions) )
    
    let rec refreshMetadataLoop request attempt =
      let refreshResult = connection.TryPick request
      match refreshResult with
      | Some r ->
          match r.Message with
          | Metadata r ->
              verbosef (fun f -> f "Received metadata response: %A" r)
              let brokersValid  = r.Brokers        |> validateBrokers true
              let metadataValid = r.TopicsMetadata |> validateMetadata true
              if brokersValid && metadataValid then
                r.Brokers        |> updateBrokers
                r.TopicsMetadata |> updateMetadata (fun id -> r.Brokers |> List.find(fun b -> b.NodeId = id))
              else
                Thread.Sleep (attempt * attempt * config.RetryBackoffMs)
                refreshMetadataLoop request (attempt + 1)
          | _  -> sprintf "received not metadataResponse: %A" r |> UnexpectedException |> failWith
      | None   -> ServerUnreachableException() |> failWith

    let refreshMetadata newTopics =
      let currentTopics = metadata.Keys |> Set.ofSeq |> Set.map (fun (TopicName s) -> s)
      let topics = newTopics + currentTopics |> Set.toList
      let request = Optics.metadata config.ClientId topics
      refreshMetadataLoop request 0

    let toMetadata topic =
      lock (locker) ( fun _ ->
        if not (metadata.ContainsKey (TopicName topic)) then [topic] |> Set.ofList |> refreshMetadata
        let result = metadata.[topic |> TopicName] |> Seq.map keyValueToTuple |> List.ofSeq
        Success(topic, result) )
    
    let refreshMetadataForTopics topics = lock(locker) (fun _ -> topics |> Set.ofList |> refreshMetadata)
    
    let requestConsumerMetadata groupId : Endpoint option =
      groupId
      |> Optics.groupCoordinator config.ClientId
      |> connection.TryPick
      |> function
         | Some r ->
             match r.Message with
             | GroupCoordinator r ->
                 verbosef (fun f -> f "Received metadata response: %A" r)
                 match r.ErrorCode with
                 | Errors.NoError                      -> Some(r.Coordinator.Host, r.Coordinator.Port)
                 | Errors.GroupCoordinatorNotAvailable
                 | Errors.NotCoordinatorForGroup
                 | Errors.GroupAuthorizationFailed     -> None // maybe need different behaviour
                 | c -> GroupCoordinatorErrorReceivedException(groupId, c) |> failWith
             | _ -> sprintf "received not consumerMetadataResponse: %A" r |> UnexpectedException |> failWith
         | None   -> ServerUnreachableException() |> failWith

    do
      if not config.TestConnectionTopics.IsEmpty
      then refreshMetadataForTopics config.TestConnectionTopics

    member x.RefreshMetadata topics  = refreshMetadataForTopics topics
    member x.BrokersFor      topic   = topic |> toMetadata
    member x.GetCoordinator  groupId = requestConsumerMetadata groupId

  let  create config connection = T(config, connection)