package com.kanchan.java.designpatterns.servicelocatorpattern;

public class ServiceLocator {
	
	private static ServiceCache serviceCache;
	
	static {
		serviceCache =  new ServiceCache();
	}
	
	public static Service getService(String jndiName){
		Service serv = serviceCache.getService(jndiName);
		if(null != serv) return serv;
		
		InitialContext initialContext = new InitialContext();
		Service serviceObject = (Service) initialContext.lookup(jndiName);
		serviceCache.addService(serviceObject);
		
		return serviceObject;
	}
	

}
