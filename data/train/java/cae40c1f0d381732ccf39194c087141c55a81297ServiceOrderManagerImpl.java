package com.paul.service.impl;

import javax.jws.WebService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.paul.dao.ServiceOrderDao;
import com.paul.model.ServiceOrder;
import com.paul.service.ServiceOrderManager;

@Service("serviceOrderManager")
@WebService(serviceName = "ServiceOrderService", endpointInterface = "com.paul.service.ServiceOrderManager")
public class ServiceOrderManagerImpl extends GenericManagerImpl<ServiceOrder, Long> implements ServiceOrderManager {
    ServiceOrderDao serviceOrderDao;

    @Autowired
    public ServiceOrderManagerImpl(ServiceOrderDao serviceOrderDao) {
        super(serviceOrderDao);
        this.serviceOrderDao = serviceOrderDao;
    }
}