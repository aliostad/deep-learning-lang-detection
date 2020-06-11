package services

import akka.actor._
import scala.concurrent.duration._
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import akka.util.Timeout
import javax.inject._
import scala.concurrent.{ ExecutionContext, Future, Promise }
import java.net.ConnectException

import model._

import play.api.libs.ws._
import play.api.http.HttpEntity

import services.StatisticsActor._

object LoadActor {
  def props(ws: WSClient, loadSpec: LoadSpec) = Props[LoadActor](new LoadActor(ws, loadSpec))

  case class SendRequest(numberOfRequests: Int)
  case class Failure(t: Throwable)
}

class LoadActor(val ws: WSClient, val loadSpec: LoadSpec) extends Actor {
  import LoadActor._

  val eventBus = context.system.eventStream

  override def postRestart(reason: Throwable) {
    super.postRestart(reason)
    println(s"Restarted because of ${reason.getMessage}")
  }

  def isValid(r: WSResponse): Boolean = {
    var result = true
    if (!loadSpec.expectedResponseCode.isEmpty) {
      result = loadSpec.expectedResponseCode.contains(r.status + "")
    }
    if (!loadSpec.expectedBody.isEmpty) {
      result = result && loadSpec.expectedBody.contains(r.body)
    }
    return result
  }

  val request: WSRequest = ws.url(loadSpec.url)
  val headers = loadSpec.headers.map(nv => (nv.name, nv.value))
  val queryString = loadSpec.requestParameters.map(nv => (nv.name, nv.value))
  

  val complexRequest: WSRequest =
    request.withHeaders(headers: _*)
      .withRequestTimeout(loadSpec.maxTimeForRequestInMillis.millis)
      .withQueryString(queryString: _*)

  def receive = {
    case SendRequest(numberOfRequests) =>
      //val startTime = System.currentTimeMillis
      
      for (x <- 1 to numberOfRequests) sendRequest
      
      //println("Batch time: " + (System.currentTimeMillis - startTime))
    case Failure(e) =>
      throw new LoadConnectException(loadSpec.id, e)
    case _ =>
      println("Handle error")
  }

  def sendRequest = {
    val startTime = System.currentTimeMillis

    val futureResult: Future[WSResponse] = if (loadSpec.method == "GET") {
      complexRequest.get()
    } else if (loadSpec.method == "PUT") {
      complexRequest.put(loadSpec.body)
    } else if (loadSpec.method == "POST") {
      complexRequest.post(loadSpec.body)
    } else {
      complexRequest.delete
    }

    futureResult.recover({
      case e: ConnectException =>
        println("ConnectException")
        self ! Failure(e)
      case e =>
        loadSpec.id foreach { id =>
          eventBus.publish(FailedRequest(ResourceKey(loadSpec.method, loadSpec.url, id), e.getClass.toString, System.currentTimeMillis - startTime))
        }

    })

    loadSpec.id foreach { id =>
      futureResult.map(r => {
        if (isValid(r)) {
          SuccessfulRequest(ResourceKey(loadSpec.method, loadSpec.url, id), System.currentTimeMillis - startTime)
        } else {
          FailedRequest(ResourceKey(loadSpec.method, loadSpec.url, id), "Failed validation", System.currentTimeMillis - startTime)
        }

      }).foreach(eventBus.publish)
    }
  }

}