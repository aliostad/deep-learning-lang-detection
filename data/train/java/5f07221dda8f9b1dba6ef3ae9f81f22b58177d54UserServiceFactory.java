package com.nali.spreader.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.nali.spreader.service.IUserService;
import com.nali.spreader.service.IUserServiceFactory;
import com.nali.spreader.service.IWebsiteBaseServiceFactory;

@Service
public class UserServiceFactory implements IUserServiceFactory {
	@Autowired
	private IWebsiteBaseServiceFactory serviceFactory;

	@Override
	public IUserService getUserService(Integer websiteId) {
		return serviceFactory.buildService(UserService.class, websiteId);
	}
}
