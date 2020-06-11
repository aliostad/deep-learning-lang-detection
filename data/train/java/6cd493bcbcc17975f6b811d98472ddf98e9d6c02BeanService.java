package com.job528.service;


import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.job528.profile.service.IApplyService;
import com.job528.profile.service.IUserService;
import com.job528.profile.service.IWeiboService;


public class BeanService {
	IApplyService iapplyService;
	IUserService iuserService;
	IWeiboService iweiboService;
	
	private static ApplicationContext context;
	
	public IApplyService getIapplyService() {
		return iapplyService;
	}
	
	public IWeiboService getIweiboService() {
		return iweiboService;
	}

    public IUserService getIuserService() {
		return iuserService;
	}

	public ApplicationContext getContext() {
		if(context == null) {
			context = new ClassPathXmlApplicationContext("classpath:spring/applicationContext.xml");
		}
		return context;
		
	}
	
	
}
