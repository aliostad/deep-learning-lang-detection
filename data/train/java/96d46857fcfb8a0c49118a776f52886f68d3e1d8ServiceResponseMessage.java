package com.logginghub.messaging.directives;

public class ServiceResponseMessage {

    private String serviceName;
    private String serviceType;

    public ServiceResponseMessage(String serviceName, String serviceType) {
        super();
        this.serviceName = serviceName;
        this.serviceType = serviceType;
    }

    public ServiceResponseMessage() {}
    
    public String getServiceType() {
        return serviceType;
    }
    
    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }
    
    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    @Override public String toString() {
        return "ServiceResponseMessage [serviceName=" + serviceName + ", serviceType=" + serviceType + "]";
    }
}
