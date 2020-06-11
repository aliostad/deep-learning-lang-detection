package com.jialin.action;

import javax.annotation.Resource;

import com.jialin.entity.User;
import com.jialin.service.IUserManage;
import com.opensymphony.xwork2.ActionSupport;

public class UserAction extends ActionSupport {
	
	private User user;

	@Resource  
	private IUserManage userManage;
	

	public void setUserManage(IUserManage userManage) {
		this.userManage = userManage;
	}
	
	public IUserManage getUserManage() {
		return userManage;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	public String addUser()
	{
		System.out.println("-------userAction.addUser--------"+user.getName());
		
		userManage.addUser(user);
		return "success";
	}
	
	public String modifyUser()
	{
		System.out.println("-------userAction.modifyUser--------"+user.getName());
		userManage.modifyUser(user);
		return "success";
	}
	
	public String deleteUser()
	{
		System.out.println("-------userAction.deleteUser--------"+user.getName());
		userManage.deleteUser(user);
		return "success";
	}
	
	
}
