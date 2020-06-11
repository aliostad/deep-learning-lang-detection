
package network

import java.net.URI
import java.nio.file.Files
import javax.jms.Session

import org.apache.activemq.ActiveMQConnectionFactory
import org.apache.activemq.broker.BrokerService
import resource._

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent._
import scala.concurrent.duration._


case class Broker(uri : String,name: String)

object BrokerNetwork extends App {

//  val bridge = Some(URI.create("static://(tcp://localhost:61718,tcp://localhost:61719)"))
  val bridge = None

  val broker1 = Broker("tcp://tcp://localhost:61717", "broker1")
  val broker2 = Broker("tcp://localhost:61718", "broker2")
  val broker3 = Broker("tcp://localhost:61718", "broker3")

  setupBroker(broker2)
  setupBroker(broker3)
  setupBroker(broker1, bridge )
  consume(broker2)
  consume(broker3)



  produce(broker1)
  def consume(broker : Broker): Unit ={
    val factory = new ActiveMQConnectionFactory(broker.uri)

    future {
      for (connection <- managed(factory.createConnection());
           session <- managed(connection.createSession(false, Session.AUTO_ACKNOWLEDGE));
           consumer <- managed(session.createConsumer(session.createQueue("demoQueue")))) {


        println(s"name is listening (10 sec time/out)")
        connection.start()


        demo.Helper.receiveText(consumer, 10 seconds) {
          m => println(s"queue on ${broker.name} received ${m.getText}")
        }

      }
      //brokerService.stop()
    }
  }

  def setupBroker(broker : Broker, bridge: Option[URI] = None) {
    val brokerService = new BrokerService
    brokerService.setUseJmx(true)

    brokerService.addConnector(broker.uri)

    brokerService.setDataDirectory(Files.createTempDirectory(broker.name + "Data").toString)
    brokerService.setBrokerName(broker.name)
    bridge.map(u => brokerService.addNetworkConnector(u))
    brokerService.start()


  }


  def produce(broker : Broker) {


    val factory = new ActiveMQConnectionFactory(broker.uri)
    for (connection <- managed(factory.createConnection());
         session <- managed(connection.createSession(false, Session.AUTO_ACKNOWLEDGE));
         producer <- managed(session.createProducer(null))) {

      val queue = session.createQueue("demoQueue")
      for (a <- 11 to 20)
        producer.send(queue, session.createTextMessage(s"message via broker1: #$a"))
      println(s"broker1 has sent the messages")
    }

    println(s"Stopping broker1 in 30s")
    Thread.sleep(30000)
    //brokerService.stop()
    println(s"Stopped broker1")

  }





}
