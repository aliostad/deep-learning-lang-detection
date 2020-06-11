package com.client;

import com.service.TutorialService;

public class Client {
private TutorialService service;

	// Bean properties
    public TutorialService getService() {
        return service;
    }

    public void setService(TutorialService service) {
        this.service = service;
    }

    public void init() {
    
        System.out.println("OSGi client started.");
        if (service != null) {
          //  System.out.println("Calling sayHello()");
            service.sayHello("Nice");  // Invoke the OSGi service!
           // System.out.println("getting total");
            service.sum(10);
            service.sayHello("Nice");
        }
    }

}
