package edu.ben.cmsc398.model;

public class Services {
	private int serviceId; 
	private String service;
	public Services(int serviceId, String service) {
		super();
		this.serviceId = serviceId;
		this.service = service;
	}
	public int getServiceId() {
		return serviceId;
	}
	public void setServiceId(int serviceId) {
		this.serviceId = serviceId;
	}
	public String getService() {
		return service;
	}
	public void setService(String service) {
		this.service = service;
	}
	@Override
	public String toString() {
		return "Services [serviceId=" + serviceId + ", service=" + service
				+ "]";
	}
	
	

}
