package org.packtpublishing.service

import slick.driver.H2Driver.api._
import spray.routing.authentication.UserPass
import scala.concurrent.Future

import org.packtpublishing.model.User
import org.packtpublishing.model.Permissions

class UserService(val persistence: PersistenceService) {
  import scala.concurrent.ExecutionContext.Implicits.global
  import org.packtpublishing.security.PasswordHasher._
  
  def authenticate(userPass: Option[UserPass]): Future[Option[User]] = userPass map { credentials =>
      persistence
        .findUserByUsername(credentials.user)
        .map { 
          _ filter { user => user.password.sameElements(hash(credentials.pass, user.salt)) } orElse None 
        } 
    } getOrElse Future.successful(None)
    
  def createUser(username: String, password: String, pemissions: Seq[Permissions.Permission]) =
    persistence.persistUser(new User(username, hash(password))) map { 
      persistence.addPermissions(_, pemissions)
    }
    
  def canManageBooks(user: User) = user.permissions exists { _ == Permissions.MANAGE_BOOKS }
  def canManagePublishers(user: User) = user.permissions exists { _ == Permissions.MANAGE_PUBLISHERS }
}

