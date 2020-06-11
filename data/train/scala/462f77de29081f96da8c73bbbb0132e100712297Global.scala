import java.io.File
import play.api._
import controllers.MyLogger
import controllers.Manage
import play.api.mvc.{ EssentialAction, Handler, SimpleResult, RequestHeader }
import scala.concurrent.Future
import models.FamillyNames
import play.api.mvc.Results.{ NotFound, BadRequest }
import play.api.mvc.Result

object Global extends GlobalSettings {

  override def onStart(app: Application) {
    println("システムスタート")
      println(new File(".").getAbsoluteFile().getParent())

  }

  override def onStop(app: Application) {
    Manage.backup()
    println("システム終了")
  }

  // 404
  override def onHandlerNotFound(request: RequestHeader) = {
    Future.successful(NotFound(views.html.notFoundPage(request.path)))
  }

  // BadRequest
  override def onBadRequest(request: RequestHeader, error: String) = {
    Future.successful(BadRequest(views.html.notFoundPage(request.path + " Not Found")))
  }

}