/**
 * author: 谢少华
 * 
 * date: 2014-06-24 09:46
 */
package com.web.business.system.action;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;

import com.web.api.core.action.annotation.Menu;
import com.web.api.core.action.template.TemplateAction;
import com.web.api.core.action.template.annotation.TemplateEntity;
import com.web.api.core.action.template.annotation.TemplateService;
import com.web.api.core.exception.ExistsException;
import com.web.api.core.utils.BaseUtils;
import com.web.business.system.entity.ManageUserEntity;
import com.web.business.system.service.ManageRoleService;
import com.web.business.system.service.ManageUserService;

@Menu(menuid = "2003")
public class ManageUserAction extends TemplateAction {

	private static final long serialVersionUID = 1L;
	
	private static String OPENPASSWORD = "openpassword";
	
	private static String SAVEPASSWORD = "savepassword";
	
    @Autowired
    @TemplateService
    private ManageUserService manageUserService;

    @TemplateEntity
    private ManageUserEntity manageUserEntity;

	@Autowired
	private ManageRoleService manageRoleService;
	
	public ManageUserAction() {
		this.setGoListJsp("/web/business/system/user/manage/list.jsp");
		this.setGoEditJsp("/web/business/system/user/manage/edit.jsp");
	}
	
	public ManageUserService getManageUserService() {
		return manageUserService;
	}

	public void setManageUserService(ManageUserService manageUserService) {
		this.manageUserService = manageUserService;
	}

	public ManageUserEntity getManageUserEntity() {
		return manageUserEntity;
	}

	public void setManageUserEntity(ManageUserEntity manageUserEntity) {
		this.manageUserEntity = manageUserEntity;
	}

	public ManageRoleService getManageRoleService() {
		return manageRoleService;
	}

	public void setManageRoleService(ManageRoleService manageRoleService) {
		this.manageRoleService = manageRoleService;
	}

	@Override
	public void instance() {
		super.instance();
    	request.setAttribute("roleEntityList", manageRoleService.getEntityList());
	}
	
	@Override
    public String save() {
		String password = manageUserEntity.getPassword();
		if (BaseUtils.isEmpty(password)) {
			password = BaseUtils.getMD5Str(manageUserEntity.getUserid() + "123456");
			manageUserEntity.setPassword(password);
		}
		
		return super.save(); 
	}
    
    /**
	 * 强制修改密码
	 * @return
	 */
	public String password() {
		String save = request.getParameter("save");
		
		if (BaseUtils.isEmpty(save)) {
			super.view();
			return OPENPASSWORD;
		} else {
			JSONObject jsonObject = new JSONObject();
			
			try {
				String password = BaseUtils.getMD5Str(manageUserEntity.getUserid() + manageUserEntity.getPassword());
				manageUserEntity.setPassword(password);
				String id = this.getTemplateService().save(this.getEntityClass());
				if (id != null) {
					jsonObject.accumulate("status", "y");
				} else {
					jsonObject.accumulate("status", "n");
				}
			} catch (ExistsException e) {
				jsonObject.accumulate("status", "n");
			}
			
			this.setResultJson(jsonObject);
			return SAVEPASSWORD;
		}
	}
	
}
