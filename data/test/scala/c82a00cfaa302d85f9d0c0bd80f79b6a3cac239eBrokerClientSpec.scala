package com.messagehub

import java.net.{InetSocketAddress, InetAddress}

import akka.actor._
import akka.io.{Tcp, IO}
import akka.testkit.{ImplicitSender, TestKit, TestProbe}
import org.scalatest._

class BrokerClientSpec(_system: ActorSystem) extends TestKit(_system) with WordSpecLike with BeforeAndAfterAll with ShouldMatchers {

  def this() = this(ActorSystem("SubscriberSpec"))


  override def afterAll() {
    TestKit.shutdownActorSystem(system)
  }

  trait SubscriberSetup {
    val brokerClient = TestProbe()
    val subscriber   = system.actorOf(Subscriber.props(messageFilter = "Test", protocol = "TCP", createBrokerClient = (ActorRefFactory, ActorRef) => brokerClient.ref))
  }

  "A BrokerClient" when {
    "created" should {
      "connect to the broker via a client connection" in new SubscriberSetup {
        brokerClient.expectMsg(ClientConnection.Connect("TCP"))
      }
    }

    "connected to the broker" should {
      "request a subscription" in new SubscriberSetup {
        brokerClient.expectMsg(ClientConnection.Connect("TCP"))
        subscriber ! ClientConnection.Connected
        brokerClient.expectMsg(ClientConnection.Message("[SUBSCRIBE] Test"))
      }
    }

    "a connection is disconnected" should {
      "self-terminate" in new SubscriberSetup {
        subscriber ! ClientConnection.ConnectionClosed
        brokerClient.expectMsg(ClientConnection.Connect("TCP"))
        brokerClient watch subscriber
        brokerClient.expectTerminated(subscriber)
      }
    }
  }
}



