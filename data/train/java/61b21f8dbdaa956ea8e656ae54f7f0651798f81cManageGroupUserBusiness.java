package cn.com.ufgov.hainan.manage.business;

import cn.com.ufgov.hainan.framework.business.ModuleBusiness;
import cn.com.ufgov.hainan.manage.module.ManageGroupUser;
import cn.com.ufgov.hainan.manage.service.ManageGroupUserService;

public class ManageGroupUserBusiness extends ModuleBusiness<ManageGroupUser> implements ManageGroupUserService {

	@Override
	public boolean hasSame(ManageGroupUser value) {
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
