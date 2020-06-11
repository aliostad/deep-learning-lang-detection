import play.api.{Application, GlobalSettings}
import play.api.mvc.{Results, Action, RequestHeader, WithFilters}

/**
 * Created by alain on 15/05/15.
 */
object Global extends WithFilters(utils.CorsFilter()) with GlobalSettings {

  override def onStart(app: Application) = {}

  override def onStop(app: Application) = {}

  // to manage request with trailing slash
  override def onRouteRequest(request: RequestHeader) = {

    Some(request.path).filter(p => p.endsWith("/") && p != "/" ).map { p =>  // filter requests with path that are ending with '/' and not equal to root page '/'

      // Without redirect :
      //super.onRouteRequest(request.copy(path = p.dropRight(1)))

      // With redirect :
      Some(Action(Results.MovedPermanently(p.dropRight(1))))

    } getOrElse(super.onRouteRequest(request))

  }

}
