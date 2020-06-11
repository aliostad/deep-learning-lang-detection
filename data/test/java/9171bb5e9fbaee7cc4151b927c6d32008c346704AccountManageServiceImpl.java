package com.xininit.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xininit.dao.AccountManageDAOI;
import com.xininit.pojo.AccountManage;
import com.xininit.service.AccountManageServiceI;

/**
 * 
 * @author xin
 * @version 1.0(xin) 2015年2月24日 上午12:42:12
 */
@Service("accountManageService")
public class AccountManageServiceImpl implements AccountManageServiceI{

	@Autowired
	private AccountManageDAOI accountManageDAO;
	
	@Override
	public AccountManage login(String account, String password) {
		return this.accountManageDAO.getByAccountAndPwd(account, password);
	}

}
