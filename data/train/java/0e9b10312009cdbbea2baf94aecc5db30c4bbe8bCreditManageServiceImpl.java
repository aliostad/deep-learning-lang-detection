package com.hbkd.hyx.app.sence.service.impl;

import com.hbkd.hyx.app.sence.dao.CreditManageDao;
import com.hbkd.hyx.app.sence.service.CreditManageService;

import java.util.Map;


public class CreditManageServiceImpl implements CreditManageService {
	
	private CreditManageDao creditManageDao;

	public Object getCreditManage(Map<String, String> map) {
		return creditManageDao.getCreditManage(map);
	}

	public CreditManageDao getCreditManageDao() {
		return creditManageDao;
	}

	public void setCreditManageDao(CreditManageDao creditManageDao) {
		this.creditManageDao = creditManageDao;
	}

}
