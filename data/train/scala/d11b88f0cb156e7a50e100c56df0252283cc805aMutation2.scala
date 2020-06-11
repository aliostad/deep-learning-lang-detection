package telemachus.actors.mutations

import akka.actor.{ActorRef, Actor, Props}
import akka.util.Timeout
import scala.concurrent._
import scala.concurrent.duration._
import telemachus.actors._
import telemachus.models._
import telemachus.services._
import scala.util.{Success, Random}
import akka.pattern.{ask, pipe}

object Mutation2 {

  case class X(oldLoad: Load, loads: List[Option[(Load, Load)]], shipment: Shipment, consumer: ActorRef)

  def props(loadBuilder: ActorRef, loadValidator: LoadValidator) = {
    Props(classOf[Mutation1], loadBuilder, loadValidator)
  }

}

class Mutation2(loadBuilder: ActorRef, loadValidator: LoadValidator) extends Actor {
  import Mutagen._
  import Mutation2._

  implicit val timeout = Timeout(30 seconds)
  import context.dispatcher

  def receive: Receive = {
    case Mutate(loads) => {
      val _sender = sender

      if (loads.forall(_.shipments.size == 1)) {
        _sender ! Change(List(), List())
        return ???
      }

      val load1 = sample(loads.filter(_.shipments.size > 1))
      val shipment = sample(load1.shipments)

      val loadsFutures = loads.filter( _ != load1 ).map( load =>
        (loadBuilder ? LoadBuilder.BuildFrom(shipment :: load.shipments)).
          mapTo[Option[Load]].
          map {
          case Some(newLoad) => Some(load, newLoad)
          case None => None
        }
      )

      val loadsFuture = Future.sequence(loadsFutures).map( loads => X(load1, loads, shipment, _sender) )

      loadsFuture pipeTo self
    }

    case X(oldLoad1, loads, shipment, consumer) => {
      val possibleChanges = loads.flatten

      val goodChanges = possibleChanges.filter{
        case (_, newLoad) => loadValidator.fullCheck(newLoad)
      }.sortBy{
        case (_, newLoad) => newLoad.distance.fullDistance
      }

      val f = (loadBuilder ? LoadBuilder.BuildFrom(oldLoad1.shipments.filter(_ != shipment))).mapTo[Option[Load]]

      f onComplete {
        case Success(Some(load)) => {
          goodChanges match {
            case x :: xs => consumer ! Change(List(x._2, load), List(oldLoad1, x._1))
            case Nil => consumer ! Change(List(), List())
          }
        }
        case _ => consumer ! Change(List(), List())
      }

    }
  }

  def sample[T](list: List[T]): T = {
    list(Random.nextInt(list.size))
  }

}
