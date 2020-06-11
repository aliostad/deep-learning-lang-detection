package com.zeng.typeliteral;

import com.google.inject.Inject;

public class OtherService {

    public String serviceType;

    @TestProperty("A")
    public Service service;


    public OtherService() {
    }

    public OtherService(String serviceType) {
        this.serviceType = serviceType;
    }

    public void test(){

        service.test();
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }
}
