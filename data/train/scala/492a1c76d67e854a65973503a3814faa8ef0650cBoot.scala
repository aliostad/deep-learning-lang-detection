package bootstrap.liftweb

import net.liftweb._
import util._
import Helpers._

import common._
import http._
import sitemap._
import Loc._
import mapper._

import net.liftweb.couchdb.{CouchDB, Database, DatabaseInfo}
import dispatch.{Http, StatusCode}
import net.liftweb.http.ResourceServer
import net.liftweb.http.auth.{HttpBasicAuthentication,AuthRole,userRoles}

import code.api._

import code.model._
import code.snippet.LoggedIn

/**
* A class that's instantiated early and run.  It allows the application
* to modify lift's environment
*/
class Boot extends Logger {
  def boot {

    // MySql connection for stats
    if (!DB.jndiJdbcConnAvailable_?) {
      val vendor = 
        new StandardDBVendor(Props.get("db.driver") open_!, 
        Props.get("db.url") open_!,
        Props.get("db.user"), Props.get("db.password"))

      LiftRules.unloadHooks.append(vendor.closeAllConnections_! _)

      DB.defineConnectionManager(DefaultConnectionIdentifier, vendor)
    }

    /* Crosshair plugin suffers from an execution bug on line 155, which I did not succeed in fixing 
    ResourceServer.allow({
      case "flot" :: "jquery.flot.crosshair.js" :: Nil => true
    })
    */

    // Use Lift's Mapper ORM to populate the database
    // you don't need to use Mapper to use Lift... use
    // any ORM you want
    Schemifier.schemify(true, Schemifier.infoF _, Stats)

    // where to search snippet
    LiftRules.addToPackages("code")

    // Hook for the webservice
    LiftRules.dispatch.append(REST_Webservice) // stateful -- associated with a servlet container session


    // Rule that handles authentication for us
    LiftRules.dispatch.prepend(NamedPF("Management Access") {
      case Req("manage" :: page, "", _) if !LoggedIn.is && page.head != "login" =>
        () => Full(RedirectResponse("/manage/login"))
    })
 

    // Build SiteMap
    val entries = List(
      Menu.i("Index") / "index",
      Menu.i("Manage") / "manage" / "index" submenus(
        Menu.i("Edit Customer") / "manage" / "edit" >> Hidden,
        Menu.i("Login") / "manage" / "login" >> Hidden,
        Menu.i("Customer Stats") / "manage" / "stats" >> Hidden),
      Menu.i("About") / "about")

    SiteMap.enforceUniqueLinks = false;

    LiftRules.setSiteMap(SiteMap(entries:_*))

    // Use jQuery 1.4
    LiftRules.jsArtifacts = net.liftweb.http.js.jquery.JQuery14Artifacts

    //Show the spinny image when an Ajax call starts
    LiftRules.ajaxStart =
    Full(() => LiftRules.jsArtifacts.show("ajax-loader").cmd)

    // Make the spinny image go away when it ends
    LiftRules.ajaxEnd =
    Full(() => LiftRules.jsArtifacts.hide("ajax-loader").cmd)

    // Force the request to be UTF-8
    LiftRules.early.append(_.setCharacterEncoding("UTF-8"))


    //sets the default database for the application
    val (http, db) = CustomerUtils.init

    debug(http(db info))
  }
}
