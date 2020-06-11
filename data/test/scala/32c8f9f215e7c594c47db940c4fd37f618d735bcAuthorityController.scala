package controllers

import com.google.inject.Inject
import play.api.mvc.{Action, Controller}
import services.RWService


class AuthorityController @Inject() (rWService: RWService) extends Controller{

  def manageAuthority = Action{

    val list = rWService.getUserList
    println(list)
    Ok(views.html.userList(list))
  }

  def suspend(username: String) = Action{

    implicit request =>
      rWService.suspendUser(username)
      Redirect(routes.AuthorityController.manageAuthority())
  }

  def resume(username: String) = Action{
    implicit request =>
      rWService.resumeUser(username)
      Redirect(routes.AuthorityController.manageAuthority()) }
}

