package cnauroth.dumpservlet

import scala.collection.immutable.ListMap

import javax.servlet.http.HttpSession;

/**
 * Provides implicit type conversion of sessions to a more convenient interface.
 */
private[dumpservlet] object DumpSession {

  /**
   * Implicitly converts an HttpSession to a DumpSession.
   *
   * @param session HTTP session.
   * @return DumpSession wrapping the session.
   */
  implicit def asDumpSession(session: HttpSession) = new DumpSession(session)
}

/**
 * Wraps HTTP sessions in a more convenient interface.
 *
 * @param session HTTP session.
 */
private[dumpservlet] final class DumpSession(session: HttpSession)
                                    extends PropertyProvider {

  protected override def properties = ListMap(
    "getCreationTime" -> (() => this.session.getCreationTime()),
    "getId" -> (() => this.session.getId()),
    "getLastAccessedTime" -> (() => this.session.getLastAccessedTime()),
    "getMaxInactiveInterval" -> (() => this.session.getMaxInactiveInterval()),
    "isNew" -> (() => this.session.isNew())
  )
}

