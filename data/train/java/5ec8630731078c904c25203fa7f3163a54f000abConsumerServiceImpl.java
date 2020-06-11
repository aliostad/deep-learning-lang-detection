package org.astonbitecode.osgi.wabConsumer.service.impl;

import org.astonbitecode.osgi.serviceProvider.service.MyService;
import org.astonbitecode.osgi.wabConsumer.service.ConsumerService;

public class ConsumerServiceImpl implements ConsumerService {
	private MyService myService;

	@Override
	public String invokeBlueprintService() {
		return myService.getName();
	}

	public MyService getMyService() {
		return myService;
	}

	public void setMyService(MyService myService) {
		this.myService = myService;
	}
}
