package com.cyou.advertising.web.service.security.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.cyou.advertising.web.dao.security.ManageModuleDAO;
import com.cyou.advertising.web.model.security.ManageModule;
import com.cyou.advertising.web.service.security.ManageModuleService;

@Service("manageModuleService")
public class ManageModuleServiceImpl implements ManageModuleService {

	@Resource
	private ManageModuleDAO manageModuleDAO;

	@Override
	public List<ManageModule> list() {
		return manageModuleDAO.findAll();
	}

	@Override
	public void insert(ManageModule manageModule) {
		manageModuleDAO.insert(manageModule);
	}

	@Override
	public void update(ManageModule manageModule) {
		manageModuleDAO.update(manageModule);
	}

	@Override
	public void delete(Integer id) {
		manageModuleDAO.delete(id);
	}

}
