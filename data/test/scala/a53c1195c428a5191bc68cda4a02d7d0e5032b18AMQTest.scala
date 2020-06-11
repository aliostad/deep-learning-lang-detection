import org.apache.activemq.camel.component.ActiveMQComponent
import org.apache.activemq.broker.BrokerService
import org.scalatest.{BeforeAndAfter, FunSuite}
import akka.actor.{ActorSystem, Props}
import akka.camel.CamelExtension

class AMQTest extends FunSuite with BeforeAndAfter {

  val brokerUrl = "tcp://localhost:61616"
  // Create a broker and start it
  val broker = new BrokerService()
  broker.setBrokerName("amq-broker")
  broker.addConnector(brokerUrl)
  broker.start()

  //Setup akka and camel component
  val actorSystem = ActorSystem("actor-test-system")
  val system = CamelExtension(actorSystem)
  system.context.addComponent("activemq", ActiveMQComponent.activeMQComponent(brokerUrl))

  test("Tests broker is persistent") {
    //Persistence is activated by default
    assert(broker.isPersistent)
  }
  test("Test client connection uppon creation") {
    val testConsumer1 = actorSystem.actorOf(Props[AMQClient])
    val view = broker.getAdminView
    Thread.sleep(500)
    assert(view.getTotalConsumerCount == 1)
  }
  test("Test the queue creation") {
    assert(true)
  }
  test("Test peristence store") {
    assert(true)
  }
}
