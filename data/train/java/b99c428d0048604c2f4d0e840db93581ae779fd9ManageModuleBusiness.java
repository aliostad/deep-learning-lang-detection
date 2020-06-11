package cn.com.ufgov.hainan.manage.business;

import cn.com.ufgov.hainan.framework.business.ModuleBusiness;
import cn.com.ufgov.hainan.manage.module.ManageModule;
import cn.com.ufgov.hainan.manage.service.ManageModuleService;

public class ManageModuleBusiness extends ModuleBusiness<ManageModule> implements ManageModuleService {

	@Override
	public boolean hasSame(ManageModule value) {
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
