namespace FsKafka

open FsKafka.Common
open FsKafka.Protocol
open FsKafka.Protocol.Responses

module Consumer =
  type Config =
    { Topics  : string list
      GroupId : string
      PartitionAssignmentStrategy : string (* need to be changed to be able to store few strategies with their metadata *)
      SessionTimeoutMs : int
      ClientId : string }
  let defaultConfig =
    { Topics  = []
      GroupId = ""
      PartitionAssignmentStrategy = "consumer"
      SessionTimeoutMs = 1000
      ClientId = "FsKafka" }
    
  type State =
    | Down
    | Starting
    | PartOfAGroup
    | Rediscovering
    | Stopped
    
  type Commands =
    | Start
    | Stop
  let startCommand = function
    | Start -> Some <| async{()}
    | _     -> None
    
  type T<'a>(config:Config, connection:Connection.T, metadataProvider:MetadataProvider.T, consume:'a -> unit) =
    let rec getCoordinator () =
      match metadataProvider.GetCoordinator config.GroupId with
      | Some broker -> broker
      | None        -> getCoordinator ()
      
    let joinGroup coordinator consumerId =
      let joinRequest = Optics.joinGroup config.ClientId config.GroupId config.SessionTimeoutMs consumerId config.PartitionAssignmentStrategy []
      connection.Send(coordinator, joinRequest, true)
      
    let agent = MailboxProcessor<Commands>.Start(fun inbox ->
      let rec loop state = async {
        match state with
        | Down ->
            let! _ = inbox.Scan startCommand
            return! loop State.Starting
        | Starting ->
            let coordinator = getCoordinator()
            let joinResult  = joinGroup coordinator ""
            match joinResult with
            | Success(Some r) ->
                match r.Message with
                | JoinGroup r -> ()
                | _ -> ()
            | Failure error   -> ()
            return! loop State.PartOfAGroup
        | PartOfAGroup
        | Rediscovering
        | Stopped -> () }
      loop State.Down )
      
    member x.Start () = agent.Post Commands.Start

  let consume<'a> config connection metadataProvider consumeF =
    let consumer = T<'a>(config, connection, metadataProvider, consumeF)
    consumer

(**
To read for consumer:
Api            : https://cwiki.apache.org/confluence/display/KAFKA/A+Guide+To+The+Kafka+Protocol#AGuideToTheKafkaProtocol-JoinGroupRequest
Brief intro    : http://www.confluent.io/blog/tutorial-getting-started-with-the-new-apache-kafka-0.9-consumer-client
Docsumentation : https://cwiki.apache.org/confluence/display/KAFKA/Kafka+0.9+Consumer+Rewrite+Design
*)