package ru.fintech.feedback_streamer.sources.bankiru.crawler

import akka.actor.{Actor, ActorLogging, ActorRef, Props}
import ru.fintech.feedback_streamer.Comment.BankiRuComment

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer

object CommentReceiver {
  def props = Props[CommentReceiver]

  final case class FilterCriteria(rating: Int)
  final case class AddSubscriber(actor: ActorRef, criteria: FilterCriteria)
  final case class ChangeCriteria(actor: ActorRef, criteria: FilterCriteria)
  final case class DeleteSubscriber(actorRef: ActorRef)
}

class CommentReceiver extends Actor with ActorLogging{
  import CommentReceiver._
  val subscribers = mutable.HashMap[ActorRef, FilterCriteria]()
  val comments = ArrayBuffer[BankiRuComment]()

  override def receive: Receive = collect orElse manageSubscribers

  def collect: Receive = manageSubscribers orElse {
    case OneByOnePageScrapper.Comments(c) =>
      log.info("received new comments")
      comments ++= c
    case OneByOnePageScrapper.Commit =>
      log.info("received commit")
      sendComments()
      comments.clear()
  }

  def sendComments() = {
    subscribers.foreach { entry =>
      val actorRef = entry._1
      val criteria = entry._2

      val commentsToSend = comments
        .filter(_.rating.isDefined)
        .filterNot(_.hasAnswer)
        .filter(_.rating.get.rating <= criteria.rating)
      actorRef ! OneByOnePageScrapper.Comments(commentsToSend)
    }
  }

  def manageSubscribers: Receive = {
    case AddSubscriber(actorRef, criteria) =>
      if (!subscribers.contains(actorRef)) {
        log.info(s"Add subscriber: $actorRef")
        subscribers += actorRef -> criteria
      }
      else {
        log.warning("Actor already in subscriber list")
      }
    case DeleteSubscriber(actorRef) => subscribers.remove(actorRef)
    case ChangeCriteria(actorRef, criteria) =>
      if (subscribers.contains(actorRef)) {
        subscribers += actorRef -> criteria
      } else {
        log.warning("Actor does not subscribed to comments")
      }
  }
}
