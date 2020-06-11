package com.novediagroup.workshop1.web;

import com.novediagroup.workshop1.model.User;
import com.novediagroup.workshop1.service.Service;
import com.novediagroup.workshop1.service.ServiceImpl;

public class Controller {
	
	private Service service = new ServiceImpl();
	
	public void action(){
		for(User user : service.getAllUsers()){
			user.setFirstname("toto");
			user.setLastname("bobo");
			service.saveUser(user);
		}
		
	}

	public Service getService() {
		return service;
	}

	public void setService(Service service) {
		this.service = service;
	}
	
	

}
