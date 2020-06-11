package config

import controllers.users.{ MenuItem, MenuBar }
import models.conferences.{ Conferences, Event }
import models.users.Role
import models.courses.{ Teacher, Guardian }

object ConferencesMenu {
  def SomeIf[T](cond: Boolean)(t: => T): Option[T] = if (cond) Some(t) else None

  def forRole(maybeRole: Option[Role]): Option[MenuItem] = maybeRole match {
    case None => None
    case Some(role) => {
      val perms = role.permissions()
      val eventItems: List[MenuItem] = Event.getActive().map(e => role match {
        case role: Teacher => Some(new MenuItem(e.name, s"menu_event${e.id}", Some(controllers.routes.Conferences.eventForTeacher(e.id).toString), Nil))
        case role: Guardian => Some(new MenuItem(e.name, s"menu_event${e.id}", Some(controllers.routes.Conferences.eventForGuardian(e.id).toString), Nil))
        case _ => None
      }).flatten
      val items: List[MenuItem] = if (perms.contains(Conferences.Permissions.Manage)) {
          new MenuItem("Manage", "menu_manage", None, Nil, List(
            new MenuItem("List Events", "menu_listevents", Some(controllers.routes.Conferences.listEvents.toString), Nil),
            new MenuItem("View Teacher Schedule", "menu_teacherConfSched", Some(controllers.routes.Conferences.viewTeacher().toString), Nil),
            new MenuItem("View Guardian Schedule", "menu_guardianConfSched", Some(controllers.routes.Conferences.viewGuardian().toString), Nil)
          )) :: eventItems
      } else {
        eventItems
      }
      SomeIf(!items.isEmpty)(new MenuItem("Conferences", "menu_conferences", None, items))
    }
  }
}