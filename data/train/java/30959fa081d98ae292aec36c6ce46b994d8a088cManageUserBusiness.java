package cn.com.ufgov.hainan.manage.business;

import java.util.ArrayList;
import java.util.List;

import cn.com.ufgov.hainan.framework.business.ModuleBusiness;
import cn.com.ufgov.hainan.framework.business.Paging;
import cn.com.ufgov.hainan.framework.utility.Security;
import cn.com.ufgov.hainan.manage.module.ManageUser;
import cn.com.ufgov.hainan.manage.service.ManageUserService;

public class ManageUserBusiness extends ModuleBusiness<ManageUser> implements ManageUserService {

	@Override
	public boolean hasSame(ManageUser value) {
		boolean result = false;

		String account = value.getAccount();
		String hql = "from ManageUser t where upper(t.account) = upper(?)";
		List<ManageUser> manageUsers = this.select(hql, account);
		if ((manageUsers != null) && (manageUsers.size() > 0)) {
			ManageUser originalManageUser = manageUsers.get(0);
			if (value.getUuid() == null) {
				result = true;
			} else {
				if (!value.getUuid().equals(originalManageUser.getUuid())) {
					result = true;
				}
			}
		}

		return result;
	}

	@Override
	public boolean hasReference(String uuid) {
		return false;
	}

	@Override
	public boolean deleteReference(String uuid) {
		return true;
	}

	@Override
	public ManageUser authenticationValidation(String account, String password) {
		ManageUser result = null;

		if ((account != null) && (password != null)) {
			password = Security.md5(password);

			String hql = "from ManageUser t where upper(t.account) = upper(?)";
			List<ManageUser> manageUsers = this.select(hql, account);
			if ((manageUsers != null) && (manageUsers.size() > 0)) {
				if (manageUsers.get(0).getPassword().equals(password)) {
					result = manageUsers.get(0);
				}
			}
		}

		return result;
	}

	@Override
	public boolean permissionValidation(String userId, String action, String execute) {
		System.out.println(action);
		return true;
	}

	public List<ManageUser> queryDataGrid(Paging paging, ManageUser manageUser) {
		List<ManageUser> results = null;

		String hql = "";
		List<Object> parameters = new ArrayList<Object>();

		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("from ManageUser as t where t.uuid is not null ");
		if (manageUser != null) {
			if (manageUser.getName() != null) {
				if (!manageUser.getName().isEmpty()) {
					stringBuffer.append("and t.name = ? ");
					parameters.add(manageUser.getName());
				}
			}
			if (manageUser.getAccount() != null) {
				if (!manageUser.getAccount().isEmpty()) {
					stringBuffer.append("and t.account = ? ");
					parameters.add(manageUser.getAccount());
				}
			}
			if (manageUser.getPrerogative() != null) {
				stringBuffer.append("and t.prerogative = ? ");
				parameters.add(manageUser.getPrerogative());
			}
		}
		stringBuffer.append("order by t.updateTime desc");
		hql = stringBuffer.toString();

		results = this.select(paging, hql, parameters.toArray());

		return results;
	}
}
