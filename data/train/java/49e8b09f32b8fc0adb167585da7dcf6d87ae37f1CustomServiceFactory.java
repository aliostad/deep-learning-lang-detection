package com.whirlpool.salesman.app.factory;

import com.whirlpool.salesman.app.service.AccessService;
import com.whirlpool.salesman.app.service.AppService;
import com.whirlpool.salesman.app.service.impl.AccessServiceImpl;
import com.whirlpool.salesman.app.service.impl.AppServiceImpl;

public class CustomServiceFactory {
	private static AccessService accessService;
	private static AppService appService;

	public static AccessService getAccessService() {
		if (accessService == null) {
			accessService = new AccessServiceImpl();
		}
		return accessService;
	}
	
	public static AppService getAppService() {
		if (appService == null) {
			appService = new AppServiceImpl();
		}
		return appService;
	}
}
