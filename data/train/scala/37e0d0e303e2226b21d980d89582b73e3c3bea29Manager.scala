package actor

import java.io.File
import javax.inject._
import akka.actor._

case class StartedFileProcessing(uuid: String, file: File)
case class TerminatFileProcessing(uuid: String, clientId: Option[String], done: Boolean, file: File)
case class Work(uuid: String, clientId: Option[String], file: File)
case class ConnectWebSocketActorRef(actorRef: ActorRef)
case class DisconnectWebSocketActorRef(actorRef: ActorRef)
case class IdClient(uuid: String, actorRef: ActorRef)

@Singleton
class Manager @Inject() (system: ActorSystem, @Named("filemanage-actor") aFileManageActor: ActorRef, @Named("fileprocess-actor") aFileProcessActor: ActorRef) {
  val fileManageActor = aFileManageActor
  val fileProcessActor = aFileProcessActor

}