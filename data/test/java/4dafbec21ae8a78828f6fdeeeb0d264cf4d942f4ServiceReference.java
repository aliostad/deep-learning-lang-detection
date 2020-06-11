package com.salta.service;

public class ServiceReference {
	private static ServiceReference serviceReference;
	private SaltaService service;

	private ServiceReference() {
	}

	public static SaltaService service() {
		ServiceReference instance = instance();
		return instance.service;
	}

	private static ServiceReference instance() {
		if (serviceReference == null)
			serviceReference = new ServiceReference();
		return serviceReference;
	}

	public static void service(SaltaService service) {
		ServiceReference instance = instance();
		instance.service = service;
	}
}