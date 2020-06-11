package com.fr.net.manage.action;

import java.util.List;

import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.mvc.annotation.At;
import org.nutz.mvc.annotation.Fail;
import org.nutz.mvc.annotation.Ok;

import com.fr.net.manage.service.ManageService;
import com.fr.net.model.po.Module;

@IocBean
@At("/manage")
public class ManageAction {
	
	private ManageService manageService;
	 
	@At("/modellist")
	@Ok("jsp:view.manage.modellist")
	@Fail("jsp:view.system.error")
	public List<Module> toManageIndex(){
		return manageService.getModulePage();
	}
	
}
