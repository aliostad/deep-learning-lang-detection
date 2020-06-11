package cnauroth.dumpservlet

import scala.collection.immutable.ListMap

import javax.servlet.http.Cookie;

/**
 * Provides implicit type conversion of cookies to a more convenient interface.
 */
private[dumpservlet] object DumpCookie {

  /**
   * Implicitly converts a Cookie to a DumpCookie.
   *
   * @param cookie HTTP cookie.
   * @return DumpCookie wrapping the cookie.
   */
  implicit def asDumpCookie(cookie: Cookie) = new DumpCookie(cookie)
}

/**
 * Wraps HTTP cookies in a more convenient interface.
 *
 * @param cookie HTTP cookie.
 */
private[dumpservlet] final class DumpCookie(cookie: Cookie)
                                    extends PropertyProvider {

  protected override def properties = ListMap(
    "getComment" -> (() => this.cookie.getComment()),
    "getDomain" -> (() => this.cookie.getComment()),
    "getMaxAge" -> (() => this.cookie.getComment()),
    "getName" -> (() => this.cookie.getComment()),
    "getPath" -> (() => this.cookie.getComment()),
    "getSecure" -> (() => this.cookie.getComment()),
    "getValue" -> (() => this.cookie.getComment()),
    "getVersion" -> (() => this.cookie.getComment())
  )
}

