package model.scraping

import java.util.concurrent.TimeUnit

import akka.actor.{Props, ActorSystem, ActorRef}
import akka.util.Timeout

import scala.concurrent.Future

object LoadLog {
  import scala.concurrent.ExecutionContext.Implicits.global

  val ref: ActorRef = ActorSystem("deepfij-loader").actorOf(Props(classOf[LoadLogger]))

  def start(loadId: String, stepName: String, stepKey: String) {
    ref !(StepKey(loadId, stepName, stepKey), "")
  }

  def stop(loadId: String, stepName: String, stepKey: String, message: String) {
    ref !(StepKey(loadId, stepName, stepKey), message)
  }

  def stop(loadId: String, stepName: String, stepKey: String, err: Throwable) {
    ref !(StepKey(loadId, stepName, stepKey), err)
  }

  def wrapLog[S, T](loadId: String, stepName: String, stepKey: String, f: (S) => Future[T]): (S) => Future[T] = {
    (s: S) => {
      LoadLog.start(loadId, stepName, stepKey)
      val fut: Future[T] = f(s)
      fut onSuccess {
        case _ => LoadLog.stop(loadId, stepName, stepKey, "Success")
      }
      fut onFailure {
        case t: Throwable => LoadLog.stop(loadId, stepName, stepKey, t)
      }
      fut
    }
  }

  def wrapLog[T](loadId: String, stepName: String, stepKey: String, f: () => Future[T]): () => Future[T] = {
    () => {
      LoadLog.start(loadId, stepName, stepKey)
      val fut: Future[T] = f()
      fut onSuccess {
        case _ => LoadLog.stop(loadId, stepName, stepKey, "Success")
      }
      fut onFailure {
        case t: Throwable => LoadLog.stop(loadId, stepName, stepKey, t)
      }
      fut
    }
  }

  def dump(loadId: String) = {
    import akka.pattern.ask
    implicit val timeout = Timeout(5, TimeUnit.MINUTES)

    (ref ? ShowLoadResults(loadId)).mapTo[List[(StepKey, StepResult)]]

  }
}

