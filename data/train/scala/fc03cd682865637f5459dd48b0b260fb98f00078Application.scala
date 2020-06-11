package controllers

import views.html.index
import play.api._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import models.{DAO, DAOComponent}
import java.util.concurrent.TimeoutException
import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global

/**
  * Manage a database of employees
  */
class Application(dao: DAOComponent) extends Controller {

  def index = Action {
    Ok(views.html.index("hello there", "Bobby"))
  }

}

object Application extends Application(DAO)
