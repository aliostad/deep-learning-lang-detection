package ServiceLocator;

import java.util.ArrayList;
import java.util.List;


public class Cache {
    private List<Service> services = new ArrayList<Service>();
    
    public Service getService(String serviceName) {
        for (Service serv : services) {
            if (serv.getName().equalsIgnoreCase(serviceName)) {
                System.out.println("Service [" + serviceName + "] found in the cache.");
                return serv;
            }
        }
        
        return null;
    }
    
    public void addService(Service newService) {
        if (getService(newService.getName()) != null) return; // the newService already exists
        
        services.add(newService);
    }
}
