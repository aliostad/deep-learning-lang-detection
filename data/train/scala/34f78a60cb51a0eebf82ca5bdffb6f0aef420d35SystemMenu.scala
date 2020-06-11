package views.menu

import scala.collection.mutable.LinkedHashMap
import controllers.routes

object SystemMenu {
  implicit val implicitLeftNav = LinkedHashMap(
	"nav.sys.settings" -> routes.SettingController.edit,
	"nav.homePage.edit" -> routes.HomePageController.edit,
	"nav.user.list" -> routes.UserController.manage,
	"nav.file.list" -> routes.FileController.list,
	"nav.stdPage.list" -> routes.StandardPageController.list,
  "a" -> null,
	"nav.event.tag.list" -> routes.EventTagController.list,
  "b" -> null,
	"nav.organization.list" -> routes.OrganizationController.list,
  "c" -> null,
	"nav.geo.country.list" -> routes.CountryController.list,
	"nav.geo.city.list" -> routes.CityController.list
  )
}
