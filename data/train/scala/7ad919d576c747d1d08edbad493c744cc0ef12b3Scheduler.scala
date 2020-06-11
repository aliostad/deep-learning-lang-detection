package controllers

import play.api._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._


import anorm._

import models._
import views._

/**
 * Manage projects related operations.
 */
object Scheduler extends Controller with Secured {

  /**
   * Display the dashboard.
   */
  def index = IsAuthenticated { username => _ =>
    User.findByEmail(username).map { user =>
      Ok(
        html.scheduler(
          user
        )
      )
    }.getOrElse(Forbidden)
  }
//  def index = IsAuthenticated { username => _ =>
//    User.findByEmail(username).map { user =>
//      Ok(
//        html.dashboard(
//          Project.findInvolving(username), 
//          Task.findTodoInvolving(username), 
//          user
//        )
//      )
//    }.getOrElse(Forbidden)
//  }

}

