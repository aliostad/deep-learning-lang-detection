package com.ecfront.ez.framework.service.auth.manage

import com.ecfront.common.Resp
import com.ecfront.ez.framework.core.rpc.RPC
import com.ecfront.ez.framework.service.auth.model.EZ_Role
import com.ecfront.ez.framework.service.jdbc.BaseStorage
import com.ecfront.ez.framework.service.jdbc.scaffold.SimpleRPCService

/**
  * 角色管理
  */
@RPC("/ez/auth/manage/role/","EZ-角色管理","")
object RoleService extends SimpleRPCService[EZ_Role] {

  override protected val storageObj: BaseStorage[EZ_Role] = EZ_Role

  /**
    * 为指定角色附加新的资源
    *
    * @param roleCode            目标角色
    * @param appendResourceCodes 新的资源列表
    * @return 是否成功
    */
  def appendResources(roleCode: String, appendResourceCodes: List[String]): Resp[Void] = {
    val roleR = EZ_Role.getByCode(roleCode)
    if (roleR) {
      roleR.body.resource_codes ++= appendResourceCodes
      EZ_Role.update(roleR.body)
    } else {
      roleR
    }
  }

}