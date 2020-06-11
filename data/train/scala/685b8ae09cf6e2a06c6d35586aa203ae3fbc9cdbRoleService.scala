package com.ecfront.lego.rbac.component.manage

import com.ecfront.lego.core.component.SyncBasicService
import com.ecfront.lego.core.component.cache.Cacheable
import com.ecfront.lego.core.foundation.protocol.{Req, Resp}
import com.ecfront.lego.core.component.storage.JDBCService
import com.ecfront.lego.core.foundation.IdModel
import com.ecfront.lego.rbac.foundation.Role

object RoleService extends JDBCService[Role] with SyncBasicService[Role]  with Cacheable{

  override protected def preSave(model: Role, request: Req): Resp[Any] = {
    model.id = model.code + IdModel.SPLIT_FLAG + (if (!isSystem(request) || model.appId == null) request.appId else model.appId)
    Resp.success(model)
  }

}
