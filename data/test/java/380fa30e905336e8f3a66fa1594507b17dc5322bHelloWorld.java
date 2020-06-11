package org.jboss.msc.quickstart;

import org.jboss.msc.service.Service;
import org.jboss.msc.service.ServiceBuilder;
import org.jboss.msc.service.ServiceContainer;

public class HelloWorld {

	public static void main(String[] args) throws InterruptedException {
		ServiceContainer container = ServiceContainer.Factory.create(); 
		Service<Boolean> service = new MyService("Hello World");
		ServiceBuilder<Boolean> builder = container.addService(MyService.SERVICE, service);
		builder.install();
		Thread.sleep(1000);
		System.out.println("MyService isActive:" + service.getValue());
		container.dumpServices();
	}
}
