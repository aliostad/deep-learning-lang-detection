package com.xininit.dao.impl;

import org.springframework.stereotype.Repository;

import com.xininit.dao.AccountManageDAOI;
import com.xininit.pojo.AccountManage;

/**
 * 
 * @author xin
 * @version 1.0(xin) 2015年2月24日 上午12:35:31
 */
@Repository("accountManageDAO")
public class AccountManageDAOImpl extends EntityBaseDAOImpl<AccountManage,String> implements AccountManageDAOI{

	@Override
	public Class<AccountManage> getEntityClass() {
		return AccountManage.class;
	}
	
	@Override
	public AccountManage getByAccountAndPwd(String account, String password) {
		String hql = " from AccountManage a where a.account = ?0 and a.password = ?1 ";
		return this.getByHQL(hql,account,password);
	}
}
