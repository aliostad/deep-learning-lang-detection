package com.justjoinus.web.util;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.justjoinus.service.GenericService;
import com.justjoinus.service.MerchantService;
import com.justjoinus.service.MerchantServiceService;

public final class ServiceFactory {

	private static ApplicationContext context = new ClassPathXmlApplicationContext(
			"classpath:spring.service.xml");

	public static <T> GenericService<T> getService(Class<T> entityClass) {
		String className = entityClass.getSimpleName();
		
		char ch=Character.toLowerCase(className.charAt(0));
		className = ch + className.substring(1);
		
		String serviceName = className + "Service";
		@SuppressWarnings("unchecked")
		GenericService<T> service = (GenericService<T>) context
				.getBean(serviceName);
		return service;
	}

	public static MerchantService getMerchantService() {
		MerchantService service = (MerchantService) context
				.getBean("merchantService");
		return service;
	}

	public static MerchantServiceService getMerchantServiceService() {
		MerchantServiceService service = (MerchantServiceService) context
				.getBean("merchantServiceService");
		return service;
	}

}