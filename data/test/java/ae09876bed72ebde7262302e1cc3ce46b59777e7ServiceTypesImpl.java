package com.unite.model.customer;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
@XmlType (propOrder={"ServiceId","Service"})


public class ServiceTypesImpl implements ServiceTypes {
	@XmlElement (name="ServiceId")
	private int serviceId;
	@XmlElement (name="Service")
	private String service;
	
	public ServiceTypesImpl(){
		super();
	}

	public ServiceTypesImpl(int serviceId,String service){
	this();
	this.serviceId = serviceId;
	this.service = service;
	}
	public int getServiceId() {
		return serviceId;
	}

	public void set(int serviceId) {
		this.serviceId = serviceId;
		
	}

	public String getService() {
		return service;
	}

	public void set(String service) {
		this.service = service;
		
	}

}
