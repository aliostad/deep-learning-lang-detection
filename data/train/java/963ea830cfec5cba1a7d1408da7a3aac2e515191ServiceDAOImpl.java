package com.appbazar.iam.dao;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate4.HibernateTemplate;

import com.appbazar.iam.entity.Service;
import com.appbazar.iam.entity.User;

@SuppressWarnings("unchecked")
public class ServiceDAOImpl {

	@Autowired
	private HibernateTemplate template;

	public void setTemplate(HibernateTemplate template) {
		this.template = template;
	}

	public long addService(Service service) {
		
		service.setCreatedBy(String.valueOf(service.getReqUserId()));
		service.setUpdatedBy(String.valueOf(service.getReqUserId()));
		service.setCreatedOn(new Timestamp(new java.util.Date().getTime()));
		service.setUpdatedOn(new Timestamp(new java.util.Date().getTime()));
		
		
		template.save(service);
		return service.getServiceId();
	}

	public List<Service> getAllServices(Service service) {
		List<Service> serviceList = (List<Service>) template.find("from Service");
		return serviceList;
	}

	public List<Service> findServiceById(int serviceId) {
		List<Service> serviceList = (List<Service>) template.find("from Service where serviceId = ?",serviceId);
		return serviceList;
	}
	
	public List<Service> findServiceByRequestedUserId(int reqUserId) {
		List<Service> serviceList = (List<Service>) template.find("from Service where reqUserId = ?", reqUserId);
		return serviceList;
	}


	public List<Service> findServiceByStatus(String status) {
		List<Service> serviceList = (List<Service>) template.find("from Service where status = ?", status);
		return serviceList;
	}

	public List<Service> findServiceByProfession(String profession) {
		List<Service> serviceList = (List<Service>) template.find("from Service where profession = ?", profession);
		return serviceList;
	}

}
