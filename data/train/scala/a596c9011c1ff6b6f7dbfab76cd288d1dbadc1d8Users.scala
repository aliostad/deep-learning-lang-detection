package eu.sbradl.liftedcontent.core.snippet

import eu.sbradl.liftedcontent.core.model.Role
import eu.sbradl.liftedcontent.core.model.User
import net.liftweb.http.js.JsCmd
import net.liftweb.http.js.JsCmds
import net.liftweb.http.S
import net.liftweb.http.SHtml
import net.liftweb.mapper.By
import net.liftweb.util.Helpers.strToCssBindPromoter
import net.liftweb.util.IterableConst.itNodeSeqFunc
import scala.xml.Text

class UserRoles {

  def render = {
    val roles = User.effectiveRoles

    "*" #> {
      roles map (role => "data-name=role *" #> role.name.is)
    }

  }

}

class ManageRoles(user: User) {

  def addOrRemoveRole(roleId: Long, addOrRemove: Boolean): JsCmd = {
    if (addOrRemove) {
      val userRole = eu.sbradl.liftedcontent.core.model.UserRoles.create
      userRole.user(user.id.is)
      userRole.role(roleId)
      userRole.save
    } else {
      val userRole = eu.sbradl.liftedcontent.core.model.UserRoles.find(
        By(eu.sbradl.liftedcontent.core.model.UserRoles.user, user.id.is),
        By(eu.sbradl.liftedcontent.core.model.UserRoles.role, roleId)).open_!

      userRole.delete_!
    }

    JsCmds.RedirectTo("/admin/users/manage-roles/" + user.id.is)
  }

  def render = {
    val title = <header><h1>{ S ? "MANAGE_ROLES" } { S ? "FOR" } { user.email.is }</h1></header>
    val roles = Role.findAll

    "data-name=title" #> title &
      "data-name=roles *" #> (roles map {
        role =>
          {
            val belongsToRole = eu.sbradl.liftedcontent.core.model.UserRoles.count(
              By(eu.sbradl.liftedcontent.core.model.UserRoles.user, user.id.is),
              By(eu.sbradl.liftedcontent.core.model.UserRoles.role, role.id.is)) != 0

            "data-name=checkbox" #> SHtml.ajaxCheckbox(belongsToRole, (value) => addOrRemoveRole(role.id.is, value)) &
              "data-name=role *" #> Text(role.name.is)
          }
      })
  }

}