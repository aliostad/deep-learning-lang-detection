package services


import javax.inject.Inject

import org.mindrot.jbcrypt.BCrypt

import models._

import scala.concurrent._
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration.Duration

/**
 * Created by kyota.yasuda on 15/08/17.
 */
class UserService @Inject()(val manageUserService: ManageUserService,
                            val manageTweetService: ManageTweetService) {

  def authenticate(screen_name: String, password: String): Option[User] = {
    val f = manageUserService.getUserByScreenName(screen_name)
      .map(userOption =>
        userOption.filter(user => user.password.isDefined)
          .filter(user => BCrypt.checkpw(password, user.password.get))
      )
    Await.result(f, Duration.Inf)
  }

  def create(user: User): Future[Any] = {
    val userForSave = user.copy(password = Option(BCrypt.hashpw(user.password.get, BCrypt.gensalt())))
    manageUserService.insertUser(userForSave)
  }

  def makeFollow(from: User, to: User): Future[Any] = {
    if (from.follow.contains(to.id)) {
      Future.successful()
    } else {
      val toUpdate = from.copy(follow = to.id :: from.follow)
      manageUserService.updateUser(toUpdate).flatMap { user =>
        val toUpdate = to.copy(follower = from.id :: to.follower)
        manageUserService.updateUser(toUpdate)
      }
    }
  }

  def makeUnfollow(from: User, to: User): Future[Any] = {
    val toUpdate = from.copy(follow = from.follow.filter(_ != to.id))
    manageUserService.updateUser(toUpdate).flatMap { user =>
      val toUpdate = to.copy(follower = to.follower.filter(_ != from.id))
      manageUserService.updateUser(toUpdate)
    }
  }
}
