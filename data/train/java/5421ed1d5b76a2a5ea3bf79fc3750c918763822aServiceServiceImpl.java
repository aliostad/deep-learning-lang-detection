package com.univer.hotelSystem.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.univer.hotelSystem.dao.ServiceDAO;
import com.univer.hotelSystem.service.ServiceService;

@Service
public class ServiceServiceImpl implements ServiceService {
	
	@Autowired
	private ServiceDAO serviceDAO;

	@Transactional
	public void addService(com.univer.hotelSystem.domain.Service service) {
		serviceDAO.addService(service);
		
	}
	
	@Transactional
	public void updateService(com.univer.hotelSystem.domain.Service service) {
		serviceDAO.updateService(service);
		
	}
	
	@Transactional
	public List<com.univer.hotelSystem.domain.Service> listService() {
		return serviceDAO.listService();
	}
	
	@Transactional
	public void deleteService(Integer id) {
		serviceDAO.deleteService(id);
		
	}
	
	@Transactional
	public com.univer.hotelSystem.domain.Service getServiceById(Integer id) {
		return serviceDAO.getServiceById(id);
	}

}
