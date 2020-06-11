/**
 * ydhz_yjy.com Inc.
 * Copyright (c) 2014-2014 All Rights Reserved.
 */
package com.hms.manage.handler.old;

import com.hms.manage.ManageHandlerResult;

/**
 * openfire账户管理
 * 
 * @author wangq
 * @version $Id: IUserManageHandler.java, v 0.1 2014-11-19 下午3:13:38 wangq Exp $
 */
public interface IAccountManageHandler {

    /**
     * 
     * @param platform
     * @param type
     * @param userinfos
     * @return
     */
    ManageHandlerResult manage(String platform, String type, String userinfos);

}
