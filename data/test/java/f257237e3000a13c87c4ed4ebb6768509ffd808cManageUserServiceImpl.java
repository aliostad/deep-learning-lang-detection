package com.ishare.mall.core.service.manageuser.impl;

import com.ishare.mall.common.base.exception.manageuser.ManageUserServiceException;
import com.ishare.mall.core.model.manage.ManageUser;
import com.ishare.mall.core.repository.manageuser.ManageUserRepository;
import com.ishare.mall.core.service.manageuser.ManageUserService;
import com.ishare.mall.core.service.member.PasswordHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by YinLin on 2015/8/12.
 * Description :
 * Version 1.0
 */
@Service
@Transactional
public class ManageUserServiceImpl implements ManageUserService {

	private static final Logger log = LoggerFactory.getLogger(ManageUserServiceImpl.class);

	@Autowired
	private ManageUserRepository manageUserRepository;
	@Autowired
	private PasswordHelper passwordHelper;

	@Override
	public ManageUser findByUsername(String username) throws ManageUserServiceException {
		List<ManageUser> manageUsers = manageUserRepository.findByUsername(username);
		return manageUsers != null && manageUsers.size() > 0 ? manageUsers.get(0) : null;
	}

	@Override
	public ManageUser findOne(Integer id) {
		return manageUserRepository.findOne(id);
	}

	@Override
	public void saveManageUser(ManageUser manageUser) throws ManageUserServiceException{
		passwordHelper.encryptPassword(manageUser);
		manageUserRepository.save(manageUser);
	}

	@Override
	public void update(ManageUser manageUser) throws ManageUserServiceException {
		manageUserRepository.save(manageUser);
	}

	@Override
	public Page<ManageUser> getManageUserPage(PageRequest pageRequest) {
		return manageUserRepository.getManageUserPage(pageRequest);
	}

	@Override
	public Page<ManageUser> getManageUserPage(PageRequest pageRequest, String userName, String name) throws ManageUserServiceException {
		return manageUserRepository.getManageUserPage(pageRequest,userName,name);
	}

}
