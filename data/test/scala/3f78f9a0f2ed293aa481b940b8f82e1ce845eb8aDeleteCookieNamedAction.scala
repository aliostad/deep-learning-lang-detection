package net.selenate
package server
package sessions
package actions

import common.comms.res._
import common.comms.req._
import java.util.ArrayList
import org.openqa.selenium.firefox.FirefoxDriver
import org.openqa.selenium.remote.RemoteWebElement
import scala.collection.JavaConversions._


class DeleteCookieNamedAction(val d: FirefoxDriver)(implicit context: ActionContext)
    extends IAction[SeReqDeleteCookieNamed, SeResDeleteCookieNamed]
    with ActionCommons {

  protected val log = Log(classOf[DeleteCookieNamedAction])

  def act = { arg =>
    inAllWindows { address =>
      d.manage.deleteCookieNamed(arg.name)
    }
    new SeResDeleteCookieNamed()
  }
}
