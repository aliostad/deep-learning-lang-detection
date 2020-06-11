package org.motechproject.csd.service.impl;

import org.joda.time.DateTime;
import org.motechproject.csd.domain.Service;
import org.motechproject.csd.mds.ServiceDataService;
import org.motechproject.csd.service.ServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@org.springframework.stereotype.Service("serviceService")
public class ServiceServiceImpl implements ServiceService {

    @Autowired
    private ServiceDataService serviceDataService;

    @Override
    @Transactional
    public List<Service> allServices() {
        return serviceDataService.retrieveAll();
    }

    @Override
    @Transactional
    public void deleteAll() {
        serviceDataService.deleteAll();
    }

    @Override
    @Transactional
    public Service getServiceByEntityID(String entityID) {
        return serviceDataService.findByEntityID(entityID);
    }

    @Override
    @Transactional
    public void update(Service service) {
        delete(service.getEntityID());
        serviceDataService.create(service);
    }

    @Override
    @Transactional
    public void delete(String entityID) {
        Service service = getServiceByEntityID(entityID);
        if (service != null) {
            serviceDataService.delete(service);
        }
    }

    @Override
    @Transactional
    public void update(Set<Service> services) {
        for (Service service : services) {
            update(service);
        }
    }

    @Override
    @Transactional
    public Set<Service> getModifiedAfter(DateTime date) {
        List<Service> allServices = allServices();
        Set<Service> modifiedServices = new HashSet<>();

        for (Service service : allServices) {
            if (service.getRecord().getUpdated().isAfter(date)) {
                modifiedServices.add(service);
            }
        }
        return modifiedServices;
    }
}
