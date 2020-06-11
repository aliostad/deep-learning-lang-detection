package zzb.srvbox

import akka.testkit.{ ImplicitSender, TestKit }
import akka.actor.{ Props, ActorSystem }
import org.scalatest.WordSpecLike
import org.scalatest.MustMatchers
import zzb.StopSystemAfterAll
import zzb.srvbox.SrvManageProtocol._
import zzb.srvbox.SrvManageProtocol.Services
import zzb.srvbox.SrvManageProtocol.Register
import scala.concurrent.Future
import scala.util.Success

/**
 * Created with IntelliJ IDEA.
 * User: Simon Xiao
 * Date: 13-8-13
 * Time: 下午4:28
 * Copyright baoxian.com 2012~2020
 */
class BoxActorTest extends TestKit(ActorSystem("testSystem"))
    with WordSpecLike
    with MustMatchers
    with ImplicitSender
    with StopSystemAfterAll {

  "A Box Actor" must {

    val boxActor = system.actorOf(Props[BoxActor], name = "boxActor")

    "create service actor" in {
      boxActor ! Register("S1", "zzb.srvbox.S1Service", sharedActorSystem = true)
      boxActor ! RequestList
      expectMsgPF() {
        case Services(services) ⇒
          ()
          services.contains(ServiceStatus("S1", running = false))
      }
    }
    "can start service " in {
      boxActor ! RequestStart("S1")
      expectMsgPF() {
        case ServiceStatus(name, running) ⇒
          name must be("S1")
          running mustBe true
      }
    }
    "can stop service " in {
      boxActor ! RequestStop("S1")
      expectMsgPF() {
        case ServiceStatus(name, running) ⇒
          name must be("S1")
          running mustBe false
      }
    }
    "ignore no exist service" in {
      boxActor ! RequestStop("Hello")
      expectMsg(ServiceNotExist)
    }
    "reg filter " in{
      boxActor ! FilterReg("testFilter",List("srv1","srv2"))
      expectMsgPF() {
        case FilterReg(name,serverNames) ⇒
          name must be("testFilter")
          serverNames must contain("srv1")
      }
    }
    "list filter " in{
      boxActor ! FilterList
      expectMsgPF() {
        case list:Map[_,_] ⇒
          list.keys must contain("srv1")
      }
    }
    "unreg filter " in{
      boxActor ! FilterUnReg("testFilter")
      expectMsgPF() {
        case FilterUnReg(name) ⇒
          name must be("testFilter")
          boxActor ! FilterList
          expectMsgPF() {
            case list:Map[_,_] ⇒
              list.keys.size must be(0)
          }
      }
    }
  }

}
