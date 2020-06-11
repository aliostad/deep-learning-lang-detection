/**
 * author: 谢少华
 * 
 * date: 2014-06-23 15:48
 */
package com.web.business.system.action;

import org.springframework.beans.factory.annotation.Autowired;

import com.web.api.core.action.annotation.Menu;
import com.web.api.core.action.template.TemplateAction;
import com.web.api.core.action.template.annotation.TemplateEntity;
import com.web.api.core.action.template.annotation.TemplateService;
import com.web.business.system.entity.ManageRoleEntity;
import com.web.business.system.service.ManageRoleService;

@Menu(menuid = "2001")
public class ManageRoleAction extends TemplateAction {

    private static final long serialVersionUID = 1L;
    
	public ManageRoleAction() {
		this.setGoListJsp("/web/business/system/role/manage/form.jsp");
		this.setGoEditJsp("/web/business/system/role/manage/form.jsp");
	}

    @Autowired
    @TemplateService
    private ManageRoleService manageRoleService;

    @TemplateEntity
    private ManageRoleEntity manageRoleEntity;
    
    public ManageRoleService getManageRoleService() {
        return manageRoleService;
    }

    public void setManageRoleService(ManageRoleService manageRoleService) {
        this.manageRoleService = manageRoleService;
    }

    public ManageRoleEntity getManageRoleEntity() {
        return manageRoleEntity;
    }

    public void setManageRoleEntity(ManageRoleEntity manageRoleEntity) {
        this.manageRoleEntity = manageRoleEntity;
    }

}