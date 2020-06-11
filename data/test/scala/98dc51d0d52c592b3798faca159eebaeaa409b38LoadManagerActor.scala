package services

import akka.actor._
import scala.concurrent.duration._
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import akka.util.Timeout
import java.net.ConnectException

import model._
import LoadSessionActor._
import play.api.libs.ws._

import services.StatisticsActor._

import akka.actor.OneForOneStrategy
import akka.actor.SupervisorStrategy._
import scala.concurrent.duration._



object LoadManagerActor {
  def props(ws: WSClient) = Props[LoadManagerActor](new LoadManagerActor(ws))

  case class ListLoadResources()
  case class GetLoadResource(index: String)
  case class CreateLoadReource(loadSpec: LoadSpec)
  case class UpdateLoadResource(index: String, loadSpec: LoadSpec)
  case class DeleteLoadResource(index: String)

  case class ListLoadSessions()
  case class StartLoadSession(name: String)
  case class EndLoadSession(name: String)
  
  case class LoadResourceCreated(resource: ResourceKey)
  case class LoadResourceDeleted(resource: ResourceKey)
  case class FatalError(resource: ResourceKey, e: Throwable)
  
  
}

class LoadManagerActor(val ws: WSClient) extends Actor {
  import LoadManagerActor._

  var loadResources: Map[String, LoadSpec] = Map()

  var index: Integer = 0
  
  
  override val supervisorStrategy =
    OneForOneStrategy(maxNrOfRetries = 10, withinTimeRange = 1 minute) {
      case e: LoadConnectException => 
        println("LoadManagerActor: stopping")
        for(
          id <- e.id;
          r <- loadResources.get(id)
        ) {
          loadResources = loadResources + (id -> r.copy(status = Some("Inactive")))
          context.system.eventStream.publish(FatalError(ResourceKey(r.method,r.url, id), e.cause))
        }     
        Stop
      case e: NullPointerException =>
        Stop
      case t =>
        super.supervisorStrategy.decider.applyOrElse(t, (_: Any) => Escalate)
    }

  def receive = {
    case StartLoadSession(id) =>
      val r = loadResources.get(id) 

      r foreach { r =>
          if (r.status.getOrElse("Inactive") == "Inactive") {
            val session = context.actorOf(LoadSessionActor.props(id, r, ws), "load-session-" + id)
            loadResources = loadResources + (id -> r.copy(status = Some("Active")))
            session ! StartSession
          }
      }

      sender ! (r map { r => LoadSession(id) } )
    case EndLoadSession(id) =>
      loadResources.get(id) foreach { r => loadResources = loadResources + (id -> r.copy(status = Some("Inactive"))) }     
      
      val s = for (
        r <- loadResources.get(id);
        s <- context.child("load-session-" + id)
      ) yield (s)
      
      s foreach { _ ! EndSession }
      sender ! (s map { _ => LoadSession})
    case ListLoadResources =>
      sender ! loadResources.keys
    case CreateLoadReource(resource) =>
      val newIndex = index + ""
      val createdResource = resource.copy(status = Some("Inactive"), id = Some(newIndex))
      loadResources = loadResources + ((index + "") -> createdResource)
      index = index + 1
      context.system.eventStream.publish(LoadResourceCreated(ResourceKey(createdResource.method, createdResource.url, newIndex)))
      sender ! createdResource
    case UpdateLoadResource(id, loadSpec) =>
      val resource = loadResources.get(id) map { r =>   
        loadSpec.copy(status = r.status)
      }
      
      resource foreach { r => 
        loadResources = loadResources + (id -> r)
      }
      
      sender ! resource
    case DeleteLoadResource(id) =>
      val resource = loadResources.get(id)

      resource.foreach { r =>
        loadResources = loadResources - id
        context.system.eventStream.publish(LoadResourceDeleted(ResourceKey(r.method, r.url, id)))
        context.child("load-session-" + id) foreach { a =>
          a ! EndSession
        }
      }

      sender ! resource
    case GetLoadResource(name) =>
      sender ! loadResources.get(name)

  }

}