package modelstests

/**
 * This class test Broker actor
 */

import akka.actor.ActorSystem
import akka.testkit.{ImplicitSender, TestActorRef, TestKit}
import models.Broker._
import models._
import org.scalatest.{BeforeAndAfterAll, Matchers, WordSpecLike}


class BrokerTest(_system:ActorSystem) extends TestKit(_system) with ImplicitSender
with WordSpecLike with Matchers with BeforeAndAfterAll{

  def this() = this(ActorSystem("BrokerTest2"))

  override def afterAll: Unit = {
    TestKit.shutdownActorSystem(system)
  }

  "borker" must {
    "return nothing since queue is empty" in {
      val broker = system.actorOf(Broker.props)
      broker ! GetNextEvent("c1")

      expectMsg(EndOfQueue)
    }
  }

  "broker" must {
    "add new event to queue" in {
      val broker = TestActorRef(Broker.props)
      broker ! AddNewEvent(Event("1"))
      broker ! GetNextEvent("c1")
      expectMsg(Event("1"))
    }
  }

  "broker" must {
    "retrieve just one event" in {
      val broker = TestActorRef(Broker.props)
      broker ! AddNewEvent(Event("1"))

      broker ! GetNextEvent("c1")
      expectMsg(Event("1"))

      broker ! GetNextEvent("c1")
      expectMsg(EndOfQueue)
    }
  }
}
