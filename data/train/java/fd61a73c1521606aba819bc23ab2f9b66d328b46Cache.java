package com.edu.service;
import java.util.ArrayList;
import java.util.List;

import com.edu.service.Service;


public class Cache {
	
	List<Service >services =new ArrayList<Service>();
	
	
	public Cache(){
		this.services=new ArrayList<Service>();
	}
	
	public Service getService(String serviceName){
		for(Service service:services){
			if(service.getName().equalsIgnoreCase(serviceName)){
				return service;
				
			}
		}
		return null;
		
	}
	public void addService(Service newService){
		boolean exists =false;
		for(Service service :services){
			if(service.getName().equalsIgnoreCase(newService.getName())){
				exists=true;
				
				
			}
			if(!exists){
				services.add(newService);
			}
			
		}
		
	}

}
