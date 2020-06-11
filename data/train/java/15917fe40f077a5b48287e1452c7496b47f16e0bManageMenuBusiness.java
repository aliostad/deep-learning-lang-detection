package cn.com.ufgov.hainan.manage.business;

import cn.com.ufgov.hainan.framework.business.ModuleBusiness;
import cn.com.ufgov.hainan.manage.module.ManageMenu;
import cn.com.ufgov.hainan.manage.service.ManageMenuService;

public class ManageMenuBusiness extends ModuleBusiness<ManageMenu> implements ManageMenuService {

	@Override
	public boolean hasSame(ManageMenu value) {
		return false;
	}

	@Override
	public boolean hasReference(String uuid) {
		return false;
	}

	@Override
	public boolean deleteReference(String uuid) {
		return false;
	}

}
