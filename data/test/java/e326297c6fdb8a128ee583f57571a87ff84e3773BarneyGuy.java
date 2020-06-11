package design.patterns.locators.bros;

import design.patterns.locators.services.BroService;
import design.patterns.locators.services.ServiceType;

import java.util.ArrayList;
import java.util.List;

/**
 * Abstract Guy Class
 */
public abstract class BarneyGuy {
    private String name;
    protected List<ServiceType> serviceTypes = new ArrayList<>();
    protected BroService service;

    protected BarneyGuy(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<ServiceType> getServiceTypes() {
        return serviceTypes;
    }

    public void setServiceTypes(List<ServiceType> serviceTypes) {
        this.serviceTypes = serviceTypes;
    }

    public BroService getService() {
        return service;
    }

    public void callService(){
        if( service != null ){
            service.executeService();
        }
    }

    public abstract void addServiceType(ServiceType type);
    public void setService(BroService service) {
        this.service = service;
    }

    public boolean offersService(ServiceType serviceType){
        for (ServiceType type : serviceTypes) {
            if( type == serviceType ){
                return true;
            }
        }
        return false;
    }
}
