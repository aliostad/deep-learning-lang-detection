package controllers
import services._
import javax.inject.Inject

import play.api.Configuration
import play.api.cache.CacheApi
import play.api.mvc.{Action, Controller}

/**
  * Created by knoldus on 3/8/17.
  */
class ManageController @Inject()(cache: CacheApi, cacheService:CacheTrait, configuration: Configuration) extends Controller{

  def ManagementArea()= Action { implicit  request =>

    val allUsers =  bufferService.getAllUsers
    val users = for {
      userName <- allUsers
    }yield  cacheService.getCache(userName)
    Ok(views.html.Manage(users.flatten.toList))

  }

  def suspendUser(username:String)= Action { implicit  request =>
    val users = cacheService.getCache(username)
    users match {
      case Some(user) => {
        val BlockedUser = user.copy(isAllow = true)
        cacheService.removeFromCache(username)
        cache.set(username,BlockedUser)
      }
      case None=>
    }
    Redirect(routes.ManageController.ManagementArea())
  }
  def resumeUser(username:String)= Action { implicit  request =>
    val users = cacheService.getCache(username)
    users match {
      case Some(user) => {
        val resumedUser = user.copy(isAllow = false)
        cacheService.removeFromCache(username)
        cacheService.setCache(username,resumedUser)
      }
    }
    Redirect(routes.ManageController.ManagementArea())
  }

}
