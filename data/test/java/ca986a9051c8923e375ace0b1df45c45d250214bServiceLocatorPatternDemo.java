package com.material.patterns.servicelocator;

import com.material.logic.Demo;

public class ServiceLocatorPatternDemo implements Demo {

	private static final String NAME = "Service locator pattern";

	@Override
	public String getName() {
		return NAME;
	}

	@Override
	public void run() {
		Service service = ServiceLocator.getService("Service1");
		service.execute();

		service = ServiceLocator.getService("Service2");
		service.execute();

		service = ServiceLocator.getService("Service1");
		service.execute();

		service = ServiceLocator.getService("Service2");
		service.execute();
	}
}
