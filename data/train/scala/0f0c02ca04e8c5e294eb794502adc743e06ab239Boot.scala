package bootstrap.liftweb


import net.liftweb._
import util._
import Helpers._

import common._
import http._
import sitemap._
import Loc._
import net.liftmodules.JQueryModule
import net.liftweb.http.js.jquery._
import net.liftweb.common.Logger

class Boot extends Logger {
  def boot {
    // where to search snippet
    LiftRules.addToPackages("code")

    val canManage_? = If(
      () => {
        true
      },
      () => RedirectResponse("/"))


    val entries = List(
      Menu.i("Home") / "index",
      Menu.i("Tasks") / "my" / "todo" >> canManage_? //,

     // Menu(Loc("Static", Link(List("static"), true, "/static/index"),
      //  "Static Content"))
    )

    LiftRules.setSiteMap(SiteMap(entries: _*))

    LiftRules.ajaxStart =
      Full(() => LiftRules.jsArtifacts.show("ajax-loader").cmd)

    LiftRules.ajaxEnd =
      Full(() => LiftRules.jsArtifacts.hide("ajax-loader").cmd)

    LiftRules.early.append(_.setCharacterEncoding("UTF-8"))

    // Use HTML5 for rendering
    LiftRules.htmlProperties.default.set((r: Req) =>
      new Html5Properties(r.userAgent))
  }

}
