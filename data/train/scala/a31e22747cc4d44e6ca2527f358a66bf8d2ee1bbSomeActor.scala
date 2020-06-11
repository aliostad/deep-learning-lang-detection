package zzb.srvdemo

import akka.actor.{Props, Actor, ActorLogging}
import zzb.db.DBAccess
import zzb.srvbox.SrvManageProtocol._
import akka.pattern._
import scala.util.Success
import akka.util.Timeout
import zzb.srvbox.SrvManageProtocol.FilterReg
import zzb.srvbox.SrvManageProtocol.RestRequest
import scala.util.Success

/**
 * Created with IntelliJ IDEA.
 * User: Simon Xiao
 * Date: 13-7-30
 * Time: 上午8:42
 * Copyright goodsl.org 2012~2020
 */
class SomeActor extends Actor with DBAccess with ActorLogging{

  import zzb.srvdemo.DemoProtocol._
  import zzb.srvdemo.entites._
  import context.dispatcher

/*  val boxActor = context.system.actorSelection("/user/boxActor")
  implicit val timeOut=Timeout(5000)
  boxActor ! FilterReg("demo",List("demo"))
  boxActor ? FilterList onComplete{
    case Success(result)=>
      println(result)
  }*/
  def receive = {
    case ListUser => sender ! DBOperate.listUsers()
    case AddUser(user) => sender ! DBOperate.addUser(user)
    case DelUser(id) => sender ! DBOperate.delUser(id)
    case RestRequest(name, ctx)=>sender ! FilterError("demo")
    case _  => ()
  }
}

