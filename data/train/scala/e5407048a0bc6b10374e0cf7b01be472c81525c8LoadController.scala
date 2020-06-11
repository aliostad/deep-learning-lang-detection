package controllers

import javax.inject._
import play.api._
import play.api.mvc._
import akka.actor.ActorSystem
import scala.concurrent.{ ExecutionContext, Future, Promise }
import scala.concurrent.duration._

import services.LoadActor._
import services.LoadActor
import services.LoadManagerActor._
import services.LoadManagerActor
import model.LoadSpec
import model.LoadSession

import akka.util.Timeout
import play.api.libs.json._
import akka.pattern.ask

import play.api.libs.ws._

/*
 * http://localhost:9000/load-resource/test
 * 
 * {"url": "http://localhost:9001/mock-service/test", "numberOfRequestPerSecond":1000}
 */

@Singleton
class LoadController @Inject() (actorSystem: ActorSystem,ws: WSClient)(implicit exec: ExecutionContext) extends Controller {

  val loadManagerActor = actorSystem.actorOf(LoadManagerActor.props(ws), "load-manager-actor")
  implicit val timeout: Timeout = 1.seconds

  def listLoadResources = Action.async {
    (loadManagerActor ? ListLoadResources).mapTo[Set[String]].map { msg => Ok(Json.toJson(msg)) }
  }
  
  def getLoadResource(id: String) = Action.async {
    (loadManagerActor ? GetLoadResource(id)).mapTo[Option[LoadSpec]].map { 
      case Some(msg) => Ok(Json.toJson(msg)) 
      case None => NotFound  
    }
  }
  
  def createLoadResource() = Action.async(BodyParsers.parse.json) { request =>
    request.body.validate[LoadSpec].map {
      loadSpec => (loadManagerActor ? CreateLoadReource(loadSpec)).mapTo[LoadSpec].map { msg => Ok(Json.toJson(msg)) }
    }.recoverTotal {
      errors => Future.successful(BadRequest("Bad request: " + JsError.toFlatJson(errors)))
    }
  }
  
  
  def updateLoadResource(id: String) = Action.async(BodyParsers.parse.json) { request =>
    request.body.validate[LoadSpec].map {
      loadSpec => 
        (loadManagerActor ? UpdateLoadResource(id,loadSpec.copy(id = Some(id)))).mapTo[Option[LoadSpec]].map { 
        case Some(resource) => Ok(Json.toJson(resource)) 
        case None => NotFound  
      }
    }.recoverTotal {
      errors => Future.successful(BadRequest("Bad request: " + JsError.toFlatJson(errors)))
    }
  }

def deleteLoadResource(id: String) = Action.async {
    (loadManagerActor ? DeleteLoadResource(id)).mapTo[Option[LoadSpec]].map { 
        case Some(resource) => Ok 
        case None => NotFound  
      }
  }

def listLoadSessions = Action.async {
    (loadManagerActor ? ListLoadSessions).mapTo[Set[String]].map { msg => Ok(Json.toJson(msg)) }
  }

def updateLoadSessions(name: String) = Action.async {
    println("Start load session")
    (loadManagerActor ? StartLoadSession(name)).mapTo[Option[LoadSession]].map { 
      case Some(s) => Ok
      case None => NotFound
    }
  }

def deleteLoadSessions(name: String) = Action.async {
  println("Stop load session")
    (loadManagerActor ? EndLoadSession(name)).mapTo[Option[LoadSession]].map { 
      case Some(s) => Ok
      case None => NotFound
    }
  } 
  

}
