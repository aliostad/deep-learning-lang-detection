package br.ufpe.cin.dsoa.qos.monitoring.service.events;

public class ServiceEvent extends Event {

	private String serviceId;
	private String serviceName;
	private String serviceInterface;

	public ServiceEvent(long timestamp, String serviceId, String serviceName,
			String serviceInterface) {
		super(timestamp);
		this.serviceId = serviceId;
		this.serviceName = serviceName;
		this.serviceInterface = serviceInterface;
	}

	public String getServiceId() {
		return serviceId;
	}

	public String getServiceName() {
		return serviceName;
	}

	public String getServiceInterface() {
		return serviceInterface;
	}

}
