package bootstrap.liftweb

import _root_.net.liftweb.http._
import _root_.net.liftweb.sitemap._
import _root_.net.liftweb.widgets.menu.MenuWidget
import com.mycotrack.model._
import com.mycotrack.db._
import net.liftweb.util.Helpers._
import com.mycotrack.snippet.SelectedProject
import com.mycotrack.snippet._
import com.mycotrack.lift.{MycotrackAjaxRules, MycotrackUrlRewriter}
import net.liftweb.common.{Logger, Full}

/**
 * A class that's instantiated early and run.  It allows the application
 * to modify lift's environment
 */
class Boot extends MycotrackUrlRewriter with MycotrackAjaxRules with Logger {
  def boot {
    // where to search snippet
    LiftRules.addToPackages("com.mycotrack")

    // Build SiteMap
    LiftRules.setSiteMap(SiteMap(MenuInfo.menu: _*))
    /*LiftRules.setSiteMap(new SiteMap(List({
      case Full(Req(path, _, _)) if !User.currentUser.isDefined && path != List("user_mgt", "login") =>
        info("Redirecting to login")
        Loc.EarlyResponse(() => Full(RedirectResponse("/user_mgt/login")))
    }), MenuInfo.menu:_*))*/

    MenuWidget init

      //Set up MongoDB
      MycoMongoDb.setup

    //REST API
    LiftRules.dispatch.append(com.mycotrack.api.MycotrackApi) // stateful — associated with a servlet container session
    LiftRules.statelessDispatchTable.append(com.mycotrack.api.MycotrackApi) // stateless — no session created

  }
}

object MenuInfo {

  import Loc._

  //val IfLoggedIn = If(() => User.currentUser.isDefined, "You must be logged in")
  val IfLoggedIn = If(() => User.loggedIn_?, () => RedirectResponse("/user_mgt/login"))
  //val IfSuperUser = If(() => User.currentUser.get.superUser == true, "You must be a superuser")

  def menu: List[Menu] =
    List[Menu](Menu(Loc("home", List("index"), "Home", IfLoggedIn, Hidden)),
      Menu(Loc("manage", List("manage"), "Manage Project", IfLoggedIn, Hidden)),
      Menu(Loc("library", List("library"), "Culture Library", IfLoggedIn, Hidden)),
      Menu(Loc("createCulture", List("createCulture"), "New Culture", IfLoggedIn, Hidden)),
      Menu(Loc("newProject", List("create"), "New Project", IfLoggedIn, Hidden)),
      Menu(Loc("createEvent", List("createEvent"), "Create Event", IfLoggedIn, Hidden)),
      Menu(Loc("createNote", List("createNote"), "Create Note",  IfLoggedIn, Hidden)),
      Menu(Loc("events", List("events"), "Add Events", IfLoggedIn, Hidden)),
      Menu(Loc("speciesInfo", List("speciesInfo"), "Species Info", IfLoggedIn, Hidden)),
      Menu(Loc("splitProject", List("splitProject"), "Split Project", IfLoggedIn, Hidden)),
      Menu(Loc("manageSpecies", List("manageSpecies"), "Add Species", IfLoggedIn, Hidden))) :::
      User.sitemap
      //User.sitemap :::
      //List[Menu](Menu("Help") / "help" / "index")

}