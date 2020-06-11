package services.security.Impl

import com.outworkers.phantom.dsl.ResultSet
import conf.util.{Events, HashcodeKeys}
import domain.security.{Token, UserGeneratedToken}
import domain.users.User
import services.security.{ManageTokenService, TokenGenerationService, TokenService}
import services.users.UserRoleService

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

/**
  * Created by hashcode on 6/8/17.
  */
class ManageTokenServiceImpl extends ManageTokenService {

  override def createNewToken(user: User, agent: String): Future[UserGeneratedToken] = {
    for {
      role <- UserRoleService.getUserRole(user)
      claims <- Future {
        TokenGenerationService.apply.createClaims(user.email, user.siteId, role.roleId, agent)
      }
      token <- TokenGenerationService.apply.getToken(claims)
    } yield {
      val createdToken = Token(token,token)
      TokenService.save(createdToken)
      UserGeneratedToken(token, Events.TOKENCREATED, Events.TOKENSUCCESSMESSAGE, user.siteId)
    }
  }

  override def revokeToken(token: String): Future[ResultSet] = {
    TokenService.invalidateToken(token)
  }

  override def getTokenRole(token: String): Future[String] = {
    TokenGenerationService.apply.getClaimFromToken(token, HashcodeKeys.ROLE)
  }

  override def getEmail(token: String): Future[String] = {
    TokenGenerationService.apply.getClaimFromToken(token, HashcodeKeys.EMAIL)
  }

  override def getOrganisationCode(token: String): Future[String] = {
    TokenGenerationService.apply.getClaimFromToken(token, HashcodeKeys.ORGCODE)
  }

  override def isTokenValid(token: String, agent: String): Future[Boolean] = {
    for{
      claims <- TokenGenerationService.apply.getTokenClaims(token)
      hashExpired <- tokeInStorage(token)
    } yield TokenGenerationService.apply.verifyClaims(claims, agent) && hashExpired
  }

  private  def tokeInStorage(token: String): Future[Boolean] = TokenService.getTokenById(token) map {
    case Some(_) => true
    case None => false
  }
}
