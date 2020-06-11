package flumina.client

import akka.actor.{Actor, ActorLogging, ActorRef, Props}
import akka.io.{IO, Tcp}
import cats.implicits._

import scala.concurrent.duration._
import scala.util.Random

import flumina._

final class KafkaConnectionPool private (bootstrapBrokers: Seq[KafkaBroker.Node], connectionsPerBroker: Int) extends Actor with ActorLogging {

  import context.system

  private case class StashedRequest(from: ActorRef, request: KafkaBrokerRequest)

  private val manager       = IO(Tcp)
  private val retryStrategy = new KafkaConnectionRetryStrategy.Infinite(5.seconds)

  //Append the stashed request to the list, but drop the tail. We can do this, because the requests will timeout eventually
  private def append(stashedRequest: StashedRequest, stashedRequestsBuffer: List[StashedRequest]) =
    stashedRequest :: stashedRequestsBuffer.take(999)

  private def randomNode(nodes: Set[ActorRef]) =
    if (nodes.nonEmpty) Some(nodes.iterator.drop(Random.nextInt(nodes.size)).next())
    else None

  private def randomBroker(connections: Map[KafkaBroker.Node, Set[ActorRef]]) =
    if (connections.nonEmpty)
      Some(connections.iterator.drop(Random.nextInt(connections.size)).next())
    else None

  private def running(connectionsBeingSpawned: Set[KafkaBroker.Node], stashedRequestsBuffer: List[StashedRequest], connections: Map[KafkaBroker.Node, Set[ActorRef]]): Actor.Receive = {

    case kafkaBrokerRequest @ KafkaBrokerRequest(KafkaBroker.AnyNode, request) =>
      if (connections.isEmpty) {
        context.become(running(connectionsBeingSpawned, append(StashedRequest(sender(), kafkaBrokerRequest), stashedRequestsBuffer), connections))
      } else {
        (for {
          (_, nodes) <- randomBroker(connections)
          node       <- randomNode(nodes)
        } yield node) foreach (_ forward request)
      }

    case kafkaBrokerRequest @ KafkaBrokerRequest(node: KafkaBroker.Node, request) =>
      connections.get(node) match {
        case Some(nodes) =>
          log.debug(s"[api-key: ${request.apiKey}] $node found in connections, picking random one to forward to it ${nodes.size}")
          randomNode(nodes).foreach(_ forward request)
        case None =>
          if (connectionsBeingSpawned.contains(node)) {
            log.debug(s"$node not found in connections, but is already being spawned")
            context.become(running(connectionsBeingSpawned, append(StashedRequest(sender(), kafkaBrokerRequest), stashedRequestsBuffer), connections))
          } else {
            log.debug(s"$node not found in connections, SPAWNING!!")
            spawnConnections(node)
            context.become(running(connectionsBeingSpawned + node, append(StashedRequest(sender(), kafkaBrokerRequest), stashedRequestsBuffer), connections))
          }
      }

    case KafkaConnectionPool.BrokerUp(connection, node) =>
      val (matched, nonMatched) = stashedRequestsBuffer.partition(_.request.matchesBroker(node))
      log.info(s"Broker up $node")
      matched.foreach(x => self.tell(x.request, x.from))
      context.become(running(connectionsBeingSpawned - node, nonMatched, connections |+| Map(node -> Set(connection))))

    case KafkaConnectionPool.BrokerDown(connection, node) =>
      log.debug(s"Broker down $node")
      context.become(running(connectionsBeingSpawned, stashedRequestsBuffer, connections.updatedValue(node, Set())(_ - connection)))
  }

  def receive: Receive = running(
    connectionsBeingSpawned = bootstrapBrokers.toSet,
    stashedRequestsBuffer = Nil,
    connections = Map()
  )

  private def connId(broker: KafkaBroker.Node, nr: Int) =
    s"$nr:${broker.host}:${broker.port}"

  private def spawnConnections(broker: KafkaBroker.Node): Unit = {
    log.debug(s"Spawning $connectionsPerBroker connections for $broker")
    (1 to connectionsPerBroker) foreach { i =>
      context.actorOf(propsConn(broker), connId(broker, i))
    }
  }

  override def preStart(): Unit = bootstrapBrokers.foreach(spawnConnections)

  private def propsConn(broker: KafkaBroker.Node) =
    KafkaConnection.props(self, manager, broker, retryStrategy)
}

object KafkaConnectionPool {
  def props(bootstrapBrokers: Seq[KafkaBroker.Node], connectionsPerBroker: Int): Props =
    Props(new KafkaConnectionPool(bootstrapBrokers, connectionsPerBroker))

  final case class BrokerUp(connection: ActorRef, node: KafkaBroker.Node)
  final case class BrokerDown(connection: ActorRef, node: KafkaBroker.Node)
}
