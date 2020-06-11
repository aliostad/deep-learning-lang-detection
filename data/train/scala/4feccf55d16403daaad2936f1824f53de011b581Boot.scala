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
import code.rest.Clients
import code.session.ClientCache
import code.rest.IssuesService

/**
 * A class that's instantiated early and run.  It allows the application
 * to modify lift's environment
 */
class Boot extends Logger {
  def boot {
    println("boot!")
    // where to search snippet
    LiftRules.addToPackages("code")

    IssuesService.init()
    Clients.init
//    ClientCache.startClient()
//    LiftRules.statelessDispatch.append(Clients)

    val canManage_? = If(
      // always true means everybody can manage
      () => {
        true
      },
      // if false, redirect to root
      () => RedirectResponse("/"))

    val isAdmin_? = If(
      // always false means nobody is admin
      () => {
        false
      },
      // if false, redirect to /contacts/list
      () => RedirectWithState("/contacts/list", MessageState("Authorized personnel only" -> NoticeType.Warning)))

    // Build SiteMap
    val entries = List(
      Menu.i("Home") / "index", // the simple way to declare a menu
      Menu.i("List contacts") / "contacts" / "list" >> canManage_?,
      Menu.i("Create") / "contacts" / "create" >> canManage_?,
      Menu.i("Edit") / "contacts" / "edit" >> canManage_?,
      Menu.i("Delete") / "contacts" / "delete" >> canManage_?,
      Menu.i("View") / "contacts" / "view" >> canManage_?,
      Menu.i("Send email") / "contacts" / "send",

      // more complex because this menu allows anything in the
      // /static path to be visible
      Menu(Loc("Static", Link(List("static"), true, "/static/index"),
        "Static Content")))

    // set the sitemap.  Note if you don't want access control for
    // each page, just comment this line out.
    LiftRules.setSiteMap(SiteMap(entries: _*))

    //Show the spinny image when an Ajax call starts
    LiftRules.ajaxStart =
      Full(() => LiftRules.jsArtifacts.show("ajax-loader").cmd)

    // Make the spinny image go away when it ends
    LiftRules.ajaxEnd =
      Full(() => LiftRules.jsArtifacts.hide("ajax-loader").cmd)

    // Force the request to be UTF-8
    LiftRules.early.append(_.setCharacterEncoding("UTF-8"))

    //Init the jQuery module, see http://liftweb.net/jquery for more information.
    LiftRules.jsArtifacts = JQueryArtifacts
    JQueryModule.InitParam.JQuery = JQueryModule.JQuery191
    JQueryModule.init()

  }

}
