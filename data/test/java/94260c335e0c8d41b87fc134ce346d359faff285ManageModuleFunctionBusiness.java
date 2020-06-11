package cn.com.ufgov.hainan.manage.business;

import cn.com.ufgov.hainan.framework.business.ModuleBusiness;
import cn.com.ufgov.hainan.manage.module.ManageModuleFunction;
import cn.com.ufgov.hainan.manage.service.ManageModuleFunctionService;

public class ManageModuleFunctionBusiness extends ModuleBusiness<ManageModuleFunction> implements ManageModuleFunctionService {

	@Override
	public boolean hasSame(ManageModuleFunction value) {
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
