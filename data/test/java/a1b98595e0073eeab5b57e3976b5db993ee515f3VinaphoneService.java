package com.vnp.myvinaphone.bean;


public class VinaphoneService {
	private String serviceName, serviceImageUrl;
	
	public String getServiceImageUrl() {
		return serviceImageUrl;
	}

	public void setServiceImageUrl(String serviceImageUrl) {
		this.serviceImageUrl = serviceImageUrl;
	}

	public String getServiceName() {
		return serviceName;
	}

	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}

	

	public VinaphoneService() {
	}

	public VinaphoneService(String serviceName, String serviceImageUrl) {
		this.serviceName =serviceName;
		this.serviceImageUrl = serviceImageUrl;
		
	}

	
}
