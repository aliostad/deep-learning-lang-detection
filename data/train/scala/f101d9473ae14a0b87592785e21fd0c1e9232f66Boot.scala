package bootstrap.liftweb

import net.liftweb._
import util._
import Helpers._

import common._
import http._
import js.jquery.JQueryArtifacts
import sitemap._
import Loc._
import mapper._

import lift.cookbook.model._
import net.liftmodules.JQueryModule
import javax.mail.{Authenticator, PasswordAuthentication}


/**
 * A class that's instantiated early and run.  It allows the application
 * to modify lift's environment
 */
class Boot {
  def boot {

    // where to search snippet
    LiftRules.addToPackages("lift.cookbook")

    val canManage_? = If(() => {
      true
    }, () => RedirectResponse("/"))


    val isAdmin_? = If(() => false, () => {
      RedirectWithState("/contacts/list",
        MessageState("Authorized Persons only" -> NoticeType.Warning))
    })

    // Build SiteMap
    def sitemap = SiteMap(

      Menu.i("Home") / "index",

      Menu.i("List Contacts") / "contacts" / "list",
      Menu.i("Create") / "contacts" / "create" >> canManage_?,
      Menu.i("Edit") / "contacts" / "edit" >> canManage_?,
      Menu.i("Delete") / "contacts" / "delete" >> isAdmin_?,
      Menu.i("View") / "contacts" / "view" >> canManage_?,
      Menu.i("SendEmail") / "send",

        // more complex because this menu allows anything in the
        // /static path to be visible
        Menu (Loc("Static", Link(List("static"), true, "/static/index"),
        "Static Content"))

    )

    LiftRules.setSiteMap(sitemap)

    configureMail()


    //Init the jQuery module, see http://liftweb.net/jquery for more information.
    LiftRules.jsArtifacts = JQueryArtifacts
    JQueryModule.InitParam.JQuery = JQueryModule.JQuery172
    JQueryModule.init()

    //Show the spinny image when an Ajax call starts
    LiftRules.ajaxStart =
      Full(() => LiftRules.jsArtifacts.show("ajax-loader").cmd)

    // Make the spinny image go away when it ends
    LiftRules.ajaxEnd =
      Full(() => LiftRules.jsArtifacts.hide("ajax-loader").cmd)

    // Force the request to be UTF-8
    LiftRules.early.append(_.setCharacterEncoding("UTF-8"))

    // Use HTML5 for rendering
    LiftRules.htmlProperties.default.set((r: Req) =>
      new Html5Properties(r.userAgent))

  }

  def configureMail() = {
    import javax.mail.{PasswordAuthentication, Authenticator}
    System.setProperty("mail.smtp.starttls.enable", "true")
    System.setProperty("mail.smtp.ssl.enable", "true")
    System.setProperty("mail.smtp.host", "smtp.gmail.com")
    System.setProperty("mail.smtp.auth", "true")
    System.setProperty("mail.smtp.port", "465")

    Mailer.authenticator = for {
      user <- Props.get("mail.user")
      password <- Props.get("mail.password")
    } yield new Authenticator {
        override def getPasswordAuthentication = new PasswordAuthentication(user, password)
      }
  }
}
