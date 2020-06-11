package zzb.srvbox

import org.scalatest.WordSpecLike
import org.scalatest.MustMatchers
import zzb.shell.Task
import akka.testkit.{ImplicitSender, TestKit}
import akka.actor.ActorSystem
import zzb.StopSystemAfterAll
import com.typesafe.config.ConfigFactory
import zzb.shell.remote.ShellProtocol._

/**
 * Created with IntelliJ IDEA.
 * User: Simon Xiao
 * Date: 13-10-16
 * Time: 上午11:11
 * Copyright baoxian.com 2012~2020
 */
class RemoteManageTest extends TestKit(ActorSystem("testSystem"))
with WordSpecLike
with MustMatchers
with ImplicitSender
with StopSystemAfterAll {

  "remote manage " must {
    val config = ConfigFactory.load("remoteManage")
    val shellActor = BoxApp.startRemoteManage(config,system)

    "can login from remote" in {


      shellActor ! Login("not_me", "wrongPass",self)

      expectMsgPF() {
        case LoginFailed ⇒ ()
      }

      shellActor ! Login("admin", "wrongPass",self)
      expectMsgPF() {
         case LoginFailed ⇒ ()
      }

      shellActor ! Login("admin", "baoxian",self)
      expectMsgPF() {
        case LoginSuccess(sid,peer) ⇒
          sid.length must equal(36)
      }
    }
    "can exec task from remote" in {

//      shellActor ! Command("no_this_session", "tasks")
//      expectMsgPF() {
//        case Timeout(sid) => ()
//      }
//      shellActor ! Login("admin", "baoxian")
//      val sessionid = expectMsgPF() {
//        case LoginSuccess(sid) ⇒
//          sid.length must equal(36)
//          sid
//      }
//      shellActor ! Command(sessionid, "tasks")
//      expectMsgPF() {
//        case CommandResult(out,err,stat) ⇒
//          assert(out.contains("tasks"))
//      }
//      Thread.sleep(20 * 1000)
//      shellActor ! Command("no_this_session", "tasks")
//      expectMsgPF() {
//        case Timeout(sid) => ()
//      }
    }
  }
}

