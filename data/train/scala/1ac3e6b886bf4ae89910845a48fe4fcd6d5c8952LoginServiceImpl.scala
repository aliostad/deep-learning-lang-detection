package services.security.Impl

import com.datastax.driver.core.ResultSet
import domain.security.{Credential, UserGeneratedToken}
import domain.users.{Login, User}
import services.security.{AuthenticationService, LoginService, ManageTokenService}
import services.users.UserService

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

/**
  * Created by hashcode on 6/8/17.
  */
class LoginServiceImpl extends LoginService{

  override def getUser(email: String,siteId:String): Future[Option[User]] = {
    UserService.getSiteUser(email,siteId)
  }


  override def createNewToken(credential: Credential, agent:String): Future[UserGeneratedToken] = {
    val createdToken = for{
      user <-  UserService.getSiteUser(credential.email,credential.siteId)
      } yield {
      val userProfile = UserService.extractUser(user)
      if (AuthenticationService.apply.checkPassword(credential.password,userProfile.password)){
        ManageTokenService.apply.createNewToken(userProfile,agent)
      }else{
        Future{ UserGeneratedToken("NONE","INVALID","TOKEN NOT ISSUED",userProfile.siteId) }
      }
    }
    createdToken.flatten
  }

  override def revokeToken(token: String): Future[ResultSet] = {
    ManageTokenService.apply.revokeToken(token)
  }

  override def getTokenRolesFromToken(token: String): Future[String] = {
    ManageTokenService.apply.getTokenRole(token)
  }

  override def getEmailFromToken(token: String): Future[String]= {
    ManageTokenService.apply.getEmail(token)
  }

  override def getOrganisationCodeFromToken(token: String): Future[String]= {
    ManageTokenService.apply.getOrganisationCode(token)
  }

  override def isTokenValid(token: String, agent: String): Future[Boolean] = {
    ManageTokenService.apply.isTokenValid(token,agent)
  }

  override def getLogins(email: String): Future[Seq[Login]] = {
    val accounts = UserService.getUserAccounts(email)
    accounts map ( accs => accs map ( acc => Login(email,Set()+acc.siteId )))
  }
}
