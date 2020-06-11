package com.shine.ssi.core.service.impl;

import org.springframework.beans.factory.annotation.Autowired;

import com.shine.ssi.core.service.UserManageService;
import com.shine.ssi.model.UserPO;
import com.shine.ssi.persist.UserManageDao;

public class UserManageServiceImpl implements UserManageService {
	@Autowired
	private UserManageDao userManageMapper;
	
	public UserPO findById(String id) {
		return userManageMapper.findById(id);
	}

	public int queryCount() {
		return userManageMapper.queryCount();
	}

}
