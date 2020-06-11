package com.javachap.service;

import com.javachap.service.impl.CategoryServiceImpl;
import com.javachap.service.impl.LeadServiceImpl;
import com.javachap.service.impl.UserServiceImpl;

public class ServiceUtils {

	/**
	 * Gets Instance of UserService
	 * @return UserService Instance
	 */	
	public static UserService getUserService(){
		return UserServiceImpl.getInstance();
	}	
	
	/**
	 * Gets Instance of LeadService
	 * @return LeadService Instance
	 */
	public static LeadService getLeadService(){
		return LeadServiceImpl.getInstance();
	}
	
	/**
	 * Gets Instance of CategoryService
	 * @return CategoryService Instance
	 */	
	public static CategoryService getCategoryService(){
		return CategoryServiceImpl.getInstance();
	}
}
