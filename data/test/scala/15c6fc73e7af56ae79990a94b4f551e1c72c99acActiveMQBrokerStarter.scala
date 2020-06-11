package hu.environment.messagebroker

import org.apache.activemq.broker.BrokerService
import akka.actor.Actor
import akka.actor.ActorRef
import akka.actor.actorRef2Scala
import hu.fx.config.EnvironmentSupplier
import hu.monitoring.MonitoringManager
import hu.monitoring.jms.ActiveMQHandler
import hu.environment.params.ParamValues
import hu.environment.params.ParamsRequest

class ActiveMQBrokerStarter(paramsActor: ActorRef) extends Actor {

  val BROKER_ENDPOINT = "jms.broker.endpoint"
  val MONITORING_DESTINATION = "jms.monitoring.destination"

  def receive(): Receive = {
    case StartBroker => {
      paramsActor ! ParamsRequest(EnvironmentSupplier.getEnvironment(), BROKER_ENDPOINT + "," + MONITORING_DESTINATION)
      context.become(waitForParameters(sender))
    }
  }

  def waitForParameters(sender: ActorRef): Receive = {
    case ParamValues(values) => {
      try {
        startMqBroker(values)
        sender ! BrokerStarted
      } catch {
        case ex: Exception => sender ! BrokerStartError(ex)
      }
    }
  }

  private def startMqBroker(values: List[(String, String)]) {
    val jmsEndpoint = values.filter(tuple => tuple._1.equals(BROKER_ENDPOINT))(0)._2
    val monitoringQueue = values.filter(tuple => tuple._1.equals(MONITORING_DESTINATION))(0)._2

    startBroker(jmsEndpoint)
    startMonitoringClient(jmsEndpoint, monitoringQueue)
  }

  private def startBroker(jmsBrokerEndpoint: String): Unit = {
    val broker = new BrokerService()
    broker.addConnector(jmsBrokerEndpoint)
    broker.start()
  }

  private def startMonitoringClient(jmsBrokerEndpoint: String, monitoringServiceQueue: String): Unit = {
    val monitoringManager = MonitoringManager("EnvironmentDataService", new ActiveMQHandler(jmsBrokerEndpoint, monitoringServiceQueue))
    monitoringManager.start()
  }

}
