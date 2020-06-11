package org.jboss.msc.quickstart;

import java.util.concurrent.TimeUnit;

import org.jboss.msc.service.Service;
import org.jboss.msc.service.ServiceBuilder;
import org.jboss.msc.service.ServiceContainer;
import org.jboss.msc.service.ServiceController;

public class Startup {

	public static void main(String[] args) {
		
		ServiceContainer serviceContainer = ServiceContainer.Factory.create("JBoss MSC Test", 1, 30L, TimeUnit.SECONDS);
		Service<MyService> service = new MyService(new MyServiceManager());
		ServiceBuilder<MyService> builder = serviceContainer.addService(MyService.SERVICE, service);
		ServiceController<MyService> controller = builder.install();
		controller.getService();
		
	}

}
