package com.ecfront.ez.framework.service.auth.manage

import com.ecfront.ez.framework.core.rpc.RPC
import com.ecfront.ez.framework.service.auth.model.EZ_Organization
import com.ecfront.ez.framework.service.jdbc.BaseStorage
import com.ecfront.ez.framework.service.jdbc.scaffold.SimpleRPCService

/**
  * 组织（租户）管理
  */
@RPC("/ez/auth/manage/organization/","EZ-组织/租户管理","")
object OrganizationService extends SimpleRPCService[EZ_Organization] {

  override protected val storageObj: BaseStorage[EZ_Organization] = EZ_Organization

}