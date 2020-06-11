package cn.com.ufgov.hainan.manage.business;

import cn.com.ufgov.hainan.manage.module.ManageUser;
import cn.com.ufgov.hainan.manage.service.ManageEveryoneService;
import cn.com.ufgov.hainan.manage.service.ManageUserService;

public class ManageEveryoneBusiness implements ManageEveryoneService {
	private ManageUserService manageUserService;

	public ManageUserService getManageUserService() {
		return manageUserService;
	}

	public void setManageUserService(ManageUserService manageUserService) {
		this.manageUserService = manageUserService;
	}

	@Override
	public String authenticationValidation(String account, String password) {
		String result = null;

		ManageUser manageUser = this.manageUserService.authenticationValidation(account, password);
		if (manageUser != null) {
			result = manageUser.getUuid();
		}

		return result;
	}

}
