package com.java.hibernate.service;

public class ServiceLocator {
	
	private static ServiceLocator serviceLocator;

	private UserService userService;
	
	private ServiceLocator(){
		
	}
	
	public static ServiceLocator getInstance(){
		if(serviceLocator == null ){
			serviceLocator = new ServiceLocator();
		}
		return serviceLocator;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	
	

}
