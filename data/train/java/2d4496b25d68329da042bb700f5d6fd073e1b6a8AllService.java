package com.dmall.model;

import java.util.Date;

public class AllService {
    private Integer serviceId;

    private String serviceName;

    private String serviceIP;

    public AllService(Integer serviceId, String serviceName, String serviceIP) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.serviceIP = serviceIP;
    }

    public String getServiceIP() {
        return serviceIP;
    }

    public void setServiceIP(String serviceIP) {
        this.serviceIP = serviceIP;
    }

    public AllService() {
        super();
    }

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }


    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName == null ? null : serviceName.trim();
    }
}