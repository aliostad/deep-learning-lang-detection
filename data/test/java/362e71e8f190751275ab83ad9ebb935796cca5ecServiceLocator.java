package com.san.my.common.util.springs;

import org.apache.log4j.Logger;

import com.san.my.service.IUsersService;

public class ServiceLocator {
	static Logger logger = Logger.getLogger(ServiceLocator.class);
	
	public static IUsersService getUserService() throws Exception{
		IUsersService usersService = (IUsersService)BeanLocatorFactory.getBean("usersService");
		return usersService;
	}
	
//	public static SeedsService getSeedsService() throws Exception{
//		SeedsService seedsService = (SeedsService)BeanLocatorFactory.getBean("seedsService");
//		return seedsService;
//	}
	
}
