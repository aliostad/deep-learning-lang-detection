package com.anisakai.test.cucumber.stepdefs

import com.anisakai.test.pageobjects._
import cucumber.api.scala.{EN, ScalaDsl}
import cucumber.api.scala.{ScalaDsl, EN}
import scala.collection.mutable.ListBuffer

/**
 * Created by gareth on 12/9/14.
 */
class PopulateSiteTest extends ScalaDsl with EN with TearDown{
  var eids = new ListBuffer[String]

  And("""I create '(.+)' users""") { (numUsers: Int) =>
    for (i <- 1 to numUsers) {
      Portal.goToTool("Users")
      eids += UsersTool.randomUser
    }
  }

  Then("""I add the students to a random site""") { () =>
    Portal.goToSite(SiteManageTool.createRandomSite("course"))
    Portal.goToTool("Site Setup")
    SiteManageTool.addUserWithRole(role = "Student", bulk = true, eids = eids.toList)
  }
}
