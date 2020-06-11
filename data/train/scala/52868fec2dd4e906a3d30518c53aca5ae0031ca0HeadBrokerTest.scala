package modelstests

/**
 * This class test HeadBroker actor
 */


import akka.actor.ActorSystem
import akka.testkit._
import models.HeadBroker._
import models._
import org.scalatest._


class HeadBrokerTest(_system:ActorSystem) extends TestKit(_system) with ImplicitSender
with WordSpecLike with Matchers with BeforeAndAfterAll {

  def this() = this(ActorSystem("BrokerTest2"))

  override def afterAll: Unit = {
    TestKit.shutdownActorSystem(system)
  }

  "headborker" must {
    "add new topic" in {
      val headBroker = TestActorRef(HeadBroker.props)
      headBroker ! AddNewTopic("t1")

      expectMsgType[TopicAdded]
    }
  }

  "headbroker" must {
    "reject adding repetitive topic" in {
      val headBroker = TestActorRef(HeadBroker.props)
      headBroker ! AddNewTopic("t1")
      expectMsgType[TopicAdded]

      headBroker ! AddNewTopic("t2")
      expectMsgType[TopicAdded]

      headBroker ! AddNewTopic("t1")
      expectMsg(TopicExist)
    }
  }
}
