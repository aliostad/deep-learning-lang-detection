package zzb.service

import akka.actor._
import com.typesafe.config.Config
import zzb.srvbox.SrvManageProtocol._
import scala.collection.JavaConversions._
import zzb.srvbox.SrvManageProtocol.FilterOk
import zzb.srvbox.SrvManageProtocol.RestRequest
import akka.actor.Identify
import scala.concurrent.duration.Duration
import java.util.concurrent.TimeUnit
import scala.concurrent.ExecutionContext.Implicits.global
/**
 * Created by blackangel on 14-1-14
 */
abstract class ServiceFilter(system: ActorSystem, config: Config) extends BoxedService(system, config) {
  def name:String

  require(config.hasPath("filter.boxActor"))
  require(config.hasPath("filter.services"))

  val boxActor = system.actorSelection(config.getString("filter.boxActor"))
  val services=config.getStringList("filter.services").toList
  val actor=system.actorOf(Props(new FilterHandler(name,services,boxActor,filter)),name+"-filter")

  def filter(req:RestRequest):Either[FilterError,FilterOk.type ]
}

class FilterHandler(val filterName:String,services:List[String],val boxActor:ActorSelection,val filter:RestRequest=>Either[FilterError,FilterOk.type ]) extends Actor with ActorLogging{
  var scheduler=context.system.scheduler.schedule(
    Duration.create(10, TimeUnit.SECONDS), Duration.create(10, TimeUnit.SECONDS), self, "reg"
  )
  def receive={
    case "reg" =>{
      boxActor ! Identify(filterName)
    }
    case ActorIdentity(`filterName`, Some(ref)) =>{
      scheduler.cancel()
      ref ! FilterReg(filterName,services)
    }
    case req @ RestRequest(name,ctx) =>{
      log.debug("service {} filter handler!",name)
      sender ! (filter(req) match {
        case Right(ok) =>ok
        case Left(failure)=>failure
      })
    }
    case FilterUnReg(name) if name==filterName =>{
      scheduler=context.system.scheduler.schedule(
        Duration.create(10, TimeUnit.SECONDS), Duration.create(10, TimeUnit.SECONDS), self, "reg"
      )
    }
    case _ =>
  }
}
