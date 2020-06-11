package com.miracle.test.service.fixture.internal;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.miracle.test.service.fixture.ManagedService;
import com.miracle.test.service.fixture.FooService;
import com.miracle.test.service.fixture.UnmanagedService;

@Service
public final class FooServiceImpl implements FooService {
	
	@Resource
	private ManagedService managedService;
	
	private UnmanagedService unmanagedService = new UnmanagedServiceImpl();
	
	@Override
	public String getMessage() {
		return unmanagedService.getDate() + " : " + managedService.sayHello();
	}
}
