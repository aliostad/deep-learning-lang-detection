package telemachus.actors

import akka.actor.{ActorRef, Props, Actor}
import telemachus.models._
import akka.pattern.{ask, pipe}
import akka.util.Timeout
import telemachus.services._
import scala.concurrent.Future
import telemachus.actors.mutations._
import scala.concurrent.duration._
import scala.util.{Success, Failure, Random}

object Mutagen {

  case class Mutate(loads: List[Load])

  case class Change(add: List[Load], remove: List[Load])

  def props(loadBuilder: ActorRef, loadValidator: LoadValidator) =
    Props(classOf[Mutagen], loadBuilder, loadValidator)

}

class Mutagen(loadBuilder: ActorRef, loadValidator: LoadValidator) extends Actor {
  import Mutagen._

  val mutations = List(
    context.actorOf(Mutation1.props(loadBuilder, loadValidator), "Mutation1"),
    context.actorOf(Mutation2.props(loadBuilder, loadValidator), "Mutation2")
//    context.actorOf(Mutation1.props(loadBuilder, generalValidator)),
//    context.actorOf(Mutation1.props(loadBuilder, generalValidator)),
//    context.actorOf(Mutation1.props(loadBuilder, generalValidator))
  )

  def receive = {
    case Mutate(loads) => {
      implicit val timeout = Timeout(30 seconds)
      import context.dispatcher
      val _sender = sender

      val futures = mutations.map{ m => (m ? Mutate(loads)).mapTo[Change] }
      val changesFuture = Future.sequence(futures)

      changesFuture.onComplete {
        case Success(changes) => {
          val goodChanges = changes.filter( c => c.add.forall(loadValidator.fullCheck(_)) )

          if (goodChanges.nonEmpty) {
            val change = goodChanges.sortBy( c => c.add.map( _.distance.fullDistance ).sum ).head
            val newLoads = loads.filter(!change.remove.contains(_)) ++ change.add

            _sender ! newLoads
          } else {
            _sender ! loads
          }
        }
        case Failure(error) => {
          _sender ! Failure(error)
        }
      }
    }
  }



}
