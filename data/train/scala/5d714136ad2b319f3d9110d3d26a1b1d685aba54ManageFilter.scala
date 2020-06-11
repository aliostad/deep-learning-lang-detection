package filters

import controllers.{routes, Application}
import models.RoleType
import play.api.Logger
import play.api.mvc.{Results, Result, RequestHeader, Filter}

import scala.concurrent.Future

/**
 * Created by Leo.
 * 2015/11/14 21:24
 */
class ManageFilter extends Filter {

  private lazy val log = Logger(this.getClass)

  override def apply(f: (RequestHeader) => Future[Result])(rh: RequestHeader): Future[Result] = {
    if (rh.path.contains("manage")) {
      //      log.info(rh.remoteAddress + " is requesting management: '" + rh.uri + "'")

      Application.getLoginUser(rh.session) match {
        case Some((u, r)) =>
          // first defence with role
          r.roleType match {
            case RoleType.OWNER => f(rh)
            case _ =>
              log.warn("user: " + u.userName + ", roleType: " + r.roleType + " not authorized: " + rh.remoteAddress + ", redirected.")
              Future.successful(Results.Redirect(routes.Index.index))
          }
        //here i do not care about if the user is logged, LoginFilter should do this for me
        case _ => f(rh)
      }
    } else {
      f(rh)
    }
  }
}
