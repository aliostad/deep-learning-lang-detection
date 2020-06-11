package com.abbcc.service;

import com.abbcc.service.impl.AdminServiceImpl;
import com.abbcc.service.impl.CheckSerivceImpl;
import com.abbcc.service.impl.ProductServiceImpl;
import com.abbcc.service.impl.UserServiceImpl;

public class ServiceFactory {
	public static AdminService getAdminService(){
		return AdminServiceImpl.getInstance();  
	}
	public static UserService getUserService(){
		return UserServiceImpl.getInstance();  
	}
	public static CheckService getCheckService(){
		return CheckSerivceImpl.getInstance();  
	}
	 
}
