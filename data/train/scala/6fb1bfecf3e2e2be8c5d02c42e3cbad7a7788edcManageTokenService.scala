package services.security

import com.outworkers.phantom.dsl.ResultSet
import domain.security.UserGeneratedToken
import domain.users.User
import services.security.Impl.ManageTokenServiceImpl

import scala.concurrent.Future

/**
  * Created by hashcode on 6/24/17.
  */
trait ManageTokenService {

  def createNewToken(user: User,agent:String): Future[UserGeneratedToken]

  def revokeToken(token: String): Future[ResultSet]

  def getTokenRole(token: String): Future[String]

  def getEmail(token: String): Future[String]

  def getOrganisationCode(token: String): Future[String]

  def isTokenValid(token: String, agent: String): Future[Boolean]

}

object ManageTokenService{
  def apply: ManageTokenService = new ManageTokenServiceImpl()
}
