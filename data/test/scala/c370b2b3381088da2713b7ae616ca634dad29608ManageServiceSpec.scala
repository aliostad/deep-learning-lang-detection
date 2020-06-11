package com.ecfront.lego.rbac.component

import com.ecfront.lego.core.foundation.protocol.Req
import com.ecfront.lego.core.component.storage.JDBCService
import com.ecfront.lego.rbac.component.manage._
import com.ecfront.lego.rbac.foundation._
import org.scalatest._

class JDBCServiceSpec extends FunSuite {

  JDBCService.init

  val request = Req("0000", "jzy", "test_app")

  test("管理服务测试") {
    //-------------------save--------------------------------------------
    val app = App()
    app.name = "测试应用"
    val appId = AppService.save(app, request)
    val org_a = Organization()
    org_a.id = "a"
    org_a.name = "A组"
    OrganizationService.save(org_a, request)
    val org_b = Organization()
    org_b.id = "b"
    org_b.name = "B组"
    OrganizationService.save(org_b, request)
    val role_admin = Role()
    role_admin.code = "admin"
    role_admin.name = "管理员"
    RoleService.save(role_admin, request)
    val role_user = Role()
    role_user.code = "user"
    role_user.name = "用户"
    RoleService.save(role_user, request)
    val res_manage = Resource()
    res_manage.name = "系统管理"
    res_manage.address = "sys.manage"
    ResourceService.save(res_manage, request)
    val res_index = Resource()
    res_index.name = "首页"
    res_index.address = "index"
    ResourceService.save(res_index, request)
    val res_login = Resource()
    res_login.name = "登录"
    res_login.address = "login"
    ResourceService.save(res_login, request)
    val account_1 = Account()
    account_1.loginId = "1"
    account_1.name = "zhangsan"
    account_1.organizationIds = List("a")
    account_1.roleIds = List("user@" + appId)
    AccountService.save(account_1, request)
    val account_2 = Account()
    account_2.loginId = "2"
    account_2.name = "lisi"
    account_2.organizationIds = List("a", "b")
    account_2.roleIds = List("admin" + appId)
    AccountService.save(account_2, request)
    //-------------------get--------------------------------------------
    assert(RoleService.getById("user@" + appId, request).body.name == "用户")
    assert(ResourceService.getById("login@" + appId, request).body.name == "登录")
    val acc = AccountService.getById("2@" + appId, request).body
    assert(acc.name == "lisi")
    assert(acc.organizationIds.size == 2)
    assert(acc.organizationIds(1) == "b")
    assert(acc.roleIds.size == 1)
    assert(acc.roleIds(0) == "admin" + appId)
  }

}


