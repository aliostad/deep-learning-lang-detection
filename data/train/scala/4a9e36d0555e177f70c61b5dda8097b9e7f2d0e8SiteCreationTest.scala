package com.anisakai.test.cucumber.stepdefs

import java.util.{List => JList}
import com.anisakai.test.pageobjects.{Portal, SiteManageTool}
import cucumber.api.DataTable
import cucumber.api.scala.{EN, ScalaDsl}
import com.anisakai.test.Config
import scala.collection.JavaConverters._
import scala.collection.mutable.ListBuffer
/**
 * Created with IntelliJ IDEA.
 * User: jbush
 * Date: 8/24/13
 * Time: 11:28 PM
 * To change this template use File | Settings | File Templates.
 */
class SiteCreationTest extends ScalaDsl with EN with TearDown {
  var maintainRole : String = ""
  var newlyCreatedSite: Boolean = true
  var siteTitles = new ListBuffer[String]

  Given( """^the following sites exist:$""") {
    (data: DataTable) =>
      val row = data.asMaps(classOf[String], classOf[String]).iterator
      while (row.hasNext) {
        val map = row.next
        val siteId = map.get("id")
        siteTitles += map.get("title") // we do this so we can add the appropriate tools to each site
        val title = map.get("title")
        val description = map.get("description")
        val contactname = map.get("contactname")
        val siteType = map.get("sitetype")
        maintainRole = SiteManageTool.getMaintainRole
        Portal.goToTool("Sites")
        newlyCreatedSite = SiteManageTool.createSiteWithSitesTool(siteType, title, siteId)
        if (newlyCreatedSite) {
          if (Config.isTen) {
            Portal.goToTool("Worksite Setup", true)
          } else {
            Portal.goToTool("Site Setup", true)
          }
          if (SiteManageTool.findSiteAndEdit(title)) {
            SiteManageTool.editSite(description, description, contactname)
            SiteManageTool.manageAccess(true, false)
          }
        }
      }
  }

  And ("""^the sites have the following tools:$""") { (data:JList[String]) =>
    if (data.get(0) == "All") {
      siteTitles.foreach(title => SiteManageTool.addTools(siteTitle = title))
    } else {
      siteTitles.foreach(title => SiteManageTool.addTools(tools = data.asScala.toList, siteTitle = title))
    }
  }

  Given( """^the following memberships exist:$""") {
    (data: DataTable) =>
      val row = data.asMaps(classOf[String], classOf[String]).iterator

      while (row.hasNext) {
        val map = row.next
        val siteId = map.get("site-id")
        val userEid = map.get("user-eid")
        var role = map.get("role")

        if (role.equalsIgnoreCase("instructor")) {
          role = maintainRole
        }

        Portal.goToSiteDirectly(siteId)
        Portal.goToTool("Site Editor", true)


        SiteManageTool.addUserWithRole(userEid, role)

        // doing this so we can can come back to Site Editor and reset
        Portal.goToTool("Home")
      }

  }

}
