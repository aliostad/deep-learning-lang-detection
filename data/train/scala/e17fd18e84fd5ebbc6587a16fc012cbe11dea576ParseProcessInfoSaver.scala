package actors

import akka.actor.{Props, Actor}
import domain.ParseProcessInfo
import services.mongo.ParseProcessInfoRepository

/**
  * Must be subscribed to event stream (ParseProcessInfo).
  * Save all results to mongo
  *
  * @author Maxim Ochenashko
  */
class ParseProcessInfoSaver(repo: ParseProcessInfoRepository) extends Actor {

  import context.dispatcher

  override def receive: Receive = {
    case x: ParseProcessInfo =>
      repo save x
  }

}

object ParseProcessInfoSaver {

  def props(repo: ParseProcessInfoRepository) =
    Props(classOf[ParseProcessInfoSaver], repo)

}
