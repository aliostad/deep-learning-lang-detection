package controllers

import java.io.File
import javax.inject._
import actor._
import akka.actor._
import play.api.{Logger, Configuration}
import play.api.mvc._
import play.api.cache.CacheApi
import play.api.libs.json._
import play.api.Play.current

class Application @Inject() (managerActor: Manager, cache: CacheApi, configuration: Configuration) extends Controller {

  case class FileStatus(uuid: String, status: String)
  implicit val fileStatusWrites = new Writes[FileStatus] {
    def writes(fileStatus: FileStatus) = Json.obj(
      "uuid" -> fileStatus.uuid,
      "status" -> fileStatus.status)
  }

  val fileProcessActor = managerActor.fileProcessActor
  val fileManageActor = managerActor.fileManageActor
  val tmpDestDir = configuration.getString("images.directory.temp") match {
    case Some(s: String) => s
    case _               => throw new Exception("Configuration error, please set images.directory.temp")
  }

  def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }

  def upload = Action(parse.multipartFormData) { request =>
    request.body.file("data").map { picture =>
      val filename = picture.filename
      val uuid = java.util.UUID.randomUUID.toString
      val file = new File(s"$tmpDestDir/$uuid-$filename")
      val clientId = request.headers.get("Client-UUID")
      Logger.debug(s"UUID : $uuid, Client UUID : $clientId -- File : ${file.getPath}")
      
      picture.ref.moveTo(file)
      fileProcessActor.tell(Work(uuid, clientId, file), fileManageActor)

      Ok(Json.toJson(FileStatus(uuid, "File uploaded")))
    }.getOrElse {
      BadRequest(Json.obj("status" -> "KO", "message" -> "Missing file"))
    }
  }

  def jsonUpload = Action(parse.temporaryFile) { request =>
    val uuid = java.util.UUID.randomUUID.toString
    val file = new File(s"$tmpDestDir/$uuid-jsonfile.jpg")        
    val clientId = request.headers.get("Client-UUID")
    
    Logger.debug(s"UUID : $uuid, Client UUID : $clientId -- File : ${file.getPath}")
    
    request.body.moveTo(file)
    
    fileProcessActor.tell(Work(uuid, clientId, file), fileManageActor)

    Ok(Json.toJson(FileStatus(uuid, "File uploaded")))
  }

  def info(uuid: String) = Action {
    val cachedValue = cache.getOrElse(uuid)("Not Found")

    Ok(Json.toJson(FileStatus(uuid, cachedValue)))
  }

  def ws = WebSocket.acceptWithActor[String, JsValue] { request =>
    out =>
      WebSocketActor.props(out, fileManageActor)
  }

  // TODO websocket pour avoir le flux de retour
  //https://www.playframework.com/documentation/2.4.x/ScalaWebSockets
}

