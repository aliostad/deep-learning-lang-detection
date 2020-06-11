package com.urgoo.counselor.model;

/**
 * Created by urgoo_01 on 2016/8/24.
 */
public class CounselorServiceList {
    private double servicePrice;
    private String serviceLife;
    private String serviceName;
    private String serviceid;


    public double getServicePrice() {
        return servicePrice;
    }

    public void setServicePrice(double mServicePrice) {
        servicePrice = mServicePrice;
    }

    public String getServiceid() {
        return serviceid;
    }

    public void setServiceid(String mServiceid) {
        serviceid = mServiceid;
    }

    public String getServiceLife() {
        return serviceLife;
    }

    public void setServiceLife(String mServiceLife) {
        serviceLife = mServiceLife;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String mServiceName) {
        serviceName = mServiceName;
    }

    public String getServiceId() {
        return serviceid;
    }

    public void setServiceId(String mServiceId) {
        serviceid = mServiceId;
    }

    @Override
    public String toString() {
        return "CounselorServiceListBean{" +
                "servicePrice=" + servicePrice +
                ", serviceLife='" + serviceLife + '\'' +
                ", serviceName='" + serviceName + '\'' +
                ", serviceid='" + serviceid + '\'' +
                '}';
    }

}
