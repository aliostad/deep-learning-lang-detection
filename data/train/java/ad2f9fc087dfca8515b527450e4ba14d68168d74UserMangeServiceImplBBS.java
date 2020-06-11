package com.bbs.service;

import com.bbs.dao.UserManageDaoBBS;
import com.model.BBSUser;

public class UserMangeServiceImplBBS implements UserMangeServiceBBS {

	private UserManageDaoBBS userManageDaoBBS;
	
	public boolean checkUserAccount(String loginAccount) {
		if (userManageDaoBBS.checkUserAccount(loginAccount)) {
			return true;
		} else {
			return false;
		}
	
	}

	public boolean registerUser(BBSUser user) {
		if(userManageDaoBBS.registerUser(user)) {
			return true;
		} else {
			return false;
		}	
	}

	public UserManageDaoBBS getUserManageDaoBBS() {
		return userManageDaoBBS;
	}

	public void setUserManageDaoBBS(UserManageDaoBBS userManageDaoBBS) {
		this.userManageDaoBBS = userManageDaoBBS;
	}

	public boolean bbsUserLogin(BBSUser user) {
		if(this.userManageDaoBBS.bbsUserLogin(user)) {
			return true;
		} else {
			return false;
		}	
	}

	public BBSUser queryUserByAccount(String loginAccount) {
		return this.userManageDaoBBS.queryUserByAccount(loginAccount);
	}
}
