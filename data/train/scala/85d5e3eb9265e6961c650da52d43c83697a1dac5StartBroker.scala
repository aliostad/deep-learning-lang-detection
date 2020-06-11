package org.dolphin.broker

import akka.actor.{Props, ActorSystem}
import com.typesafe.config.ConfigFactory
import org.dolphin.broker.actor.{MetricAct, StoreAct, EnrollAct}
import org.dolphin.domain.BrokerModel
import org.dolphin.common._
import org.dolphin.broker._

/**
 * User: bigbully
 * Date: 14-4-27
 * Time: 上午9:50
 */
object StartBroker {

  def main(args:Array[String]) {
    val system = ActorSystem("broker")
    val conf = ConfigFactory.load("broker.conf")
    val id = conf.getInt("broker.id")
    val port = conf.getInt("broker.port")
    val host = if (conf.hasPath("broker.host")) conf.getString("broker.host") else null
    val cluster = if (conf.hasPath("broker.cluster")) conf.getString("broker.cluster") else DEFAULT_CLUSTER
    val managerHost = conf.getString("manager.host")
    val managerPort = conf.getInt("manager.port")


    val storePath = conf.getString("broker.store.path")
    val maxPersistentDays = conf.getInt("broker.store.maxPersistentDays")

    val params = Map(
      "cluster" -> cluster,
      "managerHost" -> managerHost,
      "managerPort" -> managerPort,
      "path" -> storePath,
      "maxPersistentDays" -> maxPersistentDays.toString)

    val enrollAct = system.actorOf(Props(classOf[EnrollAct], BrokerModel(id, cluster, host, port), params), ENROLL_ACT_NAME)

    enrollAct ! REGISTER

  }


}

