package com.ecfront.ez.framework.service.auth.manage

import com.ecfront.ez.framework.core.rpc.RPC
import com.ecfront.ez.framework.service.auth.model.EZ_Resource
import com.ecfront.ez.framework.service.jdbc.BaseStorage
import com.ecfront.ez.framework.service.jdbc.scaffold.SimpleRPCService

/**
  * 资源管理
  */
@RPC("/ez/auth/manage/resource/","EZ-资源管理","")
object ResourceService extends SimpleRPCService[EZ_Resource] {

  override protected val storageObj: BaseStorage[EZ_Resource] = EZ_Resource

}