package com.ppcredit.bamboo.backend.web.rest.admin.manage.service.impl;

import javax.inject.Inject;

import com.ppcredit.bamboo.backend.web.rest.admin.util.Pager;
import org.springframework.stereotype.Service;

import com.ppcredit.bamboo.backend.web.rest.admin.manage.dao.UserManageDAO;
import com.ppcredit.bamboo.backend.web.rest.admin.manage.service.UserManageService;

@Service("myUserManageService")
public class UserManageServiceImpl implements UserManageService {
	
	@Inject
	private UserManageDAO myUserManageDAO;
	
	@Override
	public Pager query(String status, String searchCondition, int offset, int pagesize) {
		
		Pager pager = myUserManageDAO.query(status, searchCondition, offset, pagesize);
		return pager;
	}
}
