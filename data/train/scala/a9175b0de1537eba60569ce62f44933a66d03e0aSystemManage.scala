package models.slick.systemmanage

import scala.slick.lifted._

/**
 * Created by hooxin on 15-1-26.
 */
object SystemManage {
  val departments = TableQuery[DepartmentTable]
  val users = TableQuery[UserTable]
  val dicts = TableQuery[DictTable]
  val dictItems = TableQuery[DictItemTable]
  val functions = TableQuery[FunctionTable]
  val roles  = TableQuery[RoleTable]
  val roleFuncs = TableQuery[RoleFuncTable]
  val menus = TableQuery[MenuTable]
  val roleMenus = TableQuery[RoleMenuTable]
  val globalParams = TableQuery[GlobalParamTable]
  val userRoles = TableQuery[UserRoleTable]
}
