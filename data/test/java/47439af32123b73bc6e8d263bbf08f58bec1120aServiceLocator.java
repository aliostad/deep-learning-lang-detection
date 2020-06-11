package com.academy.patterns.servicelocator;

/**
 * Created by keos on 22.06.15.
 */
public class ServiceLocator {

    private static ServiceCache serviceCache = new ServiceCache();

    public static Service getService(String serviceName) {
        Service service = serviceCache.getService(serviceName);
        if(service != null) {
            return service;
        } else {
            InitContext initContext = new InitContext();
            service = (Service) initContext.lookup(serviceName);
            if(service != null) {
                serviceCache.addService(service, serviceName);
                return service;
            } else {
                throw new NullPointerException("No such service");
            }
        }

    }
}
