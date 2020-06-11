package telemachus.actors.mutations

import akka.actor.{ActorRef, Actor, Props}
import akka.util.Timeout
import scala.concurrent._
import scala.concurrent.duration._
import telemachus.actors._
import telemachus.models._
import telemachus.services._
import scala.util.Random
import akka.pattern.{ask, pipe}

object Mutation1 {

  case class X(oldLoad: Load, loads: List[Option[(Load, Load)]], consumer: ActorRef)

  def props(loadBuilder: ActorRef, loadValidator: LoadValidator) = {
    Props(classOf[Mutation1], loadBuilder, loadValidator)
  }

}

class Mutation1(loadBuilder: ActorRef, loadValidator: LoadValidator) extends Actor {
  import Mutagen._
  import Mutation1._

  def receive: Receive = {
    case Mutate(loads) => {
      implicit val timeout = Timeout(30 seconds)
      import context.dispatcher
      val _sender = sender

      val load1 = sample(loads)
      val loadsFutures = loads.filter( _ != load1 ).map( load =>
        (loadBuilder ? LoadBuilder.BuildFrom(load1.shipments ++ load.shipments)).
          mapTo[Option[Load]].
          map {
            case Some(newLoad) => Some(load, newLoad)
            case None => None
          }
      )

      val loadsFuture = Future.sequence(loadsFutures).map( loads => X(load1, loads, _sender) )

      loadsFuture pipeTo self
    }

    case X(oldLoad1, loads, consumer) => {
      val possibleChanges = loads.flatten

      val goodChanges = possibleChanges.filter{
        case (_, newLoad) => loadValidator.fullCheck(newLoad)
      }.sortBy{
        case (_, newLoad) => newLoad.distance.fullDistance
      }

      goodChanges match {
        case x :: xs => consumer ! Change(List(x._2), List(oldLoad1, x._1))
        case Nil => consumer ! Change(List(), List())
      }

    }
  }

  def sample[T](list: List[T]): T = {
    list(Random.nextInt(list.size))
  }

}
