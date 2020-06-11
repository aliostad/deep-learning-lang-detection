package yields.server.router

import akka.testkit.{TestActorRef, TestProbe}
import yields.server.actions.nodes.NodeMessageBrd
import yields.server.router.ClientHub.OnPush
import yields.server.tests._

class DispatcherTests extends YieldsAkkaSpec {

  import Dispatcher._

  "Dispatcher" should "should manage push to one client on one connection" in {

    val dispatcher = TestActorRef[Dispatcher]
    val client = 0
    val broadcast = sample[NodeMessageBrd]

    dispatcher ! InitConnection(client)

    dispatcher ! Notify(List(client), broadcast)
    expectMsg(OnPush(broadcast))

    dispatcher ! TerminateConnection

    dispatcher ! Notify(List(client), broadcast)
    expectNoMsg()

  }

  it should "should manage push to two clients on one connection" in {

    val dispatcher = TestActorRef[Dispatcher]
    val probe = TestProbe()
    val clientA = 0
    val clientB = 1
    val broadcast = sample[NodeMessageBrd]

    dispatcher ! InitConnection(clientA)
    probe.send(dispatcher, InitConnection(clientB))

    dispatcher ! Notify(List(clientA, clientB), broadcast)
    expectMsg(OnPush(broadcast))
    probe.expectMsg(OnPush(broadcast))

  }

  it should "should manage push to one client on two connections" in {

    val dispatcher = TestActorRef[Dispatcher]
    val probe = TestProbe()
    val client = 0
    val broadcast = sample[NodeMessageBrd]

    dispatcher ! InitConnection(client)
    probe.send(dispatcher, InitConnection(client))

    dispatcher ! Notify(List(client), broadcast)
    expectMsg(OnPush(broadcast))
    probe.expectMsg(OnPush(broadcast))

  }

  it should "should manage push to only selected client" in {

    val dispatcher = TestActorRef[Dispatcher]
    val probe = TestProbe()
    val clientA = 0
    val clientB = 1
    val broadcast = sample[NodeMessageBrd]

    dispatcher ! InitConnection(clientA)
    probe.send(dispatcher, InitConnection(clientB))

    dispatcher ! Notify(List(clientB), broadcast)
    expectNoMsg()
    probe.expectMsg(OnPush(broadcast))

    dispatcher ! Notify(List(clientA), broadcast)
    expectMsg(OnPush(broadcast))
    probe.expectNoMsg()

  }

  it should "should manage push to client only when included in pool" in {

    val dispatcher = TestActorRef[Dispatcher]
    val client = 0
    val broadcast = sample[NodeMessageBrd]

    dispatcher ! InitConnection(client)

    dispatcher ! Notify(List(client), broadcast)
    expectMsg(OnPush(broadcast))

    dispatcher ! TerminateConnection

    dispatcher ! Notify(List(client), broadcast)
    expectNoMsg()

    dispatcher ! InitConnection(client)

    dispatcher ! Notify(List(client), broadcast)
    expectMsg(OnPush(broadcast))

  }

}
