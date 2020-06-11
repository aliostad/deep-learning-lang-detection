package gr.upatras.ece.nam.fci.core;

import brokermodel.services.OfferedService;

public class ServiceType {
	protected OfferedService service;
	
	
	public ServiceType(OfferedService service) {
		this.setService(service);
	}

	public void setService(OfferedService service) {
		this.service = service;
	}

	public String getName() {
		return service.getName();
	}
	
	public String getDescription() {
		return service.getDescription();
	}
	
	protected OfferedService getOfferedService(){
		return service;
	}

}
