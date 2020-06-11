package example

import com.typesafe.config.ConfigFactory
import akka.actor.ActorSystem
import akka.actor.Address
import akka.actor.PoisonPill
import akka.cluster.Cluster
import akka.contrib.pattern.ClusterSingletonManager
import common.{BrokerConfig, Broker}

object BrokerMain extends Startup {

  def main(args: Array[String]): Unit = {
    // FIX - Add config file for broker
    val config = if (args.length > 0) BrokerConfig.default.copy(port = args(0).toInt)
                 else BrokerConfig.default
    startBroker(config)
  }

  def startBroker(config: BrokerConfig): Address = {
    val role = config.role
    val port = config.port
    val hostname = config.hostname
    val seedNodesString = seedNodes.map("\"" + _ + "\"").mkString("[", ",", "]")
    println("Seed nodes:" + seedNodesString)
    val conf = ConfigFactory.parseString(
      s"""akka.cluster.roles=[$role]
          akka.remote.netty.tcp.port=$port
          akka.remote.netty.tcp.hostname="$hostname"
          akka.cluster.seed-nodes=$seedNodesString
      """).withFallback(ConfigFactory.load())
    val system = ActorSystem(systemName, conf)

    /**
     * Use a ClusterSingletonManager to ensure there is only one Broker active
     * in the cluster.
     */
    system.actorOf(ClusterSingletonManager.props(_ ⇒ Broker.props(config), "active",
      PoisonPill, Some(role)), "broker")

    println(s"Broker with role $role started at $hostname:$port")
    Cluster(system).selfAddress
  }
}
