package com.iconamanagement.service;

import org.junit.Assert;
import org.junit.Test;

import com.iconamanagement.service.test.TestService;

public class ServiceFactoryTest {

	@Test
	public void testGetService() {
		
		TestService service = ServiceFactory.getService(TestService.class);
		Assert.assertNotNull(service);
	}

	@Test
	public void testSingleton() {
		
		TestService service1 = ServiceFactory.getService(TestService.class);
		TestService service2 = ServiceFactory.getService(TestService.class);
		
		Assert.assertTrue(service1 == service2);
	}
}
