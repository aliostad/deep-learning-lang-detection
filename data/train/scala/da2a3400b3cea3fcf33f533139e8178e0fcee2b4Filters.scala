package filters

import javax.inject.Inject

import play.api.http.HttpFilters
import play.filters.csrf.CSRFFilter
import play.filters.gzip.GzipFilter

/**
 * Created by Leo.
 * 2016/1/7 21:45
 */
class Filters @Inject()(https: HttpsFilter,
                        log: LogFilter,
                        login: LoginFilter,
                        manage: ManageFilter,
                        csrf: CSRFFilter) extends HttpFilters {

  private val gzip = new GzipFilter(shouldGzip = (request, response) => request.uri.startsWith("/assets"))

  val filters = Seq(
    //    https,
    log,
    login,
    manage,
    //    csrf,
    gzip
  )
}