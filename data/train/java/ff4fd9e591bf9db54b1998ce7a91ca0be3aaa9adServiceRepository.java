package com.bsc.intg.svcs.repository;

import java.util.List;

import com.bsc.intg.svcs.exception.ServiceAdminException;
import com.bsc.intg.svcs.model.Service;
import com.bsc.intg.svcs.model.ServiceInstance;

public interface ServiceRepository {

	Service createService(Service s) throws ServiceAdminException ;
	Service deleteService(Service s);
	Service updateService(Service s);
	
	Service addServiceInstance(ServiceInstance si) ;
	Service removeServiceInstance(ServiceInstance si);
	Service getServiceFromInstance(ServiceInstance si);
	
	List<ServiceInstance> getServiceInstances(Service s);
	

	
	List<Service> getServices();

	
}
