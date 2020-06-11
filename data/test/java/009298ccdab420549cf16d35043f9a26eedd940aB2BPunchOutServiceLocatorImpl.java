package org.kuali.ext.mm.service.impl;

import java.util.Map;

import org.kuali.ext.mm.service.B2BPunchOutService;
import org.kuali.ext.mm.service.B2BPunchOutServiceLocator;


public class B2BPunchOutServiceLocatorImpl implements B2BPunchOutServiceLocator {

    private Map<String, B2BPunchOutService> serviceMap;
    
    private B2BPunchOutService defaultB2BPunchOutService;

    public void setServiceMap(Map<String, B2BPunchOutService> serviceMap) {
        this.serviceMap = serviceMap;
    }

    public Map<String, B2BPunchOutService> getServiceMap() {
        return serviceMap;
    }
    
    public void setDefaultB2BPunchOutService(B2BPunchOutService defaultB2BPunchOutService) {
        this.defaultB2BPunchOutService = defaultB2BPunchOutService;
    }

    public B2BPunchOutService getDefaultB2BPunchOutService() {
        return defaultB2BPunchOutService;
    }

    public B2BPunchOutService getB2BPunchOutService(String vendorCredentialDomain, String vendorIdentity) {
        B2BPunchOutService service = getServiceMap().get(vendorCredentialDomain + "-" + vendorIdentity);
        
        return service != null ? service : getDefaultB2BPunchOutService();      
    }   
}
