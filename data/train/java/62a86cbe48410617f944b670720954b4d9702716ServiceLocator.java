package learnew.servicelocator;

import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: hvdang
 * Date: 6/10/14
 * Time: 2:31 PM
 * To change this template use File | Settings | File Templates.
 */
public class ServiceLocator {
  private ServiceCache serviceCache = new ServiceCache();

  public Service getService(String serviceName){
    Service service = serviceCache.getService(serviceName);
    if(service != null){
      return  service;
    }

    service = ServiceContext.lookup(serviceName);
    if(service != null){
      serviceCache.addService(service);
    }
    return service;
  }

  private static class ServiceCache {
    private List<Service> services = new ArrayList<Service>();

    public Service getService(String serviceName){
      for(Service service: services){
        if(service.getName().equalsIgnoreCase(serviceName)){
          System.out.println("Got service from service cache: " + serviceName);
          return  service;
        }
      }
      return null;
    }

    public void addService(Service service){
      boolean isExist = false;
      for(Service ser: services){
        if(ser.getName().equalsIgnoreCase(service.getName())){
          isExist = true;
        }
      }

      if(!isExist){
        services.add(service);
      }
    }
  }

  private static class ServiceContext {
    public static Service lookup(String jndiServiceName){
      if(jndiServiceName.equalsIgnoreCase("SERVICE1")){
        System.out.println("Create new service: " + jndiServiceName);
        return new Service1();
      }else if(jndiServiceName.equalsIgnoreCase("SERVICE2")){
        System.out.println("Create new service: " + jndiServiceName);
        return new Service2();
      }

      return null;
    }
  }
}
