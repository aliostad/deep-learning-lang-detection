package cn.com.ufgov.hainan.manage.service;

import java.util.List;

import cn.com.ufgov.hainan.framework.business.Paging;
import cn.com.ufgov.hainan.framework.service.ModuleService;
import cn.com.ufgov.hainan.manage.module.ManageUser;

public interface ManageUserService extends ModuleService<ManageUser> {
	ManageUser authenticationValidation(String account, String password);

	boolean permissionValidation(String userId, String action, String execute);

	List<ManageUser> queryDataGrid(Paging paging, ManageUser manageUser);
}
