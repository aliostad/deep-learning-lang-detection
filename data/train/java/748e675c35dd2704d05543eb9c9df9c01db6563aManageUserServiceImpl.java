/**
 * author: 谢少华
 * 
 * date: 2014-06-24 09:46
 */
package com.web.business.system.service.impl;

import com.web.api.core.service.template.impl.TemplateServiceImpl;
import com.web.business.system.dao.ManageUserDao;
import com.web.business.system.service.ManageUserService;

public class ManageUserServiceImpl extends TemplateServiceImpl
        implements ManageUserService { 

    private ManageUserDao manageUserDao;

    public ManageUserDao getManageUserDao() {
        return manageUserDao;
    }

    public void setManageUserDao(ManageUserDao manageUserDao) {
        this.manageUserDao = manageUserDao;
    }
	
}
