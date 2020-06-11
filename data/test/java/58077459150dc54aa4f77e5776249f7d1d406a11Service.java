package org.backmeup.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Service {
	@Id
	@Column(nullable = false)
	private Long serviceId;
	
	@Column(nullable = false, unique = true)
	private String serviceName;
	
	public Service() {
	}

	public Service(Long serviceId, String serviceName) {
	  this.serviceId = serviceId;
		this.serviceName = serviceName;
	}

	public String getServiceName() {
		return serviceName;
	}

	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}

	public Long getServiceId() {
		return serviceId;
	}

  public void setServiceId(Long serviceId) {
    this.serviceId = serviceId;
  }
}
