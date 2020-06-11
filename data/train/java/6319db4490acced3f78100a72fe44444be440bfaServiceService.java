package com.udm.health.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.udm.health.dao.ServiceDao;
import com.udm.health.domain.hibernate.Service;

@Component
public class ServiceService {

	@Autowired
	private ServiceDao serviceDao;

	public List<Service> findAll() {
		return serviceDao.findAll();
	}
	
	public Service findById(Long id) {
		return serviceDao.findById(id);
	}
	
	public Service update(Service service) {
		return serviceDao.update(service);
	}
	
	public void enable(Long id, Boolean enabled) {
		Service service = serviceDao.findById(id);
		if (service != null) {
			service.setEnabled(enabled);
			serviceDao.update(service);
		}
	}
	
	public boolean isLoggingEnabled(String serviceName) {
		Service service = findByServiceName(serviceName);
		if (service != null) {
			return service.getEnabled();
		}		
		return false;
	}
	
	public void setServiceDao(ServiceDao serviceDao) {
		this.serviceDao = serviceDao;
	}
	
	public Service findByServiceName(String serviceName) {
		return serviceDao.findByServiceName(serviceName);
	}
	
}
