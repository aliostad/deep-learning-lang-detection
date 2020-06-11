package bootstrap.liftweb


import net.liftweb.common.{Logger}
import net.liftweb.util.{Helpers}
import net.liftweb.http.{LiftRules}
import net.liftweb.sitemap.{Loc, Menu, SiteMap}
import net.liftweb.mongodb.{MongoDB, DefaultMongoIdentifier,MongoAddress, MongoHost}
import net.liftweb.sitemap.Loc._

import com.xiiik1a.model._


class Boot {
  val logger = Logger(classOf[Boot])

  def boot {
  
    LiftRules.early.append {
      _.setCharacterEncoding("UTF-8")
    }
     
    MongoDB.defineDb(
      DefaultMongoIdentifier,
      MongoAddress(MongoHost("localhost", 27017), "local"))

    LiftRules.addToPackages("com.xiiik1a")
    LiftRules.setSiteMap(SiteMap(MenuInfo.menu :_*))

    logger.info("Bootstrap up")
  }
}


object MenuInfo {
  import Loc._
  import net.liftweb.sitemap.**

  val IfLoggedIn = If(() => User.currentUser.isDefined, "You must be logged in")

  def menu: List[Menu] = 
    List[Menu](Menu.i("Home") / "index",
               Menu.i("Add a New Department") / "editDepartment" >> Hidden >> IfLoggedIn,
               Menu.i("Manage Departments") / "manageDepartments" >> IfLoggedIn,
               Menu.i("Manage Employees") / "manageEmployees" >>  IfLoggedIn,
               Menu.i("Modify Employee") / "editOneEmployee" >> Hidden >> IfLoggedIn,
               Menu.i("Help") / "help" / "index") :::
    User.sitemap  
}


