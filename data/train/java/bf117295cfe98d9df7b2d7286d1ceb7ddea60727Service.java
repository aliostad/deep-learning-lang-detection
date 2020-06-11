package com.androidbash.androidbashfirebaseupdated;

import com.google.firebase.database.IgnoreExtraProperties;

@IgnoreExtraProperties
public class Service {


    private String serviceId;
    private String serviceName;
    private String serviceDescription;
    private String serviceTime;



    public Service(){
        //this constructor is required
    }

    public Service(String serviceId, String serviceName, String serviceDescription, String serviceTime) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.serviceTime = serviceTime;
        this.serviceDescription = serviceDescription;
    }

    public String getServiceId() {
        return serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }
    public String getServiceDescription() {
        return serviceDescription;
    }
    public String getServiceTime() {
        return serviceTime;
    }
}
