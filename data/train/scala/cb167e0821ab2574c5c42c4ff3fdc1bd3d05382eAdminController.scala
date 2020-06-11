package controllers

import javax.inject.Inject

import Models.Operations
import play.api.cache
import play.api.cache.CacheApi
import play.api.mvc.{Action, Controller}
import services.CacheTrait

import scala.collection.mutable.ListBuffer


class AdminController @Inject() (cacheService: CacheTrait) extends Controller {

  def manageUsers() = Action {
    implicit request =>
      val list: ListBuffer[String] = Operations.listOfUsersNames
      Ok(views.html.adminprivileges(list.toList)).flashing("msg" -> "msg")

  }

  def suspend(user: String) = Action {
    implicit request =>
      val suspendedUser = cacheService.getFromCache(user)
      suspendedUser match{
        case Some(x) => cacheService.addToCache(user,x.copy(status = false))
        case _ => throw new Exception("Error")

      }
      Redirect(routes.AdminController.manageUsers()).flashing("status" -> "Suspended")



  }

  def resume(user: String) = Action {
    implicit request =>
      val resumedUser = cacheService.getFromCache(user)
      resumedUser match{
        case Some(x) => cacheService.addToCache(user,x.copy(status = true))
        case _ => Ok(views.html.index())
      }
      Redirect(routes.AdminController.manageUsers()).flashing("status" -> "Resumed")




  }


}