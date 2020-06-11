package com.lobinary.设计模式.服务定位器模式;

import com.lobinary.设计模式.服务定位器模式.service.Service;

public class ServiceLocator {
	
	static Cache cache = new Cache();
	
	
	public static Service getService(String serviceName){
		Service service = cache.getService(serviceName);
		if(service==null){
			System.out.println("初次调用service，准备创建新service："+serviceName);
			service = new InitialContext().getService(serviceName);
			cache.addService(service);
		}
		return service;
	}

}
