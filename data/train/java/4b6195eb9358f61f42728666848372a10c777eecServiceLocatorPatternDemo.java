package com.example.patterns.ServiceLocator;

import com.example.patterns.ServiceLocator.services.Service;

public class ServiceLocatorPatternDemo {
    
   public static void main(String[] args) {
       
      Service service = ServiceLocator.getService("ServiceOne");
      service.execute();
      
      service = ServiceLocator.getService("ServiceTwo");
      service.execute();
      
      service = ServiceLocator.getService("ServiceOne");
      service.execute();
      
      service = ServiceLocator.getService("ServiceTwo");
      service.execute();	
      
   }
   
}
