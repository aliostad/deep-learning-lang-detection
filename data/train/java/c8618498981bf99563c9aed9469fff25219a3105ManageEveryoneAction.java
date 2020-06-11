package cn.com.ufgov.hainan.manage.action;

import com.opensymphony.xwork2.ActionSupport;
import cn.com.ufgov.hainan.framework.action.EveryoneAction;
import cn.com.ufgov.hainan.framework.action.InitializeListener;
import cn.com.ufgov.hainan.framework.action.ModuleAction;
import cn.com.ufgov.hainan.manage.module.ManageUser;
import cn.com.ufgov.hainan.manage.service.ManageEveryoneService;

public class ManageEveryoneAction extends EveryoneAction {

	private ManageEveryoneService manageEveryoneService;
	private ManageUser manageUser;

	public ManageEveryoneService getManageEveryoneService() {
		return manageEveryoneService;
	}

	public void setManageEveryoneService(ManageEveryoneService manageEveryoneService) {
		this.manageEveryoneService = manageEveryoneService;
	}

	public ManageUser getManageUser() {
		return manageUser;
	}

	public void setManageUser(ManageUser manageUser) {
		this.manageUser = manageUser;
	}

	@Override
	public void prepare() throws Exception {
	}

	public String executeLogin() throws Exception {
		String result = ModuleAction.LOGIN;

		return result;
	}

	public String executeLogout() throws Exception {
		String result = ModuleAction.LOGOUT;

		this.strutsSession.put(InitializeListener.SESSION_USER_ID, null);

		return result;
	}

	public String executeVerity() throws Exception {
		String result = ActionSupport.SUCCESS;

		if (manageUser != null) {
			String userId = null;
			String account = manageUser.getAccount();
			String password = manageUser.getPassword();
			userId = this.manageEveryoneService.authenticationValidation(account, password);
			this.strutsSession.put(InitializeListener.SESSION_USER_ID, userId);
		}

		return result;
	}
}
