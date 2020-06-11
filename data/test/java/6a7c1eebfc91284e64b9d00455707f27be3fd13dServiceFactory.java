package com.eshopping.service;

public class ServiceFactory {
	
	private static ESUserService eUserService;
	private static EShoppingService eShoppingService;

	public ServiceFactory() {
	}
	
	
	public static ESUserService getESUserService() {
		if (eUserService == null) {
			eUserService = new ESUserService();
		}
		
		return eUserService;
	}
	
	
	public static EShoppingService getEShoppingService() {
		if (eShoppingService == null) {
			eShoppingService = new EShoppingService();
		}
		
		return eShoppingService;
	}


}
