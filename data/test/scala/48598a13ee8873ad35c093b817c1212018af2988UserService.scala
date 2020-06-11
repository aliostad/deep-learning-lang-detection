package org.trackpro.services

import org.trackpro.model.{Project, User}
import org.trackpro.persistence.{Projects, Users}
import spray.routing.authentication.UserPass

import scala.concurrent.Future

/**
  * Created by Petar on 8/4/2016.
  */
class UserService (val persistence: PersistenceServices){

  import scala.concurrent.ExecutionContext.Implicits.global

  //metoda za kreiranje usera
  def createUser(user :User): Future[User]=persistence.persistUser(user)

  //dohvatanje usera by id
  def getUser(id:Long): Future[Option[User]] =persistence.userById(id)
  //metoda za autorizaciju
  def authenticate(userPass:Option[UserPass]):Future[Option[User]] = userPass map {
    credentials => persistence.userByEmail(credentials.user).map{

      _ filter{user => user.password.sameElements(credentials.pass)} orElse(None)
    }
  } getOrElse Future.successful(None)

  //dodatna metoda za proveru permisija usera nad projektom
  def canManageProjects(userId: Long,projectId: Long):Future[Option[(Project, User)]]=persistence.canManage(userId,projectId)


  //nepotrebna
  def findAll(): Future[Seq[(User,Project)]] = persistence.getAllUsers()

}
