package eu.sbradl.liftedcontent.core

import eu.sbradl.liftedcontent.util.Module
import eu.sbradl.liftedcontent.core.model.Role
import net.liftweb._
import util._
import Helpers._
import sitemap._
import Loc._
import net.liftweb.http.S
import eu.sbradl.liftedcontent.core.model.User
import eu.sbradl.liftedcontent.core.model.ACLEntry
import eu.sbradl.liftedcontent.core.model.UserRoles
import eu.sbradl.liftedcontent.admin.model.BackendArea

class PermissionModule extends Module {
  
  override def name = "Permissions"

  override def mappers = List(Role, ACLEntry, UserRoles)

  override def init {
    
    BackendArea.insert("GROUP_SETTINGS", "groups.png", "roles", "MANAGE_ROLES")
    
    val userSubmenus = List(
        Menu.param[User]("ManageRoles", S ? "MANAGE_ROLES", User.find, _.id.toString) / "admin" / "users" / "manage-roles"	
    )
    
    BackendArea.insert("USER_SETTINGS", "users.png", "users", "MANAGE_USERS")
    BackendArea.addMenu("users", userSubmenus)
    
    BackendArea.insert("PERMISSION_SETTINGS", "permissions.png", "permissions", "MANAGE_PERMISSIONS")

  }

}