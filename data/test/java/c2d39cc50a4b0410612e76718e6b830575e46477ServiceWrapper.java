package com.samsung.multiscreen.msf20.sdk;

import com.samsung.multiscreen.Service;

/**
 * @author plin
 *
 * Simply wraps a {@link Service} object.
 * 
 */
public class ServiceWrapper  {
    private Service service = null;

    public ServiceWrapper() {
    }
    
    public ServiceWrapper(Service service) {
        this.service = service;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    @Override
    public boolean equals(Object object) {
        if ((object != null) && 
                (object instanceof ServiceWrapper)) {
            Service s1 = getService();
            Service s2 = ((ServiceWrapper)object).getService();

            if (((s1 == null) && (s2 != null)) || 
                ((s1 != null) && (s2 == null))) {
                return false;
            }
            return ((s1 == s2) || 
                    s1.getUri().equals(s2.getUri()) || 
                    (s1.getId().equals(s2.getId()) && 
                    s1.getName().equals(s2.getName())));
        }
        return false;
    }

}
