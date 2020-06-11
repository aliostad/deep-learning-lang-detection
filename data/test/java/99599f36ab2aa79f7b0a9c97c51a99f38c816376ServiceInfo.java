package de.uks.beast.server.service.model;

import de.uks.beast.model.Service;

public class ServiceInfo {

	protected String serviceName;
	protected String serviceType;
	protected ServiceInfo relatedService; // TODO list
	
	protected ServiceInfo(ServiceInfo orig) {
		this(orig.getServiceName(), orig.getServiceType());
	}
	
	public ServiceInfo(Service service) {
		this(service.getServiceName(), service.getServiceType());
	}
	
	public ServiceInfo(String serviceName, String serviceType) {
		this.serviceName = serviceName;
		this.serviceType = serviceType;
	}

	public String getServiceName() {
		return serviceName;
	}
	
	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}
	
	public String getServiceType() {
		return serviceType;
	}
	
	public void setServiceType(String serviceType) {
		this.serviceType = serviceType;
	}
	
	public ServiceInfo getRelatedService() {
		return relatedService;
	}
	
	public void setRelatedService(ServiceInfo relatedService) {
		this.relatedService = relatedService;
	}
	
}
