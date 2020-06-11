package com.rc.dl.service.impl;

import java.util.List;

import javax.annotation.Resource;

import com.rc.dl.bean.Order;
import com.rc.dl.bean.PageParam;
import com.rc.dl.dao.ISendManageDao;
import com.rc.dl.service.ISendManageService;

public class SendManageServiceImpl implements ISendManageService {
	
	//注入DAO
	@Resource
	private ISendManageDao sendManageDao ;
	
	public ISendManageDao getSendManageDao() {
		return sendManageDao;
	}

	public void setSendManageDao(ISendManageDao sendManageDao) {
		this.sendManageDao = sendManageDao;
	}

	@Override
	public List<Order> findSendLists(String customID) 
	{
		return sendManageDao.findSendOrders(customID);
	}

	@Override
	public List<Order> findSendOrdersPage(String customID, PageParam pageParam) {
		return sendManageDao.findSendOrdersPage(customID, pageParam);
	}

}
