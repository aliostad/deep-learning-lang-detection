package cn.com.ufgov.hainan.manage.business;

import cn.com.ufgov.hainan.framework.business.ModuleBusiness;
import cn.com.ufgov.hainan.manage.module.ManageGroupModule;
import cn.com.ufgov.hainan.manage.service.ManageGroupModuleService;

public class ManageGroupModuleBusiness extends ModuleBusiness<ManageGroupModule> implements ManageGroupModuleService {

	@Override
	public boolean hasSame(ManageGroupModule value) {
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
