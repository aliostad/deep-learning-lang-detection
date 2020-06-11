package controllers

import javax.inject._

import daos.NativeDao
import play.api.Configuration
import play.api.mvc._
import services.GrayServerService

import scala.concurrent.ExecutionContext.Implicits.global

/**
 *
 * @author Eric on 2016/7/21 15:55
 */
@Singleton
class ServersManageController@Inject()(configuration:Configuration) extends Controller {

  def index = Action{ implicit request =>
      val agentUri = configuration.getString("agent.host").get
      val agentPort = configuration.getString("agent.port").get
      Ok(views.html.manage.render(agentUri,agentPort))
  }
}
