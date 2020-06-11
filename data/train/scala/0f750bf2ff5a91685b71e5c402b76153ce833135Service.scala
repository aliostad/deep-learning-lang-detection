package remote.broker

import com.typesafe.config.ConfigFactory
import akka.actor.{ ActorSystem, Props }

object Service {
  import util.RemoteAddress

  val name = "broker"

  def main(args: Array[String]) {
    val conf = RemoteAddress.fromConfig("broker")
    val addr = RemoteAddress.parseWithDefault(args(0), conf)
    start(addr)
  }

  def start(addr: RemoteAddress) {
    val config  = ConfigFactory.parseString(addr.configString).withFallback(ConfigFactory.load("broker"))
    val system  = ActorSystem(name, config)
    val broker  = system.actorOf(Props[BrokerActor], name)

    println(s"Started BrokerSystem(${broker.path}). Waiting for messages")
  }
}
