module ElectroElephant.Client

open ElectroElephant.Api
open ElectroElephant.Common
open ElectroElephant.MetadataResponse
open Cricket
open Cricket.Actor
open Logary
open System.Collections.Generic
open System.Net.Sockets

let logger = Logging.getCurrentLogger()

let system =
  ActorHost.Start("ElectroElephant Actor System").SubscribeEvents(fun (ae : ActorEvent)->   
    Logger.info logger (sprintf "%A" ae))

type Broker = 
  { /// hostname of a broker
    hostname : Hostname
    /// the port of the broker
    port : Port }

type BootstrapConf = 
  { /// list of brokers that we can attempt to contact
    /// inorder to get metadata
    brokers : Broker list
    /// these are the topics that we want to constraint us to
    topics : TopicName list option }

type TopicPartition = 
  { topic : TopicName
    partition : PartitionId }

/// this is the object which is passed around and contains all the information we
/// need in order to publish messages.
type ClientState =
  { topic_to_partition            : Dictionary<TopicName, PartitionId list>
    topic_partition_to_broker_id  : Dictionary<TopicPartition, NodeId>
    broker_to_actor               : Dictionary<NodeId, Cricket.ActorRef> }

type SendAction =
  | Bootstrap
  | Publish of byte []

type BrokerAction =
  | Publish of ( byte[] * TopicName * PartitionId )
  | FetchRequest
  | OffsetRequest
  | ConsumerMetadataRequest
  | OffsetFetchRequest
  | OffsetCommitRequest

type private BrokerActorState =
    /// This is the id of the broker according to kafka.
  { node_id : NodeId
    /// the hostname of the broker
    hostname : Hostname
    /// the port for the broker.
    port : Port
    /// the actual tcp client. Its set as an option so we can
    /// lazy load it.
    tcp_client : TcpClient option }

/// <summary>
///  This type of actor is in charge of talking to one specific broker.
/// </summary>
let private create_broker_actor state =
  let actor_name = (sprintf "Broker Actor (node id = %d)" state.node_id)
  actor {
    name actor_name
    body (
      let rec loop (state : BrokerActorState) = messageHandler {
        let! msg = Message.receive()

        let tcp =
          match state.tcp_client with
          | Some t -> t
          | None -> new TcpClient(state.hostname, state.port)

        match msg.Message with
          | Publish(msg, topic, partition) -> ()
          | FetchRequest
          | OffsetRequest
          | ConsumerMetadataRequest
          | OffsetFetchRequest
          | OffsetCommitRequest
          | _ -> failwith "got something strange!"
        }
      loop state
      )
  } |> Actor.spawn


let private create_client (metadata : MetadataResponse)  : ClientState =
  let client_state = 
    { topic_to_partition = new Dictionary<TopicName, PartitionId list>()
      topic_partition_to_broker_id = new Dictionary<TopicPartition, NodeId> ()
      broker_to_actor = new Dictionary<NodeId, Cricket.ActorRef> () }

  /// create all broker actors
  metadata.brokers 
  |> List.iter (fun brker -> 
      let actor = 
        { node_id = brker.node_id
          hostname = brker.host
          port = brker.port
          tcp_client = None } 
        |> create_broker_actor
      /// map the node id of the broker to an actor
      client_state.broker_to_actor.Add(brker.node_id, actor))

  /// map all topic names to a partition id lists
  metadata.topic_metadatas
  |> List.iter (fun topic ->
      let topic_name = topic.name
      let partition_ids = topic.partitions |> List.map (fun part -> part.id)
      client_state.topic_to_partition.Add(topic_name, partition_ids)
      )

  /// given a topic name and a partition id 
  /// then the map should return the id of the broker
  /// which is currently leader
  metadata.topic_metadatas
  |> List.iter (fun topic ->
      topic.partitions |> List.iter (fun partition ->
        let node_id = partition.leader
        let topic_partition = 
          { topic = topic.name
            partition = partition.id }
        client_state.topic_partition_to_broker_id.Add(topic_partition, node_id)
      )
    )
  client_state

type private MasterActorActions =
  /// bootstrap the master actor with a list of hosts
  /// and a callback, if you wish, which will give you a 
  /// copy of the client state.
  | Bootstrap of ( BootstrapConf * ((ClientState -> unit) option) )
  | Publish of ( byte[] * TopicName * PartitionId )

let private master_actor () = 
  let actor_name = "Master Actor"
  actor {
    name actor_name
    body (
      let rec loop (state : ClientState option) = messageHandler {
        let! msg = Message.receive()
        match msg.Message with
        | Bootstrap(conf, clb) -> 
          let head = conf.brokers |> List.head
          let! resp = do_metadata_request head.hostname head.port conf.topics
          let s = create_client resp

          match clb with
          | Some c -> c s
          | None -> ()
          return! loop (Some s)
        | Publish(msg, topic, partition) ->
          if state.IsNone then
            Logger.error logger "tried to publish msg to master actor with out bootstrapping it"
            failwith "you must bootstrap the master actor before publishing messages"
          else
            let broker_id = state.Value.topic_partition_to_broker_id.[{topic = topic ; partition = partition}]
            let actor = state.Value.broker_to_actor.[broker_id]
            actor <-- Publish(msg, topic, partition)
        | _ -> failwith "got something strange!"
      }
      loop None
    )
  } |> Actor.spawn

/// <summary>
///  This method starts and inits ElectroElephant. 
///  supply it with a initial list of brokers
///  and it will then try to bootstrap from them.
///  The callback can be used to get a the client state 
/// </summary>
/// <param name="boot_conf"></param>
/// <param name="clb"></param>
let bootstrap (boot_conf : BootstrapConf) (clb : (ClientState -> unit) option) =
  let master = master_actor ()
  master <-- Bootstrap(boot_conf, clb)
  master
