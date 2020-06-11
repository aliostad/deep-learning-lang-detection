package controllers

import models.user.UsersTable
import play.api.mvc._
import play.api.db.slick.Config.driver.simple._
import play.api.db.slick._

object AdminUserManage extends Controller {

  def index = DBAction { implicit request =>
    request.session.get("aid").map { user: String =>
      val set = 30
      val setper = 15
      val per = set - setper
      var output: String = ""
      for (x <- 1 to per) {
        if(TableQuery[UsersTable].filter(_.id === x).exists.run) {
          val user = TableQuery[UsersTable].filter(_.id === x).firstOption.get
          output = output + "<br/><br/> | " + user.id + " | " + user.name + " | " + user.email + " | " + user.joindate + " | "
        }
      }
      Ok(views.html.admin.usermanage(output))
    }.getOrElse {
      Redirect("/")
    }
  }
}