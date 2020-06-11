package com.example.patterns.ServiceLocator;

import com.example.patterns.ServiceLocator.services.Service;


public class ServiceLocator {
    
    private static Cache cache;
    
    static {
        cache = new Cache();
    }
    
    public static Service getService(String name){
        
        Service service = cache.getService(name);
        
        if(service != null){
            return service;
        }
        
        InitialContext context = new InitialContext();
        service = (Service)context.lookup(name);
        cache.addService(service);
        return service;
    }
    
}
