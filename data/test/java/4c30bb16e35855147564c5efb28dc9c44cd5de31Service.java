package models;

public class Service {

	private Integer serviceId;
	private String label, serviceEndpoint, serviceType, serviceVersion;
	
	public Service() {
		
	}
	
	public Service(Integer serviceId, String label, String serviceEndpoint, String serviceType, String serviceVersion) {
		this.serviceId = serviceId;
		this.label = label;
		this.serviceEndpoint = serviceEndpoint;
		this.serviceType = serviceType;
		this.serviceVersion = serviceVersion;
	}

	public Integer getServiceId() {
		return serviceId;
	}

	public void setServiceId(Integer serviceId) {
		this.serviceId = serviceId;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getServiceEndpoint() {
		return serviceEndpoint;
	}

	public void setServiceEndpoint(String serviceEndpoint) {
		this.serviceEndpoint = serviceEndpoint;
	}

	public String getServiceType() {
		return serviceType;
	}

	public void setServiceType(String serviceType) {
		this.serviceType = serviceType;
	}

	public String getServiceVersion() {
		return serviceVersion;
	}

	public void setServiceVersion(String serviceVersion) {
		this.serviceVersion = serviceVersion;
	}
}