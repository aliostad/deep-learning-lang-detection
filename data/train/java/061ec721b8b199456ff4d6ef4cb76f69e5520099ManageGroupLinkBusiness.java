package cn.com.ufgov.hainan.manage.business;

import cn.com.ufgov.hainan.framework.business.ModuleBusiness;
import cn.com.ufgov.hainan.manage.module.ManageGroupLink;
import cn.com.ufgov.hainan.manage.service.ManageGroupLinkService;

public class ManageGroupLinkBusiness extends ModuleBusiness<ManageGroupLink> implements ManageGroupLinkService {

	@Override
	public boolean hasSame(ManageGroupLink value) {
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
