package com.ecfront.lego.rbac.foundation

object ServiceInfo extends Enumeration {

  private val BASE: String = "rbac."

  val MANAGE_APP_SAVE: String = BASE + "manage.app.save"
  val MANAGE_APP_UPDATE: String = BASE + "manage.app.update"
  val MANAGE_APP_GET: String = BASE + "manage.app.get"
  val MANAGE_APP_FIND: String = BASE + "manage.app.find"
  val MANAGE_APP_PAGE: String = BASE + "manage.app.page"
  val MANAGE_APP_DELETE: String = BASE + "manage.app.delete"

  val MANAGE_ORGANIZATION_SAVE: String = BASE + "manage.organization.save"
  val MANAGE_ORGANIZATION_UPDATE: String = BASE + "manage.organization.update"
  val MANAGE_ORGANIZATION_GET: String = BASE + "manage.organization.get"
  val MANAGE_ORGANIZATION_FIND: String = BASE + "manage.organization.find"
  val MANAGE_ORGANIZATION_PAGE: String = BASE + "manage.organization.page"
  val MANAGE_ORGANIZATION_DELETE: String = BASE + "manage.organization.delete"

  val MANAGE_ACCOUNT_SAVE: String = BASE + "manage.account.save"
  val MANAGE_ACCOUNT_UPDATE: String = BASE + "manage.account.update"
  val MANAGE_ACCOUNT_GET: String = BASE + "manage.account.get"
  val MANAGE_ACCOUNT_FIND: String = BASE + "manage.account.find"
  val MANAGE_ACCOUNT_PAGE: String = BASE + "manage.account.page"
  val MANAGE_ACCOUNT_DELETE: String = BASE + "manage.account.delete"

  val MANAGE_ROLE_SAVE: String = BASE + "manage.role.save"
  val MANAGE_ROLE_UPDATE: String = BASE + "manage.role.update"
  val MANAGE_ROLE_GET: String = BASE + "manage.role.get"
  val MANAGE_ROLE_FIND: String = BASE + "manage.role.find"
  val MANAGE_ROLE_PAGE: String = BASE + "manage.role.page"
  val MANAGE_ROLE_DELETE: String = BASE + "manage.role.delete"

  val MANAGE_RESOURCE_SAVE: String = BASE + "manage.resource.save"
  val MANAGE_RESOURCE_UPDATE: String = BASE + "manage.resource.update"
  val MANAGE_RESOURCE_GET: String = BASE + "manage.resource.get"
  val MANAGE_RESOURCE_FIND: String = BASE + "manage.resource.find"
  val MANAGE_RESOURCE_PAGE: String = BASE + "manage.resource.page"
  val MANAGE_RESOURCE_DELETE: String = BASE + "manage.resource.delete"

  val AUTH: String = BASE + "auth"
  val LOGOUT: String = BASE + "logout"
  val LOGIN: String = BASE + "login"
  val GET_LOGIN_INFO: String = BASE + "logininfo"
  val ACCOUNT_SELF_UPDATE: String = BASE + "account.self.update"

}
