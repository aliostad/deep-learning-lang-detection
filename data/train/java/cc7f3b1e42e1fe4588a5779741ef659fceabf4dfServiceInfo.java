package com.demandnow.model;

/**
 * Created by Nirav on 28/11/2015.
 */
public class ServiceInfo {

    private String serviceId;
    private String serviceName;
    private String serviceDescription;
    private String servicePhotoUrl;
    private Boolean newService;
    private Boolean activeService;


    public ServiceInfo(String serviceId, String serviceName, String serviceDescription, String servicePhotoUrl, Boolean newService, Boolean activeService) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.serviceDescription = serviceDescription;
        this.servicePhotoUrl = servicePhotoUrl;
        this.newService = newService;
        this.activeService = activeService;
    }

    public String getServiceId() {
        return serviceId;
    }

    public void setServiceId(String serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getServiceDescription() {
        return serviceDescription;
    }

    public void setServiceDescription(String serviceDescription) {
        this.serviceDescription = serviceDescription;
    }

    public String getServicePhotoUrl() {
        return servicePhotoUrl;
    }

    public void setServicePhotoUrl(String servicePhotoUrl) {
        this.servicePhotoUrl = servicePhotoUrl;
    }

    public Boolean getNewService() {
        return newService;
    }

    public void setNewService(Boolean newService) {
        this.newService = newService;
    }

    public Boolean getActiveService() {
        return activeService;
    }

    public void setActiveService(Boolean activeService) {
        this.activeService = activeService;
    }
}