package aries.subsystem.application;

import aries.subsystem.feature.api.Service;
import org.osgi.framework.Bundle;
import org.osgi.framework.BundleActivator;
import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceReference;
import org.osgi.util.tracker.ServiceTracker;
import org.osgi.util.tracker.ServiceTrackerCustomizer;


public class ApplicationActivator implements BundleActivator {

    private ServiceTracker<Service, Service> serviceTracker = null;

    public void start(BundleContext context) throws Exception {
        serviceTracker = new ServiceTracker<Service, Service>(context, Service.class, new MyServiceTrackerCustomizer());
        serviceTracker.open();
    }

    public void stop(BundleContext context) throws Exception {
        serviceTracker.close();
    }

    private class MyServiceTrackerCustomizer implements ServiceTrackerCustomizer<Service, Service> {

        public Service addingService(ServiceReference<Service> reference) {
            Bundle bundle = reference.getBundle();
            BundleContext context = bundle.getBundleContext();
            Service service = context.getService(reference);

            service.sayHello();

            return service;
        }

        public void modifiedService(ServiceReference<Service> reference, Service service) {

        }

        public void removedService(ServiceReference<Service> reference, Service service) {

        }
    }
}
