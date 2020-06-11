package org.wsr.stu.servicelocator.simple;

/**
 * Created by wangshengren on 16/10/26.
 */
public class ServiceLocator {
    public static final Cache CACHE;

    static {
        CACHE = new Cache();
    }

    public static Service getService(String serviceName) {
        Service service = CACHE.getService(serviceName);
        if (service != null) {
            return service;
        }

        InitialContext context = new InitialContext();
        service = (Service) context.lookup(serviceName);
        CACHE.addService(service);
        return service;

    }
}
