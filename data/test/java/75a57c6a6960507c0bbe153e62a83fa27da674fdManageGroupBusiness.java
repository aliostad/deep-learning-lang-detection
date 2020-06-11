package cn.com.ufgov.hainan.manage.business;

import cn.com.ufgov.hainan.framework.business.ModuleBusiness;
import cn.com.ufgov.hainan.manage.module.ManageGroup;
import cn.com.ufgov.hainan.manage.service.ManageGroupService;

public class ManageGroupBusiness extends ModuleBusiness<ManageGroup> implements ManageGroupService {

	@Override
	public boolean hasSame(ManageGroup value) {
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
