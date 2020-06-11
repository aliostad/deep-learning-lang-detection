package com.osgo.plugin.portfolio.api;

import com.googlecode.objectify.ObjectifyService;
import com.osgo.plugin.portfolio.model.objectify.*;

public class PortfolioServiceFactory {
	
	static {
		ObjectifyService.register(Category.class);
		ObjectifyService.register(Picture.class);
		ObjectifyService.register(Project.class);
	}
	
	private static PortfolioService service;
	
	public static PortfolioService getPortfolioService(){
		if(service==null){
			service = new PortfolioServiceImpl();
		}
		
		return service;
	}
	
}
