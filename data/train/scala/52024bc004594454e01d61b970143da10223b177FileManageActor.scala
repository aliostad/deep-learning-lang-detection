package actor

import play.api.Logger
import play.api.libs.concurrent.Akka
import play.api.Play.current
import akka.actor._
import play.api.cache._
import javax.inject._
import scala.concurrent.duration._
import scala.collection.mutable.{MutableList, ListBuffer}

object FileManageActor {

  def props = Props[FileManageActor]

}

class FileManageActor @Inject() (cache: CacheApi) extends Actor {
  case class Client(id:Option[String], actor: ActorRef) 
  val listWebSocket = ListBuffer.empty[Client]
  val cacheDuration = Duration.create(5, MINUTES) // 5.minutes  
  override def receive = {
    case t: TerminatFileProcessing  =>     
      Logger.debug(s"Image Finish Processing [${t.clientId} / ${t.uuid}] : ${t.done}")      
      cache.set(t.uuid, s"Terminated, integrated : ${t.done}", cacheDuration)
      if (t.file.exists()) t.file.delete()      
      listWebSocket.filter { p => t.clientId ==  p.id }.foreach { ref => ref.actor ! t }

    case s: StartedFileProcessing =>
      Logger.debug(s"Start processing ${s.uuid} : ${s.file}")      
      cache.set(s.uuid, "Started", cacheDuration)

    case c: ConnectWebSocketActorRef =>
      Logger.debug(s"Connect ${c.actorRef}")
      listWebSocket.+=(new Client(None,c.actorRef))

    case d: DisconnectWebSocketActorRef =>
      Logger.debug(s"Disconnect ${d.actorRef}")
      val toRemove = listWebSocket.find { p => p.actor == d.actorRef }
      if (toRemove.isDefined) listWebSocket.-=(toRemove.get)
      

    case id: IdClient =>
      Logger.debug(s"IdClient ${id.uuid}")
      val toUpdate = listWebSocket.find { p => p.actor == id.actorRef }
      if (toUpdate.isDefined) listWebSocket.-=(toUpdate.get).+=(new Client(Option(id.uuid), id.actorRef))
      
    case _ =>
      Logger.error("?? FileManageActor ??")

  }
}
