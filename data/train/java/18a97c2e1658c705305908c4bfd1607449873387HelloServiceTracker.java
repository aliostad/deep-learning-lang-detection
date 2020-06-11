package com.javaworld.sample.helloworld;

import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceReference;
import org.osgi.util.tracker.ServiceTracker;

import com.javaworld.sample.service.HelloService;

public class HelloServiceTracker extends ServiceTracker<HelloService, Object> {

	public HelloServiceTracker(BundleContext context) {
		super(context, HelloService.class.getName(),null);
	}
	
	@Override
	public Object addingService(ServiceReference<HelloService> reference) {
        System.out.println("Inside HelloServiceTracker.addingService " + reference.getBundle());
        return super.addingService(reference);
    }
	
	@Override
    public void removedService(ServiceReference<HelloService> reference, Object service) {
        System.out.println("Inside HelloServiceTracker.removedService " + reference.getBundle());
        super.removedService(reference, service);
    }

}
