package com.example.http

import javax.inject.{Inject, Singleton}
import javax.naming.AuthenticationException

import com.example.service.ExampleService
import com.twitter.finagle.http.{Request, Status}
import com.twitter.finatra.http.Controller
import com.twitter.finatra.request.FormParam
import com.twitter.finatra.validation._
import finatra.freemarker.Freemarker
import finatra.greatbit.shiro.ShiroFilter
import org.apache.shiro.SecurityUtils
import org.apache.shiro.authc.{IncorrectCredentialsException, LockedAccountException, UnknownAccountException, UsernamePasswordToken}
import org.apache.shiro.session.UnknownSessionException
import org.apache.shiro.subject.Subject

@Singleton
class SecurityController @Inject()(service: ExampleService) extends Controller {

  get("/login") { _: Request =>
    LoginView()
  }

  post("/login") { lur: LoginUserRequest =>
    val cu = SecurityUtils.getSubject

    val token = new UsernamePasswordToken(lur.username, lur.password)
    token.setRememberMe(lur.remember)
    response.status(Status.Unauthorized.code)

    try {
      cu.login(token)
      response.temporaryRedirect.location("/info").toFuture
    } catch {
      case e: UnknownSessionException =>
        try {
          cu.logout()
        } catch {
          case e: Exception => e.printStackTrace()
        }
        LoginView(error = Status.GatewayTimeout.reason)
      case e: UnknownAccountException => LoginView(error = Status.Forbidden.reason)
      case e: IncorrectCredentialsException => LoginView(error = Status.NonAuthoritativeInformation.reason)
      case e: LockedAccountException => LoginView(error = Status.Locked.reason)
      case e: AuthenticationException => LoginView(error = Status.Unauthorized.reason)
    }
  }
  filter[ShiroFilter].any("/info") { _: Request =>
    InfoView(SecurityUtils.getSubject)
  }

  get("/logout") { _: Request =>
    val cu = SecurityUtils.getSubject
    cu.logout()
    response.ok.plain(s"Current User:${cu.getPrincipal} is LOGOUT!!!")
  }

  filter[ShiroFilter].get("/console") { _: Request =>
    val cu = SecurityUtils.getSubject
    if (cu.isAuthenticated) ManageIndexView(cu)
    else LoginView()
  }
}

@Freemarker("info")
case class InfoView(user: Subject = null)

@Freemarker("login")
case class LoginView(user: Subject = null, error: String = null, success: String = null)

@Freemarker("manage/index")
case class ManageIndexView(user: Subject)

case class LoginUserRequest(@FormParam @NotEmpty username: String,
                            @FormParam @NotEmpty password: String,
                            @FormParam remember: Boolean = false)
